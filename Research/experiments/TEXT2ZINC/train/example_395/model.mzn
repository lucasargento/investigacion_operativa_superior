int: n = 365; % number of days of a year
int: p = 100; % number of persons to check

array[1..p] of var 0.0..1.0: prob_no_dup; % probablity of no duplicate
array[1..p] of var 0.0..1.0: prob_dup; % probablity of same birthday (duplicate)

solve satisfy;

constraint
  prob_no_dup[1] = 1.0

  /\  % calculate the probability of _no_ duplicate
  forall(i in 2..p) (
     prob_no_dup[i] = prob_no_dup[i-1] * int2float(n - i-1 )/ int2float(n)
  )

  /\ % probability of duplicates
  forall(i in 1..p) (
    prob_dup[i] = 1.0 - prob_no_dup[i]
  )
;

output 
[
 "num persons: prob of duplicates\n"
] ++
[
  show(i) ++ ": " ++ show(prob_dup[i]) ++ "\n"
  | i in 1..p
];