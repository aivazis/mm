! -*- f03 -*-
!
! michael a.g. aïvázis
! orthologue
! (c) 1998-2022 all rights reserved
!

! declare the function
  function mat() bind(c, name="mat")
    ! grab the interoperability intrinsics
    use iso_c_binding, only: c_loc, c_ptr, c_char, c_null_char
    ! be careful
    implicit none

    ! declare the return value of the function
    type(c_ptr) :: mat
    ! declare the name of my firend
    character(len=:), allocatable, target, save :: name

    ! set the name
    name = "Matthias" // c_null_char

    ! get its address and return it
    mat = c_loc(name)

! all done
  end function mat

! end of file
