######################################################################
#
#   See COPYING file distributed along with the psignifit package for
#   the copyright and license terms
#
######################################################################

# The main Psignifit 3.x Makefile

DOCOUT=doc-html

################# GROUPING FILES ######################
PYTHONFILES=pypsignifit/__init__.py pypsignifit/psignidata.py pypsignifit/psignierrors.py pypsignifit/psigniplot.py pypsignifit/psigobservers.py pypsignifit/pygibbsit.py
CFILES_LIB=src/bootstrap.cc src/core.cc src/data.cc src/linalg.cc src/mclist.cc src/mcmc.cc src/optimizer.cc src/psychometric.cc src/rng.cc src/sigmoid.cc src/special.cc
HFILES_LIB=src/bootstrap.h  src/core.h  src/data.h  src/errors.h src/linalg.h src/mclist.h src/mcmc.h src/optimizer.h src/prior.h src/psychometric.h src/rng.h src/sigmoid.h src/special.h src/psipp.h
PSIPY_INTERFACE=psipy/psipy.cc psipy/psipy_doc.h psipy/pytools.h
SWIGNIFIT_INTERFACE=swignifit/swignifit.i
SWIGNIFIT_AUTOGENERATED=swignifit/swignifit.py swignifit/swignifit_wrap.cxx
DOCFILES=doc-src/API.rst doc-src/index.rst doc-src/TUTORIAL.rst doc-src/*.png

################ COMMAND DEFINITIONS #################

build: python-build python-doc

install: python-install python-doc

clean: clean-python-doc clean-python-build

python-install: psipy-install
	echo "Installing python extension"

python-build: psipy-build
	echo "Building python extension"

clean-python-build:
	echo "clean python build"
	-rm -rv build

python-doc: $(DOCFILES) $(PYTHONFILES) python-build
	echo "building sphinx documentation"
	PYTHONPATH=build/`ls -1 build | grep lib` sphinx-build doc-src $(DOCOUT)

clean-python-doc:
	echo "clean sphinx documentation"
	-rm -rv $(DOCOUT)

# PSIPY COMMANDS

psipy-build: $(PYTHONFILES) $(CFILES) $(HFILES) $(PSIPY_INTERFACE) setup_basic.py setup_psipy.py
	./setup_psipy.py build

psipy-install: psipy-build
	./setup_psipy.py install

psipy-test:
	PYTHONPATH=build/`ls -1 build | grep lib` python tests/psipy_test.py

# SWIGNIFIT COMMANDS

swignifit-build: $(PYTHONFILES) $(CFILES) $(HFILES) $(SWIGNIFIT_AUTOGENERATED) setup_basic.py setup_swignifit.py
	./setup_swignifit.py build

swignifit-install: swignifit-build
	./setup_swignifit.py install

$(SWIGNIFIT_AUTOGENERATED): $(SWIGNIFIT_INTERFACE)
	swig -c++ -python -v -Isrc -Ipsipy swignifit/swignifit.i

swignifit-clean:
	-rm -rf $(SWIGNIFIT_AUTOGENERATED)

swignifit-test: test-swignifit-wrap test-interface

test-swignifit-wrap:
	PYTHONPATH=build/`ls -1 build | grep lib` python swignifit/swignifit_test.py

test-interface:
	PYTHONPATH=build/`ls -1 build | grep lib` python swignifit/interface_test.py

# TEST COMMANDS

test-cpp:
	cd src
