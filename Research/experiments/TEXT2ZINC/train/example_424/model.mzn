var int: calcium;
% vitamin D pills
var int: vitaminD;

% pills takes are non-negative
constraint calcium >= 0;
constraint vitaminD >= 0;

% the student must take at least 130 pills of medication
constraint calcium + vitaminD >= 130;
% at least 40 of the total pills must be vitamin D pills
constraint vitaminD >= 40;
% the student must take more calcium pills than vitamin D pills
constraint calcium > vitaminD;

% calcium pills take 5 minutes to be effective and vitamin D pills take 6 minutes to be effective
var int: total_time = calcium * 5 + vitaminD * 6;

% minimize total time for the pills to be effective
solve minimize total_time;

output ["Calcium: " ++ show(calcium) ++ "\n", "Vitamin D: " ++ show(vitaminD) ++ "\n", "Total time: " ++ show(total_time) ++ " minutes\n"];