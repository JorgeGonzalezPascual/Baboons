with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
package body def_monitor is

  NORT: constant string := ESC & "[1;34m" & "NORTE" & ESC & "[0;37m";   -- Nort format string
  SUR : constant string := ESC & "[1;36m" & "SUR" & ESC & "[0;37m" ;    -- Sur format string
  
  protected body BaboonsMonitor is

    entry baboonNthLock when (counterSouth = 0) and (counterNorth < MaxBaboons) is
    begin
      counterNorth := counterNorth + 1;
      Put_Line("***** En la cuerda hay" & counterNorth'Img & " direccion "&SUR&" *****");
    end baboonNthLock;

    procedure baboonNthUnlock is
    begin
      counterNorth := counterNorth - 1;
      Put_Line("***** En la cuerda hay" & counterNorth'Img & " direccion "&SUR&" *****");
    end baboonNthUnlock;

    entry baboonSthLock when (counterNorth = 0) and (counterSouth < MaxBaboons) is
    begin
      counterSouth := counterSouth + 1;
      Put_Line("+++++ En la cuerda hay" & counterSouth'Img &" direccion "&NORT&" +++++");
    end baboonSthLock;

    procedure baboonSthUnlock is
    begin
      counterSouth := counterSouth - 1;
      Put_Line("+++++ En la cuerda hay" & counterSouth'Img &" direccion "&NORT&" +++++");
    end baboonSthUnlock;

  end BaboonsMonitor;

end def_monitor;
