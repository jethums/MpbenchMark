package Utilities is
   function 	fpow(x : Long_Float; y : Long_Float) return Long_Float;
   function	expo(x : Long_Float) return Long_Float;
   function 	fabs(x : Long_Float) return Long_Float;
   function 	mylog(x : Long_Float)  return Long_Float;
   function 	sqroot(number : Long_Float) return Long_Float;
   function 	getCp(temp : Long_Float) return Long_Float;
   function 	getGama(temp : Long_Float) return Long_Float;
   function	getMach(sub : Integer; corair : Long_Float; gama1: Long_Float) return Long_Float;
   function 	getAir(mach : Long_Float; gama2 : Long_Float) return Long_Float;
   function  	getRayleighLoss(mach1 : Long_Float; ttrat : Long_Float; tlow : Long_Float) return Long_Float;
   function 	deg2rad (deg : Long_Float; pi : Long_Float) return Long_Float;
end Utilities;
