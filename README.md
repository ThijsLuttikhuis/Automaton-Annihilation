# Automaton-Annihilation

## TODO: Refactor
 - 

## TODO: DEMO v2
 - Second Enemy Type (ranged / faster / ...)
 - Better Manage Enemy Waves + add info bar / panel / animation
 - Wall
 - Laser Tower
 - Conveyor Splitter
 - Conveyor Tunnel
 - Inserter

## TODO: long term
 - Make scene with root node script for Pickupitems, check neighbour squares, ... 
 - General code refactor and modularization of the code
 - Use more Composition rather than Inheritance
 - Actions: should / can they be compositions in tree structure (not sure)
 - Passives: should / can they be compositions in tree structure (probably)
 - Add Factory -> Create Build Unit + Fight Unit
 - More offensive units
 - Assembler / Miner / etc: input configuration --> only on belts / chests / convert buildings / ...
 - Add RMB on Ore Patch -> mine resource?
 - Vision system / Radar / ...
 - Buildings bigger than 1x1
 - Airplanes
 - Smart enemy units that avoid towers, break towers ...

## DONE:
 - DEMO!!! :)
 - Enemies spawn more the later the game
 - Enemy Attacks
 - Add Enemy Unit
 - Catch input UI panels and prioritize over normal script
 - E + Click -> queue remove building
 - Path Finding / Use TileMap to go around buildings
 - F-click = select box pickup items + pickup from chest if chest in region
 - Add panel with settings per unit: auto pickup items + fill inventory when pickup resources + ... + ...
 - Update Ore Patch texture
 - Add Assembly Building + add Copper Plate -> Copper Wire and Iron Plate -> Iron Gear
 - Add Copper Plate
 - Update Recipes
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
