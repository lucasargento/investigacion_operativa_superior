include "globals.mzn"; 

int: numActors;
set of int: Actors = 1..numActors;
array[Actors] of int: actorPay;
int: numScenes;
set of int: Scenes = 1..numScenes;
array[Scenes] of int: sceneDuration;

array[Actors,Scenes] of int: actorInScene;

array[Scenes] of var Scenes: scene;
array[Scenes] of var Scenes: slot;

% First and last slots where each actor plays
array[Actors] of var int: firstSlot;
array[Actors] of var int: lastSlot;

% Expression for the waiting time for each actor
array[Actors] of var int: actorWait;

% Expression representing the global cost
var 0..100: idleCost = sum(a in Actors) (actorPay[a] * actorWait[a]);

solve :: int_search(scene, first_fail, indomain_min, complete) minimize idleCost;
% solve :: int_search(scene, "first_fail", "indomain_min", "complete") satisfy;
% solve :: labelling_ff minimize idleCost;


constraint
 % idleCost <= 17
 % /\
 forall(a in Actors) ( 
    firstSlot[a] >= 0 
    /\
    minimum(firstSlot[a], [slot[s] | s in Scenes where actorInScene[a,s] = 1])
 )
 /\
 forall(a in Actors) (
    lastSlot[a] >= 0 
    /\
    maximum(lastSlot[a], [slot[s] | s in Scenes where actorInScene[a,s] = 1])
 )
 /\
 forall(a in Actors) ( 
    actorWait[a] >= 0
    /\
    actorWait[a] = sum(s in Scenes where actorInScene[a, s] = 0)  (
         (sceneDuration[s] * bool2int(firstSlot[a] <= slot[s] /\ slot[s] <= lastSlot[a]))
    )
 )
 /\ % use the slot-based secondary model
 inverse(scene, slot)

;

output [
  "idleCost: ", show(idleCost), "\n",
  "slot: ", show(slot), "\n",
  "scene: ", show(scene), "\n"
];


numActors = 5;
actorPay = [1, 1, 1, 1, 1];
numScenes = 9;
sceneDuration = [2, 4, 1, 3, 3, 2, 5, 7, 6];
actorInScene = array2d(Actors, Scenes, 
        [1, 1, 0, 1, 0, 1, 1, 0, 1,
         1, 1, 0, 1, 1, 1, 0, 1, 0,
         1, 1, 0, 0, 0, 0, 1, 1, 0,
         1, 0, 0, 0, 1, 1, 0, 0, 1,
         0, 0, 1, 0, 1, 1, 1, 1, 0]);