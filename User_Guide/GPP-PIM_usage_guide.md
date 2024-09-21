This document provides detailed approach on the usage of GPP-PIM.

In this section, we take the situation during the Runtime Phase Pipeline Adaption phase as an example, where the off-chip bandwidth is set to 16B.

Step 1: Select the corresponding instruction code file. For the generalized ping-pong, the file used is ['16macros_16B_28pictures.md'](ISA/512x512B_VMM_phase2/16macros_16B_28pictures.md). For the naive ping-pong, the file used is ['32macros_4pictures.md'](ISA/512x512B_VMM_phase2/32macros_4pictures.md). For the in situ write-compute, the file used is ['16macros_4pictures.md'](ISA/512x512B_VMM_phase2/16macros_4pictures.md).

Step 2: Execute the ['GPP-PIM_assembler.py'](Assembler/GPP-PIM_assembler.py), paste the selected instruction code into the input field to generate the binary code.

Step 3: Configure the capacity of the result memory allocated to each macro within the Tile_tb.v file.
```Verilog 
rmc_of_each_macro = 28*512; 
```
Step 4: Set the weight transfer speed within the Weight_SRAM.v file. At this point, the generalized ping-pong is configured to 8, the naive ping-pong is set to 1, and the in situ write-compute is set to 1.
```Verilog 
rewriting_speed  = 8;
```
Step 5: Configure the execution mode within the CHAS_execution_unit.v file by simply uncommenting the corresponding code segment. For instance, to enable the generalized ping-pong mode, the code to be uncommented is as follows: 
```Verilog 
    CCU_start_flag0  = 0;
    CCU_start_flag1  = 0;
    CCU_start_flag2  = 0;
    CCU_start_flag3  = 0;
    CCU_start_flag4  = 0;
    CCU_start_flag5  = 0;
    CCU_start_flag6  = 0;
    CCU_start_flag7  = 0;
    CCU_start_flag8  = 0;
    CCU_start_flag9  = 0;
    CCU_start_flag10 = 0;
    CCU_start_flag11 = 0;
    CCU_start_flag12 = 0;
    CCU_start_flag13 = 0;
    CCU_start_flag14 = 0;
    CCU_start_flag15 = 0;

    CCU_start_flag0 <= 1;CCU_start_flag1 <= 1;
    if( counter >= 128*1 ) begin CCU_start_flag2 <= 1;CCU_start_flag3 <= 1; end
    if( counter >= 128*2 ) begin CCU_start_flag4 <= 1;CCU_start_flag5 <= 1; end
    if( counter >= 128*3 ) begin CCU_start_flag6 <= 1;CCU_start_flag7 <= 1; end
    if( counter >= 128*4 ) begin CCU_start_flag8 <= 1;CCU_start_flag9 <= 1; end
    if( counter >= 128*5 ) begin CCU_start_flag10<= 1;CCU_start_flag11<= 1; end
    if( counter >= 128*6 ) begin CCU_start_flag12<= 1;CCU_start_flag13<= 1; end
    if( counter >= 128*7 ) begin CCU_start_flag14<= 1;CCU_start_flag15<= 1; end
```
Step 6: After completing the aforementioned configurations, place all the Verilog files into Modelsim for simulation. The execution time, bandwidth utilization, macro utilization, and on-chip memory usage will be automatically printed out.