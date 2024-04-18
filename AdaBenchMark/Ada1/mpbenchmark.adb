with Ada.Text_IO; use Ada.Text_IO;
with Ada.Command_Line; use Ada.Command_Line;
with worker; use worker;

procedure mpBenchMark is
   engine : Integer :=3;
begin
   --Put_Line("Multi Processor Benchmark Ada version");

   if Argument_Count > 0 then
      if Argument(1) = "1" then
         engine := 1;
         --Put_Line("Turbojet is selected");
      elsif Argument(1) = "2" then
         engine := 2;
         --Put_Line("Afterburner is selected");
      elsif Argument(1) = "3" then
         engine := 3;
         --Put_Line("Turbofan is selected");
      end if;
   else
      null;
      --Put_Line("Turbofan (default) is selected");
   end if;
   --New_line;

   start(engine);

end mpBenchMark;
