var int: silver_days;
% days spent at lucent beach
var int: lucent_days;

constraint silver_days >= 0;
constraint lucent_days >= 0;

% Jack needs to find at least 80 shrimps
% Jack finds 7 shrimps each day at silver beach and 4 each day at lucent beach
constraint silver_days * 7 + lucent_days * 4 >= 80;

% Jack needs to find at least 50 shrimps
% Jack finds 7 shrimps each day at silver beach and 4 each day at lucent beach
constraint silver_days * 3 + lucent_days * 6 >= 50;

var int: total_days = silver_days + lucent_days;

% minimizing the total days spent at the beaches
solve minimize total_days;

output ["Silver Beach Days: " ++ show(silver_days), "\nLucent Beach Days: " ++ show(lucent_days), "\nTotal Days: " ++ show(total_days)];