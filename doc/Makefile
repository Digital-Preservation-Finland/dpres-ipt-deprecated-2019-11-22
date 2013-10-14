# Makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    = -D todo_include_todos=1
SPHINXBUILD   = sphinx-build
PAPER         =
BUILDDIR      = build

# Internal variables.
PAPEROPT_a4     = -D latex_paper_size=a4
PAPEROPT_letter = -D latex_paper_size=letter
ALLSPHINXOPTS   = -d $(BUILDDIR)/doctrees $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) source

.PHONY: help clean html dirhtml pickle json htmlhelp qthelp latex changes linkcheck doctest

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  html      to make standalone HTML files"
	@echo "  dirhtml   to make HTML files named index.html in directories"
	@echo "  pickle    to make pickle files"
	@echo "  json      to make JSON files"
	@echo "  htmlhelp  to make HTML files and a HTML help project"
	@echo "  qthelp    to make HTML files and a qthelp project"
	@echo "  latex     to make LaTeX files, you can set PAPER=a4 or PAPER=letter"
	@echo "  changes   to make an overview of all changed/added/deprecated items"
	@echo "  linkcheck to check all external links for integrity"
	@echo "  doctest   to run all doctests embedded in the documentation (if enabled)"

clean:
	-rm -rf $(BUILDDIR)/*

html: modules
	$(SPHINXBUILD) -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/html."

dirhtml:
	$(SPHINXBUILD) -b dirhtml $(ALLSPHINXOPTS) $(BUILDDIR)/dirhtml
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/dirhtml."

pickle:
	$(SPHINXBUILD) -b pickle $(ALLSPHINXOPTS) $(BUILDDIR)/pickle
	@echo
	@echo "Build finished; now you can process the pickle files."

json:
	$(SPHINXBUILD) -b json $(ALLSPHINXOPTS) $(BUILDDIR)/json
	@echo
	@echo "Build finished; now you can process the JSON files."

htmlhelp:
	$(SPHINXBUILD) -b htmlhelp $(ALLSPHINXOPTS) $(BUILDDIR)/htmlhelp
	@echo
	@echo "Build finished; now you can run HTML Help Workshop with the" \
	      ".hhp project file in $(BUILDDIR)/htmlhelp."

qthelp:
	$(SPHINXBUILD) -b qthelp $(ALLSPHINXOPTS) $(BUILDDIR)/qthelp
	@echo
	@echo "Build finished; now you can run "qcollectiongenerator" with the" \
	      ".qhcp project file in $(BUILDDIR)/qthelp, like this:"
	@echo "# qcollectiongenerator $(BUILDDIR)/qthelp/information-package-tools.qhcp"
	@echo "To view the help file:"
	@echo "# assistant -collectionFile $(BUILDDIR)/qthelp/information-package-tools.qhc"

latex: modules
	$(SPHINXBUILD) -b latex $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	@echo
	@echo "Build finished; the LaTeX files are in $(BUILDDIR)/latex."
	@echo "Run \`make all-pdf' or \`make all-ps' in that directory to" \
	      "run these through (pdf)latex."

changes:
	$(SPHINXBUILD) -b changes $(ALLSPHINXOPTS) $(BUILDDIR)/changes
	@echo
	@echo "The overview file is in $(BUILDDIR)/changes."

linkcheck:
	$(SPHINXBUILD) -b linkcheck $(ALLSPHINXOPTS) $(BUILDDIR)/linkcheck
	@echo
	@echo "Link check complete; look for any errors in the above output " \
	      "or in $(BUILDDIR)/linkcheck/output.txt."

doctest:
	$(SPHINXBUILD) -b doctest $(ALLSPHINXOPTS) $(BUILDDIR)/doctest
	@echo "Testing of doctests in the sources finished, look at the " \
	      "results in $(BUILDDIR)/doctest/output.txt."

docserver: html killdocserver
	cd build ; python -mSimpleHTTPServer 8090 &
	sleep 1
	@echo ""
	@echo "------------------------------------------------------------"
	@echo "Documentation SimpleHTTPServer up and running..."
	@echo ""
	@echo "Point your browser to http://`hostname`:8090/"
	@echo ""
	@echo "You can stop the server with command: make killdocserver"
	@echo ""
	@echo "------------------------------------------------------------"
	@echo ""

killdocserver: 
	kill `ps auxwww | grep "[S]impleHTTPServer 8090" | awk '{print $$2}'` | true

_htmldev: html
	find build/html -iname '*.html' -exec sed -i 's/<head>/<head><meta http-equiv="refresh" content="5"\/>/' '{}' \;

htmldev: docserver _htmldev
	while true ; do make _htmldev ; sleep 5 ;  done

pdf: latex
	make -C build/latex all-pdf

modules: testmodules
	mkdir -p source/modules
	tools/generate_modules.py -m10 -f --dest-dir=source/modules --suffix=rst ../src

testmodules:
	rm -rf source/tests
	rm -rf build/tests
	mkdir -p source/tests
	mkdir -p build/tests
	cp -r ../tests build/tests
	cp -r ../tests/testcommon build/tests
	find build/tests
	find build/tests -type d -iname '__pycache__' -exec rm -rf '{}' \; | true
	find build/tests -type f -iname '*.pyc' -exec rm -rf '{}' \;
	find build/tests/tests -type d -exec touch '{}/__init__.py' \;
	tools/generate_modules.py -n"Testing" -m10 -f --dest-dir=source/tests --suffix=rst build/tests


