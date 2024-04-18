
package body Synchronized_File_Access is
   protected body fileReader is
      function readline(br     : File_Type) return String is
      begin
         if not End_Of_File(br) then
            return Get_Line(br);
         else
            return "";
         end if;
      end readline;
   end fileReader;

end Synchronized_File_Access;
