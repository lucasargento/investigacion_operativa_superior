include "globals.mzn"; 

int: n;
int: num_perms = factorial(n);
array[1..num_perms,1..n] of int: permutations;
int: upper_bound = sum([factorial(i) | i in 1..n]);

function int: factorial(int: n) =
  let {
    int: f = product([i | i in 1..n]);
  } in
  f
;

% decision variables
array[1..upper_bound] of var 1..n: x;
array[1..num_perms] of var 1..upper_bound: ps; % where start the p'th permutation
var 0..upper_bound: z = max(ps);

% solve minimize z;
% solve :: int_search(x ++ ps, input_order, indomain_split, complete) minimize z;
solve :: int_search(x ++ ps, occurrence, indomain_split, complete) minimize z;

constraint
  forall(perm in 1..num_perms) (
    forall(j in 0..n-1) (
      x[ps[perm]+j] = permutations[perm,j+1]
    )  
  )

  /\ all_different(ps)


  /\ % symmetry breaking
  forall(i in 1..n) (
    x[i] = i
  )


  /\ % palindrome (experimental)
  forall(i in 1..upper_bound) (
    x[i] = x[upper_bound-i+1]
  )
  % forall(i in 1..z+n-1) (
  %   x[i] = x[z+n-1-i+1]
  % )
;

output [
  "factorial(n): \(factorial(n))\n",
  "upper_bound: \(upper_bound)\n",
  "x: \(x)\n",
  "ps: \(ps)\n",
  "z: \(z)\n",
  "tot_len: \(z+n-1)\n",
];