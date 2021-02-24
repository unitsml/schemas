#!make
ifeq ($(OS),Windows_NT)
SHELL := cmd
else
SHELL := /bin/bash
endif

UNITSMLSRC := $(wildcard unitsml/*.xsd)
UNITSMLLITESRC := $(wildcard unitsmllite/*.xsd)
UNITSMLDOC := $(patsubst unitsml/%.xsd,doc/unitsml/%/index.html,$(UNITSMLSRC))
UNITSMLLITEDOC := $(patsubst unitsmllite/%.xsd,doc/unitsmllite/%/index.html,$(UNITSMLLITESRC))
TOTALDOCS := $(UNITSMLDOC) $(UNITSMLLITEDOC)

XSDVIPATH := ${CURDIR}/xsdvi/xsdvi.jar
XSLT_FILE := ${CURDIR}/xsl/xs3p.xsl

all: $(TOTALDOCS)

setup: $(XSDVIPATH)

xsdvi/xsdvi.zip:
	mkdir -p $(dir $@)
	curl -sSL https://sourceforge.net/projects/xsdvi/files/latest/download > $@

$(XSDVIPATH): xsdvi/xercesImpl.jar
	curl -sSL https://github.com/metanorma/xsdvi/raw/master/dist/xsdvi-1.0.jar > $@
	# unzip -p $< dist/lib/xsdvi.jar > $@

xsdvi/xercesImpl.jar: xsdvi/xsdvi.zip
	unzip -p $< dist/lib/xercesImpl.jar > $@

doc/%/index.html: %.xsd $(XSDVIPATH)
	mkdir -p $(dir $@)diagrams; \
	java -jar $(XSDVIPATH) $(CURDIR)/$< -rootNodeName all -oneNodeOnly -outputPath $(dir $@)diagrams; \
	xsltproc --nonet --param title "'Units Markup language (UnitsML) Schema Documentation $(notdir $*)'" \
		--output $@ $(XSLT_FILE) $<

gitupdate:
	git add doc
	git commit -m "XSD docs generated"
	git push

clean:
	rm -rf doc

distclean: clean
	rm -rf xsdvi

.PHONY: all clean setup distclean
