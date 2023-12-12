# Automaton-Annihilation


## TODO:

#### short term / fix bugs:
 - Add Copper Plate
 - Update Recipes
 - Add Assembly Building + add Copper Plate -> Copper Wire and Iron Plate -> Iron Gear
 - Add Enemy Unit
 - Add Factory -> Create Build Unit + Fight Unit
 - Add panel with settings per unit: auto pickup items + fill inventory when pickup resources + ... + ...
 - F-click = select box pickup items + pickup from chest if chest in region
 - Catch input UI panels and prioritize over normal script


#### long term:
 - Path Finding / Use TileMap to go around buildings
 - More offensive units
 - Vision system / Radar / ...
 - Buildings bigger than 1x1
 - Airplanes


## DONE:
 - Take items from multiple chests when needed
 - Put build action in ActionQueue
 - Shift / Space + build action
 - Metal Extractor Building
 - Limit building on top of buildings / Extractors not on top of the designated areas
 - Show resource cost in UI left bottom
 - Build Cost Buildings / Units
 - Check if building on a resource tile + check other build constraints
 - Conveyor Belt building
 - Chest building
 - Store Buildings in tilemap (building name only for now, not a reference to building itself)
 - Show sprites in the correct order (y-position)
 - when a building is queued, and no resource available, auto check all chests for resource and pickup from nearest chest with enough
 - chest next to miner -> put item in chest == put item on conveyor belt > put item on ground
 - Show Items in the correct order (y-position or always behind buildings)
 - Furnace to smelt iron / copper
