VERSION=$(shell git describe --tags)

BASE=regvue-final-report
ADOC=$(BASE).adoc
PDF=$(BASE).pdf
HTML=$(BASE).html

MAKEFLAGS=-j2

.PHONY: all
all: $(PDF) $(HTML)

$(PDF): $(ADOC) pdf-theme.yml
	docker run -v $(PWD):/documents asciidoctor/docker-asciidoctor asciidoctor-pdf \
	    -a pdf-theme=./pdf-theme.yml \
	    $(ADOC)

$(HTML): $(ADOC)
	docker run -v $(PWD):/documents asciidoctor/docker-asciidoctor asciidoctor $(ADOC)

.PHONY: publish
publish:
	rm -rf gh-pages
	git clone --branch gh-pages $(shell git remote get-url origin) gh-pages
	mkdir -p gh-pages/$(VERSION)/images
	cp $(HTML) gh-pages/$(VERSION)/index.html
	cp -R images/*.png gh-pages/$(VERSION)/images
	git -C gh-pages add $(VERSION)
	git -C gh-pages commit -m "Add $(VERSION)"
	echo "Remove commit in gh-pages directory and push if good."