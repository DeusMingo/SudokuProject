program sudoku; 

uses
  crt, graph;


const
  title: string = 'S U D O K U';
  x_max = 9;
  y_max = 9;
  sector_size_x = 3;
  sector_size_y = 3;
  colora = 15;
  colorb = 4;
  colorc = 11;
  colord = 4;
  open_brackets = '[';
  close_brackets = ']';
  pistasmax = 17;


type
  slots = record
    valor, solucion: integer;
    HL, hb: boolean;
  end;


var
  surren: integer;
  pista: integer;
  xa, ya, ca, da, win: integer;
  slot: array [0..x_max, 0..y_max] of slots;
  turno: integer;
  device_screenx, device_screeny: integer;
  error1, finish: boolean;
  m1: string;
  modi: boolean;

function vers(x_slot, y_slot: integer;
axis: string) : integer; 

var
  varios: boolean;
  i_vers: integer;


begin
  varios := false;
  if axis = 'y' then
    for i_vers := 1 to y_max do 
      if i_vers <> x_slot then
        if slot[x_slot, y_slot].valor = slot[i_vers, y_slot].valor then
          begin
            error1 := true;
            varios := true;
          end   ;
  if axis = 'x' then
    for i_vers := 1 to y_max do 
      if i_vers <> y_slot then
        if slot[x_slot, y_slot].valor = slot[x_slot, i_vers].valor then
          begin
            error1 := true;
            varios := true;
          end   ;
  if varios = true then
    vers := 2  
  else 
    vers := 1;
end; 
procedure writeslot(xv, yv: integer;
open, close: string); 

begin
  if slot[xv, yv].Hb = true then
    if slot[xv, yv].valor > 0 then
      textcolor(colord)  
    else 
      textcolor(0) else textcolor(0) ;
  if slot[xv, yv].HL = true then
    textcolor(colorc) ;
  write(open);
  textcolor(colora);
  write(slot[xv, yv].valor);
  if slot[xv, yv].Hb = true then
    if slot[xv, yv].valor > 0 then
      textcolor(colord)  
    else 
      textcolor(0) else textcolor(0) ;
  if slot[xv, yv].HL = true then
    textcolor(colorc) ;
  write(close);
  textcolor(colora);
end; 
procedure surr(xv, yv: integer;
open, close: string); 

begin
  if slot[xv, yv].HL = true then
    textcolor(colorc)  
  else 
    textcolor(0);
  write(open);
  textcolor(colora);
  write(slot[xv, yv].solucion);
  if slot[xv, yv].HL = true then
    textcolor(colorc)  
  else 
    textcolor(0);
  write(close);
  textcolor(colora);
end; 
procedure writeboard(screenx, screeny, justification, solved: integer);

var
  x, y: integer;
  lx, ly, i: integer;
  line_count: integer;
  g: integer;


begin
  g := x_max + (x_max * 2) + 2;
  for y := 1 to y_max do 
    begin
      line_count := line_count + 1;
      gotoxy(round((screenx / 2) - (g / 2)), round(screeny / 9) + line_count);
      if ly = sector_size_y then
        if y <> y_max then
          begin
            ly := 0;
            for i := 1 to g do 
              begin
                textcolor(colorb);
                write('-');
                textcolor(colora);
              end;
            line_count := line_count + 1;
            gotoxy(round((screenx / 2) - (g / 2)), round(screeny / 9) + line_count);
          end  ;
      lx := 0;
      for X := 1 to x_max do 
        begin
          writeslot(x, y, open_brackets, close_brackets);
          lx := lx + 1;
          if x <> x_max then
            if lx = sector_size_x then
              begin
                lx := 0;
                textcolor(colorb);
                write('|');
                textcolor(colora);
              end  ;
        end;
      ly := ly + 1;
      if x = x_max then
        gotoxy(round((screenx / 2) - (g / 2)), round(screeny / 5) + line_count + 1) ;
    end;
end; 
procedure generar_linea;

var
  i: integer;


begin
  for i := 1 to x_max do 
    slot[i, 1].solucion := slot[i - 1, 1].solucion + 1;
end; 
procedure titulo;

begin
  gotoxy(trunc((device_screenx / 2) - (length(title) / 2)), trunc(device_screeny / 10));
  writeln(title);
end; 
procedure modify;

begin
  if modi = false then
    begin
      if turno > 1 then
        begin
          writeln('Deseas continuar?');
          writeln('1 = Si. 2=Verificar. 3=Rendirse');
          readln(surren);
        end ;
      if surren = 1 then
        begin
          writeln('Introduce una columna');
          readln(xa);
          writeln('Introduce una fila');
          readln(ya);
          writeln('Introduce un numero');
          readln(da);
          slot[xa, ya].hl := true;
          modi := true;
        end ;
    end 
  else 
    begin
      writeln('quieres modificar ese numero?');
      writeln('1 = Si. 2= No.');
      readln(ca);
      slot[xa, ya].hl := false;
      slot[xa, ya].hb := false;
      modi := false;
      if ca = 1 then
        begin
          slot[xa, ya].valor := da;
          turno := turno + 1;
        end ;
    end;
end; 
procedure surrender(screenx, screeny, justification, solved: integer);

var
  x, y: integer;
  lx, ly, i: integer;
  line_count: integer;
  g: integer;


begin
  g := x_max + (x_max * 2) + 2;
  for y := 1 to y_max do 
    begin
      line_count := line_count + 1;
      gotoxy(round((screenx / 2) - (g / 2)), round(screeny / 9) + line_count);
      if ly = sector_size_y then
        if y <> y_max then
          begin
            ly := 0;
            for i := 1 to g do 
              begin
                textcolor(colorb);
                write('-');
                textcolor(colora);
              end;
            line_count := line_count + 1;
            gotoxy(round((screenx / 2) - (g / 2)), round(screeny / 9) + line_count);
          end  ;
      lx := 0;
      for X := 1 to x_max do 
        begin
          surr(x, y, open_brackets, close_brackets);
          lx := lx + 1;
          if x <> x_max then
            if lx = sector_size_x then
              begin
                lx := 0;
                textcolor(colorb);
                write('|');
                textcolor(colora);
              end  ;
        end;
      ly := ly + 1;
      if x = x_max then
        gotoxy(round((screenx / 2) - (g / 2)), round(screeny / 5) + line_count + 1) ;
    end;
end; 
procedure gameover;

begin
  gotoxy(trunc((device_screenx / 2) - (16 / 2)), trunc(device_screeny / 10));
  writeln('G A M E O V E R');
end; 
procedure gamewin;

begin
  gotoxy(trunc((device_screenx / 2) - (16 / 2)), trunc(device_screeny / 10));
  writeln('F E L I C I D A D E S');
end; 
procedure verify;

var
  x, y, c: integer;


begin
  c := 0;
  for y := 1 to y_max do 
    for x := 1 to x_max do 
      if slot[x, y].valor = slot[x, y].solucion then
        c := c + 1  
      else 
        slot[x, y].hb := true;
  if c = x_max * y_max then
    win := 1 ;
end; 
procedure tablero;

begin
  slot[1, 1].solucion := 6;
  slot[2, 1].solucion := 5;
  slot[3, 1].solucion := 2;
  slot[4, 1].solucion := 7;
  slot[5, 1].solucion := 1;
  slot[6, 1].solucion := 8;
  slot[7, 1].solucion := 9;
  slot[8, 1].solucion := 3;
  slot[9, 1].solucion := 9;
  slot[1, 2].solucion := 3;
  slot[2, 2].solucion := 4;
  slot[3, 2].solucion := 7;
  slot[4, 2].solucion := 5;
  slot[5, 2].solucion := 2;
  slot[6, 2].solucion := 9;
  slot[7, 2].solucion := 1;
  slot[8, 2].solucion := 6;
  slot[9, 2].solucion := 9;
  slot[1, 3].solucion := 1;
  slot[2, 3].solucion := 9;
  slot[3, 3].solucion := 8;
  slot[4, 3].solucion := 3;
  slot[5, 3].solucion := 4;
  slot[6, 3].solucion := 6;
  slot[7, 3].solucion := 2;
  slot[8, 3].solucion := 5;
  slot[9, 3].solucion := 7;
  slot[1, 4].solucion := 2;
  slot[2, 4].solucion := 6;
  slot[3, 4].solucion := 9;
  slot[4, 4].solucion := 1;
  slot[5, 4].solucion := 3;
  slot[6, 4].solucion := 4;
  slot[7, 4].solucion := 8;
  slot[8, 4].solucion := 7;
  slot[9, 4].solucion := 5;
  slot[1, 5].solucion := 8;
  slot[2, 5].solucion := 7;
  slot[3, 5].solucion := 1;
  slot[4, 5].solucion := 9;
  slot[5, 5].solucion := 6;
  slot[6, 5].solucion := 5;
  slot[7, 5].solucion := 3;
  slot[8, 5].solucion := 4;
  slot[9, 5].solucion := 2;
  slot[1, 6].solucion := 4;
  slot[2, 6].solucion := 3;
  slot[3, 6].solucion := 5;
  slot[4, 6].solucion := 8;
  slot[5, 6].solucion := 7;
  slot[6, 6].solucion := 2;
  slot[7, 6].solucion := 6;
  slot[8, 6].solucion := 9;
  slot[9, 6].solucion := 1;
  slot[1, 7].solucion := 7;
  slot[2, 7].solucion := 8;
  slot[3, 7].solucion := 6;
  slot[4, 7].solucion := 2;
  slot[5, 7].solucion := 5;
  slot[6, 7].solucion := 6;
  slot[7, 7].solucion := 4;
  slot[8, 7].solucion := 1;
  slot[9, 7].solucion := 9;
  slot[1, 8].solucion := 9;
  slot[2, 8].solucion := 1;
  slot[3, 8].solucion := 4;
  slot[4, 8].solucion := 6;
  slot[5, 8].solucion := 8;
  slot[6, 8].solucion := 7;
  slot[7, 8].solucion := 5;
  slot[8, 8].solucion := 2;
  slot[9, 8].solucion := 3;
  slot[1, 9].solucion := 5;
  slot[2, 9].solucion := 2;
  slot[3, 9].solucion := 3;
  slot[4, 9].solucion := 4;
  slot[5, 9].solucion := 9;
  slot[6, 9].solucion := 1;
  slot[7, 9].solucion := 7;
  slot[8, 9].solucion := 8;
  slot[9, 9].solucion := 6;
end; 
procedure pistas;

var
  y, x, g: integer;


begin
  for y := 1 to y_max do 
    for x := 1 to x_max do 
      if pista < pistasmax then
        begin
          g := random(5) + 1;
          if g = 2 then
            begin
              pista := pista + 1;
              slot[x, y].valor := slot[x, y].solucion;
            end ;
        end 
      else 
        break ;
end; 

begin
  pista := 0;
  tablero;
  while pista < pistasmax do 
    pistas;
  device_screenx := 59;
  device_screeny := 90;
  turno := 1;
  surren := 1;
  repeat 
    clrscr;
    titulo;
    writeboard(59, 90, 1, 1);
    modify;
    if surren = 2 then
      verify ;
    if surren = 3 then
      finish := true  
    else if win = 1 then
      finish := true ;
  until finish = true;
  if win = 1 then
    begin
      gamewin;
    end 
  else 
    begin
      gameover;
      surrender(59, 90, 1, 1);
      writeln('Te has rendido tras: ', Turno - 1, ' Turnos');
      readln;
    end;
end.