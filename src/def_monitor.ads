package def_monitor is

   protected type BaboonsMonitor is
      entry baboonNthLock;
      procedure baboonNthUnlock;
      entry baboonSthLock;
      procedure baboonSthUnlock;

   private
      MaxBaboons: Integer := 3;
      counterNorth : integer := 0;
      counterSouth : integer := 0;
   end BaboonsMonitor;

end def_monitor;
