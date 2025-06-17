include "globals.mzn";
% include "gecode.mzn"; % For Gecode!

int: n = 5; 
int: total = (n*(n*n+1)) div 2;

% var 0..n*n*n: total;
array[1..n,1..n] of var 1..n*n: magic;
array[1..n,1..n] of var 1..n*n: water;

% the difference between water and magic
% array[1..n,1..n] of var 0..n*n: diffs;

int: assoc = n*n+1;
% var 1..n*n+1: assoc;

% objective (to maximize)
var 0..n*n*n: z = sum(water) - (n*n*(n*n+1) div 2) ;
% var 0..n*n*n: z2 = sum(diffs);

% ann: var_select;
% ann: val_select;
% solve :: int_search(
%         % [water[i,j] | i in 1..n, j in 1..n] ++
%         [magic[i,j] | i in 1..n, j in 1..n] % ++ [z]
%         % ++[water[i,j] | i in 1..n, j in 1..n] 
%         % [magic[i,j] | i in 1..n, j in 1..n] % ++ [z]
%         % [diffs[i,j] | i in 1..n, j in 1..n]
%         % ++[water[i,j] | i in 1..n, j in 1..n] % ++
%         % ++[magic[i,j] | i in 1..n, j in 1..n]
%         , 
%         most_constrained,
%         indomain_random, % indomain_split, % 
%         complete) 
%     % satisfy;
%     maximize z;
%     % maximize z2;

% solve :: seq_search(
%        [

%         int_search([magic[i,j] | i in 1..n, j in 1..n], most_constrained, indomain_random, complete),

%          % this (as the singular int_search) is best at 5x5
%          % int_search([magic[i,j] | i in 1..n, j in 1..n], most_constrained, indomain_max, complete),


%          % int_search([magic[i,j] | i in 1..n, j in 1..n], most_constrained, indomain_max, complete),
%          % int_search([water[i,j] | i in 1..n, j in 1..n], first_fail, indomain_max, complete),


%          % int_search([diffs[i,j] | i in 1..n, j in 1..n], first_fail, indomain_max, complete),
%          % int_search([magic[i,j] | i in 1..n, j in 1..n], most_constrained, indomain_max, complete),
         
%        ]
%      ) 
%      maximize z;

% solve satisfy;
solve maximize z;


% constraint
%   % trace("n: " ++ show(n) ++ " total: " ++ show(total) ++ " assoc: " ++ show(assoc) ++ "\n", 1=1)
%   trace("n: " ++ show(n) ++ " total: " ++ show(total) ++ "\n", 1=1)
% ;

constraint
  all_different([magic[i,j] | i,j in 1..n]) :: domain
  /\
  forall(k in 1..n) (
     sum(i in 1..n) (magic[k,i]) = total /\
     sum(i in 1..n) (magic[i,k]) = total
  )
  /\ % diagonal
  sum(i in 1..n) (magic[i,i]) = total
  /\ % diagonal
  sum(i in 1..n) (magic[i,n-i+1]) = total

  /\ % "associative value"
  forall(i,j in 1..n) (
     magic[i,j] + magic[n-i+1,n-j+1] = assoc
  )

  % /\ z = 0 % optimal value for n=4
  % /\ z >= 69 % testing n=5

  % TESTING for n=5
  % /\ if n = 5 then
  %    magic[1,2] > magic[2,2] /\ magic[1,3] > magic[2,3] /\ magic[1,4] > magic[2,4] /\ 
  %    magic[n,2] > magic[n-1,2] /\   magic[n,3] > magic[n-1,3] /\ magic[n,4] > magic[n-1,4] 
  %    /\ 
  %    magic[2,1] > magic[2,2] /\ magic[3,1] > magic[3,2] /\ magic[4,1] > magic[4,2] /\
  %    magic[2,n] > magic[2,n-1] /\ magic[3,n] > magic[3,n-1] /\ magic[4,n] > magic[4,n-1]
  %    else 
  %      true
  %    endif
  
  % Testing
  % /\ sum(i, j in 1..n) ( bool2int(water[i,j] > magic[i,j]) ) > n


;

% Water retention
% This is from the Numberjack model (MagicWater.py)
constraint
   % first, the rim
   forall(i in 1..n) (
      % rows
      water[i,1] = magic[i,1] /\
      water[i,n] = magic[i,n] /\
      % columns
      water[1,i] = magic[1,i] /\
      water[n,i] = magic[n,i]
   )
   /\
   % % then the inner cells (max between their own height and of 
   % % the water level around)
   forall(a in 2..n-1, b in 2..n-1) (
      % water[a,b] = max(magic[a,b], min([water[a-1,b], water[a,b-1], 
      %                                   water[a+1,b], water[a,b+1]]))
      % /\
      maximum(water[a,b], [magic[a,b], min([water[a-1,b], water[a,b-1], 
                                            water[a+1,b], water[a,b+1]])]) % :: domain

      % let {
      %   var 1..n*n: t = min([water[a-1,b], water[a,b-1], 
      %                        water[a+1,b], water[a,b+1]])
      % } in
      % maximum(water[a,b], [magic[a,b], t]) :: domain

   )

   % /\
   % forall(i,j in 1..n) (
   %   water[i,j] >= magic[i,j]
   % )

     % Testing
   % /\ 
   % forall(i,j in 1..n) (
   %   diffs[i,j] = water[i,j] - magic[i,j]
   % )


   % /\  % Testing: Each hole must have a neigbouring hole
   % forall(i,j in 1..n) (
   %   diffs[i,j] > 0 ->
   %          sum(a,b in {-1,0,1} where 
   %             i+a > 0  /\ j+b >  0 /\
   %             i+a <= n /\ j+b <= n /\
   %             (abs(a) + abs(b) > 0)
   %          ) (bool2int(diffs[i+a,j+b] > 0)) > 0
   % )


;

% Frénicle standard form
% See hakank.org/minizinc/magic_square_frenicle_form.mzn
% For n=4 this yields the 48 squares that's shown at
% http://en.wikipedia.org/wiki/Associative_magic_square#4_x_4_associative_magic_square_-_complete_listing
% 
constraint
  minimum(magic[1,1], [magic[1,1], magic[1,n], magic[n,1], magic[n,n]]) :: domain
  /\
  magic[1,2] < magic[2,1]
;

% Symmetry breaking as the Numberjack model 
% (which is not exactly the same as Frénicle standard form)
% constraint
%    magic[1,1] < magic[1,n] /\
%    magic[1,1] < magic[n,n] /\
%    magic[1,n] < magic[n,1]
% ;


output [
  "magic: " ++ show(magic) ++ "\n" ++
  "water: " ++ show(water) ++ "\n" ++
  "magic total: " ++ show(total) ++ "\n" ++ 
  "assoc: " ++ show(assoc) ++ "\n" ++
  "z:     " ++ show(z) ++ "\n" ++
  % "z2:     " ++ show(z2) ++ "\n" ++
  "sum(water): " ++ show(sum(water)) ++ "\n" ++
  "(n*n*(n*n+1) div 2): " ++ show((n*n*(n*n+1) div 2)) ++ "\n"
] 
++ ["\nmagic:"] ++
[
  if j = 1 then "\n" else "" endif ++
    show_int(3, magic[i,j]) ++ " "
  | i,j in 1..n
] 
++ ["\n\nwater:"] ++
[
  if j = 1 then "\n" else "" endif ++
    show_int(3, water[i,j]) ++ " "
  | i,j in 1..n
] 
% ++ ["\ndiffs:\n"] ++
% [
%   if j = 1 then "\n" else "" endif ++
%     show_int(3, diffs[i,j]) ++ " "
%   | i,j in 1..n
% ] 
++ ["\n\nretention:"] ++
[
  if j = 1 then "\n" else "" endif ++
    if fix(water[i,j]) != fix(magic[i,j]) then 
        show_int(3, water[i,j]-magic[i,j]) ++ " "
    else 
        "___ " 
    endif
  | i,j in 1..n
] 
++ 
[ "\nz:     " ++ show(z) ++ "\n"]
++
["\n"];