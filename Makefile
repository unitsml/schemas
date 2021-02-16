#!make
ifeq ($(OS),Windows_NT)
SHELL := cmd
else
SHELL := /bin/bash
endif

SRC := UnitsML-v1.0-csd04

XSDSRC := ${CURDIR}/$(SRC).xsd
SVGDEST := $(SRC).svg
DESTDIR := ${CURDIR}/doc/
XSDVIDIR := xsdvi
XSLT_FILE := xsl/xs3p.xsl

xsdvi/xsdvi.jar: $(XSDVIDIR)
	pushd $<; \
	curl -sSL https://sourceforge.net/projects/xsdvi/files/latest/download > xsdvi.zip; \
	unzip -p xsdvi.zip dist/lib/xsdvi.jar > xsdvi.jar; \
	unzip -p xsdvi.zip dist/lib/xercesImpl.jar > xercesImpl.jar; \
	popd


all: clean schemadoc cleanxsdvi


schemadoc: xsdvi/xsdvi.jar $(DESTDIR)
	cd $(XSDVIDIR); \
	java -jar xsdvi.jar $(XSDSRC); \
	mv $(SVGDEST) $(DESTDIR)
#	xsltproc --nonet --output $(DESTDIR)/$(SRC).html $(XSLT_FILE) $(XSDSRC)

gitupdate: 
	git add doc
	git commit -m "XSD docs generated"
	git push
	
$(DESTDIR):
	mkdir -p $@
	echo date > $@.date

$(XSDVIDIR):
	mkdir -p $@

clean:
	rm -rf $(DESTDIR)

cleanxsdvi:
	echo "Delete"
	rm -rf $(XSDVIDIR)

.PHONY: all clean doc xsdvi/xsdvi.jar
