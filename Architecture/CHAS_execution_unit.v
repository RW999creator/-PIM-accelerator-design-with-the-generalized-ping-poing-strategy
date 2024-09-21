module CHAS_execution_unit
#(  parameter INSTRUCTION_WIDTH = 64,
    parameter RWS = 1,
    parameter RDS = 2,
    parameter PIM = 3,
    parameter WRM = 4,
    parameter WMS = 5,
    parameter SO1 = 6,
    parameter SO2 = 7,
    parameter SIC = 8,
    parameter SCS = 9,
    parameter W   = 10,
    parameter RWM = 13,
    parameter S   = 0
)
(
    input        clk,
    input        RSTn,           // enable
    input        web,            // work/idle control

    input [7:0] rewriting_speed,

    // Core_control_unit
    input                         CCU_workload_completed_flag0,
    input                         CCU_workload_completed_flag1,
    input                         CCU_workload_completed_flag2,
    input                         CCU_workload_completed_flag3,
    input                         CCU_workload_completed_flag4,
    input                         CCU_workload_completed_flag5,
    input                         CCU_workload_completed_flag6,
    input                         CCU_workload_completed_flag7,
    input                         CCU_workload_completed_flag8,
    input                         CCU_workload_completed_flag9,
    input                         CCU_workload_completed_flag10,
    input                         CCU_workload_completed_flag11,
    input                         CCU_workload_completed_flag12,
    input                         CCU_workload_completed_flag13,
    input                         CCU_workload_completed_flag14,
    input                         CCU_workload_completed_flag15,
    input [INSTRUCTION_WIDTH-1:0] CCU_instruction0,
    input [INSTRUCTION_WIDTH-1:0] CCU_instruction1,
    input [INSTRUCTION_WIDTH-1:0] CCU_instruction2,
    input [INSTRUCTION_WIDTH-1:0] CCU_instruction3,
    input [INSTRUCTION_WIDTH-1:0] CCU_instruction4,
    input [INSTRUCTION_WIDTH-1:0] CCU_instruction5,
    input [INSTRUCTION_WIDTH-1:0] CCU_instruction6,
    input [INSTRUCTION_WIDTH-1:0] CCU_instruction7,
    input [INSTRUCTION_WIDTH-1:0] CCU_instruction8,
    input [INSTRUCTION_WIDTH-1:0] CCU_instruction9,
    input [INSTRUCTION_WIDTH-1:0] CCU_instruction10,
    input [INSTRUCTION_WIDTH-1:0] CCU_instruction11,
    input [INSTRUCTION_WIDTH-1:0] CCU_instruction12,
    input [INSTRUCTION_WIDTH-1:0] CCU_instruction13,
    input [INSTRUCTION_WIDTH-1:0] CCU_instruction14,
    input [INSTRUCTION_WIDTH-1:0] CCU_instruction15,
    input                         CCU_finish_flag0,
    input                         CCU_finish_flag1,
    input                         CCU_finish_flag2,
    input                         CCU_finish_flag3,
    input                         CCU_finish_flag4,
    input                         CCU_finish_flag5,
    input                         CCU_finish_flag6,
    input                         CCU_finish_flag7,
    input                         CCU_finish_flag8,
    input                         CCU_finish_flag9,
    input                         CCU_finish_flag10,
    input                         CCU_finish_flag11,
    input                         CCU_finish_flag12,
    input                         CCU_finish_flag13,
    input                         CCU_finish_flag14,
    input                         CCU_finish_flag15,
    output reg                    CCU_start_flag0,
    output reg                    CCU_start_flag1,
    output reg                    CCU_start_flag2,
    output reg                    CCU_start_flag3,
    output reg                    CCU_start_flag4,
    output reg                    CCU_start_flag5,
    output reg                    CCU_start_flag6,
    output reg                    CCU_start_flag7,
    output reg                    CCU_start_flag8,
    output reg                    CCU_start_flag9,
    output reg                    CCU_start_flag10,
    output reg                    CCU_start_flag11,
    output reg                    CCU_start_flag12,
    output reg                    CCU_start_flag13,
    output reg                    CCU_start_flag14,
    output reg                    CCU_start_flag15,

    output reg                    workload_completed_flag
);

reg [63:0] counter;
reg [63:0] counter_MVMU0;
reg [63:0] counter_MVMU1;
reg [63:0] counter_MVMU2;
reg [63:0] counter_MVMU3;

//--------------Code Starts Here------------------ 

initial begin
    workload_completed_flag = 0;
    counter                 = 0;
    counter_MVMU0           = 0;
    counter_MVMU1           = 0;
    counter_MVMU2           = 0;
    counter_MVMU3           = 0;

    // // No-Buffer
    // CCU_start_flag0  = 1;
    // CCU_start_flag1  = 1;
    // CCU_start_flag2  = 1;
    // CCU_start_flag3  = 1;
    // CCU_start_flag4  = 1;
    // CCU_start_flag5  = 1;
    // CCU_start_flag6  = 1;
    // CCU_start_flag7  = 1;
    // CCU_start_flag8  = 1;
    // CCU_start_flag9  = 1;
    // CCU_start_flag10 = 1;
    // CCU_start_flag11 = 1;
    // CCU_start_flag12 = 1;
    // CCU_start_flag13 = 1;
    // CCU_start_flag14 = 1;
    // CCU_start_flag15 = 1;

    // // CHAS/Ping-Pong
    // CCU_start_flag0  = 0;
    // CCU_start_flag1  = 0;
    // CCU_start_flag2  = 0;
    // CCU_start_flag3  = 0;
    // CCU_start_flag4  = 0;
    // CCU_start_flag5  = 0;
    // CCU_start_flag6  = 0;
    // CCU_start_flag7  = 0;
    // CCU_start_flag8  = 0;
    // CCU_start_flag9  = 0;
    // CCU_start_flag10 = 0;
    // CCU_start_flag11 = 0;
    // CCU_start_flag12 = 0;
    // CCU_start_flag13 = 0;
    // CCU_start_flag14 = 0;
    // CCU_start_flag15 = 0;
end

always @(posedge clk or negedge RSTn) begin
    if( CCU_workload_completed_flag0  &&
        CCU_workload_completed_flag1  &&
        CCU_workload_completed_flag2  &&
        CCU_workload_completed_flag3  &&
        CCU_workload_completed_flag4  &&
        CCU_workload_completed_flag5  &&
        CCU_workload_completed_flag6  &&
        CCU_workload_completed_flag7  &&
        CCU_workload_completed_flag8  &&
        CCU_workload_completed_flag9  &&
        CCU_workload_completed_flag10 &&
        CCU_workload_completed_flag11 &&
        CCU_workload_completed_flag12 &&
        CCU_workload_completed_flag13 &&
        CCU_workload_completed_flag14 &&
        CCU_workload_completed_flag15 ) 
        workload_completed_flag <= 1;
    else
        workload_completed_flag <= 0;
end

// CHAS
always @(posedge clk or negedge RSTn) begin
    if( web ) begin
        counter <= counter + 1;

        // // CHAS 128B/cycle 256macros
        // CCU_start_flag0 <= 1; CCU_start_flag1 <= 1;
        // if( counter >= 256*1 ) begin CCU_start_flag2 <= 1; CCU_start_flag3 <= 1; end
        // if( counter >= 256*2 ) begin CCU_start_flag4 <= 1; CCU_start_flag5 <= 1; end
        // if( counter >= 256*3 ) begin CCU_start_flag6 <= 1; CCU_start_flag7 <= 1; end
        // if( counter >= 256*4 ) begin CCU_start_flag8 <= 1; CCU_start_flag9 <= 1; end
        // if( counter >= 256*5 ) begin CCU_start_flag10<= 1; CCU_start_flag11<= 1; end
        // if( counter >= 256*6 ) begin CCU_start_flag12<= 1; CCU_start_flag13<= 1; end
        // if( counter >= 256*7 ) begin CCU_start_flag14<= 1; CCU_start_flag15<= 1; end

        // // CHAS 128B/cycle 128macros
        // CCU_start_flag0 <= 1; CCU_start_flag1 <= 1;
        // CCU_start_flag2 <= 1; CCU_start_flag3 <= 1;
        // if( counter >= 256*1 ) begin CCU_start_flag4 <= 1; CCU_start_flag5 <= 1;
        //                              CCU_start_flag6 <= 1; CCU_start_flag7 <= 1; end
        // if( counter >= 256*2 ) begin CCU_start_flag8 <= 1; CCU_start_flag9 <= 1;
        //                              CCU_start_flag10<= 1; CCU_start_flag11<= 1; end
        // if( counter >= 256*3 ) begin CCU_start_flag12<= 1; CCU_start_flag13<= 1;
        //                              CCU_start_flag14<= 1; CCU_start_flag15<= 1; end

        // // CHAS 128B/cycle 64macros
        // CCU_start_flag0 <= 1; CCU_start_flag1 <= 1;
        // CCU_start_flag2 <= 1; CCU_start_flag3 <= 1;
        // CCU_start_flag4 <= 1; CCU_start_flag5 <= 1;
        // CCU_start_flag6 <= 1; CCU_start_flag7 <= 1;
        // if( counter >= 256 ) begin CCU_start_flag8 <= 1; CCU_start_flag9 <= 1;
        //                            CCU_start_flag10<= 1; CCU_start_flag11<= 1;
        //                            CCU_start_flag12<= 1; CCU_start_flag13<= 1;
        //                            CCU_start_flag14<= 1; CCU_start_flag15<= 1; end

        // // CHAS 128B/cycle 48macros
        // CCU_start_flag0 <= 1; CCU_start_flag1 <= 1;
        // CCU_start_flag2 <= 1; CCU_start_flag3 <= 1;
        // if( counter >= 256/2*1 ) begin CCU_start_flag4 <= 1; CCU_start_flag5 <= 1;
        //                                CCU_start_flag6 <= 1; CCU_start_flag7 <= 1; end
        // if( counter >= 256/2*2 ) begin CCU_start_flag8 <= 1; CCU_start_flag9 <= 1;
        //                                CCU_start_flag10<= 1; CCU_start_flag11<= 1; end
        // CCU_start_flag12<= 1; CCU_start_flag13<= 1;
        // CCU_start_flag14<= 1; CCU_start_flag15<= 1;

        // // CHAS 128B/cycle 40macros
        // CCU_start_flag0 <= 1; CCU_start_flag1 <= 1;
        // if( counter >= 256/4*1 ) begin CCU_start_flag2 <= 1; CCU_start_flag3 <= 1; end
        // if( counter >= 256/4*2 ) begin CCU_start_flag4 <= 1; CCU_start_flag5 <= 1; end
        // if( counter >= 256/4*3 ) begin CCU_start_flag6 <= 1; CCU_start_flag7 <= 1; end
        // if( counter >= 256/4*4 ) begin CCU_start_flag8 <= 1; CCU_start_flag9 <= 1; end
        // CCU_start_flag10<= 1; CCU_start_flag11<= 1;
        // CCU_start_flag12<= 1; CCU_start_flag13<= 1;
        // CCU_start_flag14<= 1; CCU_start_flag15<= 1;

        // // CHAS 128B/cycle 36macros
        // CCU_start_flag0 <= 1;
        // if( counter >= 256/8*1 ) begin CCU_start_flag1 <= 1; end
        // if( counter >= 256/8*2 ) begin CCU_start_flag2 <= 1; end
        // if( counter >= 256/8*3 ) begin CCU_start_flag3 <= 1; end
        // if( counter >= 256/8*4 ) begin CCU_start_flag4 <= 1; end
        // if( counter >= 256/8*5 ) begin CCU_start_flag5 <= 1; end
        // if( counter >= 256/8*6 ) begin CCU_start_flag6 <= 1; end
        // if( counter >= 256/8*7 ) begin CCU_start_flag7 <= 1; end
        // if( counter >= 256/8*8 ) begin CCU_start_flag8 <= 1; end
        // CCU_start_flag9 <= 1; CCU_start_flag10<= 1;
        // CCU_start_flag11<= 1; CCU_start_flag12<= 1;
        // CCU_start_flag13<= 1; CCU_start_flag14<= 1;
        // CCU_start_flag15<= 1;

        // // CHAS 512B/cycle 128macros
        // CCU_start_flag0 <= 1;
        // CCU_start_flag1 <= 1;
        // CCU_start_flag2 <= 1;
        // CCU_start_flag3 <= 1;
        // CCU_start_flag4 <= 1;
        // CCU_start_flag5 <= 1;
        // CCU_start_flag6 <= 1;
        // CCU_start_flag7 <= 1;
        // if( counter >= 128*1 ) begin
        //     CCU_start_flag8 <= 1;
        //     CCU_start_flag9 <= 1;
        //     CCU_start_flag10 <= 1;
        //     CCU_start_flag11 <= 1;
        //     CCU_start_flag12 <= 1;
        //     CCU_start_flag13 <= 1;
        //     CCU_start_flag14 <= 1;
        //     CCU_start_flag15 <= 1;
        // end

        // // CHAS 512B/cycle 96macros
        // CCU_start_flag0 <= 1; CCU_start_flag1 <= 1;
        // CCU_start_flag2 <= 1; CCU_start_flag3 <= 1;
        // if( counter >= 64*1 ) begin CCU_start_flag4 <= 1;CCU_start_flag5 <= 1;
        //                             CCU_start_flag6 <= 1;CCU_start_flag7 <= 1; end
        // if( counter >= 64*2 ) begin CCU_start_flag8 <= 1;CCU_start_flag9 <= 1;
        //                             CCU_start_flag10<= 1;CCU_start_flag11<= 1; end
        // CCU_start_flag12<= 1; CCU_start_flag13<= 1;
        // CCU_start_flag14<= 1; CCU_start_flag15<= 1;

        // // CHAS 256B/cycle 80macros
        // CCU_start_flag0 <= 1; CCU_start_flag1 <= 1;
        // if( counter >= 64*1 ) begin CCU_start_flag2 <= 1;CCU_start_flag3 <= 1; end
        // if( counter >= 64*2 ) begin CCU_start_flag4 <= 1;CCU_start_flag5 <= 1; end
        // if( counter >= 64*3 ) begin CCU_start_flag6 <= 1;CCU_start_flag7 <= 1; end
        // if( counter >= 64*4 ) begin CCU_start_flag8 <= 1;CCU_start_flag9 <= 1; end
        // CCU_start_flag10<= 1; CCU_start_flag11<= 1;
        // CCU_start_flag12<= 1; CCU_start_flag13<= 1;
        // CCU_start_flag14<= 1; CCU_start_flag15<= 1;

        // // CHAS 128B/cycle 49macros
        // CCU_start_flag0 <= 1;
        // if( counter >= 64*1 ) CCU_start_flag1 <= 1;
        // if( counter >= 64*2 ) CCU_start_flag2 <= 1;
        // if( counter >= 64*3 ) CCU_start_flag3 <= 1;
        // if( counter >= 64*4 ) CCU_start_flag4 <= 1;
        // if( counter >= 64*5 ) CCU_start_flag5 <= 1;
        // if( counter >= 64*6 ) CCU_start_flag6 <= 1;
        // CCU_start_flag7 <= 1; CCU_start_flag8 <= 1;
        // CCU_start_flag9 <= 1; CCU_start_flag10<= 1;
        // CCU_start_flag11<= 1; CCU_start_flag12<= 1;
        // CCU_start_flag13<= 1; CCU_start_flag14<= 1;
        // CCU_start_flag15<= 1;

        // // CHAS 64B/cycle 36macros
        // CCU_start_flag0 <= 1;
        // if( counter >= 64*1 ) CCU_start_flag1 <= 1;
        // if( counter >= 64*2 ) CCU_start_flag2 <= 1;
        // if( counter >= 64*3 ) CCU_start_flag3 <= 1;
        // if( counter >= 64*4 ) CCU_start_flag4 <= 1;
        // if( counter >= 64*5 ) CCU_start_flag5 <= 1;
        // if( counter >= 64*6 ) CCU_start_flag6 <= 1;
        // if( counter >= 64*7 ) CCU_start_flag7 <= 1;
        // if( counter >= 64*8 ) CCU_start_flag8 <= 1;
        // CCU_start_flag9 <= 1; CCU_start_flag10<= 1;
        // CCU_start_flag11<= 1; CCU_start_flag12<= 1;
        // CCU_start_flag13<= 1; CCU_start_flag14<= 1;
        // CCU_start_flag15<= 1;

        // // CHAS 32B/cycle 24macros
        // CCU_start_flag0 <= 1;CCU_start_flag1 <= 1;
        // if( counter >= 128*1 ) begin CCU_start_flag2 <= 1;CCU_start_flag3 <= 1; end
        // if( counter >= 128*2 ) begin CCU_start_flag4 <= 1;CCU_start_flag5 <= 1; end
        // if( counter >= 128*3 ) begin CCU_start_flag6 <= 1;CCU_start_flag7 <= 1; end
        // if( counter >= 128*4 ) begin CCU_start_flag8 <= 1;CCU_start_flag9 <= 1; end
        // if( counter >= 128*5 ) begin CCU_start_flag10<= 1;CCU_start_flag11<= 1; end
        // CCU_start_flag12 <= 1;CCU_start_flag13 <= 1;
        // CCU_start_flag14 <= 1;CCU_start_flag15 <= 1;

        // // CHAS 16B/cycle 16macros
        // CCU_start_flag0 <= 1;CCU_start_flag1 <= 1;
        // if( counter >= 128*1 ) begin CCU_start_flag2 <= 1;CCU_start_flag3 <= 1; end
        // if( counter >= 128*2 ) begin CCU_start_flag4 <= 1;CCU_start_flag5 <= 1; end
        // if( counter >= 128*3 ) begin CCU_start_flag6 <= 1;CCU_start_flag7 <= 1; end
        // if( counter >= 128*4 ) begin CCU_start_flag8 <= 1;CCU_start_flag9 <= 1; end
        // if( counter >= 128*5 ) begin CCU_start_flag10<= 1;CCU_start_flag11<= 1; end
        // if( counter >= 128*6 ) begin CCU_start_flag12<= 1;CCU_start_flag13<= 1; end
        // if( counter >= 128*7 ) begin CCU_start_flag14<= 1;CCU_start_flag15<= 1; end

        // // CHAS 8B/cycle 11macros
        // CCU_start_flag0 <= 1;
        // if( counter >= 128*1 ) CCU_start_flag1 <= 1;
        // if( counter >= 128*2 ) CCU_start_flag2 <= 1;
        // if( counter >= 128*3 ) CCU_start_flag3 <= 1;
        // if( counter >= 128*4 ) CCU_start_flag4 <= 1;
        // if( counter >= 128*5 ) CCU_start_flag5 <= 1;
        // if( counter >= 128*6 ) CCU_start_flag6 <= 1;
        // if( counter >= 128*7 ) CCU_start_flag7 <= 1;
        // if( counter >= 128*8 ) CCU_start_flag8 <= 1;
        // if( counter >= 128*9 ) CCU_start_flag9 <= 1;
        // if( counter >= 128*10) CCU_start_flag10<= 1;
        // CCU_start_flag11 <= 1;
        // CCU_start_flag12 <= 1;
        // CCU_start_flag13 <= 1;
        // CCU_start_flag14 <= 1;
        // CCU_start_flag15 <= 1;
    end
    else begin
        counter <= 0;
        // CHAS
        CCU_start_flag0  <= 0;
        CCU_start_flag1  <= 0;
        CCU_start_flag2  <= 0;
        CCU_start_flag3  <= 0;
        CCU_start_flag4  <= 0;
        CCU_start_flag5  <= 0;
        CCU_start_flag6  <= 0;
        CCU_start_flag7  <= 0;
        CCU_start_flag8  <= 0;
        CCU_start_flag9  <= 0;
        CCU_start_flag10 <= 0;
        CCU_start_flag11 <= 0;
        CCU_start_flag12 <= 0;
        CCU_start_flag13 <= 0;
        CCU_start_flag14 <= 0;
        CCU_start_flag15 <= 0;
    end
end

// // Ping-Pong
// always @(posedge clk or negedge RSTn) begin
//     if( web ) begin
//         counter <= counter + 1;
//         if( !CCU_finish_flag0 ) CCU_start_flag0 <= 0;
//         if( !CCU_finish_flag1 ) CCU_start_flag1 <= 0;
//         if( !CCU_finish_flag2 ) CCU_start_flag2 <= 0;
//         if( !CCU_finish_flag3 ) CCU_start_flag3 <= 0;
//         if( !CCU_finish_flag4 ) CCU_start_flag4 <= 0;
//         if( !CCU_finish_flag5 ) CCU_start_flag5 <= 0;
//         if( !CCU_finish_flag6 ) CCU_start_flag6 <= 0;
//         if( !CCU_finish_flag7 ) CCU_start_flag7 <= 0;
//         if( !CCU_finish_flag8 ) CCU_start_flag8 <= 0;
//         if( !CCU_finish_flag9 ) CCU_start_flag9 <= 0;
//         if( !CCU_finish_flag10) CCU_start_flag10<= 0;
//         if( !CCU_finish_flag11) CCU_start_flag11<= 0;
//         if( !CCU_finish_flag12) CCU_start_flag12<= 0;
//         if( !CCU_finish_flag13) CCU_start_flag13<= 0;
//         if( !CCU_finish_flag14) CCU_start_flag14<= 0;
//         if( !CCU_finish_flag15) CCU_start_flag15<= 0;
//         // Ping-Pong
//         if( CCU_finish_flag0 ) begin
//             if( CCU_instruction0[60+:4 ] == WMS || CCU_instruction0[60+:4 ] == S ) begin
//                 if( CCU_instruction1[60+:4 ] == RDS || CCU_instruction1[60+:4 ] == RWM )
//                     CCU_start_flag0 <= 0;
//                 else
//                     CCU_start_flag0 <= 1;
//             end
//             else
//                 CCU_start_flag0 <= 1;
//         end
//         if( CCU_finish_flag1 ) begin
//             if( counter >= 2 ) begin
//                 if( CCU_instruction1[60+:4 ] == WMS || CCU_instruction1[60+:4 ] == S ) begin
//                     if( CCU_instruction0[60+:4 ] == RDS || CCU_instruction0[60+:4 ] == RWM )
//                         CCU_start_flag1 <= 0;
//                     else
//                         CCU_start_flag1 <= 1;
//                 end
//                 else
//                     CCU_start_flag1 <= 1;
//             end
//         end
//         if( CCU_finish_flag2 ) begin
//             if( CCU_instruction2[60+:4 ] == WMS || CCU_instruction2[60+:4 ] == S ) begin
//                 if( CCU_instruction3[60+:4 ] == RDS || CCU_instruction3[60+:4 ] == RWM )
//                     CCU_start_flag2 <= 0;
//                 else
//                     CCU_start_flag2 <= 1;
//             end
//             else
//                 CCU_start_flag2 <= 1;
//         end
//         if( CCU_finish_flag3 ) begin
//             if( counter >= 2 ) begin
//                 if( CCU_instruction3[60+:4 ] == WMS || CCU_instruction3[60+:4 ] == S ) begin
//                     if( CCU_instruction2[60+:4 ] == RDS || CCU_instruction2[60+:4 ] == RWM )
//                         CCU_start_flag3 <= 0;
//                     else
//                         CCU_start_flag3 <= 1;
//                 end
//                 else
//                     CCU_start_flag3 <= 1;
//             end
//         end
//         if( CCU_finish_flag4 ) begin
//             if( CCU_instruction4[60+:4 ] == WMS || CCU_instruction4[60+:4 ] == S ) begin
//                 if( CCU_instruction5[60+:4 ] == RDS || CCU_instruction5[60+:4 ] == RWM )
//                     CCU_start_flag4 <= 0;
//                 else
//                     CCU_start_flag4 <= 1;
//             end
//             else
//                 CCU_start_flag4 <= 1;
//         end
//         if( CCU_finish_flag5 ) begin
//             if( counter >= 2 ) begin
//                 if( CCU_instruction5[60+:4 ] == WMS || CCU_instruction5[60+:4 ] == S ) begin
//                     if( CCU_instruction4[60+:4 ] == RDS || CCU_instruction4[60+:4 ] == RWM )
//                         CCU_start_flag5 <= 0;
//                     else
//                         CCU_start_flag5 <= 1;
//                 end
//                 else
//                     CCU_start_flag5 <= 1;
//             end
//         end
//         if( CCU_finish_flag6 ) begin
//             if( CCU_instruction6[60+:4 ] == WMS || CCU_instruction6[60+:4 ] == S ) begin
//                 if( CCU_instruction7[60+:4 ] == RDS || CCU_instruction7[60+:4 ] == RWM )
//                     CCU_start_flag6 <= 0;
//                 else
//                     CCU_start_flag6 <= 1;
//             end
//             else
//                 CCU_start_flag6 <= 1;
//         end
//         if( CCU_finish_flag7 ) begin
//             if( counter >= 2 ) begin
//                 if( CCU_instruction7[60+:4 ] == WMS || CCU_instruction7[60+:4 ] == S ) begin
//                     if( CCU_instruction6[60+:4 ] == RDS || CCU_instruction6[60+:4 ] == RWM )
//                         CCU_start_flag7 <= 0;
//                     else
//                         CCU_start_flag7 <= 1;
//                 end
//                 else
//                     CCU_start_flag7 <= 1;
//             end
//         end
//         if( CCU_finish_flag8 ) begin
//             if( CCU_instruction8[60+:4 ] == WMS || CCU_instruction8[60+:4 ] == S ) begin
//                 if( CCU_instruction9[60+:4 ] == RDS || CCU_instruction9[60+:4 ] == RWM )
//                     CCU_start_flag8 <= 0;
//                 else
//                     CCU_start_flag8 <= 1;
//             end
//             else
//                 CCU_start_flag8 <= 1;
//         end
//         if( CCU_finish_flag9 ) begin
//             if( counter >= 2 ) begin
//                 if( CCU_instruction9[60+:4 ] == WMS || CCU_instruction9[60+:4 ] == S ) begin
//                     if( CCU_instruction8[60+:4 ] == RDS || CCU_instruction8[60+:4 ] == RWM )
//                         CCU_start_flag9 <= 0;
//                     else
//                         CCU_start_flag9 <= 1;
//                 end
//                 else
//                     CCU_start_flag9 <= 1;
//             end
//         end
//         if( CCU_finish_flag10 ) begin
//             if( CCU_instruction10[60+:4 ] == WMS || CCU_instruction10[60+:4 ] == S ) begin
//                 if( CCU_instruction11[60+:4 ] == RDS || CCU_instruction11[60+:4 ] == RWM )
//                     CCU_start_flag10 <= 0;
//                 else
//                     CCU_start_flag10 <= 1;
//             end
//             else
//                 CCU_start_flag10 <= 1;
//         end
//         if( CCU_finish_flag11 ) begin
//             if( counter >= 2 ) begin
//                 if( CCU_instruction11[60+:4 ] == WMS || CCU_instruction11[60+:4 ] == S ) begin
//                     if( CCU_instruction10[60+:4 ] == RDS || CCU_instruction10[60+:4 ] == RWM )
//                         CCU_start_flag11 <= 0;
//                     else
//                         CCU_start_flag11 <= 1;
//                 end
//                 else
//                     CCU_start_flag11 <= 1;
//             end
//         end
//         if( CCU_finish_flag12 ) begin
//             if( CCU_instruction12[60+:4 ] == WMS || CCU_instruction12[60+:4 ] == S ) begin
//                 if( CCU_instruction13[60+:4 ] == RDS || CCU_instruction13[60+:4 ] == RWM )
//                     CCU_start_flag12 <= 0;
//                 else
//                     CCU_start_flag12 <= 1;
//             end
//             else
//                 CCU_start_flag12 <= 1;
//         end
//         if( CCU_finish_flag13 ) begin
//             if( counter >= 2 ) begin
//                 if( CCU_instruction13[60+:4 ] == WMS || CCU_instruction13[60+:4 ] == S ) begin
//                     if( CCU_instruction12[60+:4 ] == RDS || CCU_instruction12[60+:4 ] == RWM )
//                         CCU_start_flag13 <= 0;
//                     else
//                         CCU_start_flag13 <= 1;
//                 end
//                 else
//                     CCU_start_flag13 <= 1;
//             end
//         end
//         if( CCU_finish_flag14 ) begin
//             if( CCU_instruction14[60+:4 ] == WMS || CCU_instruction14[60+:4 ] == S ) begin
//                 if( CCU_instruction15[60+:4 ] == RDS || CCU_instruction15[60+:4 ] == RWM )
//                     CCU_start_flag14 <= 0;
//                 else
//                     CCU_start_flag14 <= 1;
//             end
//             else
//                 CCU_start_flag14 <= 1;
//         end
//         if( CCU_finish_flag15 ) begin
//             if( counter >= 2 ) begin
//                 if( CCU_instruction15[60+:4 ] == WMS || CCU_instruction15[60+:4 ] == S ) begin
//                     if( CCU_instruction14[60+:4 ] == RDS || CCU_instruction14[60+:4 ] == RWM )
//                         CCU_start_flag15 <= 0;
//                     else
//                         CCU_start_flag15 <= 1;
//                 end
//                 else
//                     CCU_start_flag15 <= 1;
//             end
//         end
//     end
//     else begin
//         counter <= 0;
//         // Ping-Pong
//         CCU_start_flag0  <= 0;
//         CCU_start_flag1  <= 0;
//         CCU_start_flag2  <= 0;
//         CCU_start_flag3  <= 0;
//         CCU_start_flag4  <= 0;
//         CCU_start_flag5  <= 0;
//         CCU_start_flag6  <= 0;
//         CCU_start_flag7  <= 0;
//         CCU_start_flag8  <= 0;
//         CCU_start_flag9  <= 0;
//         CCU_start_flag10 <= 0;
//         CCU_start_flag11 <= 0;
//         CCU_start_flag12 <= 0;
//         CCU_start_flag13 <= 0;
//         CCU_start_flag14 <= 0;
//         CCU_start_flag15 <= 0;
//     end
// end

endmodule