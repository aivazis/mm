#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2023 all rights reserved

# externals
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
    pdir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".mm"))
    # if it doesn't exist, make it
    os.makedirs(pdir, exist_ok=True)

    # the target version
    release = "v1.12.2"
    # the bootstrapping package
    boot = "pyre-boot.zip"

    # the local file
    local = os.path.join(pdir, boot)
    # if it not already here
    if not os.path.exists(local):
        # support for URL access
        import urllib.request

        # form the url to the bootstrapper
        url = f"http://github.com/pyre/pyre/releases/download/{release}/{boot}"
        # show me
        print(f"downloading '{url}'")
        # pull the bootstrapper from the web
        with urllib.request.urlopen(url=url) as ins:
            # open the local file
            with open(local, "wb") as outs:
                # pull the data and write it
                outs.write(ins.read())
    # grab the sys module
    import sys

    # so we can add the bootstrapper to it
    sys.path.insert(1, local)
    # try importing pyre again
    import pyre


# the app
class mm(pyre.application, family="pyre.applications.mm", namespace="mm"):
    """
    mm 4.4.1
    Michael Aïvázis <michael.aivazis@para-sim.com>
    copyright 1998-2023 all rights reserved
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

    setup = pyre.properties.bool(default=False)
    setup.doc = "initialize the user configuration directory"

    quiet = pyre.properties.bool(default=False)
    quiet.doc = "suppress all non-critical output"

    ignore = pyre.properties.bool(default=False)
    ignore.doc = "ignore target failures and keep going"

    color = pyre.properties.bool(default=True)
    color.doc = "colorize screen output on supported terminals"

    palette = pyre.properties.str(default="builtin")
    palette.doc = "color palette for colorizing screen output on supported terminals"

    # parallelism
    serial = pyre.properties.bool(default=False)
    serial.doc = "control whether to run make in parallel"

    slots = pyre.properties.int(default=None)
    slots.doc = "the number of recipes to execute simultaneously"

    # advanced settings
    # gnu make
    make = pyre.properties.str(default=os.environ.get("GNU_MAKE", "gmake"))
    make.doc = "the name of the GNU make executable"

    runcfg = pyre.properties.str(default="")
    runcfg.doc = "a run specific directory to add to the make include path"

    # the list of compilers
    compilers = pyre.properties.strings()
    compilers.doc = "override the default compiler set"

    # the project config directory name
    cfgdir = pyre.properties.str(default=".mm")
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

    merlin = pyre.properties.str(default="merlin.mm")
    merlin.doc = "the name of the top level makefile; caveat emptor..."

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
    version = "4.4.1"

    # behavior
    @pyre.export
    def main(self, *args, **kwds):
        """
        The main entry point
        """
        # if we are in setup mode
        if self.setup:
            # just set up the user configuration directory
            return self.setupUserConfig()

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

        # if the user asked for detailed output
        if self.verbose:
            # force serial mode; anything else is output madness
            self.serial = True

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

        # check whether the project has a configuration file and load it
        self.loadProjectConfig(projcfg)

        # find the top level makefile
        merlin = self.locateMerlin(home=home)
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
        for folder in filter(None, [self.runcfg, usercfg, projcfg, home]):
            # add the flag
            incdirs.append("-I")
            # and the folder to the pile
            incdirs.append(folder)

        # if we could locate the top level makefile, point to it; otherwise leave it blank
        merlinfile = ["-f", merlin] if merlin else []
        # assemble the list of compilers
        compilers = " ".join(self.compilers)

        # compute the target
        target = host.platform + "-" + host.cpus.architecture
        # assemble the variants
        variants = "-".join(sorted(self.target))
        # compute the current target tag
        tag = "-".join(filter(None, (variants, target)))

        # check whether
        try:
            # we can extract version info from the repository
            major, minor, micro, revision, ahead = self.gitDescribe()
        # if this failed
        except TypeError:
            # set some default values
            major, minor, micro, revision, ahead = (1, 0, 0, "", 0)

        # if we are injecting the build layout into the user's environment
        if self.clear is False:
            # process with the injector
            setenv = self.inject
        # otherwise
        else:
            # remove our settings
            setenv = self.eject
        # pull variables from the environment and adjust them
        path = setenv(var=self.PATH, path=(prefix / "bin"))
        ldpath = setenv(var=self.LD_LIBRARY_PATH, path=(prefix / "lib"))
        pythonpath = setenv(var=self.PYTHONPATH, path=(prefix / "packages"))
        incpath = setenv(var=self.MM_INCLUDES, path=(prefix / "include"))
        libpath = setenv(var=self.MM_LIBPATH, path=(prefix / "lib"))
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

        # include path and the top level makefile
        argv += (
            incdirs
            + merlinfile
            + [
                # parallelism
                "-j",
                f"{slots}",
            ]
            + (
                # the name of the project, if explicitly set
                [f"project={self.project}"]
                if self.project
                else []
            )
            + [
                # project info
                "project.home={}".format(root or ""),
                "project.config={}".format(projcfg or ""),
                "project.prefix={}".format(prefix or ""),
                "project.bldroot={}".format(bldroot or ""),
                "project.anchor={}".format(anchor or ""),
                f"project.origin={origin}",
                "project.makefile={}".format(self.local if anchor else ""),
                # repository information
                f"repo.major={major}",
                f"repo.minor={minor}",
                f"repo.micro={micro}",
                f"repo.revision={revision}",
                f"repo.ahead={ahead}",
                # target info
                f"target={target}",
                f"target.tag={tag}",
                "target.variants={}".format(" ".join(self.target)),
                # user info
                f"user.username={user.username}",
                f"user.home={user.home}",
                "user.config={}".format(usercfg or ""),
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
                f"mm.merlin={merlin}",
                f"mm.compilers={compilers}",
                f"mm.incpath={home} " + " ".join(incpath.split(os.pathsep)),
                f"mm.libpath=" + " ".join(libpath.split(os.pathsep)),
                # plus whatever the user put on the command line
            ]
            + list(self.argv)
        )

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
                self.firewall.log(f"{shell}: unsupported shell")
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
            self.info.log("make: " + " ".join(map(str, argv)))

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
            "executable": self.make,
            "args": argv,
            "universal_newlines": True,
            "shell": False,
        }

        # if this is a dry run
        if self.dry:
            # all done
            return 0

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

        # otherwise, invoke GNU make
        with subprocess.Popen(**settings) as child:
            # wait for it to finish and harvest its exit code
            status = child.wait()

        # share with the shell...
        return status

    def setupUserConfig(self):
        """
        Prime the user configuration directory
        """
        # form the path to the user configuration directory
        cfghome = self.user.home / self.cfgdir
        # if it doesn't exist, make it
        cfghome.mkdir(parents=True, exist_ok=True)
        # by default, package settings are in
        cfg = cfghome / "config.mm"
        # if the file exists
        if cfg.exists():
            # make a channel
            channel = self.error
            # let the user know
            channel.log(f"the file '{cfg}' exists already")
            # and bail
            return 1

        # the contents of the file
        doc = [
            "# -*- Makefile -*-",
            "",
            "# cuda",
            "# cuda.version := ",
            "# cuda.dir := ",
            "# cuda.incpath := $(cuda.dir)/include",
            "# cuda.libpath := $(cuda.dir)/lib",
            "",
            "# fftw",
            "# fftw.version := ",
            "# fftw.dir := ",
            "# fftw.incpath := $(fftw.dir)/include",
            "# fftw.libpath := $(fftw.dir)/lib",
            "# fftw.flavor := 3",
            "",
            "# gdal",
            "# gdal.version := ",
            "# gdal.dir := ",
            "# gdal.incpath := $(gdal.dir)/include",
            "# gdal.libpath := $(gdal.dir)/lib",
            "",
            "# gmsh",
            "# gmsh.version := ",
            "# gmsh.dir := ",
            "# gmsh.incpath := $(gmsh.dir)/include",
            "# gmsh.libpath := $(gmsh.dir)/lib",
            "",
            "# gsl",
            "# gsl.version := ",
            "# gsl.dir := ",
            "# gsl.incpath := $(gsl.dir)/include",
            "# gsl.libpath := $(gsl.dir)/lib",
            "",
            "# gtest",
            "# gtest.version := ",
            "# gtest.dir := ",
            "# gtest.incpath := $(gtest.dir)/include",
            "# gtest.libpath := $(gtest.dir)/lib",
            "",
            "# hdf5",
            "# hdf5.version := ",
            "# hdf5.dir := ",
            "# hdf5.incpath := $(hdf5.dir)/include",
            "# hdf5.libpath := $(hdf5.dir)/lib",
            "",
            "# libpq",
            "# libpq.version := ",
            "# libpq.dir := ",
            "# libpq.incpath := $(libpq.dir)/include",
            "# libpq.libpath := $(libpq.dir)/lib",
            "",
            "# metis",
            "# metis.version := ",
            "# metis.dir := ",
            "# metis.incpath := $(metis.dir)/include",
            "# metis.libpath := $(metis.dir)/lib",
            "",
            "# mpi",
            "# mpi.version := ",
            "# mpi.dir := ",
            "# mpi.binpath := $(mpi.dir)/bin",
            "# mpi.incpath := $(mpi.dir)/include",
            "# mpi.libpath := $(mpi.dir)/lib",
            "# mpi.flavor := openmpi",
            "# mpi.executive := mpiexec",
            "",
            "# openblas",
            "# openblas.version := ",
            "# openblas.dir := ",
            "# openblas.incpath := $(openblas.dir)/include",
            "# openblas.libpath := $(openblas.dir)/lib",
            "",
            "# parmetis",
            "# parmetis.version := ",
            "# parmetis.dir := ",
            "# parmetis.incpath := $(parmetis.dir)/include",
            "# parmetis.libpath := $(parmetis.dir)/lib",
            "",
            "# petsc",
            "# petsc.version := ",
            "# petsc.dir := ",
            "# petsc.incpath := $(petsc.dir)/include",
            "# petsc.libpath := $(petsc.dir)/lib",
            "",
            "# pyre",
            "# pyre.version := ",
            "# pyre.dir := ",
            "# pyre.incpath := $(pyre.dir)/include",
            "# pyre.libpath := $(pyre.dir)/lib",
            "",
            "# python",
            "# python.version := ",
            "# python.model := # for 3.7 or less, set to m; for 3.8+ leave blank",
            "# python.dir := ",
            "# python.incpath := $(python.dir)/include",
            "# python.libpath := $(python.dir)/lib",
            "",
            "# numpy",
            "# numpy.version := ",
            "# numpy.dir := $(python.dir)/lib/lib$(python.version)/site-packages/numpy/core",
            "# numpy.incpath := $(numpy.dir)/include",
            "# numpy.libpath := $(numpy.dir)/lib",
            "",
            "# slepc",
            "# slepc.version := ",
            "# slepc.dir := ",
            "# slepc.incpath := $(slepc.dir)/include",
            "# slepc.libpath := $(slepc.dir)/lib",
            "",
            "# summit",
            "# summit.version := ",
            "# summit.dir := ",
            "# summit.incpath := $(summit.dir)/include",
            "# summit.libpath := $(summit.dir)/lib",
            "",
            "# vtk",
            "# vtk.version := ",
            "# vtk.dir := ",
            "# vtk.incpath := $(vtk.dir)/include",
            "# vtk.libpath := $(vtk.dir)/lib",
            "",
            "# end of file",
        ]

        # open the file
        stream = cfg.open(mode="w")
        # and render
        print("\n".join(doc), file=stream)

        # all done
        return 0

    def loadProjectConfig(self, projcfg):
        """
        Check whether the project configuration directory contains an application configuration
        file, and if there, load it
        """
        # first, look for an 'mm.pfg'
        cfgApp = (projcfg / self.pyre_namespace).withSuffix(suffix=".pfg")
        # if it exists
        if cfgApp.exists():
            # load it
            pyre.loadConfiguration(cfgApp)

        # next, look for a branch specific configuration file; find the name of the branch
        branch = self.gitCurrentBranch()
        # and use it to form the path to the configuration file
        cfgBranch = (projcfg / branch).withSuffix(suffix=".pfg")
        # if it exists
        if cfgBranch.exists():
            # tell me
            self.info.log(f"loading '{cfgBranch}'")
            # load it
            pyre.loadConfiguration(cfgBranch)

        # all done
        return

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
        Find the {mm} home directory and the location of the top level makefile
        """
        # use the location of this file as guidance to locate the install directory
        return pyre.primitives.path(__file__).parent

    def locateMerlin(self, home):
        """
        Build the path to the top level makefile
        """
        # build the location of the top level makefile
        merlin = home / "make" / self.merlin
        # if it doesn't exist
        if not merlin.exists:
            # pick a channel
            channel = self.error
            # complain
            channel.log(f"could not find '{merlin}', the top level makefile")
            # nothing more to be done
            return None
        # otherwise, hand it off
        return merlin

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
        # figure out where the configuration directory is; first, try looking for an XDG compliant
        # layout; perhaps the system sets up the mandated environment variable
        xdgHome = (
            pyre.primitives.path(os.getenv("XDG_CONFIG_HOME", self.XDG_CONFIG))
            .expanduser()
            .resolve()
        )
        # point to the {mm} specific directory
        xdg = xdgHome / "mm"
        # if it is a real directory
        if xdg.exists() and xdg.isDirectory():
            # hand it off
            return xdg
        # otherwise, look for the configuration directory
        cfgdir = self.cfgdir
        # in the user's home directory
        home = self.user.home
        # form the target
        target = home / cfgdir
        # if it exists and it is a directory
        if target.exists and target.isDirectory():
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
                channel.indent()
                channel.line(f"found one in '{anchor}'")
                channel.line(f"launching from there")
                channel.outdent()
                # flush
                channel.log()
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

        # if we are out of ideas and not told to be quiet
        if not self.quiet:
            # pick a channel
            channel = self.warning
            # complain
            channel.log(
                "could not figure out where to put the intermediate build products"
            )

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

        # if we are out of ideas and not told to be quiet
        if not self.quiet:
            # otherwise, pick a channel
            channel = self.warning
            # complain
            channel.log("could not figure out where to install the build products")

        # give up
        return None

    def locate(self, marker, folder=None):
        """
        Locate the directory that contains {marker}, starting with the current working directory
        and moving upwards
        """
        # start with the current directory, unless the caller has opinions
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
            if item in known:
                continue
            # otherwise hand it to the caller
            yield item
            # and add it to the known pile
            known.add(item)
        # all done
        return

    def verifyGNUMake(self):
        # set up the subprocess settings
        settings = {
            "executable": self.make,
            "args": [self.make, "--version"],
            "stdout": subprocess.PIPE,
            "stderr": subprocess.PIPE,
            "universal_newlines": True,
            "shell": False,
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
                # build a message
                msg = f"'{self.make}' returned error {status}"
                # complain
                channel.log(f"while retrieving GNU make version: {msg}")
                # and bail
                raise SystemExit(status)
            # grab the first line of output
            signature = stdout.splitlines()[0]
            # attempt to match it
            match = self.makeVersionParser.match(signature)
            # if it doesn't match
            if not match:
                # we have a problem
                channel = self.error
                # build a message
                msg = f"'{self.make}' doesn't seem to be GNU Make"
                # complain
                channel.log(f"requires GNU Make 4.2.1 or higher; {msg}")
                # and bail
                raise SystemExit(1)

            # get the version info
            major, minor, micro = map(int, match.groups(default=0))
            # we need 4.2.1 or higher
            if major < 4 or (major == 4 and (minor < 2 or (minor == 2 and micro < 1))):
                # we have a problem
                channel = self.error
                # complain
                channel.log(
                    f"requires GNU Make 4.2.1 or higher; '{self.make}' is {major}.{minor}"
                )
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

    def gitDescribe(self):
        """
        Extract project version meta-data from a git repository
        """
        # the git command line
        cmd = ["git", "describe", "--tags", "--long", "--always"]
        # settings
        options = {
            "executable": "git",
            "args": cmd,
            "stdout": subprocess.PIPE,
            "stderr": subprocess.PIPE,
            "universal_newlines": True,
            "shell": False,
        }
        # invoke
        with subprocess.Popen(**options) as git:
            # collect the output
            stdout, stderr = git.communicate()
            # get the status
            status = git.returncode
            # if something went wring
            if status != 0:
                # bail
                return
            # get the description
            description = stdout.strip()
            # parse it
            match = self.gitDescriptionParser.match(description)
            # if something went wrong
            if not match:
                # bail
                return
            # otherwise, extract the version info
            major = match.group("major") or "1"
            minor = match.group("minor") or "0"
            micro = match.group("micro") or "0"
            commit = match.group("commit")
            ahead = match.group("ahead")
            # if we are at a tagged commit
            if int(ahead) == 0:
                # make sure {ahead} is an empty string
                ahead = ""
            # and return it
            return (major, minor, micro, commit, ahead)

        # if anything went wrong
        return

    def gitCurrentBranch(self):
        """
        Extract the name of the current git branch
        """
        # the git command line
        cmd = ["git", "branch", "--show-current"]
        # settings
        options = {
            "executable": "git",
            "args": cmd,
            "stdout": subprocess.PIPE,
            "stderr": subprocess.PIPE,
            "universal_newlines": True,
            "shell": False,
        }
        # invoke
        with subprocess.Popen(**options) as git:
            # collect the output
            stdout, stderr = git.communicate()
            # get the status
            status = git.returncode
            # if something went wring
            if status != 0:
                # bail
                return "unknown"
            # get the branch name
            branch = stdout.strip()
            # and return it
            return branch

        # if anything went wrong
        return "unknown"

    # private data    # the XDG compliant fallback for user configuration
    # the XDG compliant fallback for user configuration
    XDG_CONFIG = pyre.primitives.path("~/.config")
    # make version
    makeVersionParser = re.compile(
        r"GNU Make (?P<major>\d+)\.(?P<minor>\d+)(?:\.(?P<micro>\d+))?"
    )
    # parser of the {git describe} result
    gitDescriptionParser = re.compile(
        r"(v(?P<major>\d+)\.(?P<minor>\d+).(?P<micro>\d+)-(?P<ahead>\d+)-g)?(?P<commit>.+)"
    )


# main
if __name__ == "__main__":
    # make an instance
    app = mm(name="mm")
    # ride
    status = app.run()
    # all done
    raise SystemExit(status)


# end of file
