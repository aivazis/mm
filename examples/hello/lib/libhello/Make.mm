# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# the library namespace; determines how its headers get accessed
libhello.namespace := hello
# the source directories
libhello.directories := . greetings friends
# the list of sources
libhello.sources := ${wildcard $(libhello.directories:%=%/*.cc)}
# the list of headers
libhello.headers := ${wildcard $(libhello.directories:%=%/*.h)}

# end of file
