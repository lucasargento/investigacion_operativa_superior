var int: L; % >= 0;
var int: w; % >= 0;
var int: h; % >= 0;

var int: wh = w*h;

solve maximize wh;
% solve satisfy;

constraint
  L >= 0 /\ w >= 0 /\ h >= 0 /\
  wh >= 625 /\
  L >= 0 /\ w >= 0 /\ h >= 0 /\
  2*(w+h) = L /\
  L <= 100 /\
  h >= 2
;


output 
[
  show([L,w,h,wh]), "\n",
  "[w,h,L/4]: ", show([w,h,L div 4])
];