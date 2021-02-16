#!make
ifeq ($(OS),Windows_NT)
SHELL := cmd
else
SHELL := /bin/bash
endif

SRC := UnitsML-v1.0-csd04
XSDSRC := $(SRC).xsd
DESTDIR := doc
XSLT_FILE := xsl/xs3p.xsl

all: clean schemadoc

schemadoc: $(DESTDIR)
	xsltproc --nonet --output $(DESTDIR)/$(SRC).html $(XSLT_FILE) $(XSDSRC)

$(DESTDIR):
	mkdir -p $@

clean:
	rm -rf $(DESTDIR)

.PHONY: all clean doc
