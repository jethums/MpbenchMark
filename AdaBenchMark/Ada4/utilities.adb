with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Generic_Elementary_Functions;
with Configuration_Data; use Configuration_Data;
package body Utilities is

   -- Utility to convert degree in radian
   function deg2rad (deg : Long_Float; pi : Long_Float) return Long_Float is
   begin
      return(deg/180.0*pi);
   end deg2rad;

   -- Utility to get gamma as a function of temperature
   function getGama(temp : Long_Float) return Long_Float is
      number, a, b, c, d : Long_Float;
   begin
      a := -7.6942651e-13;
      b := 1.3764661e-08;
      c := -7.8185709e-05;
      d := 1.436914;
      number := a * temp * temp * temp + b * temp * temp + c * temp + d;
      return number;
   end getGama;



   function getCp(temp : Long_Float) return Long_Float is
      number,a,b,c,d : Long_Float;
   begin
      a :=  -4.4702130e-13;
      b :=  -5.1286514e-10;
      c :=  2.8323331e-05;
      d :=  0.2245283;
      number := a*temp*temp*temp + b*temp*temp + c*temp +d ;
      return(number) ;
   end getCp;

   -- Utility to get the Mach number given the corrected airflow per area
   function getMach(sub : Integer; corair : Long_Float; gama1: Long_Float) return Long_Float is
      number, chokair : Long_Float;  --iterate for mach number
      deriv, machn, macho, airo, airn : Long_Float;
      iter : Integer;
   begin
      chokair := getAir(1.0, gama1);
      if corair > chokair then
         number := 1.0;
         return (number);
      else
         airo := 0.25618; -- initial guess
         if sub = 1 then
            macho := 1.0; -- sonic
         else
            if sub = 2 then
               macho := 1.703; -- supersonic
            else
               macho := 0.5; -- subsonic
            end if;
            iter := 1;
            machn := macho - 0.2;
            while fabs(corair - airo) > 0.0001 and iter < 20 loop
               airn := getAir(machn, gama1);
               deriv := (airn - airo) / (machn - macho);
               airo := airn;
               macho := machn;
               machn := macho + (corair - airo) / deriv;
               iter :=iter+1;
            end loop;
         end if;
         number := macho;
      end if;

      return (number);
   end getMach;

   -- Utility to get the corrected airflow per area given the Mach number
   function getAir(mach : Long_Float; gama2 : Long_Float) return Long_Float is
      number, fac1, fac2 : Long_Float;
   begin
      fac2 := (gama2 + 1.0) / (2.0 * (gama2 - 1.0));
      fac1 := fpow((1.0 + 0.5 * (gama2 - 1.0) * mach * mach), fac2);
      number := 0.50161 * sqroot(gama2) * mach / fac1;

      return (number);
   end getAir;

   function expo(x : Long_Float)	return Long_Float is
      number,coeff : Long_Float;
      i : Integer;
   begin
      number := 1.0;
      coeff := 1.0;
      i := 1;
      -- if x > log(DBL_MAX)
      if x > 709.782712893384 then
         return expo(709.78); 		-- Infinite value
      end if;
      -- exp : x^0/0! + x^1/1! + x^2/2! + x^3/3!
      while fabs(coeff) > PRECISION loop
         coeff :=coeff* (x / Long_Float(i));
         number :=number+ coeff;
         i:=i+1;
      end loop;
      return number;
   end expo;


   function fabs(x : Long_Float) return Long_Float is
   begin
      if x<0.0 then
         return -x;
      end if;
      return x;
   end fabs;


   -- ****************************************************************************
   -- Math utilities

   function fpow(x : Long_Float; y : Long_Float) return  Long_Float is
      partieEntiere : Integer;
      package Math is new    Ada.Numerics.Generic_Elementary_Functions(Float);
   begin
      partieEntiere := Integer(y);
      -- If x<0 and y not integer
      if x < 0.0 and Long_Float(partieEntiere) /= y then
         --Put_Line("error power undefined");
         return 0.0;
      elsif  x < 0.0 then
         return x**partieEntiere;
      end if;
      return (x**partieEntiere) * expo((y - Long_Float(partieEntiere)) * Long_Float (Math.log(FLOAT(x))));
      --return (x**partieEntiere) * expo((y - Long_Float(partieEntiere)) * mylog(x));
      --return 0.0;
   end fpow;

   function sqroot(number : Long_Float) return Long_Float is
      x0, x, prec : Long_Float;
   begin
      x0 := 1.0;
      x := 1.0;
      prec := 1.0;
      if number < 0.0 then
         --Put_Line("error sqroot");
         return 0.0;
      end if;

      x := (1.0 + number) / 2.0;
      while (prec > 0.0001) or (prec < -0.0001) loop
         x0 := x;
         x := 0.5 * (x0 + number / x0);
         prec := (x - x0) / x0;
      end loop;
      return x;
   end sqroot;

   function mylog(x : Long_Float)  return Long_Float is
      number,coeff : Long_Float;
      i : Integer;
   begin
      number := 0.0;
      coeff := -1.0;
      i := 1;
      if x <= 0.0 then
         Put_Line("error log undefined");
         return 0.0;
      end if;

      if x = 1.0 then
         return 0.0;
      end if;

      if x > 1.0 then
         return -mylog(1.0 / x);
      end if;

      --0<x<1
      --log : x - x^2/2 + x^3/3 - x^4/4...
      while fabs(coeff) > PRECISION loop
         coeff := coeff * (1.0 - x);
         number := number+ (coeff / Long_Float(i));
         i:=i+1;
      end loop;
      return number;
   end mylog;



   -- Analysis for Rayleigh flow
   function getRayleighLoss(mach1 : Long_Float; ttrat : Long_Float; tlow : Long_Float) return Long_Float is
      number : Long_Float;
      wc1, wc2, mgueso, mach2, g1, gm1, g2, gm2 : Long_Float;
      fac1, fac2, fac3, fac4 : Long_Float;
   begin
      g1 := getGama(tlow);
      gm1 := g1 - 1.0;
      wc1 := getAir(mach1, g1);
      g2 := getGama(tlow * ttrat);
      gm2 := g2 - 1.0;
      number := 0.95;
      -- iterate for mach downstream
      mgueso := 0.4; -- initial guess
      mach2 := 0.5;
      while fabs(mach2 - mgueso) > 0.0001 loop
         mgueso := mach2;
         fac1 := 1.0 + g1 * mach1 * mach1;
         fac2 := 1.0 + g2 * mach2 * mach2;
         fac3 := fpow((1.0 + 0.5 * gm1 * mach1 * mach1), (g1 / gm1));
         fac4 := fpow((1.0 + 0.5 * gm2 * mach2 * mach2), (g2 / gm2));
         number := fac1 * fac4 / fac2 / fac3;
         wc2 := wc1 * sqroot(ttrat) / number;
         mach2 := getMach(0, wc2, g2);
      end loop;
      return (number);
   end getRayleighLoss;

end Utilities;
