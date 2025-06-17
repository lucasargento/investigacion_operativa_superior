% Parameters
int: N; % Number of stocks
array[1..N] of float: Bought; % Number of shares bought for each stock
array[1..N] of float: BuyPrice; % Purchase price for each stock
array[1..N] of float: CurrentPrice; % Current price for each stock
array[1..N] of float: FuturePrice; % Expected future price for each stock
float: TransactionRate; % Transaction cost rate
float: TaxRate; % Capital gains tax rate
float: K; % Amount of money to raise

% Decision Variables
array[1..N] of var 0.0..Bought[i]: Sell; % Number of shares to sell for each stock

% Constraints
constraint forall(i in 1..N) (
    % The amount of money raised should be net of capital gains and transaction costs
    (CurrentPrice[i] * Sell[i]) * (1 - TransactionRate/100) * (1 - TaxRate/100) >= K
);

% Objective
var float: PortfolioValue = sum(i in 1..N) ((Bought[i] - Sell[i]) * FuturePrice[i]);
solve maximize PortfolioValue;

% Output
output ["sell: " ++ show(Sell)];