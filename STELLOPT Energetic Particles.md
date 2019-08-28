Tutorial: STELLOPT Energetic Particle Optimization
==================================================

[image:BEAMS3D\_orbits.jpg width=\"414\" height=\"225\" align=\"right\"](image:BEAMS3D_orbits.jpg width="414" height="225" align="right")The
[STELLOPT](STELLOPT) code can target energetic particle confinement
using the [BEAMS3D](BEAMS3D) neutral beam package as a collision less
gyro-particle integrator. When run in this manner the
[STELLOPT](STELLOPT) code initialises the particle starting points and
energies for [BEAMS3D](BEAMS3D) (skipping over the neutral beam
injection parts of the code). For equilibrium run in fixed boundary
mode, [STELLOPT](STELLOPT) constructs a tessellated wall at the
[VMEC](VMEC) boundary. All particles which hit this wall are considered
lost.

------------------------------------------------------------------------

1.  \_\_**Input namelists**\_\_ \> In addition to the OPTIMUM name list
    the BEAMS3D\_INPUT name list must be included in the STELLOPT input
    file (also the INDATA namelist). The STELLOPT namelist should
    include the NPOPULATION parameter, this determines how to divide up
    the processors. For example if you has 256 processors available and
    NPOPULATION was set to 8, STELLOPT would execute with 8 processors
    doing the optimization while each of those 8 processors would have
    an addition 31 processors sitting around to help run BEAMS3D. Thus
    you could have up to 8 copies of BEAMS3D running with 32 processors
    each. Below is an example (truncated) set of namelists: \>
    [code format=\"fortran\"](code format="fortran") &INDATA \... LFREEB
    = F \... /&OPTIMUM \... NPOPULATION = 8 ! See text above \...
    !\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--
    ! Particle Transport ! Mu = 0.5\*m\*v\*v/B or (Thermal Energy)/B
    !\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--
    NU\_ORBIT = 10 ! Number of poloidal starting points per flux surface
    NV\_ORBIT = 10 ! Number of toroidal starting points per flux surface
    NP\_ORBIT = 20 ! Number of pitch angle to evaluate at each starting
    point MASS\_ORBIT = 6.64424E-27 ! Mass of energetic particles \[kg\]
    (alpha in this case) Z\_ORBIT = 2 ! Charge number of energetic
    particles VLL\_ORBIT = 20\*7.76E5 ! Array of parallel velocities
    \[m/s\] (NP\_ORBIT) ! Array of Mangetic moments (NP\_ORBIT) \[J/T\]
    MU\_ORBIT = 5.3405911000E-16 1.0681182200E-15 1.6021773300E-15
    2.1362364400E-15 2.6702955500E-15 3.2043546600E-15 3.7384137700E-15
    4.2724728800E-15 4.8065319900E-15 5.3405911000E-15 5.8746502100E-15
    6.4087093200E-15 6.9427684300E-15 7.4768275400E-15 8.0108866500E-15
    8.5449457600E-15 9.0790048700E-15 9.6130639800E-15 1.0147123090E-14
    1.0681182200E-14 TARGET\_ORBIT(10) = 0.0 SIGMA\_ORBIT(10) = 1.0 !
    Target and sigma for a given flux surface. / &BEAMS3D\_INPUT ! Note
    when run from inside STELLOPT the RMIN/RMAX ! ZMIN/ZMAX and
    PHIMIN/PHIMAX parameters are ! automatically set. NR = 201 ! Radial
    Grid points NZ = 201 ! Vertical Grid points NPHI = 60 ! Toroidal
    grid points NPOINC = 2000 ! Number of output time steps (actual time
    steps set by code) T\_END\_IN = 2\*0.003 ! Maximum time to follow
    particles (approximate slowing down time) INT\_TYPE = \'LSODE\' !
    Integrator (NAG/LSODE/RKH68) FOLLOW\_TOL = 1.00000000000000E-09 !
    Trajectory following tolerance (NAG,LSODE) / &END [code](code) \> In
    the above example the VMEC flux surface ns=10 is initialized at 100
    (10x10) unique poloidal and toroidal points. At each of these points
    20 particles are launched with mangetic moments (MU\_ORBIT) and
    parallel velocities (VLL\_ORBIT) as specified in associated arrays.
    In this way the user can set the pitch angles which are evaluated,
    the result being 2000 particles being launched from surface 10. If
    an additional surface had been specified (through TARGET\_ORBIT and
    SIGMA\_ORBIT) the total number of particles followed would be 4,000
    (and so on). It should be noted that while the STELLOPT electron
    temperature and density will be read, it is not used as only
    collisionless particle orbits are currently followed. Alternatively,
    the user may set an array called VPERP\_ORBIT which then overrides
    MU\_ORBIT. The equilibirum modB, VPERP\_ORBIT and MASS\_ORBIT are
    then used to calculate MU\_ORBIT for the run.
2.  \_\_**Execute the code**\_\_ \> The coupled BEAMS3D/STELLOPT codes
    will execute like any other STELLOPT run (note in this example
    we\'ve used the SINGLE\_ITER optimization type and set
    NPOPULATION=1) \>
    [code format=\"bash\"](code format="bash") \>mpirun -np 128
    /bin/xstelloptv2 input.LI383\_muscan STELLOPT Version 2.46
    Equilibrium calculation provided by:
    =================================================================================
    ========= Variational Moments Equilibrium Code (v 8.52) =========
    ========= (S. Hirshman, J. Whitson) ========= =========
    <http://vmecwiki.pppl.wikispaces.net/VMEC> =========
    =================================================================================

Energetic Particle calculation provided by:
=================================================================================
========= BEAMS3D (v 1.10) ========= ========= (M. McMillan, S.
Lazerson) ========= ========= lazerson\@pppl.gov ========= =========
<http://vmecwiki.pppl.wikispaces.net/BEAMS3D> =========
=================================================================================

\-\-\-\-- Optimization \-\-\-\-- =======VARS======= PHIEDGE: Total
Enclosed Toroidal Flux CURTOR: Total Toroidal Current RHO(-005, 001):
Boundary Specifiction (Hirsh. -Bres.) RHO(-004, 001): Boundary
Specifiction (Hirsh. -Bres.) RHO(-003, 001): Boundary Specifiction
(Hirsh. -Bres.) RHO(-002, 001): Boundary Specifiction (Hirsh. -Bres.)
RHO(-001, 001): Boundary Specifiction (Hirsh. -Bres.) RHO( 000, 001):
Boundary Specifiction (Hirsh. -Bres.) RHO( 001, 001): Boundary
Specifiction (Hirsh. -Bres.) RHO( 002, 001): Boundary Specifiction
(Hirsh. -Bres.) RHO( 003, 001): Boundary Specifiction (Hirsh. -Bres.)
RHO( 004, 001): Boundary Specifiction (Hirsh. -Bres.) RHO( 005, 001):
Boundary Specifiction (Hirsh. -Bres.)

Accuracy of conversion =  100.00%
---------------------------------

###### TARGETS

Ballooning Stability Particle Orbits (BEAMS3D) ================== Number
of Processors: 128 Number of Parameters: 13 Number of Targets: 99 !!!!
EQUILIBRIUM RESTARTING NOT UTILIZED !!!! Number of Optimizer Threads: 1
OPTIMIZER: SINGLE\_ITERATION NFUNC\_MAX: 100
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-- EQUILIBRIUM
CALCULATION \-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-- NS = 9 NO.
FOURIER MODES = 94 FTOLV = 1.000E-06 NITER = 1000 INITIAL JACOBIAN
CHANGED SIGN! TRYING TO IMPROVE INITIAL MAGNETIC AXIS GUESS ITER FSQR
FSQZ FSQL RAX(v=0) DELT WMHD 1 1.06E+00 1.63E-01 1.71E-01 1.604E+00
9.00E-01 3.7587E+00 124 8.81E-07 3.71E-07 1.66E-07 1.582E+00 8.10E-01
3.6372E+00 NS = 29 NO. FOURIER MODES = 94 FTOLV = 1.000E-08 NITER = 2000
ITER FSQR FSQZ FSQL RAX(v=0) DELT WMHD 1 3.90E-02 1.86E-02 3.13E-04
1.582E+00 9.00E-01 3.6369E+00 200 1.47E-07 4.25E-08 6.33E-08 1.581E+00
6.87E-01 3.6366E+00 334 9.87E-09 1.78E-09 4.09E-09 1.579E+00 6.87E-01
3.6366E+00 NS = 49 NO. FOURIER MODES = 94 FTOLV = 1.000E-10 NITER = 4000
ITER FSQR FSQZ FSQL RAX(v=0) DELT WMHD 1 7.46E-03 3.99E-03 4.87E-06
1.579E+00 9.00E-01 3.6366E+00 200 3.56E-07 8.49E-08 1.73E-07 1.581E+00
6.00E-01 3.6366E+00 400 8.96E-09 1.79E-09 2.91E-09 1.579E+00 6.00E-01
3.6366E+00 600 1.57E-09 3.83E-10 4.23E-10 1.578E+00 6.00E-01 3.6366E+00
800 4.62E-10 8.32E-11 6.22E-11 1.578E+00 6.00E-01 3.6366E+00 991
9.91E-11 1.91E-11 1.28E-11 1.578E+00 6.00E-01 3.6366E+00 NS = 99 NO.
FOURIER MODES = 94 FTOLV = 1.000E-12 NITER = 10000 ITER FSQR FSQZ FSQL
RAX(v=0) DELT WMHD 1 2.25E-02 1.23E-02 1.78E-06 1.578E+00 9.00E-01
3.6366E+00 200 8.50E-07 2.35E-07 4.69E-07 1.582E+00 4.86E-01 3.6366E+00
400 2.11E-08 4.23E-09 8.91E-09 1.579E+00 4.86E-01 3.6366E+00 600
3.79E-09 7.59E-10 9.73E-10 1.578E+00 4.86E-01 3.6366E+00 800 1.19E-09
2.54E-10 2.20E-10 1.578E+00 4.86E-01 3.6366E+00 1000 4.79E-10 8.89E-11
5.58E-11 1.578E+00 4.86E-01 3.6366E+00 1200 1.61E-10 3.18E-11 1.71E-11
1.578E+00 4.86E-01 3.6366E+00 1400 4.86E-11 1.35E-11 5.24E-12 1.578E+00
4.86E-01 3.6366E+00 1600 1.68E-11 5.40E-12 1.70E-12 1.578E+00 4.86E-01
3.6366E+00 1800 6.07E-12 2.00E-12 4.87E-13 1.578E+00 4.86E-01 3.6366E+00
2000 2.25E-12 6.99E-13 1.33E-13 1.578E+00 4.86E-01 3.6366E+00 2181
1.00E-12 3.04E-13 4.65E-14 1.578E+00 4.86E-01 3.6366E+00 EXECUTION
TERMINATED NORMALLY FILE : reset\_file NUMBER OF JACOBIAN RESETS = 5
TOTAL COMPUTATIONAL TIME 106.41 SECONDS TIME TO READ IN DATA 0.00
SECONDS TIME TO WRITE DATA TO WOUT 0.06 SECONDS TIME IN EQFORCE 1.05
SECONDS TIME IN FOURIER TRANSFORM 28.76 SECONDS TIME IN INVERSE FOURIER
XFORM 23.58 SECONDS TIME IN FORCES + SYMFORCES 21.96 SECONDS TIME IN
BCOVAR 18.48 SECONDS TIME IN RESIDUE 2.64 SECONDS TIME (REMAINDER) IN
FUNCT3D 9.01 SECONDS
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-- VMEC CALCULATION
DONE \-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-- ASPECT RATIO:
4.365 BETA: 0.042 (total) 0.584 (poloidal) 0.046 (toroidal) TORIDAL
CURRENT: -0.174295786408E+06 TORIDAL FLUX: 0.514 VOLUME: 2.979 MAJOR
RADIUS: 1.422 MINOR\_RADIUS: 0.326 STORED ENERGY: 0.192542558126E+06
BEAMS3D Version 1.10 \-\-\-\-- Particle Initialization \-\-\-\-- S = \[
0.09184, 0.09184\]; NS: 1 U = \[ 0.00000, 5.65487\]; NU: 10 V = \[
0.00000, 5.65487\]; NV: 10 V\_\|\|= \[ 0.00E+00, 5.00E+05\]; NP: 20 Mu =
\[ 0.00000, 1.07E-14\]; NP: 20 \-\-\-\-- Profile Initialization
\-\-\-\-- Ne = \[ -0.00, 5.00\] 10\^19 \[m\^-3\]; Nne: 50 Te = \[ -0.00,
4.58\] \[keV\]; Nte: 50 Ti = \[ -0.00, 4.58\] \[keV\]; Nti: 50 \-\-\-\--
Input Parameters \-\-\-\-- R = \[ 0.95223, 1.82142\]; NR: 201 PHI = \[
0.00000, 2.09440\]; NPHI: 60 Z = \[-0.66634, 0.66634\]; NZ: 201

1.  of Particles to Start: 2000 \-\-\-\-- Vessel Information \-\-\-\--
    Wall Name : HARMONICS Date : TODAY Faces : 28800 \-\-\-\--
    Constructing Splines \-\-\-\-- R = \[ 0.95223, 1.82142\]; NR: 201
    PHI = \[ 0.00000, 2.09440\]; NPHI: 60 Z = \[-0.66634, 0.66634\]; NZ:
    201 HERMITE FORM: 1 \-\-\-\-- FOLLOWING PARTICLE TRAJECTORIES
    \-\-\-\-- Method: LSODE Particles: 2000 Steps: 15000 Delta-t:
    0.2000E-06 NPOINC: 2000 dt\_out: 0.1500E-05 Tol: 0.1000E-08 Type: 10
    \-\-\-\-- CONVERTING TO FLUX COORDINATES \-\-\-\-- \-\-\-\-- WRITING
    DATA TO FILE \-\-\-\-- FILE: beams3d\_reset\_file.h5 \-\-\-\--
    BEAMS3D DONE \-\-\-\-- ns flux Lost(%) 10 0.09184 33.5 \-\-\-\--
    STELLOPT DONE \-\-\-\-- \> [code](code)
2.  \_\_**Examine the output**\_\_ \> The STELLOPT code will run as it
    usually does, however now BEAMS3D HDF5 output files will be
    produced. Given the large size of these files, only the first file
    HDF5 file produced will contain the full trajectory of particles
    followed (NPOINC locations along each trajectory). The additional
    files will just record the positions along the boundary where
    particles left the equilibrium. The \'stellopt\' file will include
    the loss fraction from each surface. \>