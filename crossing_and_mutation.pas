unit crossing_and_mutation;
interface
uses main_functions, math;


function Pointer(number: word): word;
function Single_point_crossover(first, second, point: word): word;
function Double_point_crossing(first, second, point1, point2: integer): integer;
function Universal_crossing( first, second: integer): integer;
function Homogeneous_crossing(first, second: integer): Integer;
function Searching_zero_numbers(var m: population_t; kol: integer): integer;
function Max_long(first: integer): integer; 
procedure Main_crossover(var m: population_t; kol: integer; crossing_volume: real);
function Single_mutation(first: integer): integer;
function Replace_bit_mutation(first: integer): integer;
function Reverse_mutation(first: Integer): Integer;
procedure Main_mutation(var m: population_t; kol: integer; variability: real);


implementation



{Для скрещивания}
function Pointer(number: word): word;
    var x: word=$8000;
    begin
        x := x - 1;
        Pointer :=  x shr (15 - number) ;
    end;

{Одноточечное скрещивание}
function Single_point_crossover(first, second, point: word): word;
    var
        first_part, second_part: word;
    begin
        first_part := first and not(Pointer(point));
        second_part := second and Pointer(point);
        Single_point_crossover := first_part + second_part;
    end;

{Двуточечное скрещивание}
function Double_point_crossing(first, second, point1, point2: integer): integer;
    var 
        first_part, second_part, third_part, pr: integer;
    begin
        if point1 < point2 then 
                begin
                    pr := point2;
                    point2 := point1;
                    point1 := pr;                 
                end;
        first_part := first and not(Pointer(point1));
        second_part := second and (Pointer(point1) - Pointer(point2));
        third_part := first and (Pointer(point2));
        Double_point_crossing := first_part + second_part + third_part;
    end;

{Универсальнео скрещивание}
function Universal_crossing( first, second: integer): integer;
    var
        i, ran, k, otv: word;
    begin
        //Randomize;
        k := 1;
        otv := 0;
        for i := 0 to 10 do 
            begin
                ran := Random(2);
                //WriteLn('rand= ', ran);
                if ran = 0 then
                    begin
                        otv := otv + k and first;
                    end
                else if ran = 1 then 
                    begin
                        otv := otv + k and second;
                    end;
                k := k shl 1;
                //writeln(otv, ' k = ', k);
            end;
        Universal_crossing := otv;
    end;

{Однородное скрещивание}
function Homogeneous_crossing(first, second: integer): Integer;
    var mask, i, k, otv, r: integer;
    begin 
        //Randomize;
        k := 1;
        otv := 0;
        r := round(exp(Raz * ln(2)));
        mask := Random(r); //256
        //mask := 16;
        
        for i := 0 to 10 do 
            begin
                //writeln('mk= ', mask and k);
                if mask and k = k then 
                    begin
                        otv := otv + first and k;
                    end
                else if mask and k = 0 then 
                    begin
                        otv := otv + second and k;
                    end;
                k := k shl 1;
                //WriteLn('otv= ', otv);
            end;
        Homogeneous_crossing := otv;
    end;

{Поиск нулевых номеров}
function Searching_zero_numbers(var m: population_t; kol: integer): integer;
    var i, k: integer;
    begin
        k := 0;
        for i := 0 to kol - 1 do 
            begin
                if m[i].number = 0 then 
                    k := k + 1
                else
                    begin
                        break;
                    end;
                
            end;
        Searching_zero_numbers := k;
    end;

{Количство бит в числе}
function Max_long(first: integer): integer; 
    var kol, i: Integer;
    begin
        i := 1; 
        kol := 0;
        while i <= first do 
            begin
                kol := kol + 1;
                i := i * 2;
            end;
        Max_long := kol;
    end;

{Главная процедура скрещивания}
procedure Main_crossover(var m: population_t; kol: integer; crossing_volume: real);
    var
        num_cross, num_zero, r1, r2, random_crossing, i: integer;
        first, second, point1, point2, long: integer;
    begin
        randomize;
        num_cross := round(kol * crossing_volume);
        num_zero := Searching_zero_numbers(m, kol);
        if num_cross > num_zero then 
            begin
                num_cross := num_zero;
            end;
        //writeLn('numcr= ', num_cross);
        for i := 0 to num_cross - 1 do 
            begin
                
                r1 := num_zero + random(kol - num_zero);
                
                r2 := num_zero + random(kol - num_zero);
                //writeln('randomnoe= ', r1, ' ', r2, ' ', i);
                if r1 = r2 then 
                    begin
                        while r1 = r2 do 
                            begin
                                r2 := num_zero + random(kol - num_zero);
                                //writeln('aa=', r2);
                            end;
                    end;
                first := m[r1].number;
                second := m[r2].number;
                //WriteLn (first, ' s ', second);
                long := max(Max_long(m[r1].number), Max_long(m[r2].number));
                point1 := 1 + random(long);
                point2 := 1 + Random(long);
                random_crossing := Random(4);
                    //random_crossing := 1;
                if random_crossing = 0 then 
                    begin
                        m[i].number := Single_point_crossover( first, second, point1);
                        m[i].status := allive;
                        m[i].argument := Generate_argument(m[i].number);
                        m[i].value := f(m[i].argument);
                    end
                else if random_crossing = 1 then 
                    begin
                        m[i].number := Double_point_crossing(first, second, point1, point2);
                        m[i].status := allive;
                        m[i].argument := Generate_argument(m[i].number);
                        m[i].value := f(m[i].argument);
                    end
                else if random_crossing = 2 then 
                    begin
                        m[i].number := Universal_crossing(first, second);
                        m[i].status := allive;
                        m[i].argument := Generate_argument(m[i].number);
                        m[i].value := f(m[i].argument);
                    end
                else if random_crossing = 3 then 
                    begin
                        m[i].number := Homogeneous_crossing(first, second);
                        m[i].status := allive;
                        m[i].argument := Generate_argument(m[i].number);
                        m[i].value := f(m[i].argument);
                    end;
                
                //writeln('f= ', first, ' s= ', second, ' p1= ', point1, ' p2= ', point2, ' r= ', m[i].number)
            end;
    end;

{Мутация одного бита}
function Single_mutation(first: integer): integer;
    var r, x, kol, i: Integer;
    begin
        //Randomize; 
        i := 1;
        kol := 0;
        while i <= first do 
            begin
                kol := kol + 1;
                i := i * 2;
            end;
        r := 1 + random(kol);
        //r := 4;
        x := 1 shl (r - 1);
        Single_mutation := first xor x;
    end;

{Мутация заменой двух бит}
function Replace_bit_mutation(first: integer): integer;
    var x1, x2, r1, r2, otv, kol, i: integer;
    begin
        //Randomize;
        otv := first;  
        i := 1;
        kol := 0;
        while i <= first do 
            begin
                kol := kol + 1;
                i := i * 2;
            end;

        //writeln(kol);
        r1 := 1 + Random(kol);
        r2 := 1 + Random(kol);
        {r1 := 4;
        r2 := 3;}
        x1 := 1 shl (r1 - 1) and first;
        x2 := 1 shl (r2 - 1) and first;
        if (x1 <> x2) and ((x1 = 0) or (x2 = 0)) then 
            begin 
                otv := otv xor 1 shl (r1 - 1);
                otv := otv xor 1 shl (r2 - 1);     
            end
        else
            otv := first;
        Replace_bit_mutation := otv;
        //writeln(otv);
        //WriteLn(x1, ' ', x2);
    end;

{Мутация реверсом}
function Reverse_mutation(first: Integer): Integer;
    var i, kol, x, r, otv: integer;
    begin
        //Randomize;
        i := 1;
        kol := 0;
        while i <= first do 
            begin
                kol := kol + 1;
                i := i * 2;
            end;
        r := 1 + Random(kol);
        //r := 3;
        x := 1;
        otv := first;
        for i := 1 to r  do 
            begin
                otv := x xor otv;
                x := 1 shl i ;
                //WriteLn(x, ' ', otv);
            end;
        //writeln(otv);
        Reverse_mutation := otv;
    end;

{Процедура с мутацией}
procedure Main_mutation(var m: population_t; kol: integer; variability: real);
    var 
        num_mut: integer;
        i, r, rand_mut: integer;
        k: Integer;
    begin
        Randomize;
        num_mut := Round(variability * kol);
        //WriteLn('kol=', num_mut);
        for i := 1 to num_mut do 
            begin
                r := Random(kol);
                rand_mut := Random(3);
                if rand_mut = 0 then
                    begin
                        k := m[r].number;
                        m[r].number := Single_mutation(k);
                        m[r].argument := Generate_argument(m[r].number);
                        m[r].value := f(m[r].argument);
                    end;
                if rand_mut = 1 then
                    begin
                        k := m[r].number;
                        m[r].number := Replace_bit_mutation(k);
                        m[r].argument := Generate_argument(m[r].number);
                        m[r].value := f(m[r].argument);
                    end;
                if rand_mut = 2 then
                    begin
                        k := m[r].number;
                        m[r].number := Reverse_mutation(k);
                        m[r].argument := Generate_argument(m[r].number);
                        m[r].value := f(m[r].argument);
                    end;
                //WriteLn('m=', rand_mut, ' nach=', k, ' kon=', m[r].number);
            end;    
    end;



end.