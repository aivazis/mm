# -*- shell-script -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2026 all rights reserved
#
# mm session management functions
# source this file from ~/.bashrc or ~/.bash_profile


mm.activate() {
    # wire the current mm installation into the shell session:
    # prepends {prefix}/bin to PATH and the Python package directory to PYTHONPATH;
    # undoes the previous activation first so re-invoking is always safe
    eval "$(mm --quiet --activate)"
}

mm.branch() {
    # tag the build context with the current git branch ({project}/{branch}),
    # then activate the corresponding installation tree;
    # subsequent mm invocations build into and install to a branch-scoped prefix,
    # leaving all other branch builds untouched
    eval "$(mm --quiet --branch=on)"
}

mm.clear() {
    # remove the branch tag and activate the unscoped installation tree;
    # undoes the effect of mm.branch and returns to the mainline build
    eval "$(mm --quiet --branch=off)"
}


# end of file
