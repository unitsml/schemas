#!make
ifeq ($(OS),Windows_NT)
SHELL := cmd
else
SHELL := /bin/bash
endif

SRC := UnitsML-v1.0-csd04

XSDSRC := $(SRC).xsd
SVGDEST := $(SRC).svg
DESTDIR := doc
XSDVIDIR := xsdvi
XSLT_FILE := xsl/xs3p.xsl

xsdvi/xsdvi.jar: $(XSDVIDIR)
	pushd $<
	curl -sSL https://sourceforge.net/projects/xsdvi/files/latest/download > xsdvi.zip
	unzip -p xsdvi.zip dist/lib/xsdvi.jar > xsdvi.jar
	unzip -p xsdvi.zip dist/lib/xercesImpl.jar > xercesImpl.jar
	popd


all: clean schemadoc

schemadoc: xsdvi/xsdvi.jar $(DESTDIR) cleanxsdvi
	java -jar $(XSDVIDIR)/xsdvi.jar $(XSDSRC)
	cp $(SVGDEST) $(DESTDIR)/
#	xsltproc --nonet --output $(DESTDIR)/$(SRC).html $(XSLT_FILE) $(XSDSRC)

$(DESTDIR):
	mkdir -p $@

$(XSDVIDIR):
	mkdir -p $@

clean:
	rm -rf $(DESTDIR)

cleanxsdvi:
	rm -rf $(XSDVIDIR)

.PHONY: all clean doc xsdvi/xsdvi.jar
