include "globals.mzn"; 

int: n = 5; 
set of int: nDomain = 0..n-1;

array[nDomain, nDomain] of var nDomain: quasiGroup;
array[nDomain] of var nDomain: qgDiagonal;

% solve satisfy;
solve :: int_search([quasiGroup[row, col] | row, col in nDomain], first_fail, indomain_min, complete) satisfy;

constraint

     % accessor for diagonal
     forall(i in nDomain) (
         qgDiagonal[i] = quasiGroup[i,i]
     )
     /\
     % All rows have to be different
     forall(row in nDomain) (
          all_different([quasiGroup[row,col] | col in nDomain ] )
     )
     /\
     % All columns have to be different
     forall(col in nDomain) (
          all_different([quasiGroup[row,col] | row in nDomain] )
     )
     /\
     % (j*i)*(i*j) = i
     forall(i in nDomain) (
          forall(j in nDomain) (
                quasiGroup[quasiGroup[j,i],quasiGroup[i,j]] = i
          )
     )
     /\
     % Implied (from Colton,Miguel 01)
     % All-diff diagonal
     all_different(qgDiagonal)

     /\
     % anti-Abelian
     forall(i in nDomain) (
       forall(j in nDomain) (
           (i != j) ->
             (quasiGroup[i,j] != quasiGroup[j,i])
       )
     )
     /\
     % if (i*i)=j then (j*j) = i
     forall(i in nDomain) (
       forall(j in nDomain) (
         (quasiGroup[i,i]=j) -> (quasiGroup[j,j]=i)
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