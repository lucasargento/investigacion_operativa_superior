include "globals.mzn"; 

int: courses = 5;
int: periods = 20;
int: rooms = 2;

array[1..courses,1..periods] of int: available;
array[1..courses,1..courses] of int: conflict;
array[1..courses] of int: requirement;

% decision variables
array[1..courses,1..periods] of var 0..1: timetable;


% solve satisfy;
solve :: int_search([timetable[c,p] | c in 1..courses, p in 1..periods], 
                     most_constrained, indomain_split, complete) satisfy;

constraint
   % 1. Conflicts: There is a conflict matrix M such that M[i,j] = 1 if
   %    courses i and j have common students. Lectures of courses i and j  must
   %    be all scheduled at different times
   forall(c1, c2 in 1..courses where c1 < c2) (
       if conflict[c1,c2] = 1 then
          forall(p in 1..periods) (
             timetable[c1,p] + timetable[c2,p] <= 1
          )
       else 
          true
       endif    
   )

   %
   % 2. Availabilities: There is an availability binary matrix A such that
   %    A[i,j]= 1 then lectures of course i cannot be scheduled at period j.
   %    [Note: It must be that if A[i,j] = 0 then the lectures cannot be 
   %     scheduled at period j.]
   /\
   forall(c in 1..courses, p in 1..periods) (
        if available[c,p] = 0 then
           timetable[c,p] = 0
        else
           true
        endif
   )

   % 3. Rooms: There are r rooms available. At most r lectures can be
   %    scheduled at period k, for each k = 1,...,p.
   /\
   forall(p in 1..periods) (
     sum([timetable[c,p] | c in 1..courses]) <= rooms
   )

   % The number of lectures per course
   /\
   forall(c in 1..courses) (
     sum([timetable[c,p] | p in 1..periods]) = requirement[c]
   )

;

output [
  if p = 1 then "\n" else " " endif ++
    if available[c,p] = 0 then
       "-"
    else  
      show(timetable[c,p])
    endif
  | c in 1..courses, p in 1..periods
];


%
% data (from the Alma-0 program timetable.a0)
%
available = array2d(1..courses,1..periods,
  [
   % 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0  
     0,0,1,1,1,1,1,1,1,1,1,1,0,1,1,0,1,1,1,1,
     1,1,0,0,1,0,1,1,0,1,1,1,1,1,1,1,1,1,1,1,
     0,0,0,1,1,1,1,0,1,1,1,1,0,1,1,1,1,0,1,1,
     1,1,1,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,1,1,
     1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
  ]);


conflict = array2d(1..courses,1..courses,
  [
    0,1,0,0,1,
    1,0,0,1,0,
    0,0,0,0,1,
    0,1,0,0,1,
    1,0,1,1,0,
  ]);


requirement = [6,10,14,6,4];