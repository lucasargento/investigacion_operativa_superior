include "globals.mzn"; 

int: num_people;
array[1..num_people] of set of int: compatible;

%% a matrix version of compatible
% array[1..num_people, 1..num_people] of int: a = 
%      array2d(1..num_people, 1..num_people,
%           [if j in compatible[i] then 1 else 0 endif |  i,j in 1..num_people ]);

% constraint
%   forall(i in 1..num_people) (
%     trace(show([a[i,j] | j in 1..num_people]) ++ "\n",true)
%   )
% ; 

% decision variables

% which kidney does person p get (or 0 if he/she gets no kidney)
array[1..num_people] of var 0..num_people: x;

% matrix version of the exchange (dual model)
% it take some more space (and time for flattening) 
% but it seems to be worth it
array[1..num_people, 1..num_people] of var 0..1: y;

var 0..num_people: z = sum([bool2int(x[i] > 0) | i in 1..num_people]);
% var 0..num_people: z = sum([y[i,j]| i,j in 1..num_people]);

% solve satisfy;
% solve maximize z;
solve :: int_search(
      x ++ [y[p,i] | p,i in 1..num_people], 
      first_fail, 
      indomain_random, % indomain_random, % indomain_reverse_split, 
      complete) 
    maximize z;

% TODO:
% - detecting cycles/subcircuits
% - how can x[x[p]] be stated in the y matrix representation 
%   without blowing things up.
%
constraint
   alldifferent_except_0(x) % :: domain
   /\
   forall(p in 1..num_people) (
     % either this person don't get a kidney
     (
      x[p] = 0 
      /\ sum([y[p,i] | i in 1..num_people]) = 0 
      /\ sum([y[i,p] | i in 1..num_people]) = 0
     ) 
     \/
     % or he/she does and the donor also receive a kidney
     (
       x[p] in compatible[p] % who's the donor?
       /\ x[x[p]] > 0 % the donor must also receive a kidney
       % /\ sum([a[p,i] | i in 1..num_people]) > 0
       /\ sum([y[p,i] | i in 1..num_people]) = 1 
       /\ sum([y[i,p] | i in 1..num_people]) = 1 
     )

   )

   % /\ % redundant constraint (slower)
   % forall(p in 1..num_people) (
   %   sum([y[p,i] | i in 1..num_people]) = sum([y[i,p] | i in 1..num_people])
   % )

   % /\ assigned_except_0(x) % testing

   % /\ z = sum([y[i,j]| i,j in 1..num_people])
;


output [
  "z: " ++ show(z) ++ "\n" ++
  "x: " ++ show(x) ++ "\n"
]
++
[
  "person: donor\n"
]
++
[
  if fix(x[i] = 0) then 
     show_int(3, i) ++ ":   -\n"
  else 
     show_int(3, i) ++ ": " ++  show_int(3, x[i]) ++ "\n"
  endif
  
  | i in 1..num_people
]
++
[  "\nz: " ++ show(z) ++ "\n" ]
;


%
% assigned_except_0(x)
%
predicate assigned_except_0(array[int] of var int: x) = 
   alldifferent_except_0(x) 
   /\
   forall(i in index_set(x)) (
     x[i] != 0 <-> x[x[i]] != 0
   )
;


%
% data
%

% The compatibility matrix 
% (from Pascal's introduction lecture)
% who can give a kidney to person p
% This is a directed graph
% num_people = 8;
% compatible = 
%   [
%     {2,3}, % 1
%     {1,6}, % 2
%     {1,4,7}, % 3
%     {2}, % 4  
%     {2}, % 5
%     {5}, % 6
%     {8}, % 7
%     {3}, % 8
%   ];