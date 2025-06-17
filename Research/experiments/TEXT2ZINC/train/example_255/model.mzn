% Parameters
int: N; % Number of currencies
array[1..N] of float: Start; % Initial amount of each currency
array[1..N] of float: Limit; % Limit of transactions for each currency
array[1..N, 1..N] of float: Rate; % Exchange rates between currencies

% Decision Variables
array[1..N, 1..N] of var 0.0..Limit[N]: Transactions; % Amount of currency i exchanged to currency j

% Objective
var float: FinalAmount = Start[N] + sum(i in 1..N-1) (Transactions[i,N] * Rate[i,N] - Transactions[N,i] / Rate[N,i]);
maximize FinalAmount;

% Constraints
constraint forall(i in 1..N) (
    sum(j in 1..N) (Transactions[i,j] + Transactions[j,i]) <= Limit[i]
);

constraint forall(i in 1..N, j in 1..N) (
    Transactions[i,j] <= Start[i]
);

constraint forall(i in 1..N, j in 1..N) (
    Transactions[i,j] * Rate[i,j] = Transactions[j,i]
);