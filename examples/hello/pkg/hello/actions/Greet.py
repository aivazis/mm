# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# parasim
# (c) 1998-2019 all rights reserved
#


# the package
import hello


# declaration
class Goodbye(hello.command, family='hello.actions.greet'):
    """
    Greet a friend
    """


    # commands
    @hello.export(tip="greet Alec")
    def alec(self, plexus, **kwds):
        """
        Greet Alec
        """
        # get the friend name
        firend = hello.ext.libhello.alec()
        # do it
        plexus.info.log(f"{self.greeting} {friend}!")
        # report success
        return 0


    @hello.export(tip="greet Ally")
    def ally(self, plexus, **kwds):
        """
        Greet Ally
        """
        # get the friend name
        firend = hello.ext.libhello.ally()
        # do it
        plexus.info.log(f"{self.greeting} {friend}!")
        # report success
        return 0


    @hello.export(tip="greet Mac")
    def mac(self, plexus, **kwds):
        """
        Greet Mac
        """
        # get the friend name
        firend = hello.ext.libhello.mac()
        # do it
        plexus.info.log(f"{self.greeting} {friend}!")
        # report success
        return 0


    @hello.export(tip="greet Mat")
    def mat(self, plexus, **kwds):
        """
        Greet Mat
        """
        # get the friend name
        firend = hello.ext.libhello.mat()
        # do it
        plexus.info.log(f"{self.greeting} {friend}!")
        # report success
        return 0


    # my greeting
    greeting = None


# end of file
