#!make
ifeq ($(OS),Windows_NT)
SHELL := cmd
else
SHELL := /bin/bash
endif

SRC := UnitsML-v1.0-csd04

XSDSRC := ${CURDIR}/$(SRC).xsd
SVGDEST := $(SRC).svg
DIAGRAMSDIR := ${CURDIR}/diagrams/
DESTDIR := ${CURDIR}/doc/
XSDVIDIR := xsdvi
XSLT_FILE := xsl/xs3p.xsl

#xsdvi/xsdvi.jar: $(XSDVIDIR)
#	pushd $<; \
#	curl -sSL https://sourceforge.net/projects/xsdvi/files/latest/download > xsdvi.zip; \
#	unzip -p xsdvi.zip dist/lib/xsdvi.jar > xsdvi.jar; \
#	unzip -p xsdvi.zip dist/lib/xercesImpl.jar > xercesImpl.jar; \
#	popd

xsdvi/xsdvi.jar: $(XSDVIDIR)
	pushd $<; \
	curl -sSL https://github.com/Intelligent2013/xsdvi/raw/master/dist/xsdvi-1.0.jar > xsdvi.jar; \
	popd

all: clean schemasvg schemadoc cleanxsdvi


schemasvg: xsdvi/xsdvi.jar $(DESTDIR)
	cd $(XSDVIDIR); \
	java -jar xsdvi.jar $(XSDSRC); \
	mv $(SVGDEST) $(DESTDIR)
	cp -R $(DIAGRAMSDIR) $(DESTDIR)
	

schemadoc: $(DESTDIR)
	xsltproc --nonet --param title "'Units Markup language (UnitsML) Schema Documentation'" --output $(DESTDIR)index.html $(XSLT_FILE) $(XSDSRC)

gitupdate: 
	git add doc
	git commit -m "XSD docs generated"
	git push
	
$(DESTDIR):
	mkdir -p $@
	date > $@.date

$(XSDVIDIR):
	mkdir -p $@

clean:
	rm -rf $(DESTDIR)

cleanxsdvi:
	rm -rf $(XSDVIDIR)

.PHONY: all clean doc xsdvi/xsdvi.jar
