program ratefuchs;

uses crt;

const max_size = 4;

type Spielfeld = array [0..max_size-1, 0..max_size-1] of char;
type Schiff = array[1..(max_size*max_size)] of char;

var
    mySpielfeld : Spielfeld;
    eingabe : integer;
    treffer, anz_versuche : integer;
    aida : Schiff;                           //so heisst mein Schiff,  ;-)
    schiffsgroesse : integer;                //weil das Spiel an "Schiffe versenken" erinnert


procedure init_field(var field : Spielfeld);
var i, j, zaehler : integer;
begin
    zaehler := 0;
    for i := 0 to max_size-1 do
        for j := 0 to max_size-1 do
            begin
                zaehler := zaehler+1;
                field[i,j] := chr(zaehler);
            end;
end;
//----------------------------------------------------
procedure set_ship(groesse : integer);
var 
    i, stelle : integer;
    waagerecht : boolean = false;
begin
    for i := 1 to length(aida) do aida[i] := '-';
    if random(2) = 1 then waagerecht := true;
    stelle := random(16)+1;
    aida[stelle] := 'X';
    if waagerecht then
        begin
            if (stelle mod max_size) <> 0 then aida[stelle+1] := 'X'
            else aida[stelle-1] := 'X';
        end
    else
        begin
            if (stelle + max_size) <= (max_size*max_size) then aida[stelle+max_size] := 'X'
            else aida[stelle-max_size] := 'X';
        end;
end;
//----------------------------------------------------
procedure l_rand();
begin
    write('     ');
    write('|');
end;
//-----------------
procedure r_rand();
begin
    write('|');
    write('      ');
    writeln();
end;
//----------------------------------------------------
procedure line();
begin
    write('---------------------------');
end;
//----------------------------------------------------
procedure printField(field : Spielfeld); //malt ein schoenes Spielfeld
var i, j : integer;
begin
    clrscr();
    writeln();
    writeln();

    TextBackground(7);
    TextColor(0);
    writeln('                                        ');
    writeln('                                        ');
    l_rand();
    line();
    r_rand();
    for i := 0 to max_size-1 do
    begin
        l_rand();
        for j := 0 to max_size-1 do
        begin
            write('  ');
            if ord(field[i,j]) <= 16 then write(ord(field[i,j]):2)
            else write(' ', field[i,j]);

            if j <> max_size-1 then write('  |')
            else write('  ');
        end;
        r_rand();
        l_rand();
        line();
        r_rand();
    end;
    writeln('                                        ');
    writeln('                                        ');
    TextColor(15);
    TextBackground(8);
end;

//----------------------------------------------------

procedure check_strike(ziel : integer);
var x, y : integer;
begin
    anz_versuche := anz_versuche + 1;
    x := (ziel-1) DIV max_size;   //Spalte ausrechnen
    y := (ziel-1) MOD max_size;   //Zeiel ausrechnen
    if (aida[ziel] = 'X') then 
    begin
        mySpielfeld[x,y] := 'X';
        treffer := treffer+1;
    end
    else mySpielfeld[x,y] := '-';
    printField(mySpielfeld);
end;
//----------------------------------------------------

begin  //Hauptprogramm
    randomize();
    anz_versuche := 0;
    writeln();
    //write('Wie lang ist das Schiff: ');
    //readln(schiffsgroesse);
    schiffsgroesse := 2;
    init_field(mySpielfeld);
    set_ship(schiffsgroesse);

    printField(mySpielfeld);
    writeln();
    repeat
        Write('Welches Feld raten: ');
        readln(eingabe);
        if eingabe <> 0 then check_strike(eingabe);
        if treffer = schiffsgroesse then
        begin
            writeln();
            writeln('Sie haben gewonnen!!! (', anz_versuche, ' Versuche)');
            writeln();
            eingabe := 0;
        end;
    until (eingabe = 0);
end.