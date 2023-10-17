#! /bin/bash
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2023 all rights reserved


# simple installation script for mm
# usage: ./install.sh {prefix}

# get the {prefix}
prefix=$1
# check that we were given one
if [ x"${prefix}" = x"" ]; then
    echo "usage: install.sh <prefix>"
    exit 1
fi

# ensure the installation location for the script exists
mkdir -p ${prefix}/bin
# and copy it ther
cp mm ${prefix}/bin

# ensure that the installation location for my headers exists
mkdir -p ${prefix}/include
# copy them over
cp -r include/mm ${prefix}/include

# ensure that the installation location for my makefile fragments exists
mkdir -p ${prefix}/share/mm
# copy them over, along with the readme and the license file
cp -r README.md LICENSE make ${prefix}/share/mm


# end of file