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
XSLT_FILE := xsl/xs3p.xsl

xsdvi/xsdvi.jar:
	curl -sSL https://sourceforge.net/projects/xsdvi/files/latest/download > xsdvi.zip
	unzip -p xsdvi.zip dist/lib/xsdvi.jar > xsdvi.jar
	unzip -p xsdvi.zip dist/lib/xercesImpl.jar > xercesImpl.jar

all: clean schemadoc

schemadoc: xsdvi/xsdvi.jar $(DESTDIR)
	java -jar xsdvi.jar $(XSDSRC)
	cp $(SVGDEST) $(DESTDIR)/
#	xsltproc --nonet --output $(DESTDIR)/$(SRC).html $(XSLT_FILE) $(XSDSRC)

$(DESTDIR):
	mkdir -p $@

clean:
	rm -rf $(DESTDIR)

.PHONY: all clean doc
