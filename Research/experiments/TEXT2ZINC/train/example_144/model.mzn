include "globals.mzn";

int: n_groups;                          % The number of groups.
int: n_per_group;                       % The size of each group.
int: n_rounds;                          % The number of rounds.

int: n_golfers = n_groups * n_per_group;

set of int: groups = 1..n_groups;
set of int: group = 1..n_per_group;
set of int: rounds = 1..n_rounds;
set of int: golfers = 1..n_golfers;

array [rounds, groups] of var set of golfers: round_group_golfers;

    % Each group has to have the right size.
    %
constraint
    forall (r in rounds, g in groups) (
        card(round_group_golfers[r, g]) = n_per_group
    );

    % Each group in each round has to be disjoint.
    %
constraint
    forall (r in rounds) (
        all_disjoint (g in groups) (round_group_golfers[r, g])
    );

    % Symmetry breaking.
    %
% constraint
%     forall (r in rounds, g in groups where g < n_groups) (
%         round_group_golfers[r, g] < round_group_golfers[r, g + 1]
%     );

    % Each pair may play together at most once.
    %
constraint
    forall (a, b in golfers where a < b) (
        sum (r in rounds, g in groups) (
            bool2int({a, b} subset round_group_golfers[r, g])
        )
    <=
        1
    );

solve satisfy;

output [    ( if   g = 1
              then "\nround " ++ show(r) ++ ":   "
              else "   "
              endif
            ) ++
            show(round_group_golfers[r, g])
       |    r in rounds, g in groups
       ];


%-----------------------------------------------------------------------------%
%-----------------------------------------------------------------------------%