with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Discrete_Random;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with def_monitor; use def_monitor;

-- Compilar sin GNAT STUDIO: gnatmake main.adb | .\main.exe

procedure Main is
   NORTE_BABOONS : constant integer := 5;                               -- Numero de babuinos del NORTE
   SUR_BABOONS : constant integer := 5;                                 -- Numero de babuinos del SUR                                    
   MAX_PASS : constant integer := 3;                                    -- Numero de veces que un babuino pasa por la cuerda
   MIN_RANDOM: constant integer := 1;                                   -- Minimo valor aleatorio
   MAX_RANDOM: constant integer := 5;                                   -- Maximo valor aleatorio 
   NORT: constant string := ESC & "[1;34m" & "NORTE" & ESC & "[0;37m";  -- Nort format string
   SUR : constant string := ESC & "[1;36m" & "SUR" & ESC & "[0;37m" ;   -- Sur format string

   -- Random number generator
   -- Use: Random(G)
   subtype RANDOM_RANGE is Integer range MIN_RANDOM .. MAX_RANDOM;

   package R is new
      Ada.Numerics.Discrete_Random (RANDOM_RANGE);
   use R;
   G : Generator;

   -- Tipo protegido para las tareas
   cuerda: BaboonsMonitor; 

   -- INIT TASKS
   -- Init task Norte 
   task type babuinoNorte is
      entry Start(idx : in integer);
   end babuinoNorte;

   -- Task body
   task body babuinoNorte is
      My_Idx : integer;    -- Thread number 
      velocidad : integer; -- Velocidad del babuino
   begin
      accept Start (Idx : in integer) do
         My_Idx := Idx;
      end Start;

      -- Velocidad del babuino
      velocidad := Random(G);

      -- Presentacion
      Put_Line("Soy el Babuino "&NORT&My_Idx'img&" y voy hacia el " & SUR & " , velocidad: "&velocidad'img);
      
      -- Pasadas de un babuino por la cuerda  
      for pass in 1..MAX_PASS loop
         cuerda.baboonNthLock;
         
         delay(Duration(velocidad));  -- Cruzar la cuerda 

         cuerda.baboonNthUnLock;
         Put_Line(NORT & My_Idx'Img & " he llegado");
            
         delay(Duration(velocidad));  -- Volver a subir

         if (pass = MAX_PASS)then
            Put_Line(NORT&My_Idx'img&": da la vuelta y acaba!!");
         else
            Put_Line(NORT&My_Idx'img&": vuelta"& pass'Img &" /"&MAX_PASS'Img);
         end if;
      end loop; 
   end babuinoNorte;

   -- Init task Sur
   task type babuinoSur is
      entry Start(idx : in integer);
   end babuinoSur;

   -- Task body
   task body babuinoSur is
      My_Idx : integer;    -- Thread number 
      velocidad : integer; -- Velocidad del babuino

   begin
      accept Start (Idx : in integer) do
         My_Idx := Idx;
      end Start;

      -- Velocidad del babuino
      velocidad := Random(G);

      -- Presentacion
      Put_Line("Soy el Babuino "&SUR&My_Idx'img&" y voy hacia el "&NORT&" , velocidad: "&velocidad'img);
      
      -- Pasadas de un babuino por la cuerda  
      for pass in 1..MAX_PASS loop
         cuerda.baboonSthLock;

         delay(Duration(velocidad));  -- Cruzar la cuerda 

         cuerda.baboonSthUnLock;
         Put_Line(SUR & My_Idx'Img & " he llegado");
      
         delay(Duration(velocidad)); -- Volver a subir

         if (pass = MAX_PASS)then
            Put_Line(SUR&My_Idx'img&": da la vuelta y acaba!!");
         else
            Put_Line(SUR&My_Idx'img&": vuelta"& pass'Img &" /"&MAX_PASS'Img);
         end if;
      end loop;
   end babuinoSur;

   -- Array de babuinos del Norte
   baboonsNorte : array (1..NORTE_BABOONS) of babuinoNorte;

   -- Array de babuinos del Sur
   baboonsSur : array (1..SUR_BABOONS) of babuinoSur;

begin
   Reset(G); -- Reset de la seed de los valores aleatorios 

   -- Inicializar los babuinos del Norte
   for Idx in 1..NORTE_BABOONS loop
      baboonsNorte(Idx).Start(Idx);
   end loop;

   -- Inicializar los babuinos del Sur 
   for Idx in 1..SUR_BABOONS loop
      baboonsSur(Idx).Start(Idx);
   end loop;

end Main;
