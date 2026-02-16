#! /bin/bash
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2026 all rights reserved


# simple installation script for mm
# usage: ./install.sh {prefix} [--bash-completion]

# parse arguments
prefix=""
install_completion=0

while [[ $# -gt 0 ]]; do
    case $1 in
        --bash-completion)
            install_completion=1
            shift
            ;;
        *)
            if [ x"${prefix}" = x"" ]; then
                prefix=$1
            else
                echo "error: unexpected argument '$1'"
                echo "usage: install.sh <prefix> [--bash-completion]"
                exit 1
            fi
            shift
            ;;
    esac
done

# check that we were given a prefix
if [ x"${prefix}" = x"" ]; then
    echo "usage: install.sh <prefix> [--bash-completion]"
    echo ""
    echo "options:"
    echo "  --bash-completion    install bash completion support for mm"
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

# if bash completion was requested
if [ ${install_completion} -eq 1 ]; then
    echo "installing bash completion support..."
    # ensure the bash completion directory exists
    mkdir -p ${prefix}/share/bash-completion/completions
    # copy the completion script
    cp etc/bash_completion/mm ${prefix}/share/bash-completion/completions/mm
    echo "bash completion installed to ${prefix}/share/bash-completion/completions/mm"
    echo "you may need to restart your shell or run: source ${prefix}/share/bash-completion/completions/mm"
fi


# end of file