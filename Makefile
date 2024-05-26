.ONESHELL:

SERVER_IP=127.0.0.1
SERVER_PORT=4004

GREP=/opt/homebrew/opt/grep/libexec/gnubin/grep

build: bundler # adjust-config
	bundle exec jekyll build

Gemfile.lock: Gemfile
	bundle install && touch Gemfile.lock

start: bundler Gemfile.lock # adjust-config
	bundle exec jekyll serve --port $(SERVER_PORT) --host $(SERVER_IP)

s: start

adjust-config:
	@THEME_VERSION=`$(GREP) -Po '(?<=jekyll-theme-mint", branch: ")[^"]+' Gemfile` && \
	sed -i "s|remote_theme: aidewoode/jekyll-theme-mint@$$THEME_VERSION|theme: jekyll-theme-mint|" _config.yml
	(sleep 3 && sed -i "s|theme: jekyll-theme-mint|remote_theme: aidewoode/jekyll-theme-mint@$$THEME_VERSION|" _config.yml) &

open:
	open http://$(SERVER_IP):$(SERVER_PORT)
o: open

post: bundler
	@if env | grep -i 'TERM_PROGRAM=vscode' > /dev/null; then \
		read -p "Article title: " title; \
		EDITOR=code bundle exec jekyll post "$$title"; \
	else \
		make edit; \
	fi

install: bundler git-hook

git-hook:
	cp -v pre-commit .git/hooks/

RUBY_VERSION=$(shell cat .ruby-version)
BUNDLER=$(HOME)/.rvm/gems/ruby-$(RUBY_VERSION)/bin/bundle

bundler: $(BUNDLER)
$(BUNDLER):
	gem install bundler
	bundle install

edit:
	code -n .
e: edit

pre-commit: build
pc: pre-commit

re-fonts: rm-fonts fonts
rm-fonts:
	rm -rf assets/fonts/ _sass/_fonts.scss

fonts: _sass/_fonts.scss
_sass/_fonts.scss: assets/fonts/
	set -e
	if [ -e "$@" ]; then mv "$@" "$@.old"; fi
	( \
		echo 'https://fonts.googleapis.com/css2?family=Merriweather:ital,wght@0,400;0,700;1,400;1,700&display=swap'; \
	) | while read url; do \
		curl \
			-H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:69.0) Gecko/20100101 Firefox/69.0' \
			--fail "$$url" >> $@ \
	; done
	rm -rf assets/fonts
	mkdir -p assets/fonts
	grep -Po 'https://fonts.gstatic.com\S+.woff2' $@ | xargs wget --directory-prefix=assets/fonts/
	/usr/local/opt/gnu-sed/libexec/gnubin/sed -i 's|https://fonts.gstatic.com/.*/|fonts/|' $@
	if [ -e "$@.old" ]; then rm "$@.old"; fi

assets/fonts/:
	mkdir assets/fonts

favicon: favicon.ico
	rm favicon.png

favicon.png: favicon.svg
	"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
		--headless \
		--screenshot \
		--window-size=100,100 \
		--default-background-color=0 \
		--screenshot=favicon.png \
		favicon.svg

favicon.ico: favicon.png
	convert favicon.png \
		-units PixelsPerInch \
		-resample 300 \
		-resize 64x64 \
		favicon.ico

tagging:
	@:
	grep -Rl 'tags: \[]' _posts/ |
	xargs code -n .

audit:
	bundle-audit
