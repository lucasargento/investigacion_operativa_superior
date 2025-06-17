include "globals.mzn"; 

array[0..11] of var 1..12: x;
var 0..100: triplet_sum; % the sum of the triplets


% solve minimize triplet_sum; % checks if 21 really is the highest value
solve satisfy;


constraint
    triplet_sum <= 21
    /\
    all_different(x)
    /\
    x[0] = 12 /\      
    x[1] > x[11] /\   
    forall(i in 2..11) (
      x[i] + x[i-1] + x[i-2] <= triplet_sum
    )
    /\ % and around the corners
    x[10] + x[11] + x[0]  <= triplet_sum /\ 
    x[11] + x[0]  + x[1]  <= triplet_sum
;


output [
    "triplet_sum: ", show(triplet_sum), "\n",
    "       ", show(x[0]), "\n",
    "     ", show(x[11]), "    ", show(x[1]), "\n",
    "   ", show(x[10]), "       ", show(x[2]), "\n",
    "  ", show(x[9]), "         ", show(x[3]), "\n",
    "   ", show(x[8]), "        ",show(x[4]), "\n",
    "     ",  show(x[7]), "    ", show(x[5]), "\n",
    "       ", show(x[6]), "\n",
]
++
[ "x: " ++ show(x) ++ "\n"]
;