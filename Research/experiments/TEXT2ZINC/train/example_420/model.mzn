var int: XYZ;
% number of servings of vitamin ABC
var int: ABC; 

% number of servings is non-negative
constraint XYZ >= 0;
constraint ABC >= 0;
% at least 30 mg of vitamin
% XYZ contains 2mg of vitamin and ABC contains 1.5mg
constraint XYZ * 2 + ABC * 1.5 >= 30;
% at least 55 mg of fiber
% XYZ contains 5mg of fiber and ABC contains 3mg
constraint XYZ * 5 + ABC * 3 >= 55; 
% at most 40% of the supplements taken from super vitamin XYZ
constraint XYZ <= 0.4 * (XYZ + ABC);
% at least 3 servings of super vitamin XYZ
constraint XYZ >= 3;

% XYZ causes 2 units of drowsiness per serving and ABC causes 3 units of drowsiness per serving
var int: drowsiness = XYZ * 2 + ABC * 3;

% minimize drowsiness
solve minimize drowsiness;

output ["XYZ: " ++ show(XYZ) ++ "\n", "ABC: " ++ show(ABC) ++ "\n", "Drowsiness: " ++ show(drowsiness)];