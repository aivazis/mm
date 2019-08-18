#-*- coding: utf-8 -*-


# support
import hello


# declaration
class Config(hello.command, family="hello.cli.config"):
    """
    Display configuration information about this package
    """


    # version info
    @hello.export(tip="the version information")
    def version(self, **kwds):
        """
        Print the version of the hello package
        """
        # print the version number
        print(f"{hello.meta.version}")
        # all done
        return 0


    # configuration
    @hello.export(tip="the top level installation directory")
    def prefix(self, **kwds):
        """
        Print the top level installation directory
        """
        # print the version number
        print(f"{hello.prefix}")
        # all done
        return 0


    @hello.export(tip="the directory with the executable scripts")
    def path(self, **kwds):
        """
        Print the location of the executable scripts
        """
        # print the version number
        print(f"{hello.prefix}/bin")
        # all done
        return 0


    @hello.export(tip="the directory with the python packages")
    def pythonpath(self, **kwds):
        """
        Print the directory with the python packages
        """
        # print the version number
        print(f"{hello.home.parent}")
        # all done
        return 0


    @hello.export(tip="the location of the {hello} headers")
    def incpath(self, **kwds):
        """
        Print the locations of the {hello} headers
        """
        # print the version number
        print(f"{hello.prefix}/include")
        # all done
        return 0


    @hello.export(tip="the location of the {hello} libraries")
    def libpath(self, **kwds):
        """
        Print the locations of the {hello} libraries
        """
        # print the version number
        print(f"{hello.prefix}/lib")
        # all done
        return 0



# end of file
