---
layout: post
title: NPM publishing automation
date: '2016-06-26T12:46:02+03:00'
tags: []
categories: []
---
I have a small module on NPM and I found myself tweaking it more than a
few times lately. One piece of routine related to this kind of work is
Git tag management: I want to have a tag for every new version that I
publish on NPM. This is handy if you want to get a specific version of
the module directly from the GitHub repository.

OK, so I have done that manually for a couple of times:

* update the version in package.json;
* create a tag pointing to the appropriate revision, probably current HEAD;
* push the code and tags to GitHub;
* publish to NPM.

This felt a bit tedious and I caught myself forgetting to push tags to
GitHub or create the tag altogether. So I have set out to create a make
task to do that, and not I only update the version in package.json and
run `make deploy` to get all that taken care of:

```make
deploy: tag push
    npm publish
```

So, I first run the tag and push tasks in that order, and then run `npm
publish`.

```make
VERSION=`$(call get_package_version)`
tag:
    git tag $(VERSION)
    git tag --force latest-release $(VERSION)
```

This calls the `get_package_version` function to extract the version
number from package.json, creates the Git tag for that version number,
and also updates the `latest-release` tag.

```make
push:
    git push
    git push --tags --force
```

This pushes the source code, and then pushes the tags with `--force` to
push the new tag, and also update the existing remote tags.

And here is the definition of the `get_package_version` make function
that I used earlier to extract the version from package.json. For
version 0.1.9, for example, it will return v0.1.9. It’s just a short
UNIX pipeline between `grep` and `sed`:

```
define get_package_version
    grep '"version"' package.json |\
        grep -P -o '\d+\.\d+\.\d+' |\
        sed 's/^/v/'
endef
```

All the source code is available in that module’s
[Makefile on GitHub](https://github.com/gurdiga/mocha-html-dot-reporter/blob/b59cadfe3c3a09888e7f4968c12c5d746b8d1b8a/Makefile#L7-L23).
