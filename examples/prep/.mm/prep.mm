# -*- makefile -*-
# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2026 all rights reserved


# show me
# ${info -- prep }


# prep builds no python package
prep.packages :=
# no library
prep.libraries :=
# no python extension
prep.extensions :=
# and three test suites
prep.tests := prep.tests.dep prep.tests.hooks prep.tests.runner


# the dep test suite
prep.tests.dep.stem := dep

# clean up
tests.dep.pre.clean := pre.dat
tests.dep.one.clean := one.dat
tests.dep.two.clean := two.dat

# the dependencies; note that the clean up rule of the final step includes a user defined rule
# whose body follows
tests.dep.one.pre := tests.dep.pre
tests.dep.two.pre := tests.dep.pre
tests.dep.post.pre := tests.dep.one tests.dep.two
tests.dep.post.post := tests.dep.clean user-defined

# user defined rule; the current implementation forces it to be a double colon rule, but that
# might change; note that we want this to happen after final clean up so we give it an explicit
# dependency
user-defined :: tests.dep.clean
	${call log.info,"all done"}


# the hooks test suite, whose drivers rely on a fixture of the suite
prep.tests.hooks.stem := hooks
# the fixture is ready before the first driver runs, and goes away after the last one
prep.tests.hooks.pre := hooks.start
prep.tests.hooks.post := hooks.stop
# the drivers find it through their environment
prep.tests.hooks.env := PREP_FIXTURE=fixture.dat
# a run of some of the drivers leaves the fixture behind, so cleaning the suite removes it
tests.hooks.clean := fixture.dat

# make the fixture
hooks.start:
	@${call log.action,start,"fixture"}
	@echo ready > $(prep.tests.hooks.prefix)fixture.dat

# remove it, after the last driver, which the suite makes it wait for
hooks.stop:
	@${call log.action,stop,"fixture"}
	@$(rm.force) $(prep.tests.hooks.prefix)fixture.dat


# the runner test suite, whose tests pytest finds and runs against a fixture of the suite
prep.tests.runner.stem := runner
prep.tests.runner.runner := pytest
# the fixture is ready before the runner starts, and goes away after it is done
prep.tests.runner.pre := runner.start
prep.tests.runner.post := runner.stop
# the tests find it through their environment, and leave no bytecode behind
prep.tests.runner.env := PREP_FIXTURE=fixture.dat PYTHONDONTWRITEBYTECODE=1
# and the runner keeps no cache in the source tree
prep.tests.runner.argv := -p no:cacheprovider -q

# make the fixture
runner.start:
	@${call log.action,start,"fixture"}
	@echo ready > $(prep.tests.runner.prefix)fixture.dat

# remove it, after the runner, which the suite makes it wait for
runner.stop:
	@${call log.action,stop,"fixture"}
	@$(rm.force) $(prep.tests.runner.prefix)fixture.dat

# show me
# ${info -- done with hello }


# end of file
