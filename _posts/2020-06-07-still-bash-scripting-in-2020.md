---
layout: post
title: Still Bash-scripting in 2020
date: 2020-06-07 15:19 +0300
tags: []
---

Bash scripting still turns out useful, even in 2020. 😉

A couple months ago a friend of mine asked me to help export their photos from a PhotoBucket account. It’s an ancient service and their UI and the mostly inexistent API docs seem to give very little hope at the time, so I thought I could take a look at what’s possible.

OK, so the first thing that I do in this kind of situation is to create a `Makefile` and REPL-drive a Bash script for as far as I can. “REPL-drive” sounds funny in the context of a shell script because a shell _is_ a REPL. So it’s just a fancy way of saying that I tweaked and ran the script until I got it to do what I needed — yeah, just old-school. 😊

I have had cases where I switch to Ruby because I needed to do some more advanced text munching, but not for this project.

So, below is a bunch of Bash functions I ended up with ([inline in the `Makefile`][1]), so I’m going to add inline comments to explain what’s going on.

[1]: https://gist.github.com/gurdiga/d333136683122d826415f42aafd290da#file-makefile

```shell
# Bash doesn’t have function hoisting, so I create a main() function
# which I call at the bottom of the script, and then write the thing
# top-down:
function main() {
    list_albums "/albums/c111/SandraDodd"
}

# A PhotoBucket account has the photos organized in albums, basically
# folders. The plan is to walk the album tree and get the URLs for all
# the photos, and put them into a file, one per line. Then feed that
# file into `wget` with `xargs`.
function list_albums() {
    local album_path="$1"

    # This is for the case if I canceled the process, or it fails for
    # some reason. I wanted to be able to skip the albums that I have
    # already listed.
    if finished_listing "$album_path"; then
        stderr "Album already listed: $album_path, skipping."
    else
        # This is the main flow: list the photos in this album and
        # append them to the photo-list.txt file.
        get_photos_for_album "$album_path" >> photo-list.txt
        # ...also, mark the album as finished.
        echo ":: Finished $album_path." >> photo-list.txt
    fi

    # Now, list the sub-albums of this album one per line, and
    # recursively list them in the same way.
    list_sub_albums "$album_path" \
    # Here I read every line into 2 variables: first $count up
    # to the first blank ($IFS), then the rest of the line goes
    # into the $path variable.
    | while read count path; do
        # I only read the $count for debugging. It’s the photo
        # count for the album.
        list_albums "$path"
    done
}

# The URL to list an album’s photos I got from the browser’s console
# while clicking around in the UI. I used the `Copy as cURL` feature of
# the console to get the URL and the request headers. I first tried to
# shiny-clean the URL and header list to the minimum necessary to get
# the data, but it was taking too long so I ended up just pasting it
# here and tweaking it a bit.
function get_photos_for_album() {
    local album_path=$1

    # This is how I got my debugging messages: They are written to
    # STDERR, so they don’t interfere with the pipeline input and
    # output.
    stderr "Listing photos for album $album_path:"
    stderr "- page 1:"

    # Here I’m fetching the first page of the photo list. In the
    # response JSON besides the data for the photos themselves, there is
    # some more meta-data like total photo count, which I used to
    # calculate how many pages I have to fetch.
    #
    # I found that the PhotoBucket API would sometimes fail, more often
    # than I wanted anyway, so I wrote the `retry` function (below) to
    # just retry the same request up to 5 times if it didn’t respond in 5
    # seconds. I have to say that I was surprised about how well it worked!
    # :-)
    retry curl $(CURL_PARAMS) $(THE_URL_AND_MORE_CURL_PARAMS) \
    # ...write the JSON to photo-list-page.json while piping it further
    # into `jq` to get the photo URLs:
    | tee photo-list-page.json \
    # ...the -r here is to write the value as a `raw` string, with no
    # quotes, so basically I would just get the URLs one per line
    # printed to STDOUT which would be redirected by the function caller
    # to the file list.
    | jq -r '.body.objects[].fullsizeUrl'
    # DEBUG: | jq . | tee /dev/fd/2 \

    # I used to inject this line here ☝️ into a pipeline to print the
    # JSON to STDERR. This was useful during development to inspect the
    # JSON responses. In this specific context, I would paste it before
    # the line above it.

    local total_photo_count=`jq -r '.body.total' photo-list-page.json`
    rm photo-list-page.json
    stderr "total_photo_count: $total_photo_count"

    # The default page-size is 23.
    local page_count=$(( $total_photo_count / 23 + 1))
    stderr "page_count: $page_count"

    # If there are more than one pages of photos...
    if [[ $page_count -gt 1 ]]; then
        # ...list the next pages of photos, starting with page 2 because
        # the first was listed above. I used `seq` to get the list of
        # numbers.
        for i in `seq 2 $page_count`; do \
            stderr "- page $i:"

            retry curl $(CURL_PARAMS) $(THE_URL_AND_MORE_CURL_PARAMS) \
            | jq -r '.body.objects[].fullsizeUrl'
        done
    fi

    stderr "Done."
}

function list_sub_albums() {
    # The album name can have spaces I needed to URL-encode it to be
    # able to pass it as a query string parameter, so I wrote a
    # `encode_uri_component` function that shells out to Node and prints
    # the URL-encoded version of a string. I could probably replace the
    # spaces with "%20", but I didn’t want to mess around with strings
    # too much in Bash.
    local album_path=`encode_uri_component "$1"`

    retry curl $(CURL_PARAMS) $(THE_URL_AND_MORE_CURL_PARAMS) \
    # Here I use `jq` to pluck multiple pieces of data: album’s photo
    # count and its path. As you see `jq` also has pipelines. Pipelines
    # all the way down.
    | jq -r '.body.subAlbums[] | [.mediaCount, .path] | @tsv'
}

# This is useful for debugging: it would print a string to STDERR so
# that I can see it, and at the same time prevent it from interfering
# with the STDIN-to-STDOUT data flow through the UNIX pipeline.
function stderr() {
    echo "+++ $@" > /dev/fd/2
}

# I use this helper function as an `if` condition, so the only relevant
# thing here is the exit status: success or failure. This is why I use
# grep’s `--quiet` parameter.
function finished_listing() {
    grep --quiet ":: Finished $1." photo-list.txt
}

# This helper function shells out to Node to URL-encode a string.
function encode_uri_component() {
    node -e "console.log(encodeURIComponent('$1'))"
}

# Yeah, this is weird. In some places the parameters were escaped
# instead of URL-encoded.
function js_escape() {
    node -e "console.log(escape('$1'))"
}

# This is the useful thingy that made the whole process more reliable.
function retry() {
    local retry_count=0

    while true; do
        ((retry_count++))

        # This is the key line: the Bash `timeout` built-in command will
        # kill the process started on the next line if it doesn’t return
        # after 5 seconds.
        timeout 5 "$@" && break

        stderr "Timed out; retrying ($retry_count)."

        if [[ $retry_count > 4 ]]; then
            stderr "Command failed 5 times.\n $@"
            break
        fi
    done
}

main
```

For some reason, I get a kick when I write non-trivial Bash scripts like this, especially if I get to learn some new trick in the process. 8-)

- `timeout` built-in command;
- the `stderr` helper function;
- debugging UNIX pipelines with `| tee /dev/fd/2`.

My hope is that this obscure knowledge comes in useful to someone else.

**UPDATE on Dec 29 2021**: Marc from PCWDLD generously reached out to suggest a link to a neat quick reference to Bash they put together. In his own words, “It’s not a cheat sheet in the traditional sense as it’s more about helping someone to get started with Bash than providing some shortcuts to make life easier.”

Check it out: 8-) [https://www.pcwdld.com/bash-cheat-sheet][0].

[0]: https://www.pcwdld.com/bash-cheat-sheet
