int: r;  % upper bound for amount of rings
int: n;  % amount of clients


% original comment: 
% we have double entries here because of the symmetric structure!
array[1..n, 1..n] of 0..1: demand;
array[1..r] of 1..n: capacity_nodes;

array[1..r, 1..n] of var 0..1: rings;
var int: z =  sum(ring in 1..r, client in 1..n) (rings[ring, client]);

solve minimize z;
% solve satisfy;


constraint
%   z <= 7 % for solve satisfy
%   /\

   % original comment:
   % if there is a demand between 2 nodes, then there has to exist 
   % a ring, on which they are both installed
   forall(client1,client2 in 1..n where client1 < client2) (
      (demand[client1,client2] = 1) ->
           exists(ring in 1..r) (
                 rings[ring,client1] + rings[ring, client2] >= 2
           )
   )   
   /\
   % original comment:
   % capacity of each ring must not be exceeded     
   forall(ring in 1..r) (
        sum(client in 1..n) (
              rings[ring, client]
              ) <= capacity_nodes[ring] 
   )
;


%
% data
% (sonet_problem1nu.param)
%
r = 4;
n = 5;

demand =
array2d(1..n, 1..n,
        [0,1,0,1,0,
         1,0,1,0,0,
         0,1,0,0,1,
         1,0,0,0,0,
         0,0,1,0,0])
;

capacity_nodes = [3,2,2,1];


output 
[
  "z: ", show(z)
] ++
[
  if client = 1 then "\n" else " " endif ++
    show(rings[ring, client])
  | ring in 1..r, client in 1..n
] ++ ["\n"];