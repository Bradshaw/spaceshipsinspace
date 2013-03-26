How things are done around here
===============================


A spaceship is made up from a collection of segments connected by corridors.
Modules are then mounted into the segments. Some modules need to be placed at a hardpoint, in which case they have an external representation.


Segments have a given shape, mass, center of mass and set of hardpoints.

Corridors are straight, and connect two segments together, allowing dudes to navigate inside the ship.

Hardpoints have a given size and can support a given weight.
Maybe simplify this:
+ Small, medium, heavy and super hardpoints.
+ Hardpoints can also mount a turret which can host a module one size under.
+ E.g: Fit a small turret to a medium hardpoint, and fit a small gatling to the turret.

Modules are placed inside segments, if they are hardpoint modules they can only be placed at a compatible hardpoint location.

+ Modules have sets of inputs and outputs.
+ Modules are seen as machines that convert units from inputs into units to outputs.
+ Generators convert *nothing* into energy.
+ Endpoints (e.g: weapons) convert energy into *nothing*, but cause a side-effect doing so (e.g: sending chunks of hate and discontent at other ships)

Units can be of two types: 
+ Flow:
	+ E.g: Water, power and data
	+ Represented as a flowrate (L/s, Gj/s, GB/s)
	+ Outputs connect to inputs with pipes (or cables or whatever)
+ Packets:
	+ E.g: Ammunition, batteries and meals.
	+ Represented as items (120mm steel penetrators, 10GAh Boosters, "Jerry's" canned kwik-meals)
	+ Inputs either need to be hand filled for each cycle, or have a dispenser attached.
	+ Outputs either need to be hand unloaded after each cycle, or have a storage attached.



Segments
========

## Grid or polygon?

Grid:

### Awesome:
+ Easy to draw
+ Easy to fisix
+ Super easy to modify (breakage from bombs?)

Polygon:
### Supercool:
+ Non-aligned modules
+ More realz!
+ Turrets can turn easier?

Grid segments and inner modules and polygon turrets maybe?