"""

Schematron validation using iso-schematron-xslt1 reference implementation.

XSLT template converts are done with xsltproc / libxslt C Library for
Gnome. This is because Python xml libraries are not stable enough for
Schematron.

    http://xmlsoft.org/XSLT/

Schematron XSLT files must be installed at path

    /usr/share/dpres-xml-schemas/iso_schematron_xslt1/

Schematron XSLT files can be downloaded from

    http://www.schematron.com/implementation.html

Schematron templates are cached at

    ~/.dpres-ipt/schematron-cache/<md5 of schematron schema>.xslt

This reduces need to sequentially compile Schematron schemas into XSLT
templates.

"""

import os
import shutil
import tempfile
import subprocess
import lxml.etree as etree

import xml_helpers.utils
import ipt.fileutils.checksum
from ipt.validator.basevalidator import Shell


class SchematronValidator:
    """Schematron validator
    """
    returncode = None
    messages = None
    errors = None
    xslt_filename = None
    cachepath = os.path.expanduser('~/.dpres-ipt/schematron-cache')
    schematron_dirname = '/usr/share/dpres-xml-schemas/schematron/schematron_xslt1'
    cache=True
    verbose=False

    def document_has_errors(self):
        """Check if document resulted errors
        """
        return self.messages.find('<svrl:failed-assert ') >= 0 or self.returncode == 6

    def validate(self, document, schematron_file, cache=True, verbose=False):
        """Do the Schematron validation. The results are given in self.returncode,
        self.messages and self.errors
        :document: Document to be validated
        :schematron_file: Schematron file used in validation
        :cache: Use cached xslt files, if checksum has not changed (True/False)
        """
        SVRL = {'svrl': 'http://purl.oclc.org/dsdl/svrl'}
        self.cache = cache
        self.verbose = verbose
        # Compile schematron
        self._compile_schematron(schematron_file)

        # The actual validation
        shell = self._compile_phase(
            stylesheet=self.xslt_filename,
            inputfile=document, validation=True)

        self.returncode = shell.returncode
        self.errors = shell.stderr

        # Remove unnecessary pattern and rule elements
        if not self.verbose and self.returncode == 0:
            root = etree.fromstring(shell.stdout)
            patterns = root.xpath('./svrl:active-pattern', namespaces=SVRL)        
            for pattern in patterns:
                prev = pattern.xpath('preceding-sibling::svrl:active-pattern[1]',
                                     namespaces=SVRL)
                if prev and pattern.get('id') == prev[0].get('id'):
                    pattern.getparent().remove(pattern)

            rules = root.xpath('svrl:fired-rule', namespaces=SVRL)
            for rule in rules:
                prev = rule.xpath('preceding-sibling::svrl:fired-rule[1]',
                                  namespaces=SVRL)
                if prev and rule.get('context') == prev[0].get('context'):
                    rule.getparent().remove(rule)

            # Give the fixed tree as output
            self.messages = etree.tostring(
                root, pretty_print=True, xml_declaration=False,
                encoding='UTF-8', with_comments=True)
        else:
            self.messages = shell.stdout

    def _compile_phase(self, stylesheet, inputfile, outputfile=None,
                       outputfilter=False, validation=False):
        """Compile one phase
        :stylesheet: XSLT file to used in the conversion
        :inputfile: Input document filename
        :outputfile: Filename of the resulted document, stdout if None
        :outputfilter: Use outputfilter parameter with value only_messages
        :validation: True - the actual validation / False - compilation step
        """
        cmd=['xsltproc']
        if outputfile:
            cmd = cmd + ['-o', outputfile]
        if outputfilter and not self.verbose:
            cmd = cmd + ['--stringparam', 'outputfilter', 'only_messages']
        cmd = cmd + [os.path.join(self.schematron_dirname, stylesheet),
                     inputfile]
        shell=Shell(cmd)
        if (shell.returncode != 0 and validation == False) \
        or (shell.returncode not in [0, 6] and validation == True):
            raise SchematronValidatorError(
                    "Error %s\nstdout:\n%s\nstderr:\n%s" % (
                        shell.returncode, shell.stdout, shell.stderr))
        return shell

    def _compile_schematron(self, schematron_file):
        """Compile a schematron file
        :schematron_file: Schematron file
        """
        xslt_filename = self._generate_xslt_filename(schematron_file)
        tempdir = tempfile.mkdtemp()

        if self.cache:
            if os.path.isfile(xslt_filename):
                self.xslt_filename = xslt_filename
                return xslt_filename

        try: 
            shell = self._compile_phase(
                stylesheet='iso_dsdl_include.xsl',
                inputfile=schematron_file,
                outputfile=os.path.join(tempdir, 'step1.xsl'))
            shell = self._compile_phase(
                stylesheet='iso_abstract_expand.xsl',
                inputfile=os.path.join(tempdir, 'step1.xsl'),
                outputfile=os.path.join(tempdir, 'step2.xsl'))
            shell = self._compile_phase(
                stylesheet='optimize_schematron.xsl',
                inputfile=os.path.join(tempdir, 'step2.xsl'),
                outputfile=os.path.join(tempdir, 'step3.xsl'))
            shell = self._compile_phase(
                stylesheet='iso_svrl_for_xslt1.xsl',
                inputfile=os.path.join(tempdir, 'step3.xsl'),
                outputfile=os.path.join(tempdir, 'validator.xsl'),
                outputfilter=not(self.verbose))

            shutil.move(os.path.join(tempdir, 'validator.xsl'),
                        xslt_filename)

            self.xslt_filename = xslt_filename

        finally:
            shutil.rmtree(tempdir)

        return xslt_filename

    def _generate_xslt_filename(self, schematron_schema):
        """ Example filename:

            /var/cache/schematron-validation/<schema.sch>.<sha digest>.xslt

        """
        if not os.path.exists(self.cachepath):
            os.makedirs(self.cachepath)

        checksum = ipt.fileutils.checksum.BigFile('sha1')
        schema_digest = checksum.hexdigest(schematron_schema)
        schema_basename = os.path.basename(schematron_schema)

        return os.path.join(self.cachepath, '%s.%s.validator.xsl' % (
                            schema_basename, schema_digest))


class SchematronValidatorError(Exception):
    """Throw error in compilation failure
    """
    pass
