include "globals.mzn"; 

int: n;
int: num_digits_all;
int: num_digits_missing;
int: max_len; % max length of a number

% ordered list of all digits of the concatenated numbers 1..n.
array[1..num_digits_all] of int: digits_all; 
int: sum_all = sum(digits_all);

% (random) list of concatenated numbers 1..n where one number is missing
array[1..num_digits_missing] of int: digits_missing; 

int: sum_missing = sum(digits_missing);

% digit sum of the missing number
int: diff_digit_sum = sum_all - sum_missing;
% length of the missing number
int: diff_len = num_digits_all - num_digits_missing;

% the digits in the missing number
array[0..9] of int: digit_occurrence_all = array1d(0..9, [sum([digits_all[i] = d | i in 1..num_digits_all]) | d in 0..9]);
array[0..9] of int: digit_occurrence_missing = array1d(0..9, [sum([digits_missing[i] = d | i in 1..num_digits_missing]) | d in 0..9]);
set of int: digits_in_missing_number = { d | d in 0..9 where digit_occurrence_all[d] - digit_occurrence_missing[d] > 0};

% number candidates in each digit position
array[1..num_digits_missing] of set of int: number_candidates;

% The domain of the missing number
set of int: missing_domain = { i | i in 1..n where digit_sum(i) = diff_digit_sum /\ digit_length(i) == diff_len };

%
% decision variables
%

% number assigned to each position, where a m-length number get m places
% in the list
array[1..num_digits_all] of var 1..n: x;

% start positions of each number
array[1..n] of var 1..num_digits_all: start_pos;

% var 1..n: missing;
var missing_domain: missing;

% missing number as an array
% array[1..max_len] of var 0..9: missing_a;
% have add 0 since the number array might have leading 0's
array[1..max_len] of var digits_in_missing_number union {0} : missing_a;

%
% functions
%
% the length of a number. Note that we have to use m+1 in the parameter to log10/1
function int: digit_length(int: m) = 
   ceil(log10(m+1))
;

% the digits of a number
function array[int] of int: digits(int: m) =
     let {
       int: len = digit_length(m);
       array[1..len] of int: a = [(m mod pow(10,len-i+1)) div pow(10,len-i) | i in 1..len ];
     } in 
     a
;

% digit sum of a number (not reduced!)
function int: digit_sum(int: m) =
     let {
       int: len = digit_length(m);
       int: ds = m - sum([9*(m div pow(10,len-i+1)) | i in 1..len])
     } in 
     ds
;

% alternative variant
function int: digit_sum1(int: m) =
   sum(digits(m))
;


% convert a number <-> array.
% Note: There might be leading zeros in the array.
%
% n = to_num_base(a, base)
function var int: to_num_base(array[int] of var int: a, int: base) =
          let { int: len = card(index_set(a));
                var int: n = sum(i in index_set(a)) (
                   pow(base, len-i) * a[i] 
                 );
         } in n
;

% n = to_num(a) ( base 10)
function var int: to_num(array[int] of var int: a) = to_num_base(a, 10);


solve satisfy;
% solve :: int_search(x, first_fail, indomain_split, complete) satisfy;

constraint
 % just to show the complexity of the problem 
 trace("missing_domain: \(missing_domain)\n") /\
 trace("digits_in_missing_number: \(digits_in_missing_number)\n") /\
 % trace("number_candidates: \(number_candidates)\n") /\

 % reduce domains of the number candidate for each digit position
 forall(i in 1..num_digits_missing) (
   % trace("i:\(i) d:\(digits_missing[i]) candidates: \(number_candidates[i])\n" ) /\
   x[i] in number_candidates[i]
 )
 /\

 % digit sum of the missing number:
 %   difference between sum of all digits of numbers 1..n and the digit sum of missing digits
 missing = to_num(missing_a)
 /\
 diff_digit_sum = sum(missing_a)
 /\ % start positions are distinct
 all_different(start_pos)
 /\
 % loop through all the number 1..n and see if there is a place where they can fit.
 % For the missing number we don't try to find any place to fit, but place it last in 
 % the x array
 forall(i in 1..n) ( 
     let {
        int: len = digit_length(i);
        array[int] of 0..9: s = digits(i);
        var 1..num_digits_all: p;
     } in
     if missing != i then
        % Not the missing number: Check for its place
        forall(j in 0..len-1) (
           digits_missing[p+j] = s[j+1] 
           /\
           x[p+j] = i 
           /\
           start_pos[i] = p
        )
     else
       % The missing number. Check for proper digit sum and length
       digit_sum(i) = diff_digit_sum
       /\
       len = diff_len
       /\
       forall(j in 0..len-1) (
           x[p+j] = i 
           /\
           start_pos[i] = p
       )
     endif
  )  
  % special care for the missing number
  /\ % place it last in the solution array and the position array
  forall(i in num_digits_missing+1..num_digits_all) (
     x[i] = missing 
  )
  /\
  start_pos[missing] = num_digits_missing+1
;

constraint
  forall(i in 1..n) (
     count(x,i,digit_length(i))
  )
;

output [
  "missing_domain: \(missing_domain)\n",
  "missing: \(missing)\n",
  % "digits_missing: \(digits_missing)\n",
  % "x: \(x)\n",
  % "start_pos: \(start_pos)\n",
]
++
[ "solution:\n" ]
++
[
  if fix(x[i]) != fix(x[i+1]) then 
    show(x[i]) ++ ","
  else 
    ""
  endif ++
  if i = num_digits_all then
    " (," ++ show(missing) ++ ")"
  else "" endif
  | i in 1..num_digits_all
]
;

%
% data
%

% % 1..50
% n = 50;
% max_len = 2;
% num_digits_all = 91;
% digits_all = [1,2,3,4,5,6,7,8,9,1,0,1,1,1,2,1,3,1,4,1,5,1,6,1,7,1,8,1,9,2,0,2,1,2,2,2,3,2,4,2,5,2,6,2,7,2,8,2,9,3,0,3,1,3,2,3,3,3,4,3,5,3,6,3,7,3,8,3,9,4,0,4,1,4,2,4,3,4,4,4,5,4,6,4,7,4,8,4,9,5,0];
% num_digits_missing = 89;

% digits_missing = [1,2,4,2,5,1,6,9,1,8,3,4,4,7,1,1,3,1,1,2,1,5,4,5,4,2,1,9,7,4,4,1,3,2,1,3,0,5,1,4,1,0,4,8,5,0,4,9,2,9,4,1,4,6,4,0,3,3,2,8,2,0,3,6,3,7,3,2,6,2,7,3,5,1,7,4,3,8,3,2,3,9,2,3,6,2,2,2,4]; % missing number is 38

% ordered sequence
% num_digits_missing = 89;

% Strange cases:
%   12: 11 sols of 12, 8 sols of 21. Though for missing=21 there are 21 solutions with just 21.
%   
% digits_missing = [1,2,3,4,5,6,7,8,9,1,0,1,1,1,2,1,3,1,4,1,5,1,6,1,7,1,8,1,9,2,0,2,1,2,2,2,3,2,4,2,5,2,6,2,7,2,8,2,9,3,0,3,1,3,2,3,3,3,4,3,5,3,6,3,7,3,8,3,9,4,0,4,1,4,2,4,3,4,4,4,5,4,6,4,7,4,8,5,0]; % 49 missing (21 solutions)
% digits_missing = [1,2,3,4,5,6,7,8,9,1,0,1,1,1,2,1,3,1,4,1,5,1,6,1,7,1,8,1,9,2,0,2,2,2,3,2,4,2,5,2,6,2,7,2,8,2,9,3,0,3,1,3,2,3,3,3,4,3,5,3,6,3,7,3,8,3,9,4,0,4,1,4,2,4,3,4,4,4,5,4,6,4,7,4,8,4,9,5,0]; % 21 missing (21 solutions)
% digits_missing = [1,2,3,4,5,6,7,8,9,1,0,1,1,1,2,1,3,1,4,1,5,1,6,1,7,1,8,1,9,2,1,2,2,2,3,2,4,2,5,2,6,2,7,2,8,2,9,3,0,3,1,3,2,3,3,3,4,3,5,3,6,3,7,3,8,3,9,4,0,4,1,4,2,4,3,4,4,4,5,4,6,4,7,4,8,4,9,5,0]; % 20 missing, 21 solutions

% digits_missing = [1,2,3,4,5,6,7,8,9,1,0,1,1,1,2,1,3,1,4,1,5,1,6,1,7,1,8,2,0,2,1,2,2,2,3,2,4,2,5,2,6,2,7,2,8,2,9,3,0,3,1,3,2,3,3,3,4,3,5,3,6,3,7,3,8,3,9,4,0,4,1,4,2,4,3,4,4,4,5,4,6,4,7,4,8,4,9,5,0]; % 19 missing (21 solutions)
% digits_missing = [1,2,3,4,5,6,7,8,9,1,0,1,1,1,3,1,4,1,5,1,6,1,7,1,8,1,9,2,0,2,1,2,2,2,3,2,4,2,5,2,6,2,7,2,8,2,9,3,0,3,1,3,2,3,3,3,4,3,5,3,6,3,7,3,8,3,9,4,0,4,1,4,2,4,3,4,4,4,5,4,6,4,7,4,8,4,9,5,0]; % 12 missing (sols 12 and 21)