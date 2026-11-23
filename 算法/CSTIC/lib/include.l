*** INCLUDE ALL DATA

* Voltage levels
.PARAM supply_v = 1.8

* Supply voltage
vdd! vdd! gnd! supply_v
vdd_aux! vdd_aux! gnd! supply_v

* Device models
.INCLUDE "ms018_v1p4.mdl"
.LIB "ms018_v1p4.lib" tt

* Include subcircuits
.INCLUDE "fdp3p7_chip.cdl"
