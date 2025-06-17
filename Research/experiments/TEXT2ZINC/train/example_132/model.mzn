include "globals.mzn"; 

int: n = 7;
set of int: nDomain = 0..n-1;

array[nDomain, nDomain] of var nDomain: quasiGroup;

solve :: int_search([quasiGroup[row, col] | row, col in nDomain], 
        first_fail, indomain_min, complete) satisfy;

constraint

     % All rows have to be different
     forall(row in nDomain) (
          all_different([quasiGroup[row,col] | col in nDomain])
     )
     /\
     % All columns have to be different	       
     forall(col in nDomain) (
          all_different([quasiGroup[row,col] | row in nDomain ])
     )
     /\
     % ((i*j)*j)*j = a
     forall(i in nDomain) (
          forall(j in nDomain) (
	        quasiGroup[quasiGroup[quasiGroup[i,j],j],j] = i
          )
     )
     /\
     % Idempotency
     forall(i in nDomain) (
          quasiGroup[i,i] = i
     )
     /\
     % Implied (from Colton,Miguel 01)
     forall(i in nDomain) (
       forall(j in nDomain) (
         (quasiGroup[i,j]=i) <-> (quasiGroup[j,i]=i)
       )
     )
     /\
     % Symmetry-breaking constraints	
     forall(i in nDomain) (
           quasiGroup[i,n-1] + 2 >= i
     )
;

output [
  if col = 0 then "\n" else " " endif ++
    show(quasiGroup[row, col])
  | row, col in nDomain
] ++ ["\n"];