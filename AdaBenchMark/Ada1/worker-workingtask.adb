separate(worker)
task body workingtask is
   -- **************************************************************
   -- procedure declaration
   procedure   InitializeParam;
   procedure   deduceInputs;
   procedure   getThermo;
   procedure   getGeo;
   procedure   calcPerf;
   -- End of procedure declaration
   -- **************************************************************

   -- **************************************************************
   -- variables for calculating time related, e.g.deadline etc.
   TimePoint : Long_Float :=0.0;
   StartTime : Time;
   EndTime : Time;
   ExecTime : Long_Float :=0.0;
   used : Long_Float :=0.0;
   ExecTotTime : Long_Float :=0.0;
   usedTime : Long_Float :=0.0;
   CurrentPoint : Integer :=0;
   -- variables for pi calculation
   StartPiTime : Time;
   EndPiTime : Time;
   PiTime : Long_Float;
   num_steps : constant Long_Float := 1000000.0;
   step : Long_Float :=1.0 / num_steps;
   i : Integer;
   x, pi, sum : Long_Float;
   -- variables for input data
   a,b,c,d : Long_Float :=0.1;   
    --variables for calculating
   altd,u0d: Long_Float;
   throtl : Long_Float;
   trat  : array (0..19) of Long_Float;
   tt       : array (0..19) of Long_Float;
   prat  : array (0..19) of Long_Float;
   pt       : array (0..19) of Long_Float;
   eta   : array (0..19) of Long_Float;
   gam   : array (0..19) of Long_Float;
   cp       : array (0..19) of Long_Float;
   weight : Long_Float;
   Rgas,alt,ts0,ps0,a0,u0,fsmach,q0,rho0,cpair,tsout,psout : Long_Float;
   a4,a8,a8d,m2,mfr,isp : Long_Float;
   epr,etr,npr,snpr : Long_Float;
   fnet,fgros,dram,sfc,fa,eair,uexit,ues : Long_Float;
   fnlb,fglb,drlb,flflo : Long_Float;
   pexit,pfexit : Long_Float;
   a8max,a8rat,a4p : Long_Float;
   lcomp,lburn,lturb,lnoz,ncomp,nturb : Long_Float;
   sblade,hblade,tblade,xcomp,ncompd : Long_Float;
   -- **************************************************************

   -- **************************************************************
   -- procedure defination start
   procedure InitializeParam is
   begin
      prat(4) := 1.0;
      eta(13) := 1.0;
      eta(4) := 1.0;
      eta(7) := 1.0;
      eta(3) := 1.0;
      eta(5) := 1.0;
      a4 :=  0.418;
      a8max :=  0.4;
   end InitializeParam;

   procedure deduceInputs is
   begin
      Rgas := 1718.0 ;
      alt := altd ;
      if alt < 36152.0  then
         ts0 := 518.6 - 3.56 * alt / 1000.0 ;
         ps0 := 2116.0 * fpow(ts0/518.6, 5.256);
      end if;
      if alt >= 36152.0 and alt <= 82345.0 then  -- Stratosphere
         ts0 := 389.98 ;
         ps0 := 2116.0 * 0.2236 *expo((36000.0-alt)/(53.35*389.98)) ;
      end if;
      if alt >= 82345.0 then
         ts0 := 389.98 + 1.645 * (alt-82345.0)/1000.0;
         ps0 := 2116.0 *0.02456 * fpow(ts0/389.98,-11.388);
      end if;
      a0 := sqroot(gama*Rgas*ts0) ;               -- speed of sound ft/sec
      u0 := u0d *5280.0/3600.0 ;                  -- airspeed ft/sec
      fsmach := u0/a0 ;
      q0 := gama / 2.0*fsmach*fsmach*ps0 ;

      if u0 > 0.0001 then
         rho0 := q0 /(u0*u0);
      else
         rho0 := 1.0 ;
      end if;

      tt(0) := ts0*(1.0 + 0.5 * (gama -1.0) * fsmach * fsmach) ;
      pt(0) := ps0 * fpow(tt(0)/ts0,gama/(gama-1.0)) ;
      ps0 := ps0 / 144.0 ;
      pt(0) := pt(0) / 144.0 ;
      cpair := getCp(tt(0));              --BTU/lbm R
      tsout := ts0-459.6 ;
      psout := ps0 ;

   end deduceInputs;

   -- Utility to have Thermodynamic parameters
   procedure getThermo is
      delhc,delhht,delhf,delhlt : Long_Float;
      deltc,deltht,deltf,deltlt : Long_Float;
   begin

      -- inlet recovery
      if fsmach > 1.0 then   --supersonic
         prat(2) := 1.0 - 0.075*fpow(fsmach - 1.0, 1.35) ;
      else
         prat(2) := 1.0 ;
      end if;
      eta(2) := prat(2);
      -- protection for overwriting input
      if eta(3) < 0.5 then
         eta(3) := 0.5 ;
      end if;
      if eta(5) < 0.5 then
         eta(5) := 0.5 ;
      end if;
      trat(7) := 1.0 ;
      prat(7) := 1.0 ;
      tt(2) := tt(0);
      tt(1) := tt(0);
      pt(1) := pt(0) ;
      gam(2) := getGama(tt(2)) ;
      cp(2)  := getCp(tt(2));
      pt(2) := pt(1) * prat(2) ;
      -- design - p3p2 specified - tt4 specified
      if engine <= 2 then --turbojet
         prat(3) := p3p2d ;                      -- core compressor
         if prat(3) < 0.5 then
            prat(3) := 0.5 ;
         end if;

         delhc := (cp(2)*tt(2)/eta(3))*(fpow(prat(3),(gam(2)-1.0)/gam(2))-1.0) ;
         deltc := delhc / cp(2) ;
         pt(3) := pt(2) * prat(3) ;
         tt(3) := tt(2) + deltc ;
         trat(3) := tt(3)/tt(2) ;
         gam(3) := getGama(tt(3)) ;
         cp(3)  := getCp(tt(3));
         tt(4) := tt4 * throtl/100.0 ;
         gam(4) := getGama(tt(4)) ;
         cp(4)  := getCp(tt(4));
         trat(4) := tt(4) / tt(3) ;
         pt(4) := pt(3) * prat(4) ;
         delhht := delhc ;
         deltht := delhht / cp(4) ;
         tt(5) := tt(4) - deltht ;
         gam(5) := getGama(tt(5)) ;
         cp(5)  := getCp(tt(5));
         trat(5) := tt(5)/tt(4) ;
         prat(5) := fpow((1.0-delhht/cp(4)/tt(4)/eta(5)),(gam(4)/(gam(4)-1.0)));
         pt(5) := pt(4) * prat(5) ;

         -- fan conditions
         prat(13) := 1.0 ;
         trat(13) := 1.0 ;
         tt(13)   := tt(2) ;
         pt(13)   := pt(2) ;
         gam(13)  := gam(2) ;
         cp(13)   := cp(2) ;
         prat(15) := 1.0 ;
         pt(15)   := pt(5) ;
         trat(15) := 1.0 ;
         tt(15)   := tt(5) ;
         gam(15)  := gam(5) ;
         cp(15)   := cp(5) ;
      end if;

      if engine = 3 then   --turbofan
         prat(13) := p3fp2d ;
         if prat(13) < 0.5 then
            prat(13) := 0.5 ;
         end if;

         delhf := (cp(2)*tt(2)/eta(13))*(fpow(prat(13),(gam(2)-1.0)/gam(2))-1.0) ;
         deltf := delhf / cp(2) ;
         tt(13) := tt(2) + deltf ;
         pt(13) := pt(2) * prat(13) ;
         trat(13) := tt(13)/tt(2) ;
         gam(13) := getGama(tt(13)) ;
         cp(13)  := getCp(tt(13));
         prat(3) := p3p2d ;                      -- core compressor
         if prat(3) < 0.5 then
            prat(3) := 0.5 ;
         end if;

         delhc := (cp(13)*tt(13)/eta(3))*(fpow(prat(3),(gam(13)-1.0)/gam(13))-1.0) ;
         deltc := delhc / cp(13) ;
         tt(3) := tt(13) + deltc ;
         pt(3) := pt(13) * prat(3) ;
         trat(3) := tt(3)/tt(13) ;
         gam(3) := getGama(tt(3)) ;
         cp(3)  := getCp(tt(3));
         tt(4) := tt4 * throtl/100.0 ;
         pt(4) := pt(3) * prat(4) ;
         gam(4) := getGama(tt(4)) ;
         cp(4)  := getCp(tt(4));
         trat(4) := tt(4)/tt(3) ;
         delhht := delhc ;
         deltht := delhht / cp(4) ;
         tt(5) := tt(4) - deltht ;
         gam(5) := getGama(tt(5)) ;
         cp(5)  := getCp(tt(5));
         trat(5) := tt(5)/tt(4) ;
         prat(5) := fpow((1.0-delhht/cp(4)/tt(4)/eta(5)),(gam(4)/(gam(4)-1.0))) ;
         pt(5) := pt(4) * prat(5) ;
         delhlt := (1.0 + byprat) * delhf ;
         deltlt := delhlt / cp(5) ;
         tt(15) := tt(5) - deltlt ;
         gam(15) := getGama(tt(15)) ;
         cp(15)  := getCp(tt(15));
         trat(15) := tt(15)/tt(5) ;
         prat(15) := fpow((1.0-delhlt/cp(5)/tt(5)/eta(5)),(gam(5)/(gam(5)-1.0))) ;
         pt(15) := pt(5) * prat(15) ;
      end if;
      tt(7) := tt7;

      prat(6) := 1.0;
      pt(6) := pt(15);
      trat(6) := 1.0 ;
      tt(6) := tt(15) ;
      gam(6) := getGama(tt(6)) ;
      cp(6)  := getCp(tt(6));

      --if abflag > 0.0 then   -- afterburner
      --   trat(7) := tt(7) / tt(6) ;
      --   m5 := getMach(0,getAir(1.0,gam(5))*a4/acore,gam(5)) ;
      --   prat(7) := getRayleighLoss(m5,trat(7),tt(6)) ;
      --end if;
      tt(7) := tt(6) * trat(7) ;
      pt(7) := pt(6) * prat(7) ;
      gam(7) := getGama(tt(7)) ;
      cp(7)  := getCp(tt(7));

      -- engine press ratio EPReair
      epr := prat(7)*prat(15)*prat(5)*prat(4)*prat(3)*prat(13);
      -- engine temp ratio ETR
      etr := trat(7)*trat(15)*trat(5)*trat(4)*trat(3)*trat(13);

   end getThermo;

   procedure getGeo is
   begin
      -- limits compressor face
      a8max := 0.75 * sqroot(etr) / epr;

      -- mach number to < .5
      if a8max > 1.0 then
         a8max := 1.0;
      end if;

      if a8rat > a8max then
         a8rat := a8max;
      end if;
      -- dumb down limit - a8 schedule
      --if arsched = 0.0 then
         a8rat := a8max;
      --end if;
      a8 := a8rat * acore;
      a8d := a8 * prat(7) / sqroot(trat(7));
      -- assumes choked a8 and a4
      a4 := a8 * prat(5) * prat(15) * prat(7) / sqroot(trat(7) * trat(5) * trat(15));
      a4p := a8 * prat(15) * prat(7) / sqroot(trat(7) * trat(15));

      -- size parameters for weight
      ncomp := Long_Float( Integer(1.0 + p3p2d / 1.5) );
      if ncomp > 15.0 then
         ncomp := 15.0;
      end if;
      sblade := 0.02;
      hblade := sqroot(2.0 / 3.1415926);
      tblade := 0.2 * hblade;

      xcomp := ncomp * (tblade + sblade);
      ncompd := ncomp;
      if engine = 3 then -- fan geometry
         ncompd := ncomp + 3.0;
         xcomp := ncompd * (tblade + sblade);
      end if;

      lcomp := xcomp;
      lburn := hblade;

      nturb := 1.0 + ncomp / 4.0;
      if engine = 3 then
         nturb := nturb + 1.0;
      end if;
      lturb := nturb * (tblade + sblade);
      lnoz := lburn;
      if engine = 2 then
         lnoz := 3.0 * lburn;
      end if;
   end getGeo;

   -- Utility to determine engine performance
   procedure calcPerf is
      fac1, game, cpe, cp3, rg, rg1 : Long_Float;
   begin
      rg1 := 53.3;
      rg := cpair * (gama - 1.0) / gama;
      cp3 := getCp(tt(3)); -- BTU/lbm R
      ues := 0.0;
      game := getGama(tt(5));
      fac1 := (game - 1.0) / game;
      cpe := getCp(tt(5));
      if eta(7) < 0.8 then
         eta(7) := 0.8; -- protection during overwriting
      end if;
      if eta(4) < 0.8 then
         eta(4) := 0.8;
      end if;
      -- specific net thrust - thrust / (g0*airflow) - lbf/lbm/sec

      -- turbine engine core

      -- airflow determined at choked nozzle exit
      pt(8) := epr * prat(2) * pt(0);
      eair := getAir(1.0, game) * 144.0 * a8 * pt(8) / 14.7 / sqroot(etr * tt(0) / 518.0);
      m2 := getMach(0, eair * sqroot(tt(0) / 518.0)
                    / (prat(2) * pt(0) / 14.7 * acore * 144.0), gama);
      npr := pt(8) / ps0;
      uexit := sqroot(2.0 * Rgas / fac1 * etr * tt(0) * eta(7)
                      * (1.0 - fpow(1.0 / npr, fac1)));
      if npr <= 1.893 then
         pexit := ps0;
      else
         pexit := 0.52828 * pt(8);
      end if;

      fgros := (uexit + (pexit - ps0) * 144.0 * a8 / eair) / g0;

      -- turbo fan, added terms for fan flow
      if engine = 3 then
         fac1 := (gama - 1.0) / gama;
         snpr := pt(13) / ps0;
         ues := sqroot(2.0 * Rgas / fac1 * tt(13) * eta(7)
                       * (1.0 - fpow(1.0 / snpr, fac1)));
         m2 := getMach(0, eair * (1.0 + byprat) * sqroot(tt(0) / 518.0)
                       / (prat(2) * pt(0) / 14.7 * afan * 144.0), gama);

         if snpr <= 1.893 then
            pfexit := ps0;
         else
            pfexit := 0.52828 * pt(13);
         end if;
         fgros := fgros+ (byprat * ues + (pfexit - ps0) * 144.0 * byprat * acore/ eair) / g0;
      end if;
      -- ram drag
      dram := u0 / g0;
      if engine = 3 then
         dram := dram + u0 * byprat / g0;
      end if;
      -- mass flow ratio
      if fsmach > 0.01 then
         mfr := getAir(m2, gama) * prat(2) / getAir(fsmach, gama);
      else
         mfr := 5.0;
      end if;
      -- net thrust
      fnet := fgros - dram;

      -- thrusts in pounds
      fnlb := fnet * eair;
      fglb := fgros * eair;
      drlb := dram * eair;

      -- fuel-air ratio and sfc
      fa := (trat(4) - 1.0) / (eta(4) * fhv / (cp3 * tt(3)) - trat(4))
        + (trat(7) - 1.0) / (fhv / (cpe * tt(15)) - trat(7));
      if fnet > 0.0 then
         sfc := 3600.0 * fa / fnet;
         if sfc < 0.0 then
            sfc := 0.0;
         end if;
         flflo := sfc * fnlb;
         isp := (fnlb / flflo) * 3600.0;
      else
         fnlb := 0.0;
         flflo := 0.0;
         sfc := 0.0;
         isp := 0.0;
      end if;
      -- weight calculation
      if engine = 1 then
         weight := 0.12754
           * sqroot(acore * acore * acore)
           * (dcomp * lcomp + dburner * lburn + dturbin * lturb + dnozl
              * lnoz);
      end if;
      if engine = 2 then
         weight := 0.08533
           * sqroot(acore * acore * acore)
           * (dcomp * lcomp + dburner * lburn + dturbin * lturb + dnozl
              * lnoz);
      end if;
      if engine = 3 then
         weight := 0.08955
           * acore
           * ((1.0 + byprat) * dfan * 4.0 + dcomp * (ncomp - 3.0)
              + dburner + dturbin * nturb + dburner * 2.0)
           * sqroot(acore / 6.965);
      end if;
   end calcPerf;
   -- End procedure defination
   -- **************************************************************
begin
   -- initiallize Parameter
   InitializeParam;
   loop      
      
      if rtPerformancedata.getNumPoints < LineCount then
         rtPerformancedata.getNextNumPoints(CurrentPoint);
         if CurrentPoint>LineCount then
            rtPerformancedata.undogetNextNumPoints;
            exit;
         end if;
         --Pi calculation
         i := 0;
         sum := 0.0;
         StartPiTime := Clock;
         for i in 0 .. Integer(num_steps) loop
            x := (Long_Float(i) + 0.5) * step;
            sum := sum + 4.0 / (1.0 + x * x);
         end loop;

         pi := sum * step;

         EndPiTime := Clock;
         PiTime := Long_Float( To_Duration(EndPiTime - StartPiTime) );
         --Put_Line("Pi= " & Long_Float'Image(pi) & "  used  " & Duration'Image(To_Duration(EndPiTime - StartPiTime)) & " s");

         -- read a line        
         a := InputData (CurrentPoint,1);
         b := InputData (CurrentPoint,2);
         c := InputData (CurrentPoint,3);
         d := InputData (CurrentPoint,4);
 

         if(a<0.0 or a>1500.0) then
            Put_Line("Warning : incorrect speed for point " & Integer'Image(CurrentPoint));
            u0d := 0.0;
         else
            -- Input speed in mph
            u0d := a;
         end if;

         if(b<0.0 or b>50000.0) then
            Put_Line("Warning : incorrect altitude for point " & Integer'Image(CurrentPoint));
            altd := 0.0;
         else
            -- Input altitude in feet
            altd := b;
         end if;

         if(c<45.0 or c>90.0) then
            Put_Line("Warning : incorrect throttle for point " & Integer'Image(CurrentPoint));
            throtl := 100.0;
         else
            -- Converting input throttle in %
            throtl := deg2rad(c,pi)*100.0*2.0/pi;
         end if;

         if d<0.0 then
            Put_Line("Warning : incorrect deadline for point " & Integer'Image(CurrentPoint));
            TimePoint := 0.0;
         else
            -- Input time point
            TimePoint := d;
         end if;
         --TotalTimePoint := TotalTimePoint + TimePoint;
         rtPerformancedata.increaseTotalTimePoint(TimePoint);
         --** ******** START CALCULATIONS **********
         StartTime := Clock;
         deduceInputs;
         getThermo;
         getGeo;
         calcPerf;
         EndTime := Clock;
         ExecTime := Long_Float( To_Duration(EndTime - StartTime) );
         --Put_Line("------ExecTime Time :"& Duration'Image(To_Duration(EndTime - StartTime)) );
         used := (ExecTime+PiTime) / TimePoint;
         ExecTotTime := ExecTime + PiTime;
         usedTime := (ExecTime + PiTime) - TimePoint;

         -- Count the number of points
         --TotalTime := TotalTime+ExecTotTime;
         --TotalUsed := TotalUsed+used;
         rtPerformancedata.increaseTotalTime(ExecTotTime);
         rtPerformancedata.increaseTotalUsed(used);
         -- print out result
         if used > 1.0 then
            --NumMissed :=NumMissed+1;
            --TotalTimePoint := TotalTimePoint+usedTime;
            rtPerformancedata.increaseNumMissed(1);
            rtPerformancedata.increaseTotalTimePoint(usedTime);
         end if;
         OutputData (CurrentPoint,1) := 0.0;
         OutputData (CurrentPoint,2) := ExecTotTime;
         OutputData (CurrentPoint,3) := u0d;
         OutputData (CurrentPoint,4) := altd;
         OutputData (CurrentPoint,5) := throtl;
         OutputData (CurrentPoint,6) := fsmach;
         OutputData (CurrentPoint,7) := psout;
         OutputData (CurrentPoint,8) := tsout;
         OutputData (CurrentPoint,9) := fnlb;
         OutputData (CurrentPoint,10) := fglb;
         OutputData (CurrentPoint,11) := drlb;
         OutputData (CurrentPoint,12) := flflo;
         OutputData (CurrentPoint,13) := sfc;
         OutputData (CurrentPoint,14) := eair;
         OutputData (CurrentPoint,15) := weight;
         OutputData (CurrentPoint,16) := fnlb/weight;
         OutputData (CurrentPoint,17) := used*100.0;
         OutputData (CurrentPoint,18) := Long_Float(CurrentPoint);

      else
         exit;-- exit loop
      end if;
   end loop;
end workingtask;

 
