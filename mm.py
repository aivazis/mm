#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2019 all rights reserved
#

# externals
import datetime
import os
import re
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
    copyright 1998-2019 all rights reserved
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

    dry = pyre.properties.bool(default=False)
    dry.doc = "do everything except invoke make"

    quiet = pyre.properties.bool(default=False)
    quiet.doc = "suppress all non-critical output"

    ignore = pyre.properties.bool(default=False)
    ignore.doc = "ignore target failures and keep going"

    color = pyre.properties.bool(default=True)
    color.doc = "colorize screen output on supported terminals"

    palette = pyre.properties.str(default='builtin')
    palette.doc = "color palette for colorizing screen output on supported terminals"

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

    # grant access to the current build environment
    paths = pyre.properties.str(default=None)
    paths.doc = "publish the current build environment to other mm based projects"
    paths.validators = pyre.constraints.isMember("sh", "csh", "fish")

    clear = pyre.properties.bool(default=False)
    clear.doc = "remove the presence of the current build environment from the relevant variables"

    # host info
    host = pyre.platforms.platform()
    host.doc = "information about the current host"

    # makefiles
    local = pyre.properties.str(default="Make.mm")
    local.doc = "the name of your makefile"

    master = pyre.properties.str(default="master.mm")
    master.doc = "the name of the master makefile; caveat emptor..."

    verbose = pyre.properties.bool(default=False)
    verbose.doc = "ask make to show each action taken"

    ruledb = pyre.properties.bool(default=False)
    ruledb.doc = "ask make to print the rule database"

    trace = pyre.properties.bool(default=False)
    trace.doc = "ask make to print trace information"

    # important environment variables
    PATH = pyre.properties.envpath(variable="PATH")
    PATH.doc = "the PATH environment variable"

    LD_LIBRARY_PATH = pyre.properties.envpath(variable="LD_LIBRARY_PATH")
    LD_LIBRARY_PATH.doc = "the LD_LIBRARY_PATH environment variable"

    PYTHONPATH = pyre.properties.envpath(variable="PYTHONPATH")
    PYTHONPATH.doc = "the PYTHONPATH environment variable"

    MM_INCLUDES = pyre.properties.envpath(variable="MM_INCLUDES")
    MM_INCLUDES.doc = "the MM_INCLUDES environment variable"

    MM_LIBPATH = pyre.properties.envpath(variable="MM_LIBPATH")
    MM_LIBPATH.doc = "the MM_LIBPATH environment variable"


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
        # attempt to
        try:
            # verify we have the correct make
            self.verifyGNUMake()
        # if this fails
        except Exception as error:
            # grab a channel
            channel = self.error
            # complain
            channel.log(f"error while launching '{self.make}': {error}")
            # and bail
            return 1

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
        # hunt down the local makefile; after this call, {origin} is the original {cwd},
        # {anchor} is the new one; the process {cwd} is guaranteed to be {anchor}, i.e. where
        # the local makefile lives, if any, or project {root} if we can't find a makefile
        origin, anchor = self.locateAnchor(root=root)

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

        # compute the target
        target = host.platform + "-" + host.cpus.architecture
        # assemble the variants
        variants = "-".join(sorted(self.target))
        # compute the current target tag
        tag = "-".join(filter(None, (variants, target)))

        # if we are injecting the build layout into the user's environment
        if self.clear is False:
            # process with the injector
            setenv = self.inject
        # otherwise
        else:
            # remove our setting
            setenv = self.eject
        # pull variables from the environment and adjust them
        path = setenv(var=self.PATH, path=(prefix / tag / "bin"))
        ldpath = setenv(var=self.LD_LIBRARY_PATH, path=(prefix / tag / "lib"))
        pythonpath = setenv(var=self.PYTHONPATH, path=(prefix / tag / "packages"))
        incpath = setenv(var=self.MM_INCLUDES, path=(prefix / tag / "include"))
        libpath = setenv(var=self.MM_LIBPATH, path=(prefix / tag / "lib"))
        # splice them together
        path = os.pathsep.join(path)
        ldpath = os.pathsep.join(ldpath)
        pythonpath = os.pathsep.join(pythonpath)
        incpath = os.pathsep.join(incpath)
        libpath = os.pathsep.join(libpath)

        # build the command line options to GNU make
        argv = [
            # the executable
            self.make,
            # complain about typos
            "--warn-undefined-variables",
        ]

        # if the user asked to ignore target failures and keep going
        if self.ignore:
            # ask make to comply
            argv.append("--keep-going")

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
            f"target={target}",
            f"target.tag={tag}",
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
            f"host.nickname={host.nickname}",
            f"host.os={host.platform}",
            f"host.arch={host.cpus.architecture}",
            f"host.cores={host.cpus.cpus}",

            # mm info
            f"mm={mm}",
            f"mm.color={'' if self.color else 'no'}",
            f"mm.palette={self.palette}",
            f"mm.version={self.version}",
            f"mm.home={home}",
            f"mm.master={master}",
            f"mm.compilers={compilers}",
            f"mm.incpath={home} " + ' '.join(incpath.split(os.pathsep)),
            f"mm.libpath=" + ' '.join(libpath.split(os.pathsep)),

        # plus whatever the user put on the command line
        ] + list(self.argv)

        # if the user is only interested in publishing the build environment and i have
        # something to say
        if self.paths:
            # grab the shell setting
            shell = self.paths
            # figure out the template to use
            # for sh compatible shells
            if shell == "sh":
                # template
                template = 'export {var}="{value}"'
            # for csh compatible shells
            elif shell == "csh":
                # template
                template = 'setenv {var} "{value}"'
            # for fish compatible shells
            elif shell == "fish":
                # template
                template = 'set -x {var} "{value}"'
            # otherwise
            else:
                # N.B.: this is a bug: the trait validators were adjusted to include a new
                # shell, but there is no support for this shell yet
                # complain
                self.firewall.log(f'{shell}: unsupported shell')
                # and bail
                return 1

            # print the values
            print(template.format(var="PATH", value=path))
            print(template.format(var="LD_LIBRARY_PATH", value=ldpath))
            print(template.format(var="PYTHONPATH", value=pythonpath))
            print(template.format(var="MM_INCLUDES", value=incpath))
            print(template.format(var="MM_LIBPATH", value=libpath))

            # and bail
            return 0

        # if the user wants to see
        if self.show:
            # show the command line
            self.info.log('make: ' + ' '.join(map(str, argv)))

        # our updates to the environment variables
        env = {
            "PATH": path,
            "LD_LIBRARY_PATH": ldpath,
            "PYTHONPATH": pythonpath,
        }
        # adjust the envvironment
        os.environ.update(env)

        # set up the subprocess settings
        settings = {
            'executable': self.make,
            'args': argv,
            'universal_newlines': True,
            'shell': False
            }

        # if this is a dry run
        if self.dry:
            # all done
            return 0

        # otherwise, invoke GNU make
        with subprocess.Popen(**settings) as child:
            # wait for it to finish and harvest its exit code
            status = child.wait()

        # share with the shell...
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


    def locateAnchor(self, root):
        """
        Locate the nearest directory that contains a local makefile
        """
        # grab the name of the local makefile
        local = self.local
        # get the cwd
        origin = pyre.primitives.path.cwd()
        # hunt down the local makefile
        anchor = self.locate(marker=local)
        # if we found it
        if anchor:
            # if the {cwd} is not where we found the makefile
            if anchor != origin and not self.quiet:
                # pick a channel
                channel = self.info
                # complain
                channel.line(f"no '{local}' in '{origin}'")
                channel.line(f"--  found one in '{anchor}'")
                channel.log("--  launching from there")
        # if we couldn't find a makefile
        else:
            # set {anchor} to the project {root} directory
            anchor = root
            # MGA-20190907: silenced the warning; this is now the usual case
            # and if we were not told to be quiet
            # if not self.quiet:
                # pick a channel
                # channel = self.warning
                # complain
                # channel.log(f"'{local}' not found; launching the build from '{anchor}'")

        # if {anchor} is an actual directory
        if anchor.isDirectory():
            # adjust the process working directory to launch the build from this location
            anchor.chdir()

        # all done
        return origin, anchor


    def locateBuildRoot(self, projectRoot):
        """
        Locate the directory in which to place the build intermediate products
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
            channel.log('could not figure out where to put the intermediate build products')
        # give up
        return None


    def locateInstallDirectory(self, projectRoot):
        """
        Locate the directory where the build products are to be installed
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
            channel.log('could not figure out where to install the build products')
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


    def inject(self, var, path):
        """
        Prefix the path in {var} with the a local folder
        """
        # augment the path list in {var} by prepending the target folder
        var.insert(0, path)
        # eliminate duplicates, convert to strings, and return the adjusted list
        yield from self.uniq(var)
        # all done
        return


    def eject(self, var, path):
        """
        Remove path from {var}
        """
        # go through the values in {var}
        for item in var:
            # if it matches what we put there
            if item == path:
                # skip it
                continue
            # otherwise, make it available as a string
            yield str(item)
        # all done
        return var


    def uniq(self, seq):
        """
        Remove repeated occurrences of items in {seq}
        """
        # trim
        # initialize the known set
        known = set()
        # go through the items in sequence
        for item in seq:
            # convert to a string
            item = str(item)
            # skip this one if we have seen it before
            if item in known: continue
            # otherwise hand it to the caller
            yield item
            # and add it to the known pile
            known.add(item)
        # all done
        return


    def verifyGNUMake(self):
        # set up the subprocess settings
        settings = {
            'executable': self.make,
            'args': [ self.make, "--version"],
            "stdout": subprocess.PIPE,
            "stderr": subprocess.PIPE,
            'universal_newlines': True,
            'shell': False
            }

        # otherwise, invoke GNU make
        with subprocess.Popen(**settings) as make:
            # wait for it to finish and harvest its exit code
            stdout, stderr = make.communicate()
            # grab the status code
            status = make.returncode
            # if there was an error
            if status != 0:
                # grab a channel
                channel = self.error
                # complain
                channel.log(f"while retrieving GNU make version: '{self.make}' returned error {status}")
                # and bail
                raise SystemExit(status)
            # grab the first line of output
            signature = stdout.splitlines()[0]
            # attempt to match it
            match = self.versionParser.match(signature)
            # if it doesn't match
            if not match:
                # we have a problem
                channel = self.error
                # complain
                channel.log(f"requires GNU Make 4.2.1 or higher; '{self.make}' doesn't seem to be GNU Make")
                # and bail
                raise SystemExit(1)

            # get the version info
            major, minor, micro = map(int, match.groups(default=0))
            # we need 4.2.1 or higher
            if major < 4 or (major == 4 and (minor < 2 or (minor == 2 and micro < 1))):
                # we have a problem
                channel = self.error
                # complain
                channel.log(f"requires GNU Make 4.2.1 or higher; '{self.make}' is {major}.{minor}")
                # and bail
                raise SystemExit(1)

            # all good
            return

        # if we get here, something went wrong
        channel = self.error
        # complain
        channel.log(f"unknown error while retrieving the version of {self.make}")
        # and bail
        raise SystemExit(1)


    # private data
    versionParser = re.compile(r"GNU Make (?P<major>\d+)\.(?P<minor>\d+)(?:\.(?P<micro>\d+))?")


# main
if __name__ == "__main__":
    # make an instance
    app = mm(name='mm')
    # ride
    status = app.run()
    # all done
    raise SystemExit(status)


# end of file
