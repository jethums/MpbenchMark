with Ada.Text_IO; use Ada.Text_IO;
package Synchronized_File_Access is
   protected fileReader is
      function readline(br     : File_Type) return String;
   end fileReader;
end Synchronized_File_Access;
