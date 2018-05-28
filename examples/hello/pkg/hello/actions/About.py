# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# parasim
# (c) 1998-2018 all rights reserved
#


# externals
import hello


# declaration
class About(hello.command, family='hello.actions.about'):
    """
    Display information about this application
    """


    # user configurable state
    root = hello.properties.str(default='/')
    root.tip = "specify the portion of the namespace to display"


    # commands
    @hello.export(tip="the name of the app for configuration purposes")
    def name(self, plexus, **kwds):
        """
        Print the name of the app for configuration purposes
        """
        # show me
        plexus.info.log("{!r}".format(plexus.pyre_name) or "unknown")
        # all done
        return


    @hello.export(tip="the application home directory")
    def home(self, plexus, **kwds):
        """
        Print the application home directory
        """
        # show me
        plexus.info.log("{}".format(plexus.home))
        # all done
        return


    @hello.export(tip="the application installation directory")
    def prefix(self, plexus, **kwds):
        """
        Print the application installation directory
        """
        # show me
        plexus.info.log("{}".format(plexus.prefix))
        # all done
        return


    @hello.export(tip="the application configuration directory")
    def defaults(self, plexus, **kwds):
        """
        Print the application configuration directory
        """
        # show me
        plexus.info.log("{}".format(plexus.defaults))
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
        plexus.info.log(hello.meta.header)
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


    @hello.export(tip='dump the application configuration namespace')
    def nfs(self, plexus, **kwds):
        """
        Dump the application configuration namespace
        """
        # get the prefix
        prefix = self.root or 'hello'
        # show me
        plexus.pyre_nameserver.dump(prefix)
        # all done
        return


    @hello.export(tip='dump the application private filesystem')
    def pfs(self, plexus, **kwds):
        """
        Dump the application private filesystem
        """
        # build the report
        report = '\n'.join(plexus.pfs.dump())
        # sign in
        plexus.info.line('pfs:')
        # dump
        plexus.info.log(report)
        # all done
        return


    @hello.export(tip='dump the application virtual filesystem')
    def vfs(self, plexus, **kwds):
        """
        Dump the application virtual filesystem
        """
        # get the prefix
        prefix = self.root or '/hello'
        # build the report
        report = '\n'.join(plexus.vfs[prefix].dump())
        # sign in
        plexus.info.line('vfs: root={!r}'.format(prefix))
        # dump
        plexus.info.log(report)
        # all done
        return


# end of file
