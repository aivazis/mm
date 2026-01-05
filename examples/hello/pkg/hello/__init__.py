# -*- Python-*-
# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# parasim
# (c) 1998-2026 all rights reserved
#


# publish some pyre symbols
from pyre import (
    # components and their parts
    schemata, constraints, properties, component, protocol, foundry,
    # the runtime manager
    executive,
    # interface decorators
    export, provides,
    # miscellaneous
    tracking,
)

# bootstrap
package = executive.registerPackage(name='nisar', file=__file__)
# save the geography
home, prefix, defaults = package.layout()


# plexus support
from .shells import plexus, action, command
# the extension modules
from . import ext
# meta-data
from . import meta
# command line interface
from . import cli


# administrivia
def copyright():
    """
    Return the copyright note
    """
    # pull and print the meta-data
    return print(meta.header)


def license():
    """
    Print the license
    """
    # pull and print the meta-data
    return print(meta.license)


def built():
    """
    Return the build timestamp
    """
    # pull and return the meta-data
    return meta.date


def credits():
    """
    Print the acknowledgments
    """
    return print(meta.acknowledgments)


def version():
    """
    Return the version
    """
    # pull and return the meta-data
    return meta.version


# end of file
