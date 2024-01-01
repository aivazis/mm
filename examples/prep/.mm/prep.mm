# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2024 all rights reserved
#

# show me
# ${info -- prep }


# prep builds no python package
prep.packages :=
# no library
prep.libraries :=
# no python extension
prep.extensions :=
# and a test suite
prep.tests := prep.tests.dep


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
# might change; note that we want this to happen after final clean up so we give it an explict
# dependency
user-defined :: tests.dep.clean
	${call log.info,"all done"}

# show me
# ${info -- done with hello }

# end of file
