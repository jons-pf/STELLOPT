!-----------------------------------------------------------------------
!     Module:        beams3d_free
!     Authors:       S. Lazerson (lazerson@pppl.gov), M. McMillan (matthew.mcmillan@my.wheaton.edu)
!     Date:          12/15/2014
!     Description:   Deallocate and free all arrays. 
!-----------------------------------------------------------------------
      SUBROUTINE beams3d_free
!-----------------------------------------------------------------------
!     Libraries
!-----------------------------------------------------------------------
      USE beams3d_runtime
      USE beams3d_grid
      USE beams3d_lines, ONLY: R_lines, PHI_lines, Z_lines, vll_lines, &
                               neut_lines, moment_lines, S_lines, U_lines, &
                               PE_lines, PI_lines, shine_through, &
                               ndot_prof, epower_prof, ipower_prof, j_prof,&
                               B_lines
!      USE wall_mod, ONLY: wall_free
      USE EZspline_obj
      USE mpi_sharmem
!-----------------------------------------------------------------------
!     Local Variables
!          ier            Error Flag
!          iunit          File ID Number
!-----------------------------------------------------------------------
      IMPLICIT NONE
      INTEGER :: ier
!-----------------------------------------------------------------------
!     External Functions
!          A00ADF               NAG Detection
!-----------------------------------------------------------------------
!      EXTERNAL A00ADF
!-----------------------------------------------------------------------
!     Begin Subroutine
!-----------------------------------------------------------------------
      ier = 0
      !IF (lvessel) CALL wall_free(ier)  !Moved to beams3d_follow
      IF (EZspline_allocated(BR_spl))   CALL EZspline_free(BR_spl,ier)
      IF (EZspline_allocated(BZ_spl))   CALL EZspline_free(BZ_spl,ier)
      IF (EZspline_allocated(BPHI_spl)) CALL EZspline_free(BPHI_spl,ier)
      IF (EZspline_allocated(MODB_spl)) CALL EZspline_free(MODB_spl,ier)
      IF (EZspline_allocated(S_spl)) CALL EZspline_free(S_spl,ier)
      IF (EZspline_allocated(U_spl)) CALL EZspline_free(U_spl,ier)
      IF (EZspline_allocated(TE_spl))   CALL EZspline_free(TE_spl,ier)
      IF (EZspline_allocated(NE_spl))   CALL EZspline_free(NE_spl,ier)
      IF (EZspline_allocated(TI_spl))   CALL EZspline_free(TI_spl,ier)
      IF (EZspline_allocated(ZEFF_spl))   CALL EZspline_free(ZEFF_spl,ier)
      IF (EZspline_allocated(POT_spl))   CALL EZspline_free(POT_spl,ier)
      IF (EZspline_allocated(TE_spl_s))   CALL EZspline_free(TE_spl_s,ier)
      IF (EZspline_allocated(NE_spl_s))   CALL EZspline_free(NE_spl_s,ier)
      IF (EZspline_allocated(TI_spl_s))   CALL EZspline_free(TI_spl_S,ier)
      IF (EZspline_allocated(Vp_spl_s))   CALL EZspline_free(Vp_spl_S,ier)
      IF (ALLOCATED(R_lines)) DEALLOCATE(R_lines)
      IF (ALLOCATED(PHI_lines)) DEALLOCATE(PHI_lines)
      IF (ALLOCATED(Z_lines)) DEALLOCATE(Z_lines)
      IF (ALLOCATED(vll_lines)) DEALLOCATE(vll_lines)
      IF (ALLOCATED(neut_lines)) DEALLOCATE(neut_lines)
      IF (ALLOCATED(moment_lines)) DEALLOCATE(moment_lines)
      IF (ALLOCATED(PE_lines)) DEALLOCATE(PE_lines)
      IF (ALLOCATED(PI_lines)) DEALLOCATE(PI_lines)
      IF (ALLOCATED(S_lines)) DEALLOCATE(S_lines)
      IF (ALLOCATED(U_lines)) DEALLOCATE(U_lines)
      IF (ALLOCATED(B_lines)) DEALLOCATE(B_lines)
      IF (ALLOCATED(weight)) DEALLOCATE(weight)
      IF (ALLOCATED(beam)) DEALLOCATE(beam)
      IF (ASSOCIATED(raxis)) CALL mpidealloc(raxis,win_raxis)
      IF (ASSOCIATED(phiaxis)) CALL mpidealloc(phiaxis,win_phiaxis)
      IF (ASSOCIATED(zaxis)) CALL mpidealloc(zaxis,win_zaxis)
      IF (ASSOCIATED(B_R))      CALL mpidealloc(B_R,win_B_R)
      IF (ASSOCIATED(B_PHI))    CALL mpidealloc(B_PHI,win_B_PHI)
      IF (ASSOCIATED(B_Z))      CALL mpidealloc(B_Z,win_B_Z)
      IF (ASSOCIATED(MODB))     CALL mpidealloc(MODB,win_MODB)
      IF (ASSOCIATED(S_ARR))    CALL mpidealloc(S_ARR,win_S_ARR)
      IF (ASSOCIATED(U_ARR))    CALL mpidealloc(U_ARR,win_U_ARR)
      IF (ASSOCIATED(TE))       CALL mpidealloc(TE,win_TE)
      IF (ASSOCIATED(TI))       CALL mpidealloc(TI,win_TI)
      IF (ASSOCIATED(NE))       CALL mpidealloc(NE,win_NE)
      IF (ASSOCIATED(ZEFF_ARR)) CALL mpidealloc(ZEFF_ARR,win_ZEFF_ARR)
      IF (ASSOCIATED(POT_ARR))  CALL mpidealloc(POT_ARR,win_POT_ARR)
      IF (ASSOCIATED(BR4D))     CALL mpidealloc(BR4D,win_BR4D)
      IF (ASSOCIATED(BPHI4D))   CALL mpidealloc(BPHI4D,win_BPHI4D)
      IF (ASSOCIATED(BZ4D))     CALL mpidealloc(BZ4D,win_BZ4D)
      IF (ASSOCIATED(MODB4D))   CALL mpidealloc(MODB4D,win_MODB4D)
      IF (ASSOCIATED(TE4D))     CALL mpidealloc(TE4D,win_TE4D)
      IF (ASSOCIATED(NE4D))     CALL mpidealloc(NE4D,win_NE4D)
      IF (ASSOCIATED(TI4D))     CALL mpidealloc(TI4D,win_TI4D)
      IF (ASSOCIATED(ZEFF4D))   CALL mpidealloc(ZEFF4D,win_ZEFF4D)
      IF (ASSOCIATED(S4D))      CALL mpidealloc(S4D,win_S4D)
      IF (ASSOCIATED(U4D))      CALL mpidealloc(U4D,win_U4D)
      IF (ASSOCIATED(POT4D))    CALL mpidealloc(POT4D,win_POT4D)
      IF (ALLOCATED(R_start))   DEALLOCATE(R_start)
      IF (ALLOCATED(phi_start)) DEALLOCATE(phi_start)
      IF (ALLOCATED(Z_start))   DEALLOCATE(Z_start)
      IF (ALLOCATED(v_neut))    DEALLOCATE(v_neut)
      IF (ALLOCATED(mass))      DEALLOCATE(mass)
      IF (ALLOCATED(charge))    DEALLOCATE(charge)
      IF (ALLOCATED(mu_start))  DEALLOCATE(mu_start)
      IF (ALLOCATED(Zatom))     DEALLOCATE(Zatom)
      IF (ALLOCATED(t_end))     DEALLOCATE(t_end)
      IF (ALLOCATED(vll_start)) DEALLOCATE(vll_start)
      IF (ALLOCATED(beam))      DEALLOCATE(beam)
      IF (ALLOCATED(weight))    DEALLOCATE(weight)
      IF (ALLOCATED(shine_through))    DEALLOCATE(shine_through)
      IF (ALLOCATED(ndot_prof))    DEALLOCATE(ndot_prof)
      IF (ALLOCATED(epower_prof))    DEALLOCATE(epower_prof)
      IF (ALLOCATED(ipower_prof))    DEALLOCATE(ipower_prof)
      IF (ALLOCATED(j_prof))    DEALLOCATE(j_prof)
      RETURN
!-----------------------------------------------------------------------
!     End Subroutine
!-----------------------------------------------------------------------    
      END SUBROUTINE beams3d_free