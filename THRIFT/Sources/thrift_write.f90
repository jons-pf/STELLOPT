!-----------------------------------------------------------------------
!     Subroutine:    thrift_write
!     Authors:       S. Lazerson
!     Date:          12/20/2022
!     Description:   This subroutine writes the HDF5 output for THRIFT.
!-----------------------------------------------------------------------
      SUBROUTINE thrift_write
!-----------------------------------------------------------------------
!     Libraries
!-----------------------------------------------------------------------
      USE thrift_runtime
      USE thrift_vars
#if defined(LHDF5)
      USE ez_hdf5
#endif
!-----------------------------------------------------------------------
!     Local Variables
!        ier         Error flag
!-----------------------------------------------------------------------
      IMPLICIT NONE
      INTEGER :: ier
!----------------------------------------------------------------------
!     BEGIN SUBROUTINE
!----------------------------------------------------------------------
      IF (myworkid == master) THEN
#if defined(LHDF5)
         CALL open_hdf5('thrift_'//TRIM(id_string)//'.h5',fid,ier,LCREATE=.true.)
         IF (ier /= 0) CALL handle_err(HDF5_OPEN_ERR,'thrift_'//TRIM(id_string)//'.h5',ier)
         ! Version
         CALL write_scalar_hdf5(fid,'VERSION',ier,DBLVAR=THRIFT_VERSION,ATT='Version Number',ATT_NAME='description')
         IF (ier /= 0) CALL handle_err(HDF5_WRITE_ERR,'VERSION',ier)
         ! Logicals
         CALL write_scalar_hdf5(fid,'lvmec',ier,BOOVAR=lvmec,ATT='VMEC input',ATT_NAME='description')
         IF (ier /= 0) CALL handle_err(HDF5_WRITE_ERR,'lvmec',ier)
         CALL write_scalar_hdf5(fid,'leccd',ier,BOOVAR=leccd,ATT='ECCD Present',ATT_NAME='description')
         IF (ier /= 0) CALL handle_err(HDF5_WRITE_ERR,'leccd',ier)
         CALL write_scalar_hdf5(fid,'lnbcd',ier,BOOVAR=lnbcd,ATT='NBCD Present',ATT_NAME='description')
         IF (ier /= 0) CALL handle_err(HDF5_WRITE_ERR,'lnbcd',ier)
         CALL write_scalar_hdf5(fid,'lohmic',ier,BOOVAR=lohmic,ATT='Ohmic CD Present',ATT_NAME='description')
         IF (ier /= 0) CALL handle_err(HDF5_WRITE_ERR,'lohmic',ier)
         ! Integers
         CALL write_scalar_hdf5(fid,'ntimesteps',ier,INTVAR=ntimesteps,ATT='Number of Time Steps',ATT_NAME='description')
         IF (ier /= 0) CALL handle_err(HDF5_WRITE_ERR,'ntimesteps',ier)
         CALL write_scalar_hdf5(fid,'nrho',ier,INTVAR=nrho,ATT='Number of Radial Gridpoints',ATT_NAME='description')
         IF (ier /= 0) CALL handle_err(HDF5_WRITE_ERR,'nrho',ier)
         CALL write_scalar_hdf5(fid,'npicard',ier,INTVAR=npicard,ATT='Maximum number of Picard Iterations',ATT_NAME='description')
         IF (ier /= 0) CALL handle_err(HDF5_WRITE_ERR,'npicard',ier)
         ! Floats
         CALL write_scalar_hdf5(fid,'jtol',ier,DBLVAR=jtol,ATT='j convergence factor [%]',ATT_NAME='description')
         IF (ier /= 0) CALL handle_err(HDF5_WRITE_ERR,'jtol',ier)
         CALL write_scalar_hdf5(fid,'picard_factor',ier,DBLVAR=picard_factor,ATT='Picard Iteration Factor',ATT_NAME='description')
         IF (ier /= 0) CALL handle_err(HDF5_WRITE_ERR,'picard_factor',ier)
         ! 1D Floats
         CALL write_var_hdf5(fid,'THRIFT_RHO',nrho,ier,DBLVAR=THRIFT_RHO,ATT='Radial Grid (r/a)',ATT_NAME='description')
         IF (ier /= 0) CALL handle_err(HDF5_WRITE_ERR,'THRIFT_RHO',ier)
         CALL write_var_hdf5(fid,'THRIFT_T',ntimesteps,ier,DBLVAR=THRIFT_T,ATT='Time Slice Grid [s]',ATT_NAME='description')
         IF (ier /= 0) CALL handle_err(HDF5_WRITE_ERR,'THRIFT_T',ier)
         ! 2D Floats
         CALL write_var_hdf5(fid,'THRIFT_J',nrho,ntimesteps,ier,DBLVAR=THRIFT_J,ATT='Total Current Density [A/m^2]',ATT_NAME='description')
         IF (ier /= 0) CALL handle_err(HDF5_WRITE_ERR,'THRIFT_J',ier)
         CALL write_var_hdf5(fid,'THRIFT_JBOOT',nrho,ntimesteps,ier,DBLVAR=THRIFT_JBOOT,ATT='Total Bootstrap Current Density [A/m^2]',ATT_NAME='description')
         IF (ier /= 0) CALL handle_err(HDF5_WRITE_ERR,'THRIFT_JBOOT',ier)
         CALL write_var_hdf5(fid,'THRIFT_JECCD',nrho,ntimesteps,ier,DBLVAR=THRIFT_JECCD,ATT='Total ECCD Current Density [A/m^2]',ATT_NAME='description')
         IF (ier /= 0) CALL handle_err(HDF5_WRITE_ERR,'THRIFT_JECCD',ier)
         CALL write_var_hdf5(fid,'THRIFT_JNBCD',nrho,ntimesteps,ier,DBLVAR=THRIFT_JNBCD,ATT='Total NBCD Current Density [A/m^2]',ATT_NAME='description')
         IF (ier /= 0) CALL handle_err(HDF5_WRITE_ERR,'THRIFT_JNBCD',ier)
         CALL write_var_hdf5(fid,'THRIFT_JOHMIC',nrho,ntimesteps,ier,DBLVAR=THRIFT_JOHMIC,ATT='Total Ohmic Current Density [A/m^2]',ATT_NAME='description')
         IF (ier /= 0) CALL handle_err(HDF5_WRITE_ERR,'THRIFT_JOHMIC',ier)
         CALL write_var_hdf5(fid,'THRIFT_JPLASMA',nrho,ntimesteps,ier,DBLVAR=THRIFT_JPLASMA,ATT='Total Plasma Response Current Density [A/m^2]',ATT_NAME='description')
         IF (ier /= 0) CALL handle_err(HDF5_WRITE_ERR,'THRIFT_JPLASMA',ier)
         CALL write_var_hdf5(fid,'THRIFT_JSOURCE',nrho,ntimesteps,ier,DBLVAR=THRIFT_JSOURCE,ATT='Total Source Current Density [A/m^2]',ATT_NAME='description')
         IF (ier /= 0) CALL handle_err(HDF5_WRITE_ERR,'THRIFT_JSOURCE',ier)
         CALL close_hdf5(fid,ier)
         IF (ier /= 0) CALL handle_err(HDF5_CLOSE_ERR,'thrift_'//TRIM(id_string)//'.h5',ier)
#else
         WRITE(6,'(A)')  '   FILE: '//'thrift_'//TRIM(id_string)//'.bin'
         CALL safe_open(iunit,ier,'thrift_'//TRIM(id_string)//'.bin','replace','unformatted')
         ! Version
         WRITE(iunit,*) THRIFT_VERSION
         ! Logicals
         WRITE(iunit,*) lvmec, leccd, lnbcd, lohmic
         ! Integers
         WRITE(iunit,*) ntimesteps, nrho, npicard
         ! Floats
         WRITE(iunit,*) jtol, picard_factor
         ! 1D Floats
         WRITE(iunit,*) THRIFT_RHO
         WRITE(iunit,*) THRIFT_T
         ! 2D Floats
         WRITE(iunit,*) THRIFT_J
         WRITE(iunit,*) THRIFT_JBOOT
         WRITE(iunit,*) THRIFT_JECCD
         WRITE(iunit,*) THRIFT_JNBCD
         WRITE(iunit,*) THRIFT_JOHMIC
         WRITE(iunit,*) THRIFT_JPLASMA
         WRITE(iunit,*) THRIFT_JSOURCE
         CLOSE(iunit)
#endif
      END IF

      RETURN
!----------------------------------------------------------------------
!     END SUBROUTINE
!----------------------------------------------------------------------
      END SUBROUTINE thrift_write
