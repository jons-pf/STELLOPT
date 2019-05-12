      MODULE fbal
      USE stel_kinds, ONLY: dp
      REAL(dp), DIMENSION(:), ALLOCATABLE :: rzu_fac, rru_fac,
     1  frcc_fac, fzsc_fac

      CONTAINS

      SUBROUTINE calc_fbal(bsubu, bsubv)
      USE vmec_main, ONLY: buco, bvco, equif, 
     1                     jcurv, jcuru, chipf, vp, pres, 
     2                     phipf, vpphi, presgrad, ohs
#ifdef _ANIMEC
     3                    ,pmap, pd, phot, tpotb, zero, one
     4                    ,p5 => cp5
#endif
      USE vmec_params, ONLY: signgs
      USE vmec_dim, ONLY: ns, nrzt, nznt, ns1
      USE vmec_input, ONLY: lrfp
      USE realspace, ONLY: wint, phip
#ifdef _ANIMEC
     1                    ,pperp, ppar, onembc, sigma_an,
     2                     pp1, pp2, pp3
      USE vforces, gsqrt => azmn_o, bsq => bzmn_o
#endif
!-----------------------------------------------
      REAL(dp), INTENT(in) :: bsubu(1:nrzt), bsubv(1:nrzt)
!-----------------------------------------------
!   L o c a l   V a r i a b l e s
!-----------------------------------------------
      INTEGER  :: js
#ifdef _ANIMEC
      INTEGER  :: lk
      REAL(dp) :: t4, t5
#endif
!-----------------------------------------------
      DO js = 2, ns
         buco(js) = SUM(bsubu(js:nrzt:ns)*wint(js:nrzt:ns))
         bvco(js) = SUM(bsubv(js:nrzt:ns)*wint(js:nrzt:ns))
      END DO

!     FROM AMPERE'S LAW, JcurX are angle averages of jac*JsupX, so
!                        JcurX = (dV/ds)/twopi**2 <JsupX> where <...> is flux surface average
#ifdef _ANIMEC
      IF (ANY(phot .ne. zero)) THEN
         pp3(1:nrzt:ns) = 0
         DO js = 2,ns
            DO lk = 1,nznt
               pp3(js:nrzt:ns) = gsqrt(js:nrzt:ns)/vp(js)
!               l = js +(lk-1)*ns
!               pp3(l) = gsqrt(l)/vp(js)
            END DO
         END DO	

         CALL EPwell_ppargrad(pp2,pp3,bsq,pres)

         DO js = 2, ns1
            pmap (js) = SUM(pp2(js:nrzt:ns)*wint(js:nrzt:ns))
         END DO
      ELSE
         pmap   = 0
      END IF
#endif
      DO js = 2, ns1
         jcurv(js) = (signgs*ohs)*(buco(js+1) - buco(js))
         jcuru(js) =-(signgs*ohs)*(bvco(js+1) - bvco(js))
!FOR RFP vpphi(js) = (vp(js+1)/phip(js+1) + vp(js)/phip(js))/2
         vpphi(js) = (vp(js+1) + vp(js))/2
         presgrad(js) = (pres(js+1) - pres(js))*ohs   !isotropic pressure radial gradient component
#ifdef _ANIMEC
!...pd contains -Delta_p(omega'+omega*V"/V') ==> -bcrit*(tpotb+phot*pppr/vp) on
!...the half integer mesh computed in subroutine an_pressure of module bcovar
         presgrad(js)=presgrad(js)*(one+cp5*(pd(js+1)+pd(js)))
         t4 = signgs*pmap(js)*ohs*(pd(js+1)-pd(js))
         presgrad(js) = presgrad(js) + t4
#endif
         equif(js) = (-phipf(js)*jcuru(js) + chipf(js)*jcurv(js))
     1                /vpphi(js) + presgrad(js)
      END DO

      equif(1) = 0
      equif(ns) = 0

      END SUBROUTINE calc_fbal

#ifdef _ANIMEC
      SUBROUTINE EPwell_ppargrad(pp2, pp3, bsq, pres)
      USE vmec_main, ONLY: zero ,p5 => cp5
      USE vmec_dim, ONLY: ns, nznt, nrzt
C-----------------------------------------------
C   D u m m y   A r g u m e n t s
C-----------------------------------------------
      REAL(dp), INTENT(in) :: pp3(nrzt), bsq(nrzt), pres(ns)
      REAL(dp), INTENT(out):: pp2(nrzt)
C-----------------------------------------------
C   L o c a l   V a r i a b l e s
C-----------------------------------------------
      INTEGER     :: js, lk, l
      REAL(dp), ALLOCATABLE :: tmp0(:)
      REAL(dp) :: eps
C-----------------------------------------------
!********0*********0*********0*********0*********0*********0*********0**
! Model with Anisotropic Pressure from Adjoint Method Figure of Merit. *
! EVALUATION OF AMPLITUDES OF partial p_parallel/partial s AT FIXED B. *
! Compute anisotropic component parallel pressure gradient at fixed B  *
! times PP3.    PP3 can be sqrt(g), sqrt(g)/V' or unity                *
!*********0*********0*********0*********0*********0*********0*********0*
      eps = EPSILON(eps)
      ALLOCATE (tmp0(nrzt))

!      pp1(1:nrzt:ns) = 0;
      pp2(1:nrzt:ns) = 0
      DO js = 2, ns
         tmp0(js:nrzt:ns) = pp3(js:nrzt:ns)*(bsq(js:nrzt:ns)+pres(js))
      END DO

      DO l = 1,nrzt-1      !interpolation to integer mesh
         pp2(l) = cp5*(tmp0(l)+tmp0(l+1))
      END DO

!     DEALLOCATE (tmp0, tmp2)
      DEALLOCATE (tmp0)

      END SUBROUTINE EPwell_ppargrad

      SUBROUTINE mirror_crit(taumir, bsq)
      USE stel_kinds, ONLY: rprec, dp
      USE realspace, ONLY: sigma_an, pperp, ppar
!      USE vforces,   ONLY: bsq => bzmn_o
      USE vmec_main, ONLY: pd, tpotb, pppr, pres, papr, wb,
     &                     wp, wpar, wper, ns, nznt, nrzt, 
     &                     zero, one, nthreed, phot, phips, vp, bcrit
!
!     WAC (11/30/07): See description of anisotropic pressure below
!
      IMPLICIT NONE
C-----------------------------------------------
C   D u m m y   A r g u m e n t s
C-----------------------------------------------
      REAL(dp), DIMENSION(nrzt), INTENT(out)            :: taumir
      REAL(dp), DIMENSION(nrzt), INTENT(inout)          :: bsq
      REAL(dp)                                          :: eps
C-----------------------------------------------
C   L o c a l   P a r a m e t e r s
C-----------------------------------------------
      INTEGER     :: js   , lk   , l
      REAL(dp) :: whpar, whper, bhotmx, taumin, ppprht, parpht,
     &        sigmin, bhotc, betath, betaht, betato, betapa,
     &        betape, betadi, betaew, es, betprc, betprx, Vdprime
C-----------------------------------------------
!     CALCULATION OF MIRROR STABILITY CRITERION
!********0*********0*********0*********0*********0*********0*********0**
!                                                                      *
!                 Anisotropic Pressure Model                           *
!     specific to case of the Adjoint Method based on                  *
!     a magnetic well figure of merit from the theory developed by     *
!     Antonsen, Paul and Landreman.                                    *
!     For this model, the firehose and mirror stability criteria are   *
!     identical and correspond to 1+Delta_p(omega'+omega*V"/V') > 0    * 
!********0*********0*********0*********0*********0*********0*********0**
!
!********0*********0*********0*********0*********0*********0*********0**
!   1.  Change BSQ from total pressure to magnetic pressure            *
!********0*********0*********0*********0*********0*********0*********0**
c
         bsq = bsq - pperp
!
!********0*********0*********0*********0*********0*********0*********0**
!   2.  Compute Tau-minimum, Sigma-minimum, Peak Hot Particle Beta.    *
!********0*********0*********0*********0*********0*********0*********0**
c
      eps = EPSILON(eps)
      whpar = wpar - wp
      whper = wper - wp
      bhotmx = -HUGE(bhotmx)
      taumin =  HUGE(taumin)
      sigmin =  HUGE(sigmin)

      DO 57 js = 2,ns
         DO 55 lk = 1,nznt
           l = (lk-1) * ns + js
           taumir(l) = one - pd(js)
 55       end do
 57    end do
      do 62 js = 2,ns
        do 60 lk = 1,nznt
            l = (lk-1) * ns + js
            taumin = MIN(taumir(l),taumin)
            sigmin = MIN(sigma_an(l),sigmin)
            bhotc = (2*pperp(l)+ppar(l)-3*pres(js))/bsq(l)
            bhotmx = MAX(bhotc,bhotmx)
 60     end do
 62   end do
      betprx = HUGE(betprx)
      do 64 js=2,ns
          betprc = 0.76786580_dp - 0.29708540_dp * tpotb(js)
     &      + 0.054249860_dp * tpotb(js)**2 
     &      - 0.0054254849_dp * tpotb(js)**3
     &      + 0.00030947525_dp * tpotb(js)**4 
     &      - 9.7144781e-6_dp * tpotb(js)**5
     &      + 1.3844199e-7_dp * tpotb(js)**6 
     &      - 1.4328673e-11_dp * (one + tpotb(js))*tpotb(js)**7
          betprx=min(betprx,betprc)
 64   end do
      bhotmx = bhotmx/3
      write (nthreed,101) taumin, sigmin, bhotmx
 101  format(" taumin=",1pe18.9," sigmin=",1pe18.9,
     &       "  peak hot beta=",1pe15.6)
      betath = wp/wb
      betaht = (2*whper+whpar)/(3*wb)
      betato = (2*wper+wpar)/(3*wb)
      betapa = whpar/wb
      betape = whper/wb
      betadi = betath + betape
      betaew = betath + 0.5*(betapa+betape)
      write (nthreed,102) betath,betaht,betato
 102  format(" thermal beta =",1pe13.4," beta-hot =",1pe13.4,
     &       " total beta =",1pe13.4)
      write (nthreed,103) betapa,betape,betaew-betath
 103  format(' hot parallel beta =',1pe13.4,
     &  ' hot perpendicular beta =',1pe13.4,' beta-hot(EW) =',1pe13.4)
      write (nthreed,104) betadi,betaew,betprx
 104  format(' diamagnetic beta =',1pe13.4,' beta(equal weighting) ='
     &     , 1pe13.4,' maximum hot perp. beta_c =',1pe10.3)

      IF (ABS(betaht) .GT. 1.E-12_dp) THEN
      write (nthreed,105)
 105  format(/,' js',8x,'s',9x,'th. press',3x,'par. pres',2x,
     &         'perp. pres',3x,'1-sigma_tau',3x,'d2V/dPhi^2')
!...  Vdprime = V"(Phi) 
      DO 79 js = 2,ns
         es = REAL(js - 1.5,dp) / (ns-1)
         Vdprime= -vp(js) *(tpotb(js)+pd(js)/(bcrit+eps))/(phot(js)+eps)
     &            / (phips(js)*phips(js))
         ppprht = pppr(js) - pres(js)
         parpht = papr(js) - pres(js)
         WRITE (nthreed,106) js, es, pres(js), parpht, ppprht, pd(js)
     &                      ,Vdprime
 79   END DO
      END IF
 106  format (i3,1p,1e15.6,1p,3e12.3,1p,2e15.6)

      END SUBROUTINE mirror_crit
#endif
      END MODULE fbal