Unit file_working;
interface
uses main_functions, strutils, sysutils;

procedure Test_writing_mas(m: population_t; kol: integer);
function Bit_interpretation(num: Integer): String;
procedure Test_writing_mas_file(m: population_t; kol: integer; var p: text);
procedure File_start(var p: text; var start: population_t; kol: integer);
procedure File_definition_main(var p: text; var m: population_t; kol: integer);
procedure File_definition(var p: text; var m, m1, m2, m3, m4, m5: population_t; kol: integer);
procedure Reading_param(var f: text; var mode: string; var population_volume, preserved_high_positions,
                        preserved_low_positions: Integer; var crossing_volume, variability: real; 
                        var max_iters: Integer; var enough_function_value: real; var max_valuess_iters: integer;
                        var quality_epsilon: real);

implementation
{Тестовая печать}
procedure Test_writing_mas(m: population_t; kol: integer);
    var 
        i: integer;
    begin
        for i := 0 to kol - 1 do 
            begin
                writeln(m[i].argument :0:8, '   ', m[i].value:0:8, '   ', m[i].number);
            end;
    end;

function Bit_interpretation(num: Integer): String;
    var
        mask: word;
        s: String;
    begin
        mask :=round(exp(raz * ln(2)));
        s := '';
        while mask <> 0 do 
            begin
                if (mask and num) <> 0 then 
                    //write('1')
                    s := s + '1'
                else 
                    //write('0');
                    s := s + '0';
                mask := mask shr 1;
            //writeln(mask);
            end;
        Bit_interpretation := s;
    end;

{Тестовая печать в файл}
procedure Test_writing_mas_file(m: population_t; kol: integer; var p: text);
    var 
        i: integer;
    begin
        for i := 0 to kol - 1 do 
            begin
                writeln(p, Bit_interpretation(m[i].number), '               ', 
                        m[i].argument :0:8, '               ', 
                        m[i].value:0:8, '               ', m[i].number, '               ', m[i].status);
            end;
    end;

{Сортировка}


{Печать начальной популяции в файл}
procedure File_start(var p: text; var start: population_t; kol: integer);
    begin
        Rewrite(p);
        writeln(p, 'Начальная популяция:');
        writeLn(p, 'Битовое предсталение       ', 'Аргумент функции (х)     ', 'Значение функции (y)     ',
                 'Номер особи       ', 'Статус' );
        Test_writing_mas_file(start, kol, p);
        writeln(p, '');
        writeln(p, '');
        Close(p);
    end;

{Печать конечной поуляции в файл}
procedure File_definition_main(var p: text; var m: population_t; kol: integer);
    begin
        Append(p);
        writeln(p, '');
        writeln(p, '');

        writeln(p, 'Конечная популяция:');
        Test_writing_mas_file(m, kol, p);
        Close(p);     
    end;

{Печать в файл в режиме тест}
procedure File_definition(var p: text; var m, m1, m2, m3, m4, m5: population_t; kol: integer);
    begin
        Append(p);
        writeln(p, '');
        writeln(p, '');

        writeln(p, 'Отсортированная популяция:');
        Test_writing_mas_file(m, kol, p);
    
        writeln(p, '');
        writeln(p, '');

        {writeln(p, 'Популяция после селекции:');
        Test_writing_mas_file(m1, kol, p);}

        
        
        writeln(p, 'Популяция после селекции:');
        Test_writing_mas_file(m2, kol, p);

        writeln(p, '');
        writeln(p, '');

        writeln(p, 'После Скрещивания:');
        Test_writing_mas_file(m3, kol, p);

        writeln(p, '');
        writeln(p, '');

        writeln(p, 'После Мутации:');
        Test_writing_mas_file(m4, kol, p);

        writeln(p, '');
        writeln(p, '');

        WriteLn(p, 'Удаление повторяющихся:');
        Test_writing_mas_file(m5, kol, p);

        writeln(p, '');
        writeln(p, '');
        Close(p);
    end;



{Процедура чтения из файла}
procedure Reading_param(var f: text; var mode: string; var population_volume, preserved_high_positions,
                        preserved_low_positions: Integer; var crossing_volume, variability: real; 
                        var max_iters: Integer; var enough_function_value: real; var max_valuess_iters: integer;
                        var quality_epsilon: real);
    var
        i: integer;
        mas: array [0..9] of string;
        mas2: array [0..9] of string;
    begin

        reset(f);
        i := 0;
        while not EOF(f) do 
            begin
                while not EOLn(f) do
                    begin
                      Readln(f, mas[i]);
                      i := i + 1;
                    end; 
            end;

        mas2[0] := AnsiRightStr(mas[0], Length(mas[0]) - Length('mode= '));
        
        mas2[1] := AnsiRightStr(mas[1], Length(mas[1]) - Length('population_volume= '));

        mas2[2] := AnsiRightStr(mas[2], Length(mas[2]) - Length('preserved_high_positions= '));

        mas2[3] := AnsiRightStr(mas[3], Length(mas[3]) - Length('preserved_low_positions= '));

        mas2[4] := AnsiRightStr(mas[4], Length(mas[4]) - Length('crossing_volume= '));

        mas2[5] := AnsiRightStr(mas[5], Length(mas[5]) - Length('variability= '));

        mas2[6] := AnsiRightStr(mas[6], Length(mas[6]) - Length('max_iters= '));

        mas2[7] := AnsiRightStr(mas[7], Length(mas[7]) - Length('enough_function_value= '));

        mas2[8] := AnsiRightStr(mas[8], Length(mas[8]) - Length('max_valuess_iters= '));

        mas2[9] := AnsiRightStr(mas[9], Length(mas[9]) - Length('quality_epsilon= '));

        mode := mas2[0];      
        population_volume := StrToInt(mas2[1]);
        preserved_high_positions := StrToInt(mas2[2]);
        preserved_low_positions := StrToInt(mas2[3]);
        crossing_volume := StrToFloat(mas2[4]);
        variability := StrToFloat(mas2[5]);
        max_iters := StrToInt(mas2[6]);
        enough_function_value := StrToFloat(mas2[7]);
        max_valuess_iters := StrToInt(mas2[8]);
        quality_epsilon := StrToFloat(mas2[9]);
        close(f);
    end;


end.