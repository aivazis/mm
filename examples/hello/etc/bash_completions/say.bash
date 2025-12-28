#! /bin/bash
#
# michael a.g.aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2025 all rights reserved
# bash completion script for say

function _say() {
    # get the partial command line
    local line=${COMP_LINE}
    local word=${COMP_WORDS[COMP_CWORD]}
    # ask say to provide guesses
    COMPREPLY=($(say complete --word="${word}" --line="${line}"))
}

# register the hook
complete -F _say say

# end of file
