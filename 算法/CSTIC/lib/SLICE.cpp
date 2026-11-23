/**
 * @file SLICE.cpp
 * @brief 生成SLICE内部的spice网表
 * @details
 * @author zli
 * @email lizhen19@fudan.edu.cn
 * @version 1.0
 * @date 2020-12-06
*/

#include "SLICE.h"
#include <fstream>

using std::string;
using std::ofstream;
using std::ios;


/**
 * @brief G1_LS2INV_Q_LCNAND2_YB_B2W22_0
 * @details G1从LS2INV中间到Q到LC_NAND2到YB前面，0表示cin的MUX关闭
 * @param
 * @param
 * @return 程序执行成功与否
*     @retval 0 程序执行成功
*     @retval
 * @note
*/
void G1_LS2INV_Q_LCNAND2_YB_B2W22_0(const string& s)
{
    ofstream write;

    const string sp = "./" + s + "/" + s + ".sp";

    write.open(sp, ios::app);
    write << ".TITLE " << s << "\n\n";

    write << "********************************************************************************\n";
    write << "** Include libraries, parameters and other\n";
    write << "********************************************************************************\n\n";

    write << ".INCLUDE \"../include.l\"\n\n";
    
    write << "********************************************************************************\n";
    write << "** Setup and input\n";
    write << "********************************************************************************\n\n";

    write << ".TRAN 1p 100n\n";
    write << ".OPTION POST\n\n";

    write << "* Input signal\n";
    write << "VIN n_in gnd! PULSE (0 supply_v 0 10n 10n 20n 60n)\n\n";

    write << "********************************************************************************\n";
    write << "** Measurement\n";
    write << "********************************************************************************\n\n";

    write << "* Delay\n\n";

    write << ".MEASURE TRAN tfall TRIG V(n_in) VAL='supply_v/2' FALL=1\n";
    write << "+  TARG V(n_out) VAL='supply_v/2' FALL=1\n\n";

    write << ".MEASURE TRAN trise TRIG V(n_in) VAL='supply_v/2' RISE=1\n";
    write << "+  TARG V(n_out) VAL='supply_v/2' RISE=1\n\n";

    write << ".MEASURE tavg param = '(trise + tfall)/2'\n\n";

    write << ".MEASURE tdiff param = 'abs(trise - tfall)'\n\n";

    write << ".MEASURE tmax param = 'max(trise, tfall)'\n\n";

    write << "* Power\n\n";

    write << ".MEASURE TRAN iavg avg i(vdd!) from=0 to=60n\n\n";

    write << ".MEASURE energy param='1.8*iavg*60n'\n\n";

    write << ".MEASURE edp param='abs(tavg*energy)'\n\n";

    write << "********************************************************************************\n";
    write << "** Circuit\n";
    write << "********************************************************************************\n\n";

    write << "MM7 Q n_in gnd! gnd! N18 W=1.2u L=180.00n M=1\n";
    write << "MM8 Q n_in vdd! vdd! P18 W=2.4u L=180.00n M=1\n";
    write << "MM9 gnd! Q vdd! vdd! P18 W=2.4u L=180.00n M=1\n";
    write << "MM10 gnd! Q gnd! gnd! N18 W=1.2u L=180.00n M=1\n\n";

    write << "XLC_LATCH vdd! gnd! Q gnd! gnd! LC_LATCH\n\n";

    write << "XLC_NAND2_1 Q gnd! gnd! LC_NAND2\n";  ///< LC_LUT4内部
    write << "XLC_NAND2_2 Q gnd! gnd! LC_NAND2\n";  ///< LC_LUT4内部
    write << "XLC_NAND2_3 Q vdd! net398 LC_NAND2\n";
    write << "XLC_INV_4X net398 net409 LC_INV_4X\n";
    write << "XLC_MX4X1_1 net409 vdd! gnd! gnd! net357 gnd! gnd! LC_MX4X1_1\n";
    write << "XLC_INV_U1 net357 net427 LC_INV_U1\n";
    write << "XLC_MUX2_1_1 net427 gnd! gnd! net443 LC_MUX2_1\n";
    write << "XLC_NAND2_U1 net443 vdd! Cout LC_NAND2_U1\n";
    write << "XLC_MUX2_1_2 gnd! Cout vdd! net459 LC_MUX2_1\n";
    write << "XLC_INV_U4 net459 n_out LC_INV_U4\n";
    write << "XLC__NAND2_U1 n_out gnd! gnd! LC_NAND2_U1\n\n";

    write << ".END";


    write.close();

}


