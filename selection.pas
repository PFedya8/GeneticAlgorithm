Unit selection;
interface
uses main_functions;

procedure Initial_populatoins(kol: integer; var m: population_t);
procedure Generate_population(num: integer; var x, y: real); 
procedure Sort_coctail(var m: population_t; n: integer);
function Bin_search(var m: population_t; pl, ph, kol: integer; r: real): integer;
procedure Delete_double(var a, b: population_t; kol, preserved_low_positions, preserved_high_positions: integer);
procedure Delete_double_new(var a, b: population_t; kol: integer);
procedure Rulet(var m, p: population_t; kol: integer; preserved_low_positions: integer; preserved_high_positions: integer);
procedure Sort_numbers(var m: population_t; n: integer);



implementation
{Генерация начальной популяции}
procedure Initial_populatoins(kol: integer; var m: population_t);
    var
        nom, i: integer;
        r: integer;
    begin
        randomize;
        SetLength(m, kol);
        r := round(exp(Raz * ln(2)));
        for i := 0 to kol - 1 do 
            begin
                nom := random(r); // 256 в зависимости от 2^m
                m[i].number := nom; 
                Generate_population(nom, m[i].argument, m[i].value);
            end;
    end;
{Генерация популяции}
procedure Generate_population(num: integer; var x, y: real); 
    begin
        
        x := a + num * (b - a)/(exp(raz * ln(2)));
        y := f(x);
    end;

procedure Sort_coctail(var m: population_t; n: integer);
    var
        left, right, i: integer;
        temp: pop_t;
    begin
        left := 1;
        right := n - 1;
        while left <= right do
            begin
                for i := right downto left do
                    if (m[i - 1].value > m[i].value) then
                        begin
                            temp := m[i];
                            m[i] := m[i - 1];
                            m[i - 1] := temp;
                        end;
                left := left + 1;
                for i := left to right do
                    if m[i - 1].value > m[i].value then
                        begin
                            temp := m[i];   
                            m[i] := m[i - 1];
                            m[i - 1] := temp;
                        end;
                right := right - 1;
            end;
       { WriteLn;
        for i:= 0 to n - 1 do writeln(' ', m[i].value:0:8);}
    end;


{Двоичный поиск}
function Bin_search(var m: population_t; pl, ph, kol: integer; r: real): integer;
    var
        left, right, mid: integer;
    begin
        left := pl;
        right := kol - 1 - ph;
        while left <= right do 
            begin
                mid := (left + right) div 2;
                if (r < m[mid].celection) then right := right - 1
                else if r > m[mid].celection then left := left + 1;
            end;
         Bin_search := mid ; 
    end;

{Удаление повторяющихся особей}
procedure Delete_double(var a, b: population_t; kol, preserved_low_positions, preserved_high_positions: integer);
    var i, j, k, m: integer;
    begin   
        k := 0;
        SetLength(b, kol);
        {for i := 0 to preserved_low_positions do 
            begin
                b[i] := a[i];
            end;
        
        for i := kol - 1 - preserved_high_positions to kol - 1 do 
            begin
                b[i] := a[i]
            end;}
        for i := 0 to (kol - 1) do 
            begin
                m := 0; 
                for j:=0 to k do
                    if (a[i].number = b[j].number) then inc(m);
                if m=0 then 
                    begin
                        inc(k);
                        b[k]:=a[i];
                    end;
            end;
    end;

{Удаление повторяющихся особей}
procedure Delete_double_new(var a, b: population_t; kol: integer);
    var
        i, j, m: byte;
        fl: boolean;

    begin
        SetLength(b, kol);
        {for i := 0 to kol - 1 do
            begin
                b[i].number := Pusto;
            end;}
        for i := 0 to kol - 1 do 
            begin
                b[i].status := not_alive;
            end;
        b[0] := a[0];
        m := 0;
        for i := 1 to kol - 1 do 
            begin
                fl := true;
                    for j := 0 to m  do
                        if a[i].number = b[j].number then 
                            fl := false;
                    if fl = true then 
                        begin
                            m := m + 1;
                            b[m] := a[i];
                        end;
            end;
    end;

{Селекция}
procedure Rulet(var m, p: population_t; kol: integer; preserved_low_positions: integer; preserved_high_positions: integer);
    var
        i: integer;
        r: real;
    begin
        Randomize;
        //norm := abs (m[kol - preserved_high_positions - 1].value - m[0 + preserved_low_positions].value);
        //writeln(norm:0:8, ' ', m[kol -1 ].value - m[0].value );
        SetLength(p, kol);
        for i := 0 + preserved_low_positions to kol - 1 - preserved_high_positions do
            begin
                m[i].celection := (m[i].value - m[0].value) / (m[kol - 1].value - m[0].value){(m[i].value + norm) / norm; }
            end;
        {for i := 0 to kol - 1 do
            begin
                WriteLn(i, ' ', m[i].celection:0:8)
            end;}

        for i := 0 to preserved_low_positions do 
            begin
                p[i] := m[i];
            end;   
        
        for i := (kol - preserved_high_positions - 1) to kol - 1 do 
            begin
                p[i] := m[i];              
            end;
            
        for i := preserved_low_positions to kol - 1 - preserved_high_positions do 
            begin
                r := Random;
               p[i] := m[Bin_search(m, preserved_low_positions, preserved_high_positions, kol, r)];
                //writeln(Bin_search(m, preserved_low_positions, preserved_high_positions, kol, r));
                
                
            end;
    end;

{Сортировка по возрастанию номеров}
procedure Sort_numbers(var m: population_t; n: integer);
    var
        left, right, i: integer;
        temp: pop_t;
    begin
        left := 1;
        right := n - 1;
        while left <= right do
            begin
                for i := right downto left do
                    if (m[i - 1].number > m[i].number) then
                        begin
                            temp := m[i];
                            m[i] := m[i - 1];
                            m[i - 1] := temp;
                        end;
                left := left + 1;
                for i := left to right do
                    if m[i - 1].number > m[i].number then
                        begin
                            temp := m[i];   
                            m[i] := m[i - 1];
                            m[i - 1] := temp;
                        end;
                right := right - 1;
            end;
    end;

end.