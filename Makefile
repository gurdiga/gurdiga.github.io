.ONESHELL:

SERVER_IP=127.1
SERVER_PORT=4004

build: bundler adjust-config
	bundle exec jekyll build

start: bundler adjust-config
	bundle exec jekyll serve

adjust-config:
	THEME_VERSION=`bundle list | grep -Po '(?<=jekyll-theme-mint \()[^)]+'` && \
	sed -i "s|remote_theme: aidewoode/jekyll-theme-mint@$$THEME_VERSION|theme: jekyll-theme-mint|" _config.yml
	(sleep 3 && sed -i "s|theme: jekyll-theme-mint|remote_theme: aidewoode/jekyll-theme-mint@$$THEME_VERSION|" _config.yml) &

open:
	open http://$(SERVER_IP):$(SERVER_PORT)

post: bundler
	@read -p "Article title: " title
	EDITOR=code bundle exec jekyll post "$$title"

install: bundler git-hook

git-hook:
	cp -v pre-commit .git/hooks/

bundler: /usr/local/bin/bundle
/usr/local/bin/bundle:
	gem install bundler
	bundle install

edit:
	code -n .
	exit
e: edit

pre-commit: build
pc: pre-commit

fonts: _sass/_fonts.scss
_sass/_fonts.scss: assets/fonts/
	( \
		echo 'https://fonts.googleapis.com/css2?family=Vollkorn:ital,wght@0,400;0,700;1,400;1,700&display=swap'; \
		echo 'https://fonts.googleapis.com/css2?family=PT+Sans:ital,wght@0,400;0,700;1,400;1,700&display=swap'; \
	) | while read url; do \
		curl \
			-H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:69.0) Gecko/20100101 Firefox/69.0' \
			--fail "$$url" >> $@ \
	; done
	rm -rf assets/fonts
	mkdir -p assets/fonts
	grep -Po 'https://fonts.gstatic.com\S+.woff2' $@ | xargs wget --directory-prefix=assets/fonts/
	/usr/local/opt/gnu-sed/libexec/gnubin/sed -i 's|https://fonts.gstatic.com/.*/|fonts/|' $@

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
