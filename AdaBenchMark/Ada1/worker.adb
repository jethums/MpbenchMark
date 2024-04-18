with Configuration_Data; use Configuration_Data;
with Synchronized_File_Access; use Synchronized_File_Access;
with RealTime_Performance; use RealTime_Performance;
with Ada.Text_IO; use Ada.Text_IO;
With Ada.Real_Time; use Ada.Real_Time;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with GNAT.String_Split; use GNAT.String_Split;
with Ada.Numerics.Generic_Elementary_Functions;
with Utilities; use Utilities;
with Default_Constant; use Default_Constant;

package body worker is

   -- arraies, store input and out put data
   type InputArray is array(Integer range <>,Integer range <>) of Long_Float;
   type InputData_Access is access all InputArray;
   type OutputArray is array(Integer range <>,Integer range <>) of Long_Float;
   type OutputData_Access is access all OutputArray;
   InputData : InputData_Access;
   OutputData : OutputData_Access;
   LineCount : Integer :=0;

   -- procedure, initialize array
   procedure initializeArraies;
   -- procedure, print out the result
   procedure printResult;

   task type workingtask is
   end workingtask;
   task body workingtask is separate;

   procedure start(E : Integer) is
      BenchMarkStartTime : Time;
      BenchMarkEndTime : Time;
      package Flt_IO is new Ada.Text_IO.Float_IO(Long_Float);
      use Flt_IO;
      --variables for file operation>>>>>>>>>>>>>>>
      Threads : String := Integer'Image(NUM_THREADS);
      F    : Ada.Text_IO.File_Type;
   begin
      -- set engine type
      engine := E;
      
      -- read data from file and initialize arraies according to line count
      initializeArraies;

      BenchMarkStartTime := Clock;
      declare
         workingtasks : array (1..NUM_THREADS) of workingtask;
      begin
         null;
      end; --end of declare
      BenchMarkEndTime := Clock;

      --------------------------------------------------------------------------------------------------
      --Put_Line("all done");
      --printResult;      
      --New_line;      
      Put_Line(Integer'Image(rtPerformancedata.getNumMissed));
      --Put("Thread response time sum:");
      --Put(rtPerformancedata.getTotalTime,3,9,0);New_line;
      --Put_Line("Number of threads : "& Integer'Image(NUM_THREADS));
      --Put_Line("Number of points : " & Integer'Image(rtPerformancedata.getNumPoints));
      Put_Line(Duration'Image(To_Duration(BenchMarkEndTime - BenchMarkStartTime)) );
      
      --write into file>>>>>>>>>>>>>>>
      -------write response time
      Open (File => F, Mode => Append_File, Name => "../..//IOFiles/Ada/ResponseTimeForCore"&Threads&".txt"); 
      Put_Line(F,Duration'Image(To_Duration(BenchMarkEndTime - BenchMarkStartTime)));
      Close(F);
      ---------write deadline miss
      Open (File => F, Mode => Append_File, Name => "../..//IOFiles/Ada/DeadLineForCore"&Threads&".txt"); 
      Put_Line(F,Integer'Image(rtPerformancedata.getNumMissed));
      Close(F);

   end start;

   procedure initializeArraies is
      -- variables for file reading
      br     : File_Type;
      Index : Integer :=1;
      sCurrentLine : Unbounded_String;
      Subs : GNAT.String_Split.Slice_Set;
      Seps : String := " ";
   begin
      -- open file
      Open (File => br, Mode => Ada.Text_IO.In_File, Name => "../..//IOFiles/InputFile.txt");
      -- get how many lines in file
      loop
         sCurrentLine :=To_Unbounded_String(fileReader.readline(br));
         if sCurrentLine /= "" then
            LineCount :=LineCount+1;
         else
            exit;
         end if;
      end loop;
      --Put_Line("Number of lines in file : "&Integer'Image(LineCount));

      InputData := new  InputArray(1..LineCount, 1..4);
      OutputData := new OutputArray(1..LineCount, 1..18);
      --reset file
      Reset(br);

      loop
         sCurrentLine :=To_Unbounded_String(fileReader.readline(br));
         if sCurrentLine /= "" then
            GNAT.String_Split.Create (Subs, To_String(sCurrentLine), Seps, Mode => GNAT.String_Split.Multiple);
            declare
               sa : String := GNAT.String_Split.Slice (Subs, 1);
               sb : String := GNAT.String_Split.Slice (Subs, 2);
               sc : String := GNAT.String_Split.Slice (Subs, 3);
               sd : String := GNAT.String_Split.Slice (Subs, 4);
            begin
               InputData (Index,1) := Long_Float'Value(sa);
               InputData (Index,2) := Long_Float'Value(sb);
               InputData (Index,3) := Long_Float'Value(sc);
               InputData (Index,4) := Long_Float'Value(sd);
               --Put( Long_Float'Image(InputData (Index,1) ) & " , " );
               --Put( Long_Float'Image(InputData (Index,2) ) & " , " );
               --Put( Long_Float'Image(InputData (Index,3) ) & " , " );
               --Put( Long_Float'Image(InputData (Index,4) ) & " , " );
               --New_line;
               Index := Index+1;
            end;
         else
            exit;
         end if;
      end loop;
      Close (br);
   end initializeArraies;

   procedure printResult is

      package Flt_IO is new Ada.Text_IO.Float_IO(Long_Float);
      use Flt_IO;
   begin
      Put_Line(" T,ExecTime,  Spd| Alt   |  Thr| Mach|Press| Temp|  Fnet| Fgros| RamDr| FlFlo|TSFC|Airfl|Weight|Fn/W");

      for CurrentPoint in 1..LineCount loop
         
         Put(Integer'Image(Integer(OutputData (CurrentPoint,1)))); Put(",");
         Put(OutputData (CurrentPoint,2),1,6,0); Put(",");
         Put(OutputData (CurrentPoint,3),3,0,0); Put("|");
         Put(OutputData (CurrentPoint,4),5,0,0); Put("|");
         Put(OutputData (CurrentPoint,5),3,1,0); Put("|");
         Put(OutputData (CurrentPoint,6),1,3,0); Put("|");
         Put(OutputData (CurrentPoint,7),2,2,0); Put("|");
         Put(OutputData (CurrentPoint,8),3,1,0); Put("|");
         Put(OutputData (CurrentPoint,9),4,0,0); Put("|");
         Put(OutputData (CurrentPoint,10),4,0,0); Put("|");
         Put(OutputData (CurrentPoint,11),4,0,0); Put("|");
         Put(OutputData (CurrentPoint,12),4,0,0); Put("|");
         Put(OutputData (CurrentPoint,13),1,2,0); Put("|");
         Put(OutputData (CurrentPoint,14),3,1,0); Put("|");
         Put(OutputData (CurrentPoint,15),2,2,0); Put("|");
         Put(OutputData (CurrentPoint,16),2,2,0);
         New_line;
         Put("         ");
         Put(OutputData (CurrentPoint,17),2,1,0); Put("% used for point "); Put_Line(Integer'Image(Integer(OutputData (CurrentPoint,18))));
      end loop;

   end printResult;

end worker;
