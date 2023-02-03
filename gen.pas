program gen;
{$R+}
uses sysutils, strutils, math, file_working, selection, crossing_and_mutation, main_functions;
{const   
    a = 0;
    b = 4; Начало и конец отрезка
    Raz = 10;
    Pusto = -1;

type
        status_t =(allive, not_alive);
        
        pop_t = record 
            argument: real;
            value: real;
            number: integer;
            celection: real;
            status: status_t;
            end;
    population_t = array of pop_t;}

{Функция}





var 
    mode: string;
    crossing_volume, variability: real;
    max_iters, max_valuess_iters: integer;
    enough_function_value: real;
    start, m, m1, m2, m3, m4, m5, last: population_t;
    population_volume, i, k: integer;
    quality_epsilon: Real;
    file_n: string;
    p, f1: text;
    preserved_high_positions, preserved_low_positions: integer;
    prom1: pop_t;
begin
    Randomize;
    Assign(f1, 'config.gen');
    Reading_param(f1, mode, population_volume, preserved_high_positions,
                        preserved_low_positions, crossing_volume, variability, 
                        max_iters, enough_function_value, max_valuess_iters,
                        quality_epsilon);
    
    {population_volume := 100;
    preserved_high_positions := 5;
    preserved_low_positions := 5;
    crossing_volume := 1.0;
    variability := 0.7;
    max_iters := 20;
    enough_function_value := 0.511795;
    max_valuess_iters := 122;
    quality_epsilon := 0.00001;}

    
    file_n := 'file_population';
    assign(p , file_n + '.gen');

    
    writeln;
    Initial_populatoins(population_volume, start);
    File_start(p, start, population_volume);
    m := copy(start);


    k := 0;
    prom1.value := 0;
    for i := 1 to max_iters do 
        begin
            if mode = 'test' then
                begin
                    Append(p);
                    WriteLn(p, i, 'ая итерация');
                end;

            Sort_coctail(m, population_volume);
            Rulet(m, m1, population_volume, preserved_high_positions, preserved_high_positions);
            Delete_double_new(m1, m2, population_volume);
            Sort_numbers(m2, population_volume);
            m3 := copy(m2);
            Main_crossover(m3, population_volume, crossing_volume);
            m4 := copy(m3);
            Main_mutation(m4, population_volume, variability);
            Delete_double_new(m4, m5, population_volume);
            Sort_coctail(m5, population_volume);

            if mode = 'test' then 
                File_definition(p, m, m1, m2, m3, m4, m5, population_volume);
            
            {Условие достаточного значения функции}
            if prom1.value >= enough_function_value then 
                begin
                    WriteLn( i, 'ая итерация');
                    writeln('Заданная величина функции была достигнута:');
                    WriteLn('y= ', prom1.value:0:8);
                    WriteLn('x= ', prom1.argument:0:8);
                    WriteLn('Num= ', prom1.number);
                    if mode = 'main' then 
                        begin
                            File_definition_main(p, last, population_volume);
                        end;
                    Halt(1)
                end;

            {Условие не улучшения особи}
            if m5[population_volume - 1].value - prom1.value < quality_epsilon then
                begin
                    k := k + 1; 
                end
            else 
                k := 0;
            if k = max_valuess_iters then 
                begin
                    WriteLn( i, 'ая итерация');
                    writeln( 'Особь не улучшается:');
                    WriteLn('y= ', prom1.value:0:8);
                    WriteLn('x= ', prom1.argument:0:8);
                    WriteLn('Num= ', prom1.number);
                    
                    if mode = 'main' then 
                        begin
                            File_definition_main(p, last, population_volume);
                        end;
                    Halt(2)
                end;


            prom1 := m5[population_volume - 1];
            
            last := Copy(m5);
            SetLength(m, 0);
            SetLength(m, population_volume);
            m := copy(m5);

            SetLength(m1, 0);
            SetLength(m2, 0);
            SetLength(m3, 0);
            SetLength(m4, 0);
            SetLength(m5, 0);

            SetLength(m1, population_volume);
            SetLength(m2, population_volume);
            SetLength(m3, population_volume);
            SetLength(m4, population_volume);
            SetLength(m5, population_volume);
        end;
    if mode = 'main' then 
        begin
            WriteLn('aas');
            File_definition_main(p, last, population_volume);
        end;
        

    {Если достигнуто максимальное количество заданных итераций}
    WriteLn('Выполнено максимальное количество заданных итераций:');
    WriteLn('y= ', prom1.value:0:8);
    WriteLn('x= ', prom1.argument:0:8);
    WriteLn('Num= ', prom1.number);

    
end.