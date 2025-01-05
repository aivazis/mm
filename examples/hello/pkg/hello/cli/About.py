# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# parasim
# (c) 1998-2025 all rights reserved
#


# my package
import hello


# declaration
class About(hello.command, family='hello.cli.about'):
    """
    Display information about this application
    """


    # commands
    @hello.export(tip="print the copyright note")
    def copyright(self, plexus, **kwds):
        """
        Print the copyright note of the hello package
        """
        # show the copyright note
        plexus.info.log(hello.meta.copyright)
        # all done
        return


    @hello.export(tip="print out the acknowledgments")
    def credits(self, plexus, **kwds):
        """
        Print out the license and terms of use of the hello package
        """
        # make some space
        plexus.info.log(hello.meta.acknowledgments)
        # all done
        return


    @hello.export(tip="print out the license and terms of use")
    def license(self, plexus, **kwds):
        """
        Print out the license and terms of use of the hello package
        """
        # make some space
        plexus.info.log(hello.meta.license)
        # all done
        return


    @hello.export(tip="print the version number")
    def version(self, plexus, **kwds):
        """
        Print the version of the hello package
        """
        # make some space
        plexus.info.log(hello.meta.header)
        # all done
        return


# end of file
