Unit main_functions;
interface 
uses sysutils, strutils, math;
const   
    a = 0;
    b = 4; {Начало и конец отрезка}
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
    population_t = array of pop_t;

function f(x: real): real;
function Generate_argument(num: integer): real;

implementation

function f(x: real): real;
    begin
        f := x * sin(x + 5) * cos(x - 6) * sin(x + 7) * cos (x - 8) * sin(x / 3);
    end;

function Generate_argument(num: integer): real;
    begin
        Generate_argument := a + num * (b - a)/(exp(Raz * ln(2)));
    end;




end. 