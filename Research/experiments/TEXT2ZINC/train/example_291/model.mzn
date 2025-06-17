include "globals.mzn";

% Define the Magic Modulo Number
var 1..1000: magic_modulo_number;

% The property of the Magic Modulo Number
constraint forall(v in 2..9)(magic_modulo_number mod v = v-1);

% The task is to find the smallest Magic Modulo Number
solve minimize magic_modulo_number;

% Output the Magic Modulo Number
output ["Magic Modulo Number: " ++ show(magic_modulo_number)];