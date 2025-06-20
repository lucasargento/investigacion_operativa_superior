int: n = 12; 
% disk1
% 1: transparent, 0: not transparent 
array[1..n] of var 0..1: disk1;

% number of the known sum sequence
int: m = 12; % it's instructive to use all 12
% the sum sequence
array[1..6] of 0..n: sums1 = [2,3,4,4,0,4];
% In MiniZinc version ROTD 2010-02-02 (Linux386) there is an
% error if this is directly assigned in the constraint section.
array[1..m] of var 0..n: sums;

% disk2 with all the rotations
% Note: first entry is disk1 turned around (reversed)
array[1..m,1..n] of var 0..1: disk2;

%
% reverse an array
%
predicate reverse(array[int] of var int: x, array[int] of var int: rev) =
        let {int: len = length(x)}
        in
        forall(i in 1..len) (
           rev[i] = x[len-i+1]
        )
;


% solve satisfy;
solve :: int_search(
        [disk2[rot,i] | rot in 1..m, i in 1..n] ++ disk1 ++ sums, 
         occurrence, 
         indomain_min, 
         complete) 
     satisfy;

constraint

  % symmetry breaking
  % but we still have a one shift symmetric solution
  % disk1[1] = 0 /\

  % the sum sequence
  % In MiniZinc ROTD 2010-02-02 the following throws an error
  % (which is a pity)
  % sums = [2,3,4,4,0,4]
  % sums = [2,3,4,4,0,4,_,_,_,_,_,_]
  % so we have to initialize it properly
  %/\
  forall(i in 1..6) (
    sums[i] = sums1[i]
  )
  /\

  % reverse the disk2 (i.e. turn it around)
  reverse(disk1, [disk2[1,i] | i in 1..n])
  /\
  forall(rot in 2..m) (
     forall(i in 1..n) (
        % disk2[rot,i] = disk2[rot-1, 1+(i `mod` n)]
        % disk2[rot,i] = disk2[rot-1, '+'(1, 'mod'(i, n))]
        % disk2[rot,i] = disk2[rot-1, 1 + 'mod'(i, n)]
        disk2[rot,i] = disk2[rot-1, 1+'mod'(i, n)]
    
     )
     /\
     sums[rot] = sum(i in 1..n) (     
        bool2int(disk1[i] + disk2[rot,i] = 2) 
     )
  )
;

output
[
  "disk1: " ++ show(disk1) ++ "\n" ++
  "disk2: " ++ show(disk2) ++ "\n" 
];