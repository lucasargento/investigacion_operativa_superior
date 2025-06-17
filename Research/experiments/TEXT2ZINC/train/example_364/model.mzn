include "globals.mzn"; 
int: Top = 200; 

var 1..Top:  L1;
var 1..Top:  L2;
var 1..Top:  L3;
var 1..Top:  L4;
var 1..Top:  L5;
var 1..Top:  L6;
var 1..Top:  L7;
var 1..Top:  L8;
var 1..Top:  L9; 
var 1..Top:  L10; 
var 1..Top:  L11; 
var 1..Top:  L12; 
var 1..Top:  L13; 
var 1..Top:  L14; 
var 1..Top:  L15; 
var 1..Top:  L16; 
var 1..Top:  L17; 
var 1..Top:  L18; 
var 1..Top:  L19; 
var 1..Top:  L20; 
var 1..Top:  L21; 
var 1..Top:  L22; 
var 1..Top:  L23; 
var 1..Top:  L24; 
var 1..Top:  L25; 

array[1..25] of var 1..Top: LD = [L1,L2,L3,L4,L5,L6,L7,L8,L9,L10,L11,L12,L13,L14,L15,L16,L17,L18,L19,L20,L21,L22,L23,L24,L25];

var int:  LHS;
var int:  RHS;

% solve satisfy;
solve :: int_search(LD ++ [LHS, RHS], first_fail, indomain_min, complete) satisfy;

constraint

    all_different(LD)
    /\ 

    % Ordering
    L1 < L2 /\  L2 < L3 /\  L3 < L4 /\  L4 < L5 /\  L5 < L6 /\  L6 < L7 /\  
    L7 < L8 /\  L8 < L9 /\  L9 < L10 /\  L10 < L11 /\  L11 < L12 /\  L12 < L13 /\  
    L13 < L14 /\  L14 < L15 /\  L15 < L16 /\  L16 < L17 /\  L17 < L18 /\  
    L18 < L19 /\  L19 < L20 /\  L20 < L21 /\  L21 < L22 /\  L22 < L23 /\  
    L23 < L24 /\  L24 < L25 /\ 

    % Sum of Squares Constraint
    L1*L1 + L2*L2 + L3*L3 + L4*L4 + L5*L5 + L6*L6 + L7*L7 + L8*L8 + 
    L9*L9 + L10*L10 + L11*L11 + L12*L12 + L13*L13 + L14*L14 + L15*L15 + 
    L16*L16 + L17*L17 + L18*L18 + L19*L19 + L20*L20 + L21*L21 + L22*L22 + 
    L23*L23 + L24*L24 = L25*L25 /\ 

    % Length Constraints
    L1 + L3 = L4 /\  L4 + L1 = L5 /\ 
    L4 + L5 = L7 /\  L5 + L7 = L8 /\ 
    L3 + L4 + L7 = L9 /\  L1 + L5 + L8 = L11 /\ 
    L2 + L12 = L14 /\  L2 + L14 = L15 /\ 
    L2 + L15 = L16 /\  L10 + L11 = L17 /\ 
    L7 + L8 + L9 = L18 /\  L6 + L16 = L19 /\ 
    L6 + L19 = L20 /\  L9 + L18 = L21 /\ 
    L10 + L17 = L22 /\  L14 + L15 = L23 /\ 
    L13 + L20 = L24 /\  L21 + L22 + L23 = L25 /\ 
    L18 + L21 + L24 = L25 /\  L19 + L20 + L24 = L25 /\ 
    L15 + L16 + L19 + L23 = L25 /\ 
    
    % Double check the Answer
    LHS = L1*L1 + L2*L2 + L3*L3 + L4*L4 + L5*L5 + L6*L6 + L7*L7 + 
    L8*L8 + L9*L9 + L10*L10 + L11*L11 + L12*L12 + L13*L13 + L14*L14 + 
    L15*L15 + L16*L16 + L17*L17 + L18*L18 + L19*L19 + L20*L20 + L21*L21 + 
    L22*L22 + L23*L23 + L24*L24 /\ 

    RHS = L25*L25

;

output [
  "LD: ", show(LD),"\n",
  "LHS: ", show(LHS), "\n",
  "RHS: ", show(RHS), "\n",

];