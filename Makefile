MDS := $(wildcard src/*.md src/*/*.md)
HTMLS := $(MDS:.md=.html)
PUBLISH_DIR := ../published/ # ul.elvish.io:elvish.io/published

default: gen

%.html: %.md highlighter ttyshot
	./md-to-html $< $@

%: %.go
	go build -o $@ $<

gen: $(HTMLS)
	genblog -print-default-css > assets/genblog.css
	genblog src dst

tool:
	cd $(GOPATH)/src/github.com/xiaq/genblog; \
		git pull; \
		go generate; \
		go get

publish: gen
	rsync -aLv --delete ./dst/ $(PUBLISH_DIR)

clean:
	rm $(HTMLS)

.PHONY: default gen tool publish clean
