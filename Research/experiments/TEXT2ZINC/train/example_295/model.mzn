include "globals.mzn";
    int: n; % size of the grid
    array[1..n, 1..n] of var 0..n: grid;

    % Define the pairs
    set of int: Pairs = 1..n;
    array[Pairs] of var 1..n: pair1_x;
    array[Pairs] of var 1..n: pair1_y;
    array[Pairs] of var 1..n: pair2_x;
    array[Pairs] of var 1..n: pair2_y;

    % Constraints
    constraint forall(i in Pairs)(
      grid[pair1_x[i], pair1_y[i]] = i /\
      grid[pair2_x[i], pair2_y[i]] = i
    );

    % Ensure that the lines do not cross
    constraint forall(i in Pairs, j in Pairs where i < j)(
      (pair1_x[i] != pair1_x[j] \/ pair1_y[i] != pair1_y[j]) /\
      (pair1_x[i] != pair2_x[j] \/ pair1_y[i] != pair2_y[j]) /\
      (pair2_x[i] != pair1_x[j] \/ pair2_y[i] != pair1_y[j]) /\
      (pair2_x[i] != pair2_x[j] \/ pair2_y[i] != pair2_y[j])
    );

    % Solve
    solve satisfy;