include "globals.mzn";

int: n;

array[1..n] of var 1..n: queens;

solve :: int_search(
        queens, 
        first_fail,
        indomain_median,
        complete
       )
     satisfy;

% solve satisfy;
constraint all_different(queens); %  :: domain;
constraint all_different([queens[i]+i | i in 1..n]) :: domain;
constraint all_different([queens[i]-i | i in 1..n]) :: domain;

output 
[
  "queens: " ++ show(queens)
] ++ 
% [
%   if j = 1 then "\n" else "" endif ++
%      if fix(queens[i]) = j then          
%         show_int(2,j)
%      else
%         "__"
%      endif
%   | i in 1..n, j in 1..n
% ] ++
["\n"]
;

% data
n = 8;