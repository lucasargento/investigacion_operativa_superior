var 0..100: cocks; % number of cocks
var 0..100: hens; % number of hens
var 0..100: chicks; % number of chicks

% constraints
% chicks must be bought 3 for 1 coin
constraint chicks mod 3 = 0; 
% one has 100 coins
% cocks cost 5 coins, hens cost 3 coins, 3 chicks for 1 coin
constraint 5 * 3 * cocks + 3 * 3 * hens + chicks = 100 * 3;
% one buys 100 fowl
constraint cocks + hens + chicks = 100;

% satisfaction
solve satisfy;

% output as json
output [
  "{\n",
  "  \"cocks\": " ++ show(cocks) ++ ",\n",
  "  \"hens\": " ++ show(hens) ++ ",\n",
  "  \"chicks\": " ++ show(chicks) ++ "\n",
  "}"
];