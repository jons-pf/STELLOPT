STELLOPT Compilation at the MPCDF (RZG-MPG Machines)
====================================================

This page details how to compile the STELLOPT family of codes on Hydra
at [Rechenzentrum Garching](@http://www.rzg.mpg.de/) (RZG-MPE). In order
to do so you will need an account on their system. These build
instructions are for the Intel based compilers

Hydra
-----

    module load git
    module load intel/16.0
    module load mkl/11.3
    module load mpi.ibm/1.4.0
    module load netcdf-mpi/4.4.0
    module load hdf5-mpi/1.8.16
    module load fftw/3.3.4
    module load petsc-cplx/3.7.2
    module load slepc-cplx/3.7.2
    module load nag_flib/intel/mk24

Draco
-----

    module load git
    module load intel
    module load mkl
    module load impi
    module load netcdf-mpi
    module load hdf5-mpi
    module load fftw
    module load petsc-cplx
    module load slepc-cplx
    module load nag_flib/intel/mk24

Cobra
-----

    module load git
    module load intel
    module load mkl
    module load impi
    module load hdf5-mpi
    module load netcdf-mpi
    module load fftw-mpi
    module load petsc-complex
    module load slepc-complex

General Notes
-------------

You will need to repoint the make.inc file in the main directory at the
appropriate file in SHARE. For example make.inc should point at
SHARE/make\_cobra.inc to compile on Cobra. Also take care that you
compile other codes (like GENE, SFINCS, etc.) first before compiling
STELLOPT.