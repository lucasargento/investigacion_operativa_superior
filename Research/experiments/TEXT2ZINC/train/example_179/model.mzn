include "globals.mzn"; 

int: n;
set of int: nDomain = 0..n-1;

array[nDomain, nDomain] of var nDomain: quasiGroup;
array[nDomain, nDomain] of var nDomain: quasiGroupColumns;

% solve satisfy;
solve :: int_search([quasiGroup[row, col] | row, col in nDomain], 
        first_fail, indomain_min, complete) satisfy;

constraint
     
     % assign the "reflected" quasigroup to qGColumns to access its columns
     forall(row,col in nDomain) (
         quasiGroupColumns[col,row] = quasiGroup[row,col]
     )
     /\
     % All rows have to be different
     forall(row in nDomain) (
          all_different([quasiGroup[row, col] | col in nDomain])
     )
     /\
     % All cols have to be different
     forall(col in nDomain) (
          all_different([quasiGroup[row, col] | row in nDomain])
     )
     /\
     % All columns have to be different	       
     forall(col in nDomain) (
          all_different([quasiGroupColumns[row, col] | row in nDomain])
     )
     /\
     % All rows have to be different	       
     forall(row in nDomain) (
          all_different([quasiGroupColumns[row, col] | col in nDomain])
     )
     /\
     % this strange constraint
     % corresponds to:
     % quasiGroup[i, quasiGroup[i,j]] = quasiGroup[quasiGroup[i,j], j]	
     forall(i,j in nDomain) (
         quasiGroup[i, quasiGroup[i,j]] = quasiGroupColumns[j,quasiGroup[i,j]]
     )
     /\
     % Implied constraint: Idempotency
     forall(i in nDomain) (
          quasiGroup[i,i] = i
     )
     /\
     % Symmetry-breaking constraints	
     forall(i in nDomain) (
           quasiGroup[i,n-1] + 2 >= i
     )
;

output 
[ "\nquasiGroupColumns: "
] ++
[
   if col = 0 then "\n" else " " endif ++
    show(quasiGroupColumns[row, col])
  | row, col in nDomain

] ++
[ "\nquasiGroup: "
] ++
[
  if col = 0 then "\n" else " " endif ++
    show(quasiGroup[row, col])
  | row, col in nDomain
] ++ ["\n"];




%
% data
%
n = 5;