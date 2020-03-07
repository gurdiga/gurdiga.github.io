.ONESHELL:

SERVER_IP=127.1
SERVER_PORT=4004
SERVER_PID_FILE=.tmp/server.pid
SERVER_LOG_FILE=.tmp/server.log

build: bundler
	bundle exec jekyll build

start: bundler .tmp
	@test -e $(SERVER_PID_FILE) \
		&& echo "$(SERVER_PID_FILE) already exists. The server is probably already running." && exit 1 \
		|| echo "Starting the server..."
	bundle exec jekyll serve --host $(SERVER_IP) --port $(SERVER_PORT) &> $(SERVER_LOG_FILE) & disown
	echo $$! > $(SERVER_PID_FILE)

stop: $(SERVER_PID_FILE)
	@kill `cat $(SERVER_PID_FILE)`
	rm $(SERVER_PID_FILE) $(SERVER_LOG_FILE)

restart: stop start

$(SERVER_PID_FILE):
	@echo "No $(SERVER_PID_FILE) file. The server is probably not running."
	exit 1

.tmp:
	mkdir .tmp

open:
	open http://$(SERVER_IP):$(SERVER_PORT)

post: bundler
	@read -p "Article title: " title
	EDITOR=code bundle exec jekyll post "$$title"

install: bundler
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
