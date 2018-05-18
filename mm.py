#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# externals
import datetime
import os
import subprocess
import sys

# attempt to
try:
    # access the framework
    import pyre
# if this fails
except ImportError:
    # form the home of the python bootstrap
    pdir = os.path.abspath(os.path.join(os.path.dirname(__file__), '.mm'))
    # if it doesn't exist, make it
    os.makedirs(pdir, exist_ok=True)
    # the package
    boot = 'pyre-1.0-boot.zip'
    # the local file
    local = os.path.join(pdir, boot)
    # if it not already here
    if not os.path.exists(local):
        # support for URL access
        import urllib.request
        # form the url to the bootstrapper
        url = f"http://pyre.orthologue.com/{boot}"
        # show me
        print(f"downloading '{url}'")
        # pull the bootstrapper from the web
        with urllib.request.urlopen(url=url) as ins:
            # open the local file
            with open(local, 'wb') as outs:
                # pull the data and write it
                outs.write(ins.read())
    # grab the sys module
    import sys
    # so we can add the bootstrapper to it
    sys.path.insert(1, local)
    # try importing pyre again
    import pyre


# the app
class mm(pyre.application, family='pyre.applications.mm', namespace='mm'):
    """
    mm 4.0
    Michael Aïvázis <michael.aivazis@para-sim.com>
    copyright 1998-2018 all rights reserved
    """

    # user configurable state
    project = pyre.properties.str()
    project.doc = "the name of the project to build; normally set in your makefile"

    prefix = pyre.properties.path()
    prefix.doc = "the home of the installed build products"

    bldroot = pyre.properties.path()
    bldroot.doc = "the home of the intermediate build products"

    target = pyre.properties.strings(default=["debug", "shared"])
    target.doc = "the set of build target variants, e.g. shared, debug, opt"

    # behavior
    show = pyre.properties.bool(default=False)
    show.doc = "display details about the invocation of make"

    quiet = pyre.properties.bool(default=False)
    quiet.doc = "suppress all non-critical output"

    # parallelism
    serial = pyre.properties.bool(default=False)
    serial.doc = "control whether to run make in parallel"

    slots = pyre.properties.int(default=None)
    slots.doc = "the number of recipes to execute simultaneously"

    # advanced settings
    # gnu make
    make =  pyre.properties.str(default=os.environ.get('GNU_MAKE', 'gmake'))
    make.doc = "the name of the GNU make executable"

    # the list of compilers
    compilers = pyre.properties.strings()
    compilers.doc = "override the default compiler set"

    # the project config directory name
    cfgdir = pyre.properties.str(default='.mm')
    cfgdir.doc = "the name of directories with project configuration settings"


    # host info
    host = pyre.platforms.platform()
    host.doc = "information about the current host"

    # makefiles
    local = pyre.properties.str(default="Make.mm")
    local.doc = "the name of the your makefile"

    master = pyre.properties.str(default="master.mm")
    master.doc = "the name of the master makefile; caveat emptor..."

    verbose = pyre.properties.bool(default=False)
    verbose.doc = "ask make to show each action taken"

    ruledb = pyre.properties.bool(default=False)
    ruledb.doc = "ask make to print the rule database"

    trace = pyre.properties.bool(default=False)
    trace.doc = "ask make to print trace information"

    # constants
    version = "4.0"


    # behavior
    @pyre.export
    def main(self, *args, **kwds):
        """
        The main entry point
        """
        # launch GNU make
        status = self.launch()
        # all done
        return status


    # meta-methods
    def __init__(self, **kwds):
        # chain up
        super().__init__(**kwds)
        # get the current user
        self.user = self.pyre_executive.user
        # all done
        return


    # implementation details
    def launch(self):
        """
        Launch GNU make
        """
        # get the user info
        user = self.user
        # get the host info
        host = self.host

        # mm
        mm = f"{sys.executable} {__file__}"
        # number of simultaneous recipes
        slots = self.computeSlots()

        # locate the {mm} install directory
        home = self.locateConfigHome()
        # the user configuration directory
        usercfg = self.locateUserConfig()
        # the project root
        root = self.locateProjectRoot()
        # and the project configuration directory
        projcfg = self.locateProjectConfig(folder=root)

        # find the master makefile
        master = self.locateMasterMakefile(home=home)
        # hunt down the local makefile; after this {origin} is the original {cwd}, {anchor} is
        # the new one; after this call, the process {cwd} is guaranteed to be {anchor},
        # i.e. where the local makefile lives, if any
        origin, anchor = self.locateAnchor()

        # locate the build directory
        bldroot = self.locateBuildRoot(projectRoot=root)
        # locate the install directory
        prefix = self.locateInstallDirectory(projectRoot=root)

        # build the include path arguments
        incdirs = []
        # by going through configuration directories that exist
        for folder in filter(None, [usercfg, projcfg, home]):
            # add the flag
            incdirs.append('-I')
            # and the folder to the pile
            incdirs.append(folder)

        # if we could locate the master makefile point to it, otherwise leave it blank
        masterfile = ['-f', master] if master else []
        # assemble the list of compilers
        compilers = " ".join(self.compilers)

        # build the command line options to GNU make
        argv = [
            # the executable
            self.make,
            # complain about typos
            "--warn-undefined-variables",
        ]

        # suppress make output, unless the user asked to see action details
        if not self.verbose:
            # by adding the corresponding command line argument
            argv.append("--silent")

        # if the user asked to see the database of rules
        if self.ruledb:
            # add the corresponding command line argument
            argv.append("--print-data-base")

        # if the user asked for trace information
        if self.trace:
            # add the corresponding command line argument
            argv.append("--trace")

        # include path and the master makefile
        argv += incdirs + masterfile + [
            # parallelism
            "-j", f"{slots}",
            ] + (
                # the name of the project, if explicitly set
                [f"project={self.project}"] if self.project else []
            ) + [
            # project info
            "project.home={}".format(root or ''),
            "project.config={}".format(projcfg or ''),
            "project.prefix={}".format(prefix or ''),
            "project.bldroot={}".format(bldroot or ''),
            "project.anchor={}".format(anchor or ''),
            f"project.origin={origin}",
            "project.makefile={}".format(self.local if anchor else ''),

            # target info
            "target.variants={}".format(" ".join(self.target)),

            # user info
            f"user.username={user.username}",
            f"user.home={user.home}",
            "user.config={}".format(usercfg or ''),
            f"user.uid={user.uid}",
            f"user.name={user.name}",
            f"user.email={user.email}",

            # host info
            f"host.name={host.hostname}",
            f"host.os={host.platform}",
            f"host.arch={host.cpus.architecture}",
            f"host.cores={host.cpus.cpus}",

            # mm info
            f"mm={mm}",
            f"mm.version={self.version}",
            f"mm.home={home}",
            f"mm.master={master}",
            f"mm.compilers={compilers}",

        # plus whatever the user put on the command line
        ] + list(self.argv)

        # if the user wants to see
        if self.show:
            # show the command line
            self.info.log('make: ' + ' '.join(argv))

        # set up the subprocess settings
        settings = {
            'executable': self.make,
            'args': argv,
            'universal_newlines': True,
            'shell': False
            }
        # invoke GNU make
        with subprocess.Popen(**settings) as child:
            # wait for it to finish
            status = child.wait()

        # and return its status
        return status


    def computeSlots(self):
        """
        Adjust the number of recipes that GNU make will execute in parallel
        """
        # if the user doesn't want parallelism
        if self.serial:
            # execute only one recipe at a time
            return 1

        # get the user choice
        slots = self.slots
        # otherwise, adjust the worker count
        return self.host.cpus.cpus if slots is None else slots


    def locateConfigHome(self):
        """
        Find the {mm} home directory and the location of the master makefile
        """
        # use the location of this file as guidance to locate the install directory
        return pyre.primitives.path(__file__).parent


    def locateMasterMakefile(self, home):
        """
        Build the path to the master makefile
        """
        # build the location of the master makefile
        master = home / "make" / self.master
        # if it doesn't exist
        if not master.exists:
            # pick a channel
            channel = self.error
            # complain
            channel.log(f"could not find '{master}', the master makefile")
            # nothing more to be done
            return None
        # otherwise, hand it off
        return master


    def locateProjectRoot(self):
        """
        Find the root of a project directory structure
        """
        # get the name of the root marker
        marker = self.cfgdir
        # hunt it down, starting with the current working directory
        root = self.locate(marker)
        # if we couldn't locate it
        if not root and not self.quiet:
            # pick a channel
            channel = self.error
            # complain
            channel.log("could not locate the project root directory")
        # all done
        return root


    def locateProjectConfig(self, folder):
        """
        Find the location of the project configuration directory
        """
        # we are looking for
        cfgdir = self.cfgdir
        # form the target
        target = folder / self.cfgdir
        # if it exists
        if target.exists:
            # hand it off
            return target
        # if we couldn't find it
        if not self.quiet:
            # pick a channel
            channel = self.warning
            # complain
            channel.log(f"no '{cfgdir}' found in '{folder}'")
        # all done
        return None


    def locateUserConfig(self):
        """
        Find the location of the user's configuration directory
        """
        # we are looking for
        cfgdir = self.cfgdir
        # in the user's home directory
        home = self.user.home
        # the target
        target = self.user.home / self.cfgdir
        # if it exists
        if target.exists:
            # hand it off
            return target
        # if we couldn't find it
        if not self.quiet:
            # pick a channel
            channel = self.info
            # complain
            channel.log(f"no '{cfgdir}' found in '{home}'")
        # all done
        return None


    def locateAnchor(self):
        """
        Locate the nearest directory that contains a local makefile
        """
        # grab the name of the local makefile
        local = self.local
        # get the cwd
        origin = pyre.primitives.path.cwd()
        # hunt down the local makefile
        anchor = self.locate(marker=local)
        # if we found a makefile
        if anchor:
            # if that's not where we found the makefile
            if anchor != origin and not self.quiet:
                # pick a channel
                channel = self.warning
                # complain
                channel.line(f"no '{local}' in '{origin}'")
                channel.line(f"--  found one in '{anchor}'")
                channel.log("--  launching from there")
            # go there
            os.chdir(anchor)
        # if we couldn't find a makefile
        else:
            # and we were not told to be quiet
            if not self.quiet:
                # pick a channel
                channel = self.warning
                # complain
                # channel.log(f"could not find a '{local}'")

        # all done
        return origin, anchor


    def locateBuildRoot(self, projectRoot):
        """
        Locate the folder in which to place the build products
        """
        # get the user's opinion
        bldroot = self.bldroot
        # if there is one
        if bldroot:
            # we are done
            return bldroot

        # otherwise, use the project root
        if projectRoot:
            # to form the target folder
            return projectRoot / "builds"

        # otherwise
        if self.quiet:
            # pick a channel
            channel = self.error
            # complain
            channel.log('could not figure out where to install the build products')
        # give up
        return None


    def locateInstallDirectory(self, projectRoot):
        """
        Locate the directory where the build products are to be deposited
        """
        # get the user's opinion
        prefix = self.prefix
        # if there is one
        if prefix:
            # we are done
            return prefix

        # otherwise, use the project root
        if projectRoot:
            # to form the target folder
            return projectRoot / "products"

        # otherwise
        if self.quiet:
            # pick a channel
            channel = self.error
            # complain
            channel.log('could not figure out where to place the build products')
        # give up
        return None


    def locate(self, marker, folder=None):
        """
        Locate the directory that contains {marker}, starting with the current working directory
        and moving upwards
        """
        # start with the current directory
        folder = pyre.primitives.path.cwd() if folder is None else folder
        # go through folders on the way to the root
        for candidate in folder.crumbs:
            # form the filename
            target = candidate / marker
            # if it exists
            if target.exists():
                # we have found the place
                return candidate
        # all done
        return None


    def createDirectories(self, prefix, buildroot):
        """
        Create the necessary directores
        """
        # all done
        return


# main
if __name__ == "__main__":
    # make an instance
    app = mm(name='mm')
    # ride
    status = app.run()
    # all done
    raise SystemExit(status)


# end of file
