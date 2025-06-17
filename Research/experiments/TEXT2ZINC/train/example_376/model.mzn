int: heap = 5; 

% columns for binary representation of position after move
int: col = 4;  

% maximum number of heaps to change (if k>1 then Moore's game) ! number of squares per side
int: k = 1; 

% maximum number allowed in any heap
int: nmax = ceil(pow(2.0,int2float(col-1)));

% number in each heap before move;
array[1..heap] of var int: n; 


% variables
% binary values of position after move
array[1..heap, 1..col] of var 0..1: x ; 

% 1 if heap changed, 0 otherwise
array[1..heap] of var 0..1: d; 

% number taken from heap
array[1..heap] of var int: s; 

% number in each heap after move
array[1..heap] of var int: m;

% dummy variables for winning position test 
array[1..col] of var int: w; 

% number of heaps changed
var int: heapch = sum(i in 1..heap) (d[i]);

% minimise number of heaps changed - 
% if solution is zero then current position already safe
solve minimize heapch;


constraint
  forall(i in 1..heap) (
     s[i] >= 0
     /\
     m[i] >= 0
  )
  /\
  forall(i in 1..col) (
     w[i] >= 0
  )

  /\ % convert heap numbers [after move] to binary
  forall(i in 1..heap) (
     sum(j in 1..col) ( ceil(pow(2.0, int2float((j-1))))*x[i,j]  ) = m[i]
  )

  /\ % ensures safe position after move
   forall(j in 1..col) (
        sum(i in 1..heap) (x[i,j]) = (k+1)*w[j]
   )

   /\ % positions before and after are consistent with move
  forall(i in 1..heap) (
    n[i]-s[i] = m[i]
  )
 
  /\ % dummy set to 1 if heap changed
  forall(i in 1..heap) (
    s[i]-nmax*d[i] <= 0
  )
;

%output [
% "heapch: ", show(heapch), "\n",
% "d: ", show(d), "\n",
% "m: ", show(m), "\n",
% "s: ", show(s), "\n",
% "w: ", show(w), "\n",
%
%];

output [
  show(s[i]) ++ " " ++ show(m[i]) ++ "\n"
  | i in 1..heap
];

%
% data
%
n = [5,4,3,2,1];