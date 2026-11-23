.TITLE G1_LS2INV_Q_LCNAND2_YB_B2W22_0

********************************************************************************
** Include libraries, parameters and other
********************************************************************************

.INCLUDE "../include.l"

********************************************************************************
** Setup and input
********************************************************************************

.TRAN 1p 100n
.OPTION POST

* Input signal
VIN n_in gnd! PULSE (0 supply_v 0 10n 10n 20n 60n)

********************************************************************************
** Measurement
********************************************************************************

* Delay

.MEASURE TRAN tfall TRIG V(n_in) VAL='supply_v/2' FALL=1
+  TARG V(n_out) VAL='supply_v/2' FALL=1

.MEASURE TRAN trise TRIG V(n_in) VAL='supply_v/2' RISE=1
+  TARG V(n_out) VAL='supply_v/2' RISE=1

.MEASURE tavg param = '(trise + tfall)/2'

.MEASURE tdiff param = 'abs(trise - tfall)'

.MEASURE tmax param = 'max(trise, tfall)'

* Power

.MEASURE TRAN iavg avg i(vdd!) from=0 to=60n

.MEASURE energy param='1.8*iavg*60n'

.MEASURE edp param='abs(tavg*energy)'

********************************************************************************
** Circuit
********************************************************************************

MM7 Q n_in gnd! gnd! N18 W=1.2u L=180.00n M=1
MM8 Q n_in vdd! vdd! P18 W=2.4u L=180.00n M=1
MM9 gnd! Q vdd! vdd! P18 W=2.4u L=180.00n M=1
MM10 gnd! Q gnd! gnd! N18 W=1.2u L=180.00n M=1

XLC_LATCH vdd! gnd! Q gnd! gnd! LC_LATCH

XLC_NAND2_1 Q gnd! gnd! LC_NAND2
XLC_NAND2_2 Q gnd! gnd! LC_NAND2
XLC_NAND2_3 Q vdd! net398 LC_NAND2
XLC_INV_4X net398 net409 LC_INV_4X
XLC_MX4X1_1 net409 vdd! gnd! gnd! net357 gnd! gnd! LC_MX4X1_1
XLC_INV_U1 net357 net427 LC_INV_U1
XLC_MUX2_1_1 net427 gnd! gnd! net443 LC_MUX2_1
XLC_NAND2_U1 net443 vdd! Cout LC_NAND2_U1
XLC_MUX2_1_2 gnd! Cout vdd! net459 LC_MUX2_1
XLC_INV_U4 net459 n_out LC_INV_U4
XLC__NAND2_U1 n_out gnd! gnd! LC_NAND2_U1

.END