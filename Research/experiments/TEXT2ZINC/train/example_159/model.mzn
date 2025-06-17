int: n= 12;
set of int: classes = 0..n-1;
set of int: differ = 1..n-1;


% Search space: The set of permutations of integer range [0..n-1]
array[classes] of var classes: series;
array[0..n-2] of var differ: differences;

% solve satisfy;
solve :: int_search(series, occurrence, indomain_min, complete) satisfy;

constraint
   % C1: Each pitch class occurs exactly once
   forall(i,j in classes where i != j) (
     series[i] != series[j]
   )
   /\
   % C2: Differences between neighbouring notes are all different
   % AUX: Addition of auxiliary predicates
   % Auxiliary predicate stores the interval between pairs of neighbouring notes
   forall(i in 0..n-2) (
      differences[i]=abs(series[i+1] - series[i])
   )
   /\
   forall(i,j in 0..n-2 where i != j) (
      differences[i] != differences[j]
   )
   /\
   % SBSO: Symmetry-breaking by selective ordering
   % The first note is less than last one
   series[0] < series[n-1]
;

output [
  show(series)
];