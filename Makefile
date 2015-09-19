.PHONY: all build watch

all: build

build:
	stylus -c src/styles/ -o public/css &
	coffee -co public/js src/coffee/

watch:
	stylus -c -w src/styles/ -o public/css &
	coffee -cwo public/js src/coffee/

couch: build
	couchapp push app.coffee http://localhost:5984/samgentle
