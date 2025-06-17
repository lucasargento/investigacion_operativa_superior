int: NR; % number of rows
int: NC; % number of columns
int: NP; % number of pairs

array[1..NR, 1..NC] of int: InputM;

% decision variables
array[1..NR, 1..NC] of var 1..NP: SubM;

% solve satisfy;
solve :: int_search(array1d(SubM), first_fail, indomain_split, complete) satisfy;

constraint

   % initialize preoccupied squares
   forall(I in 1..NR, J in 1..NC) (
       if InputM[I,J] > 0 then 
           SubM[I,J] = InputM[I,J]
       else 
          true
       endif
   )
   /\
   % "each end node has one connected neighbor and each interior node has two connected neighbors"
   forall(J in 1..NR, K in 1..NC) (
     let {
        var 1..2: the_sum = sum([SubM[J1,K1]=SubM[J,K] | J1 in {J-1,J,J+1}, K1 in {K-1,K,K+1} where J1 in 1..NR /\ K1 in 1..NC /\
                                          % ((J1 = J) + (K1 = K)) = 1
                                          % /\
                                          ((J1 = J-1 /\ K1 = K) \/
                                          (J1 = J+1 /\ K1 = K) \/
                                          (J1 = J /\ K1 = K-1) \/
                                          (J1 = J /\ K1 = K+1)
                                          )
                           ] )
     } in
     if InputM[J,K] != 0 then
         the_sum = 1
     else 
         the_sum = 2
     endif
   )
;


output [
  if j = 1 then "\n" else " " endif ++
    show_int(2,SubM[i,j])
  | i in 1..NR, j in 1..NC
];

%
% Data
%


% # Numberlink Puzzle
% # Author: Otto Janko
% # Source: http://www.janko.at/Raetsel/
% # URL: http://www.janko.at/Raetsel/Arukone/109.a.htm
% size 10 10
%  -  -  -  6  -  -  -  -  -  -
%  -  -  -  -  -  -  -  -  -  -
%  -  -  5  -  1  4  -  3  -  -
%  -  -  -  -  3  -  -  8  -  -
%  -  2  -  2  -  -  -  -  -  -
%  -  4  -  8  -  7  -  -  -  -
%  -  -  -  -  -  -  -  -  -  -
%  -  -  5  -  6  1  -  7  -  -
%  -  -  -  -  -  -  -  -  -  -
%  -  -  -  -  -  -  -  -  -  -

% NP = 8;
% NR = 10;
% NC = 10;
% InputM = array2d(1..NR, 1..NC,
%         [0,0,0,6,0,0,0,0,0,0,
%         0,0,0,0,0,0,0,0,0,0,
%         0,0,5,0,1,4,0,3,0,0,
%         0,0,0,0,3,0,0,8,0,0,
%         0,2,0,2,0,0,0,0,0,0,
%         0,4,0,8,0,7,0,0,0,0,
%         0,0,0,0,0,0,0,0,0,0,
%         0,0,5,0,6,1,0,7,0,0,
%         0,0,0,0,0,0,0,0,0,0,
%         0,0,0,0,0,0,0,0,0,0]);