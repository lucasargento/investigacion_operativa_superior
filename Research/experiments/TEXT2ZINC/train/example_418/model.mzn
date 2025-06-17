include "globals.mzn";
  
  % number of heated seats
  var 15..100: heated_seats;
  % number of regular seats
  var 0..100: regular_seats;
  
  % total seats should not exceed 100
  constraint heated_seats + regular_seats <= 100;
  % at least 3 times as many people prefer regular seats to heated seats
  constraint regular_seats >= 3 * heated_seats;
  
  % profit per heated seat is $20 and per regular seat is $15
  var int: profit = 20 * heated_seats + 15 * regular_seats;
  
  % maximize profit
  solve maximize profit;
  
  output ["Heated Seats: " ++ show(heated_seats) ++ "\n" ++ "Regular Seats: " ++ show(regular_seats) ++ "\n" ++ "Profit: $" ++ show(profit)];