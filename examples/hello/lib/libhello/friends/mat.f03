! -*- f03 -*-
!
! michael a.g. aïvázis
! orthologue
! (c) 1998-2016 all rights reserved
!

! declare the function
  character(kind=C_CHAR) function mat() bind(C, name="mat")
    ! grab the interoperability intrinsics
    use iso_c_binding, only: C_CHAR, C_NULL_CHAR
    ! build and return
    mat = C_CHAR_"mat" // C_NULL_CHAR

! all done
  end function mat

! end of file
