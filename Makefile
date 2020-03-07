.ONESHELL:

SERVER_IP=127.1
SERVER_PORT=4004

build: bundler adjust-config
	bundle exec jekyll build

start: bundler adjust-config
	( sleep 10 && make revert-config ) &
	bundle exec jekyll serve

adjust-config:
	sed -i 's|remote_theme: aidewoode/jekyll-theme-mint|theme: jekyll-theme-mint|' _config.yml

revert-config:
	sed -i 's|theme: jekyll-theme-mint|remote_theme: aidewoode/jekyll-theme-mint|' _config.yml

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
