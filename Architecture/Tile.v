module Tile
#(  parameter INS_INTERCORE_DEPTH = 4096,
    parameter RW_DEPTH     = 8192,        // read weight bandwidth: 32*32*8
    parameter RI_DEPTH     = 16384,       // read input bandwidth: 32*8*64
    parameter WR_DEPTH     = 16384,        // write result bandwidth
    parameter INSTRUCTION_WIDTH   = 64
)
(
    input           clk,
    input           RSTn,       //enable   

    input [31:0] rmc_of_each_macro        // result memory capacity of each macro
);

//--------------Internal variables---------------- 


//--------------Code Starts Here------------------ 
initial begin
    
end

// Instruction_generation_unit
wire IGU_web;
wire IGU_done_flag;

// Tile_instruction_memory
wire [2 :0] t_i_m_web;
wire [15:0] start_ins_addr0;
wire [15:0] start_ins_addr1;
wire [15:0] start_ins_addr2;
wire [15:0] start_ins_addr3;
wire [15:0] start_ins_addr4;
wire [15:0] start_ins_addr5;
wire [15:0] start_ins_addr6;
wire [15:0] start_ins_addr7;
wire [15:0] start_ins_addr8;
wire [15:0] start_ins_addr9;
wire [15:0] start_ins_addr10;
wire [15:0] start_ins_addr11;
wire [15:0] start_ins_addr12;
wire [15:0] start_ins_addr13;
wire [15:0] start_ins_addr14;
wire [15:0] start_ins_addr15;
wire [15:0] end_ins_addr0;
wire [15:0] end_ins_addr1;
wire [15:0] end_ins_addr2;
wire [15:0] end_ins_addr3;
wire [15:0] end_ins_addr4;
wire [15:0] end_ins_addr5;
wire [15:0] end_ins_addr6;
wire [15:0] end_ins_addr7;
wire [15:0] end_ins_addr8;
wire [15:0] end_ins_addr9;
wire [15:0] end_ins_addr10;
wire [15:0] end_ins_addr11;
wire [15:0] end_ins_addr12;
wire [15:0] end_ins_addr13;
wire [15:0] end_ins_addr14;
wire [15:0] end_ins_addr15;
wire [15:0] core_ins_output_flag;

wire [INS_INTERCORE_DEPTH-1:0] core_ins_output0;
wire [INS_INTERCORE_DEPTH-1:0] core_ins_output1;
wire [INS_INTERCORE_DEPTH-1:0] core_ins_output2;
wire [INS_INTERCORE_DEPTH-1:0] core_ins_output3;
wire [INS_INTERCORE_DEPTH-1:0] core_ins_output4;
wire [INS_INTERCORE_DEPTH-1:0] core_ins_output5;
wire [INS_INTERCORE_DEPTH-1:0] core_ins_output6;
wire [INS_INTERCORE_DEPTH-1:0] core_ins_output7;
wire [INS_INTERCORE_DEPTH-1:0] core_ins_output8;
wire [INS_INTERCORE_DEPTH-1:0] core_ins_output9;
wire [INS_INTERCORE_DEPTH-1:0] core_ins_output10;
wire [INS_INTERCORE_DEPTH-1:0] core_ins_output11;
wire [INS_INTERCORE_DEPTH-1:0] core_ins_output12;
wire [INS_INTERCORE_DEPTH-1:0] core_ins_output13;
wire [INS_INTERCORE_DEPTH-1:0] core_ins_output14;
wire [INS_INTERCORE_DEPTH-1:0] core_ins_output15;

wire [15:0] instruction_addr;
wire [INSTRUCTION_WIDTH-1:0] new_instruction;

wire [15:0] HL_read_addr;
wire [15:0] write_addr;
wire [RW_DEPTH-1:0] basic_instruction;
wire [INSTRUCTION_WIDTH-1:0] HL_instruction;

// Tile_control_unit
wire AS_web_SFU;

wire RS_web_SFU;
wire [31:0] num_of_wm;
wire [31:0] result_memory_usage;

// Weight_SRAM
wire [256    -1:0] WS_web;
wire [256*32 -1:0] WS_read_addr;
wire [256*16 -1:0] WS_length;
wire [256*6  -1:0] WS_width;
wire [256*16 -1:0] WS_depth_of_jump;
wire [256*128-1:0] WS_output;

wire [63:0] counter;
wire [63:0] peak_bandwidth;
wire [63:0] utilization_time;
wire [7 :0] rewriting_speed;

// Activation_SRAM
wire [256           :0] AS_web;
wire [256*32      -1:0] AS_read_addr;
wire [256*16      -1:0] AS_length;
wire [256*6       -1:0] AS_width;
wire [256*16      -1:0] AS_depth_of_jump;
wire [256*RI_DEPTH-1:0] AS_output;

// Result_SRAM
wire [256           :0] RS_web;
wire [256*32      -1:0] RS_write_addr;
wire [256*WR_DEPTH-1:0] Core_output;

// SFU
wire [3:0] SFU_web;
wire [3:0] Result_column;
wire [5:0] Result_picture;   

wire [6:0] MVMUa;   
wire [4:0] MVMUb;
wire [4:0] MVMUc;
wire [4:0] MVMUd;
wire [5:0] timea;   
wire [5:0] timeb;
wire [5:0] MVMUg;
wire [5:0] MVMUh; 

wire [32768-1:0] SFU_data_input;
    
wire [31:0] SFU_RS_read_addr;
wire        SFU_flag;

wire [262144-1:0] SFU_output;

// Cores
wire       c_i_m_web0;
wire       c_i_m_web1;
wire       c_i_m_web2;
wire       c_i_m_web3;
wire       c_i_m_web4;
wire       c_i_m_web5;
wire       c_i_m_web6;
wire       c_i_m_web7;
wire       c_i_m_web8;
wire       c_i_m_web9;
wire       c_i_m_web10;
wire       c_i_m_web11;
wire       c_i_m_web12;
wire       c_i_m_web13;
wire       c_i_m_web14;
wire       c_i_m_web15;
wire [15:0] c_i_m_write_addr0;
wire [15:0] c_i_m_write_addr1;
wire [15:0] c_i_m_write_addr2;
wire [15:0] c_i_m_write_addr3;
wire [15:0] c_i_m_write_addr4;
wire [15:0] c_i_m_write_addr5;
wire [15:0] c_i_m_write_addr6;
wire [15:0] c_i_m_write_addr7;
wire [15:0] c_i_m_write_addr8;
wire [15:0] c_i_m_write_addr9;
wire [15:0] c_i_m_write_addr10;
wire [15:0] c_i_m_write_addr11;
wire [15:0] c_i_m_write_addr12;
wire [15:0] c_i_m_write_addr13;
wire [15:0] c_i_m_write_addr14;
wire [15:0] c_i_m_write_addr15;

wire core_control_unit_web0;
wire core_control_unit_web1;
wire core_control_unit_web2;
wire core_control_unit_web3;
wire core_control_unit_web4;
wire core_control_unit_web5;
wire core_control_unit_web6;
wire core_control_unit_web7;
wire core_control_unit_web8;
wire core_control_unit_web9;
wire core_control_unit_web10;
wire core_control_unit_web11;
wire core_control_unit_web12;
wire core_control_unit_web13;
wire core_control_unit_web14;
wire core_control_unit_web15;
wire workload_completed_flag0;
wire workload_completed_flag1;
wire workload_completed_flag2;
wire workload_completed_flag3;
wire workload_completed_flag4;
wire workload_completed_flag5;
wire workload_completed_flag6;
wire workload_completed_flag7;
wire workload_completed_flag8;
wire workload_completed_flag9;
wire workload_completed_flag10;
wire workload_completed_flag11;
wire workload_completed_flag12;
wire workload_completed_flag13;
wire workload_completed_flag14;
wire workload_completed_flag15;

wire [63:0] MVMU_work_flag0;
wire [63:0] MVMU_work_flag1;
wire [63:0] MVMU_work_flag2;
wire [63:0] MVMU_work_flag3;
wire [63:0] MVMU_work_flag4;
wire [63:0] MVMU_work_flag5;
wire [63:0] MVMU_work_flag6;
wire [63:0] MVMU_work_flag7;
wire [63:0] MVMU_work_flag8;
wire [63:0] MVMU_work_flag9;
wire [63:0] MVMU_work_flag10;
wire [63:0] MVMU_work_flag11;
wire [63:0] MVMU_work_flag12;
wire [63:0] MVMU_work_flag13;
wire [63:0] MVMU_work_flag14;
wire [63:0] MVMU_work_flag15;

// Connect
assign AS_web[256] = AS_web_SFU;
assign RS_web[256] = RS_web_SFU;

Instruction_generation_unit Instruction_generation_unit(
    .clk                         (clk), 
    .RSTn                        (RSTn), 

    .web                         (IGU_web), 

    .input_instruction           (HL_instruction), 
    .TIM_read_addr               (HL_read_addr), 
    .TIM_write_addr              (write_addr), 
    .basic_instruction           (basic_instruction),
    .done_flag                   (IGU_done_flag)
);

Tile_instruction_memory Tile_instruction_memory(
    .clk                         (clk), 
    .RSTn                        (RSTn), 

    .web                         (t_i_m_web), 
    .start_ins_addr0             (start_ins_addr0), 
    .start_ins_addr1             (start_ins_addr1), 
    .start_ins_addr2             (start_ins_addr2), 
    .start_ins_addr3             (start_ins_addr3), 
    .start_ins_addr4             (start_ins_addr4), 
    .start_ins_addr5             (start_ins_addr5), 
    .start_ins_addr6             (start_ins_addr6), 
    .start_ins_addr7             (start_ins_addr7), 
    .start_ins_addr8             (start_ins_addr8), 
    .start_ins_addr9             (start_ins_addr9), 
    .start_ins_addr10            (start_ins_addr10), 
    .start_ins_addr11            (start_ins_addr11), 
    .start_ins_addr12            (start_ins_addr12), 
    .start_ins_addr13            (start_ins_addr13), 
    .start_ins_addr14            (start_ins_addr14), 
    .start_ins_addr15            (start_ins_addr15), 
    .end_ins_addr0               (end_ins_addr0), 
    .end_ins_addr1               (end_ins_addr1),
    .end_ins_addr2               (end_ins_addr2),
    .end_ins_addr3               (end_ins_addr3),
    .end_ins_addr4               (end_ins_addr4), 
    .end_ins_addr5               (end_ins_addr5),
    .end_ins_addr6               (end_ins_addr6),
    .end_ins_addr7               (end_ins_addr7),
    .end_ins_addr8               (end_ins_addr8), 
    .end_ins_addr9               (end_ins_addr9),
    .end_ins_addr10              (end_ins_addr10),
    .end_ins_addr11              (end_ins_addr11),
    .end_ins_addr12              (end_ins_addr12), 
    .end_ins_addr13              (end_ins_addr13),
    .end_ins_addr14              (end_ins_addr14),
    .end_ins_addr15              (end_ins_addr15),
    .core_ins_output_flag        (core_ins_output_flag),

    .core_ins_output0            (core_ins_output0),
    .core_ins_output1            (core_ins_output1),
    .core_ins_output2            (core_ins_output2),
    .core_ins_output3            (core_ins_output3),
    .core_ins_output4            (core_ins_output4),
    .core_ins_output5            (core_ins_output5),
    .core_ins_output6            (core_ins_output6),
    .core_ins_output7            (core_ins_output7),
    .core_ins_output8            (core_ins_output8),
    .core_ins_output9            (core_ins_output9),
    .core_ins_output10           (core_ins_output10),
    .core_ins_output11           (core_ins_output11),
    .core_ins_output12           (core_ins_output12),
    .core_ins_output13           (core_ins_output13),
    .core_ins_output14           (core_ins_output14),
    .core_ins_output15           (core_ins_output15),

    .addr                        (instruction_addr),
    .instruction                 (new_instruction),  

    .HL_read_addr                (HL_read_addr),
    .write_addr                  (write_addr),  
    .basic_instruction           (basic_instruction),
    .HL_instruction              (HL_instruction),
    .IGU_done_flag               (IGU_done_flag)
);

Tile_control_unit Tile_control_unit(
    .clk                             (clk), 
    .RSTn                            (RSTn), 

    .counter                         (counter),
    .peak_bandwidth                  (peak_bandwidth),
    .utilization_time                (utilization_time),

    .MVMU_work_flag0         (MVMU_work_flag0),
    .MVMU_work_flag1         (MVMU_work_flag1),
    .MVMU_work_flag2         (MVMU_work_flag2),
    .MVMU_work_flag3         (MVMU_work_flag3),
    .MVMU_work_flag4         (MVMU_work_flag4),
    .MVMU_work_flag5         (MVMU_work_flag5),
    .MVMU_work_flag6         (MVMU_work_flag6),
    .MVMU_work_flag7         (MVMU_work_flag7),
    .MVMU_work_flag8         (MVMU_work_flag8),
    .MVMU_work_flag9         (MVMU_work_flag9),
    .MVMU_work_flag10        (MVMU_work_flag10),
    .MVMU_work_flag11        (MVMU_work_flag11),
    .MVMU_work_flag12        (MVMU_work_flag12),
    .MVMU_work_flag13        (MVMU_work_flag13),
    .MVMU_work_flag14        (MVMU_work_flag14),
    .MVMU_work_flag15        (MVMU_work_flag15),

    .IGU_web                         (IGU_web), 
    .IGU_done_flag                   (IGU_done_flag),

    .t_i_m_web                       (t_i_m_web), 
    .start_ins_addr0                 (start_ins_addr0), 
    .start_ins_addr1                 (start_ins_addr1), 
    .start_ins_addr2                 (start_ins_addr2), 
    .start_ins_addr3                 (start_ins_addr3), 
    .start_ins_addr4                 (start_ins_addr4), 
    .start_ins_addr5                 (start_ins_addr5), 
    .start_ins_addr6                 (start_ins_addr6), 
    .start_ins_addr7                 (start_ins_addr7), 
    .start_ins_addr8                 (start_ins_addr8), 
    .start_ins_addr9                 (start_ins_addr9), 
    .start_ins_addr10                (start_ins_addr10), 
    .start_ins_addr11                (start_ins_addr11), 
    .start_ins_addr12                (start_ins_addr12), 
    .start_ins_addr13                (start_ins_addr13), 
    .start_ins_addr14                (start_ins_addr14), 
    .start_ins_addr15                (start_ins_addr15), 
    .end_ins_addr0                   (end_ins_addr0), 
    .end_ins_addr1                   (end_ins_addr1),
    .end_ins_addr2                   (end_ins_addr2),
    .end_ins_addr3                   (end_ins_addr3),
    .end_ins_addr4                   (end_ins_addr4), 
    .end_ins_addr5                   (end_ins_addr5),
    .end_ins_addr6                   (end_ins_addr6),
    .end_ins_addr7                   (end_ins_addr7),
    .end_ins_addr8                   (end_ins_addr8), 
    .end_ins_addr9                   (end_ins_addr9),
    .end_ins_addr10                  (end_ins_addr10),
    .end_ins_addr11                  (end_ins_addr11),
    .end_ins_addr12                  (end_ins_addr12), 
    .end_ins_addr13                  (end_ins_addr13),
    .end_ins_addr14                  (end_ins_addr14),
    .end_ins_addr15                  (end_ins_addr15),
    .core_ins_output_flag            (core_ins_output_flag), 

    .instruction_addr                (instruction_addr), 
    .new_instruction                 (new_instruction), 

    .c_i_m_web0                      (c_i_m_web0), 
    .c_i_m_web1                      (c_i_m_web1), 
    .c_i_m_web2                      (c_i_m_web2), 
    .c_i_m_web3                      (c_i_m_web3), 
    .c_i_m_web4                      (c_i_m_web4), 
    .c_i_m_web5                      (c_i_m_web5), 
    .c_i_m_web6                      (c_i_m_web6), 
    .c_i_m_web7                      (c_i_m_web7), 
    .c_i_m_web8                      (c_i_m_web8), 
    .c_i_m_web9                      (c_i_m_web9), 
    .c_i_m_web10                     (c_i_m_web10), 
    .c_i_m_web11                     (c_i_m_web11), 
    .c_i_m_web12                     (c_i_m_web12), 
    .c_i_m_web13                     (c_i_m_web13), 
    .c_i_m_web14                     (c_i_m_web14), 
    .c_i_m_web15                     (c_i_m_web15), 
    .c_i_m_write_addr0               (c_i_m_write_addr0),
    .c_i_m_write_addr1               (c_i_m_write_addr1),
    .c_i_m_write_addr2               (c_i_m_write_addr2),
    .c_i_m_write_addr3               (c_i_m_write_addr3),
    .c_i_m_write_addr4               (c_i_m_write_addr4),
    .c_i_m_write_addr5               (c_i_m_write_addr5),
    .c_i_m_write_addr6               (c_i_m_write_addr6),
    .c_i_m_write_addr7               (c_i_m_write_addr7),
    .c_i_m_write_addr8               (c_i_m_write_addr8), 
    .c_i_m_write_addr9               (c_i_m_write_addr9), 
    .c_i_m_write_addr10              (c_i_m_write_addr10), 
    .c_i_m_write_addr11              (c_i_m_write_addr11), 
    .c_i_m_write_addr12              (c_i_m_write_addr12), 
    .c_i_m_write_addr13              (c_i_m_write_addr13), 
    .c_i_m_write_addr14              (c_i_m_write_addr14), 
    .c_i_m_write_addr15              (c_i_m_write_addr15), 

    .core_control_unit_web0          (core_control_unit_web0), 
    .core_control_unit_web1          (core_control_unit_web1), 
    .core_control_unit_web2          (core_control_unit_web2), 
    .core_control_unit_web3          (core_control_unit_web3), 
    .core_control_unit_web4          (core_control_unit_web4), 
    .core_control_unit_web5          (core_control_unit_web5), 
    .core_control_unit_web6          (core_control_unit_web6), 
    .core_control_unit_web7          (core_control_unit_web7), 
    .core_control_unit_web8          (core_control_unit_web8), 
    .core_control_unit_web9          (core_control_unit_web9), 
    .core_control_unit_web10         (core_control_unit_web10), 
    .core_control_unit_web11         (core_control_unit_web11), 
    .core_control_unit_web12         (core_control_unit_web12), 
    .core_control_unit_web13         (core_control_unit_web13), 
    .core_control_unit_web14         (core_control_unit_web14), 
    .core_control_unit_web15         (core_control_unit_web15), 
    .workload_completed_flag0        (workload_completed_flag0), 
    .workload_completed_flag1        (workload_completed_flag1), 
    .workload_completed_flag2        (workload_completed_flag2), 
    .workload_completed_flag3        (workload_completed_flag3), 
    .workload_completed_flag4        (workload_completed_flag4), 
    .workload_completed_flag5        (workload_completed_flag5), 
    .workload_completed_flag6        (workload_completed_flag6), 
    .workload_completed_flag7        (workload_completed_flag7), 
    .workload_completed_flag8        (workload_completed_flag8), 
    .workload_completed_flag9        (workload_completed_flag9), 
    .workload_completed_flag10       (workload_completed_flag10), 
    .workload_completed_flag11       (workload_completed_flag11), 
    .workload_completed_flag12       (workload_completed_flag12), 
    .workload_completed_flag13       (workload_completed_flag13), 
    .workload_completed_flag14       (workload_completed_flag14), 
    .workload_completed_flag15       (workload_completed_flag15), 

    .AS_web_SFU                      (AS_web_SFU), 

    .RS_web_SFU                      (RS_web_SFU), 
    .num_of_wm                       (num_of_wm),
    .result_memory_usage             (result_memory_usage),

    .SFU_web                         (SFU_web), 
    .Result_column                   (Result_column), 
    .Result_picture                  (Result_picture), 

    .MVMUa                           (MVMUa), 
    .MVMUb                           (MVMUb), 
    .MVMUc                           (MVMUc), 
    .MVMUd                           (MVMUd), 
    .timea                           (timea), 
    .timeb                           (timeb), 
    .MVMUg                           (MVMUg), 
    .MVMUh                           (MVMUh),
    .SFU_flag                        (SFU_flag)
);

Weight_SRAM Weight_SRAM(
    .clk                     (clk), 
    .RSTn                    (RSTn), 

    .WS_web                  (WS_web), 
    .WS_read_addr            (WS_read_addr),
    .WS_length               (WS_length),
    .WS_width                (WS_width),
    .WS_depth_of_jump        (WS_depth_of_jump),
    .WS_output               (WS_output),

    .counter                 (counter),
    .peak_bandwidth          (peak_bandwidth),
    .utilization_time        (utilization_time),
    .rewriting_speed         (rewriting_speed)
);

Activation_SRAM Activation_SRAM(
    .clk                     (clk), 
    .RSTn                    (RSTn), 
    .AS_web                  (AS_web), 

    .AS_read_addr            (AS_read_addr),
    .AS_length               (AS_length),
    .AS_width                (AS_width),
    .AS_depth_of_jump        (AS_depth_of_jump),
    .AS_output               (AS_output),

    .AS_SFU_input            (SFU_output)
);

Result_SRAM Result_SRAM(
    .clk                     (clk), 
    .RSTn                    (RSTn), 
    .RS_web                  (RS_web), 
    .RS_write_addr           (RS_write_addr),
    .RS_input                (Core_output),
    .rmc_of_each_macro       (rmc_of_each_macro),
    .result_memory_usage     (result_memory_usage),
    .num_of_wm               (num_of_wm),

    .RS_SFU_read_addr        (SFU_RS_read_addr),
    .RS_SFU_output           (SFU_data_input)
);

SFU SFU(
    .clk                     (clk), 
    .RSTn                    (RSTn), 
    .SFU_web                 (SFU_web), 
    .rmc_of_each_macro       (rmc_of_each_macro),
    .Result_column           (Result_column), 
    .Result_picture          (Result_picture), 

    .MVMUa                   (MVMUa), 
    .MVMUb                   (MVMUb), 
    .MVMUc                   (MVMUc), 
    .MVMUd                   (MVMUd), 
    .timea                   (timea), 
    .timeb                   (timeb), 
    .MVMUg                   (MVMUg), 
    .MVMUh                   (MVMUh), 

    .SFU_data_input          (SFU_data_input), 
    
    .SFU_RS_read_addr        (SFU_RS_read_addr), 
    .SFU_flag                (SFU_flag),

    .SFU_output              (SFU_output)
);

Core Core0(
    .clk                             (clk), 
    .RSTn                            (RSTn), 

    .rewriting_speed          (rewriting_speed),

    .WS_web                         (WS_web          [0 *1  *16+:1  *16]),
    .WS_read_addr                   (WS_read_addr    [0 *32 *16+:32 *16]),
    .WS_length                      (WS_length       [0 *16 *16+:16 *16]),
    .WS_width                       (WS_width        [0 *6  *16+:6  *16]),
    .WS_depth_of_jump               (WS_depth_of_jump[0 *16 *16+:16 *16]),
    .updated_weight                 (WS_output       [0 *128*16+:128*16]),

    .AS_web                         (AS_web          [0 *1 *16+:1 *16]),
    .AS_read_addr                   (AS_read_addr    [0 *32*16+:32*16]),
    .AS_length                      (AS_length       [0 *16*16+:16*16]),
    .AS_width                       (AS_width        [0 *6 *16+:6 *16]),
    .AS_depth_of_jump               (AS_depth_of_jump[0 *16*16+:16*16]),
    .updated_input                  (AS_output       [0 *RI_DEPTH*16+:RI_DEPTH*16]),

    .RS_web                         (RS_web          [0 *1 *16+:1 *16]),
    .RS_write_addr                  (RS_write_addr   [0 *32*16+:32*16]),
    .Core_output                    (Core_output     [0 *WR_DEPTH*16+:WR_DEPTH*16]),

    .c_i_m_web                      (c_i_m_web0), 
    .c_i_m_write_addr               (c_i_m_write_addr0),
    .core_ins_input                 (core_ins_output0),

    .core_control_unit_web          (core_control_unit_web0), 
    .workload_completed_flag        (workload_completed_flag0),

    .MVMU_work_flag0                (MVMU_work_flag0),
    .MVMU_work_flag1                (MVMU_work_flag1),
    .MVMU_work_flag2                (MVMU_work_flag2),
    .MVMU_work_flag3                (MVMU_work_flag3),
    .MVMU_work_flag4                (MVMU_work_flag4),
    .MVMU_work_flag5                (MVMU_work_flag5),
    .MVMU_work_flag6                (MVMU_work_flag6),
    .MVMU_work_flag7                (MVMU_work_flag7),
    .MVMU_work_flag8                (MVMU_work_flag8),
    .MVMU_work_flag9                (MVMU_work_flag9),
    .MVMU_work_flag10               (MVMU_work_flag10),
    .MVMU_work_flag11               (MVMU_work_flag11),
    .MVMU_work_flag12               (MVMU_work_flag12),
    .MVMU_work_flag13               (MVMU_work_flag13),
    .MVMU_work_flag14               (MVMU_work_flag14),
    .MVMU_work_flag15               (MVMU_work_flag15)
);

Core Core1(
    .clk                             (clk), 
    .RSTn                            (RSTn), 

    .rewriting_speed          (rewriting_speed),

    .WS_web                         (WS_web          [1 *1  *16+:1  *16]),
    .WS_read_addr                   (WS_read_addr    [1 *32 *16+:32 *16]),
    .WS_length                      (WS_length       [1 *16 *16+:16 *16]),
    .WS_width                       (WS_width        [1 *6  *16+:6  *16]),
    .WS_depth_of_jump               (WS_depth_of_jump[1 *16 *16+:16 *16]),
    .updated_weight                 (WS_output       [1 *128*16+:128*16]),

    .AS_web                         (AS_web          [1 *1 *16+:1 *16]),
    .AS_read_addr                   (AS_read_addr    [1 *32*16+:32*16]),
    .AS_length                      (AS_length       [1 *16*16+:16*16]),
    .AS_width                       (AS_width        [1 *6 *16+:6 *16]),
    .AS_depth_of_jump               (AS_depth_of_jump[1 *16*16+:16*16]),
    .updated_input                  (AS_output       [1 *RI_DEPTH*16+:RI_DEPTH*16]),
    
    .RS_web                         (RS_web          [1 *1 *16+:1 *16]),
    .RS_write_addr                  (RS_write_addr   [1 *32*16+:32*16]),
    .Core_output                    (Core_output     [1 *WR_DEPTH*16+:WR_DEPTH*16]),

    .c_i_m_web                      (c_i_m_web1), 
    .c_i_m_write_addr               (c_i_m_write_addr1),
    .core_ins_input                 (core_ins_output1),

    .core_control_unit_web          (core_control_unit_web1), 
    .workload_completed_flag        (workload_completed_flag1),

    .MVMU_work_flag0                      (),
    .MVMU_work_flag1                      (),
    .MVMU_work_flag2                      (),
    .MVMU_work_flag3                      (),
    .MVMU_work_flag4                      (),
    .MVMU_work_flag5                      (),
    .MVMU_work_flag6                      (),
    .MVMU_work_flag7                      (),
    .MVMU_work_flag8                      (),
    .MVMU_work_flag9                      (),
    .MVMU_work_flag10                     (),
    .MVMU_work_flag11                     (),
    .MVMU_work_flag12                     (),
    .MVMU_work_flag13                     (),
    .MVMU_work_flag14                     (),
    .MVMU_work_flag15                     ()
);

Core Core2(
    .clk                             (clk), 
    .RSTn                            (RSTn), 

    .rewriting_speed          (rewriting_speed),

    .WS_web                         (WS_web          [2 *1  *16+:1  *16]),
    .WS_read_addr                   (WS_read_addr    [2 *32 *16+:32 *16]),
    .WS_length                      (WS_length       [2 *16 *16+:16 *16]),
    .WS_width                       (WS_width        [2 *6  *16+:6  *16]),
    .WS_depth_of_jump               (WS_depth_of_jump[2 *16 *16+:16 *16]),
    .updated_weight                 (WS_output       [2 *128*16+:128*16]),

    .AS_web                         (AS_web          [2 *1 *16+:1 *16]),
    .AS_read_addr                   (AS_read_addr    [2 *32*16+:32*16]),
    .AS_length                      (AS_length       [2 *16*16+:16*16]),
    .AS_width                       (AS_width        [2 *6 *16+:6 *16]),
    .AS_depth_of_jump               (AS_depth_of_jump[2 *16*16+:16*16]),
    .updated_input                  (AS_output       [2 *RI_DEPTH*16+:RI_DEPTH*16]),

    .RS_web                         (RS_web          [2 *1 *16+:1 *16]),
    .RS_write_addr                  (RS_write_addr   [2 *32*16+:32*16]),
    .Core_output                    (Core_output     [2 *WR_DEPTH*16+:WR_DEPTH*16]),

    .c_i_m_web                      (c_i_m_web2), 
    .c_i_m_write_addr               (c_i_m_write_addr2),
    .core_ins_input                 (core_ins_output2),

    .core_control_unit_web          (core_control_unit_web2), 
    .workload_completed_flag        (workload_completed_flag2),

    .MVMU_work_flag0                      (),
    .MVMU_work_flag1                      (),
    .MVMU_work_flag2                      (),
    .MVMU_work_flag3                      (),
    .MVMU_work_flag4                      (),
    .MVMU_work_flag5                      (),
    .MVMU_work_flag6                      (),
    .MVMU_work_flag7                      (),
    .MVMU_work_flag8                      (),
    .MVMU_work_flag9                      (),
    .MVMU_work_flag10                     (),
    .MVMU_work_flag11                     (),
    .MVMU_work_flag12                     (),
    .MVMU_work_flag13                     (),
    .MVMU_work_flag14                     (),
    .MVMU_work_flag15                     ()
);

Core Core3(
    .clk                             (clk), 
    .RSTn                            (RSTn), 

    .rewriting_speed          (rewriting_speed),

    .WS_web                         (WS_web          [3 *1  *16+:1  *16]),
    .WS_read_addr                   (WS_read_addr    [3 *32 *16+:32 *16]),
    .WS_length                      (WS_length       [3 *16 *16+:16 *16]),
    .WS_width                       (WS_width        [3 *6  *16+:6  *16]),
    .WS_depth_of_jump               (WS_depth_of_jump[3 *16 *16+:16 *16]),
    .updated_weight                 (WS_output       [3 *128*16+:128*16]),

    .AS_web                         (AS_web          [3 *1 *16+:1 *16]),
    .AS_read_addr                   (AS_read_addr    [3 *32*16+:32*16]),
    .AS_length                      (AS_length       [3 *16*16+:16*16]),
    .AS_width                       (AS_width        [3 *6 *16+:6 *16]),
    .AS_depth_of_jump               (AS_depth_of_jump[3 *16*16+:16*16]),
    .updated_input                  (AS_output       [3 *RI_DEPTH*16+:RI_DEPTH*16]),

    .RS_web                         (RS_web          [3 *1 *16+:1 *16]),
    .RS_write_addr                  (RS_write_addr   [3 *32*16+:32*16]),
    .Core_output                    (Core_output     [3 *WR_DEPTH*16+:WR_DEPTH*16]),

    .c_i_m_web                      (c_i_m_web3), 
    .c_i_m_write_addr               (c_i_m_write_addr3),
    .core_ins_input                 (core_ins_output3),

    .core_control_unit_web          (core_control_unit_web3), 
    .workload_completed_flag        (workload_completed_flag3),

    .MVMU_work_flag0                      (),
    .MVMU_work_flag1                      (),
    .MVMU_work_flag2                      (),
    .MVMU_work_flag3                      (),
    .MVMU_work_flag4                      (),
    .MVMU_work_flag5                      (),
    .MVMU_work_flag6                      (),
    .MVMU_work_flag7                      (),
    .MVMU_work_flag8                      (),
    .MVMU_work_flag9                      (),
    .MVMU_work_flag10                     (),
    .MVMU_work_flag11                     (),
    .MVMU_work_flag12                     (),
    .MVMU_work_flag13                     (),
    .MVMU_work_flag14                     (),
    .MVMU_work_flag15                     ()
);

Core Core4(
    .clk                             (clk), 
    .RSTn                            (RSTn), 

    .rewriting_speed          (rewriting_speed),

    .WS_web                         (WS_web          [4 *1  *16+:1  *16]),
    .WS_read_addr                   (WS_read_addr    [4 *32 *16+:32 *16]),
    .WS_length                      (WS_length       [4 *16 *16+:16 *16]),
    .WS_width                       (WS_width        [4 *6  *16+:6  *16]),
    .WS_depth_of_jump               (WS_depth_of_jump[4 *16 *16+:16 *16]),
    .updated_weight                 (WS_output       [4 *128*16+:128*16]),

    .AS_web                         (AS_web          [4 *1 *16+:1 *16]),
    .AS_read_addr                   (AS_read_addr    [4 *32*16+:32*16]),
    .AS_length                      (AS_length       [4 *16*16+:16*16]),
    .AS_width                       (AS_width        [4 *6 *16+:6 *16]),
    .AS_depth_of_jump               (AS_depth_of_jump[4 *16*16+:16*16]),
    .updated_input                  (AS_output       [4 *RI_DEPTH*16+:RI_DEPTH*16]),

    .RS_web                         (RS_web          [4 *1 *16+:1 *16]),
    .RS_write_addr                  (RS_write_addr   [4 *32*16+:32*16]),
    .Core_output                    (Core_output     [4 *WR_DEPTH*16+:WR_DEPTH*16]),

    .c_i_m_web                      (c_i_m_web4), 
    .c_i_m_write_addr               (c_i_m_write_addr4),
    .core_ins_input                 (core_ins_output4),

    .core_control_unit_web          (core_control_unit_web4), 
    .workload_completed_flag        (workload_completed_flag4),

    .MVMU_work_flag0                      (),
    .MVMU_work_flag1                      (),
    .MVMU_work_flag2                      (),
    .MVMU_work_flag3                      (),
    .MVMU_work_flag4                      (),
    .MVMU_work_flag5                      (),
    .MVMU_work_flag6                      (),
    .MVMU_work_flag7                      (),
    .MVMU_work_flag8                      (),
    .MVMU_work_flag9                      (),
    .MVMU_work_flag10                     (),
    .MVMU_work_flag11                     (),
    .MVMU_work_flag12                     (),
    .MVMU_work_flag13                     (),
    .MVMU_work_flag14                     (),
    .MVMU_work_flag15                     ()
);

Core Core5(
    .clk                             (clk), 
    .RSTn                            (RSTn), 

    .rewriting_speed          (rewriting_speed),

    .WS_web                         (WS_web          [5 *1  *16+:1  *16]),
    .WS_read_addr                   (WS_read_addr    [5 *32 *16+:32 *16]),
    .WS_length                      (WS_length       [5 *16 *16+:16 *16]),
    .WS_width                       (WS_width        [5 *6  *16+:6  *16]),
    .WS_depth_of_jump               (WS_depth_of_jump[5 *16 *16+:16 *16]),
    .updated_weight                 (WS_output       [5 *128*16+:128*16]),

    .AS_web                         (AS_web          [5 *1 *16+:1 *16]),
    .AS_read_addr                   (AS_read_addr    [5 *32*16+:32*16]),
    .AS_length                      (AS_length       [5 *16*16+:16*16]),
    .AS_width                       (AS_width        [5 *6 *16+:6 *16]),
    .AS_depth_of_jump               (AS_depth_of_jump[5 *16*16+:16*16]),
    .updated_input                  (AS_output       [5 *RI_DEPTH*16+:RI_DEPTH*16]),

    .RS_web                         (RS_web          [5 *1 *16+:1 *16]),
    .RS_write_addr                  (RS_write_addr   [5 *32*16+:32*16]),
    .Core_output                    (Core_output     [5 *WR_DEPTH*16+:WR_DEPTH*16]),

    .c_i_m_web                      (c_i_m_web5), 
    .c_i_m_write_addr               (c_i_m_write_addr5),
    .core_ins_input                 (core_ins_output5),

    .core_control_unit_web          (core_control_unit_web5), 
    .workload_completed_flag        (workload_completed_flag5),

    .MVMU_work_flag0                      (),
    .MVMU_work_flag1                      (),
    .MVMU_work_flag2                      (),
    .MVMU_work_flag3                      (),
    .MVMU_work_flag4                      (),
    .MVMU_work_flag5                      (),
    .MVMU_work_flag6                      (),
    .MVMU_work_flag7                      (),
    .MVMU_work_flag8                      (),
    .MVMU_work_flag9                      (),
    .MVMU_work_flag10                     (),
    .MVMU_work_flag11                     (),
    .MVMU_work_flag12                     (),
    .MVMU_work_flag13                     (),
    .MVMU_work_flag14                     (),
    .MVMU_work_flag15                     ()
);

Core Core6(
    .clk                             (clk), 
    .RSTn                            (RSTn), 

    .rewriting_speed          (rewriting_speed),

    .WS_web                         (WS_web          [6 *1  *16+:1  *16]),
    .WS_read_addr                   (WS_read_addr    [6 *32 *16+:32 *16]),
    .WS_length                      (WS_length       [6 *16 *16+:16 *16]),
    .WS_width                       (WS_width        [6 *6  *16+:6  *16]),
    .WS_depth_of_jump               (WS_depth_of_jump[6 *16 *16+:16 *16]),
    .updated_weight                 (WS_output       [6 *128*16+:128*16]),

    .AS_web                         (AS_web          [6 *1 *16+:1 *16]),
    .AS_read_addr                   (AS_read_addr    [6 *32*16+:32*16]),
    .AS_length                      (AS_length       [6 *16*16+:16*16]),
    .AS_width                       (AS_width        [6 *6 *16+:6 *16]),
    .AS_depth_of_jump               (AS_depth_of_jump[6 *16*16+:16*16]),
    .updated_input                  (AS_output       [6 *RI_DEPTH*16+:RI_DEPTH*16]),

    .RS_web                         (RS_web          [6 *1 *16+:1 *16]),
    .RS_write_addr                  (RS_write_addr   [6 *32*16+:32*16]),
    .Core_output                    (Core_output     [6 *WR_DEPTH*16+:WR_DEPTH*16]),

    .c_i_m_web                      (c_i_m_web6), 
    .c_i_m_write_addr               (c_i_m_write_addr6),
    .core_ins_input                 (core_ins_output6),

    .core_control_unit_web          (core_control_unit_web6), 
    .workload_completed_flag        (workload_completed_flag6),

    .MVMU_work_flag0                      (),
    .MVMU_work_flag1                      (),
    .MVMU_work_flag2                      (),
    .MVMU_work_flag3                      (),
    .MVMU_work_flag4                      (),
    .MVMU_work_flag5                      (),
    .MVMU_work_flag6                      (),
    .MVMU_work_flag7                      (),
    .MVMU_work_flag8                      (),
    .MVMU_work_flag9                      (),
    .MVMU_work_flag10                     (),
    .MVMU_work_flag11                     (),
    .MVMU_work_flag12                     (),
    .MVMU_work_flag13                     (),
    .MVMU_work_flag14                     (),
    .MVMU_work_flag15                     ()
);

Core Core7(
    .clk                             (clk), 
    .RSTn                            (RSTn), 

    .rewriting_speed          (rewriting_speed),

    .WS_web                         (WS_web          [7 *1  *16+:1  *16]),
    .WS_read_addr                   (WS_read_addr    [7 *32 *16+:32 *16]),
    .WS_length                      (WS_length       [7 *16 *16+:16 *16]),
    .WS_width                       (WS_width        [7 *6  *16+:6  *16]),
    .WS_depth_of_jump               (WS_depth_of_jump[7 *16 *16+:16 *16]),
    .updated_weight                 (WS_output       [7 *128*16+:128*16]),

    .AS_web                         (AS_web          [7 *1 *16+:1 *16]),
    .AS_read_addr                   (AS_read_addr    [7 *32*16+:32*16]),
    .AS_length                      (AS_length       [7 *16*16+:16*16]),
    .AS_width                       (AS_width        [7 *6 *16+:6 *16]),
    .AS_depth_of_jump               (AS_depth_of_jump[7 *16*16+:16*16]),
    .updated_input                  (AS_output       [7 *RI_DEPTH*16+:RI_DEPTH*16]),

    .RS_web                         (RS_web          [7 *1 *16+:1 *16]),
    .RS_write_addr                  (RS_write_addr   [7 *32*16+:32*16]),
    .Core_output                    (Core_output     [7 *WR_DEPTH*16+:WR_DEPTH*16]),

    .c_i_m_web                      (c_i_m_web7), 
    .c_i_m_write_addr               (c_i_m_write_addr7),
    .core_ins_input                 (core_ins_output7),

    .core_control_unit_web          (core_control_unit_web7), 
    .workload_completed_flag        (workload_completed_flag7),

    .MVMU_work_flag0                      (),
    .MVMU_work_flag1                      (),
    .MVMU_work_flag2                      (),
    .MVMU_work_flag3                      (),
    .MVMU_work_flag4                      (),
    .MVMU_work_flag5                      (),
    .MVMU_work_flag6                      (),
    .MVMU_work_flag7                      (),
    .MVMU_work_flag8                      (),
    .MVMU_work_flag9                      (),
    .MVMU_work_flag10                     (),
    .MVMU_work_flag11                     (),
    .MVMU_work_flag12                     (),
    .MVMU_work_flag13                     (),
    .MVMU_work_flag14                     (),
    .MVMU_work_flag15                     ()
);

Core Core8(
    .clk                             (clk), 
    .RSTn                            (RSTn), 

    .rewriting_speed          (rewriting_speed),

    .WS_web                         (WS_web          [8 *1  *16+:1  *16]),
    .WS_read_addr                   (WS_read_addr    [8 *32 *16+:32 *16]),
    .WS_length                      (WS_length       [8 *16 *16+:16 *16]),
    .WS_width                       (WS_width        [8 *6  *16+:6  *16]),
    .WS_depth_of_jump               (WS_depth_of_jump[8 *16 *16+:16 *16]),
    .updated_weight                 (WS_output       [8 *128*16+:128*16]),

    .AS_web                         (AS_web          [8 *1 *16+:1 *16]),
    .AS_read_addr                   (AS_read_addr    [8 *32*16+:32*16]),
    .AS_length                      (AS_length       [8 *16*16+:16*16]),
    .AS_width                       (AS_width        [8 *6 *16+:6 *16]),
    .AS_depth_of_jump               (AS_depth_of_jump[8 *16*16+:16*16]),
    .updated_input                  (AS_output       [8 *RI_DEPTH*16+:RI_DEPTH*16]),

    .RS_web                         (RS_web          [8 *1 *16+:1 *16]),
    .RS_write_addr                  (RS_write_addr   [8 *32*16+:32*16]),
    .Core_output                    (Core_output     [8 *WR_DEPTH*16+:WR_DEPTH*16]),

    .c_i_m_web                      (c_i_m_web8), 
    .c_i_m_write_addr               (c_i_m_write_addr8),
    .core_ins_input                 (core_ins_output8),

    .core_control_unit_web          (core_control_unit_web8), 
    .workload_completed_flag        (workload_completed_flag8),

    .MVMU_work_flag0                      (),
    .MVMU_work_flag1                      (),
    .MVMU_work_flag2                      (),
    .MVMU_work_flag3                      (),
    .MVMU_work_flag4                      (),
    .MVMU_work_flag5                      (),
    .MVMU_work_flag6                      (),
    .MVMU_work_flag7                      (),
    .MVMU_work_flag8                      (),
    .MVMU_work_flag9                      (),
    .MVMU_work_flag10                     (),
    .MVMU_work_flag11                     (),
    .MVMU_work_flag12                     (),
    .MVMU_work_flag13                     (),
    .MVMU_work_flag14                     (),
    .MVMU_work_flag15                     ()
);

Core Core9(
    .clk                             (clk), 
    .RSTn                            (RSTn), 

    .rewriting_speed          (rewriting_speed),

    .WS_web                         (WS_web          [9 *1  *16+:1  *16]),
    .WS_read_addr                   (WS_read_addr    [9 *32 *16+:32 *16]),
    .WS_length                      (WS_length       [9 *16 *16+:16 *16]),
    .WS_width                       (WS_width        [9 *6  *16+:6  *16]),
    .WS_depth_of_jump               (WS_depth_of_jump[9 *16 *16+:16 *16]),
    .updated_weight                 (WS_output       [9 *128*16+:128*16]),

    .AS_web                         (AS_web          [9 *1 *16+:1 *16]),
    .AS_read_addr                   (AS_read_addr    [9 *32*16+:32*16]),
    .AS_length                      (AS_length       [9 *16*16+:16*16]),
    .AS_width                       (AS_width        [9 *6 *16+:6 *16]),
    .AS_depth_of_jump               (AS_depth_of_jump[9 *16*16+:16*16]),
    .updated_input                  (AS_output       [9 *RI_DEPTH*16+:RI_DEPTH*16]),

    .RS_web                         (RS_web          [9 *1 *16+:1 *16]),
    .RS_write_addr                  (RS_write_addr   [9 *32*16+:32*16]),
    .Core_output                    (Core_output     [9 *WR_DEPTH*16+:WR_DEPTH*16]),

    .c_i_m_web                      (c_i_m_web9), 
    .c_i_m_write_addr               (c_i_m_write_addr9),
    .core_ins_input                 (core_ins_output9),

    .core_control_unit_web          (core_control_unit_web9), 
    .workload_completed_flag        (workload_completed_flag9),

    .MVMU_work_flag0                      (),
    .MVMU_work_flag1                      (),
    .MVMU_work_flag2                      (),
    .MVMU_work_flag3                      (),
    .MVMU_work_flag4                      (),
    .MVMU_work_flag5                      (),
    .MVMU_work_flag6                      (),
    .MVMU_work_flag7                      (),
    .MVMU_work_flag8                      (),
    .MVMU_work_flag9                      (),
    .MVMU_work_flag10                     (),
    .MVMU_work_flag11                     (),
    .MVMU_work_flag12                     (),
    .MVMU_work_flag13                     (),
    .MVMU_work_flag14                     (),
    .MVMU_work_flag15                     ()
);

Core Core10(
    .clk                             (clk), 
    .RSTn                            (RSTn), 

    .rewriting_speed          (rewriting_speed),

    .WS_web                         (WS_web          [10 *1  *16+:1  *16]),
    .WS_read_addr                   (WS_read_addr    [10 *32 *16+:32 *16]),
    .WS_length                      (WS_length       [10 *16 *16+:16 *16]),
    .WS_width                       (WS_width        [10 *6  *16+:6  *16]),
    .WS_depth_of_jump               (WS_depth_of_jump[10 *16 *16+:16 *16]),
    .updated_weight                 (WS_output       [10 *128*16+:128*16]),

    .AS_web                         (AS_web          [10 *1 *16+:1 *16]),
    .AS_read_addr                   (AS_read_addr    [10 *32*16+:32*16]),
    .AS_length                      (AS_length       [10 *16*16+:16*16]),
    .AS_width                       (AS_width        [10 *6 *16+:6 *16]),
    .AS_depth_of_jump               (AS_depth_of_jump[10 *16*16+:16*16]),
    .updated_input                  (AS_output       [10 *RI_DEPTH*16+:RI_DEPTH*16]),

    .RS_web                         (RS_web          [10 *1 *16+:1 *16]),
    .RS_write_addr                  (RS_write_addr   [10 *32*16+:32*16]),
    .Core_output                    (Core_output     [10 *WR_DEPTH*16+:WR_DEPTH*16]),

    .c_i_m_web                      (c_i_m_web10), 
    .c_i_m_write_addr               (c_i_m_write_addr10),
    .core_ins_input                 (core_ins_output10),

    .core_control_unit_web          (core_control_unit_web10), 
    .workload_completed_flag        (workload_completed_flag10),

    .MVMU_work_flag0                      (),
    .MVMU_work_flag1                      (),
    .MVMU_work_flag2                      (),
    .MVMU_work_flag3                      (),
    .MVMU_work_flag4                      (),
    .MVMU_work_flag5                      (),
    .MVMU_work_flag6                      (),
    .MVMU_work_flag7                      (),
    .MVMU_work_flag8                      (),
    .MVMU_work_flag9                      (),
    .MVMU_work_flag10                     (),
    .MVMU_work_flag11                     (),
    .MVMU_work_flag12                     (),
    .MVMU_work_flag13                     (),
    .MVMU_work_flag14                     (),
    .MVMU_work_flag15                     ()
);

Core Core11(
    .clk                             (clk), 
    .RSTn                            (RSTn), 

    .rewriting_speed          (rewriting_speed),

    .WS_web                         (WS_web          [11 *1  *16+:1  *16]),
    .WS_read_addr                   (WS_read_addr    [11 *32 *16+:32 *16]),
    .WS_length                      (WS_length       [11 *16 *16+:16 *16]),
    .WS_width                       (WS_width        [11 *6  *16+:6  *16]),
    .WS_depth_of_jump               (WS_depth_of_jump[11 *16 *16+:16 *16]),
    .updated_weight                 (WS_output       [11 *128*16+:128*16]),

    .AS_web                         (AS_web          [11 *1 *16+:1 *16]),
    .AS_read_addr                   (AS_read_addr    [11 *32*16+:32*16]),
    .AS_length                      (AS_length       [11 *16*16+:16*16]),
    .AS_width                       (AS_width        [11 *6 *16+:6 *16]),
    .AS_depth_of_jump               (AS_depth_of_jump[11 *16*16+:16*16]),
    .updated_input                  (AS_output       [11 *RI_DEPTH*16+:RI_DEPTH*16]),

    .RS_web                         (RS_web          [11 *1 *16+:1 *16]),
    .RS_write_addr                  (RS_write_addr   [11 *32*16+:32*16]),
    .Core_output                    (Core_output     [11 *WR_DEPTH*16+:WR_DEPTH*16]),

    .c_i_m_web                      (c_i_m_web11), 
    .c_i_m_write_addr               (c_i_m_write_addr11),
    .core_ins_input                 (core_ins_output11),

    .core_control_unit_web          (core_control_unit_web11), 
    .workload_completed_flag        (workload_completed_flag11),

    .MVMU_work_flag0                      (),
    .MVMU_work_flag1                      (),
    .MVMU_work_flag2                      (),
    .MVMU_work_flag3                      (),
    .MVMU_work_flag4                      (),
    .MVMU_work_flag5                      (),
    .MVMU_work_flag6                      (),
    .MVMU_work_flag7                      (),
    .MVMU_work_flag8                      (),
    .MVMU_work_flag9                      (),
    .MVMU_work_flag10                     (),
    .MVMU_work_flag11                     (),
    .MVMU_work_flag12                     (),
    .MVMU_work_flag13                     (),
    .MVMU_work_flag14                     (),
    .MVMU_work_flag15                     ()
);

Core Core12(
    .clk                             (clk), 
    .RSTn                            (RSTn), 

    .rewriting_speed          (rewriting_speed),

    .WS_web                         (WS_web          [12 *1  *16+:1  *16]),
    .WS_read_addr                   (WS_read_addr    [12 *32 *16+:32 *16]),
    .WS_length                      (WS_length       [12 *16 *16+:16 *16]),
    .WS_width                       (WS_width        [12 *6  *16+:6  *16]),
    .WS_depth_of_jump               (WS_depth_of_jump[12 *16 *16+:16 *16]),
    .updated_weight                 (WS_output       [12 *128*16+:128*16]),

    .AS_web                         (AS_web          [12 *1 *16+:1 *16]),
    .AS_read_addr                   (AS_read_addr    [12 *32*16+:32*16]),
    .AS_length                      (AS_length       [12 *16*16+:16*16]),
    .AS_width                       (AS_width        [12 *6 *16+:6 *16]),
    .AS_depth_of_jump               (AS_depth_of_jump[12 *16*16+:16*16]),
    .updated_input                  (AS_output       [12 *RI_DEPTH*16+:RI_DEPTH*16]),

    .RS_web                         (RS_web          [12 *1 *16+:1 *16]),
    .RS_write_addr                  (RS_write_addr   [12 *32*16+:32*16]),
    .Core_output                    (Core_output     [12 *WR_DEPTH*16+:WR_DEPTH*16]),

    .c_i_m_web                      (c_i_m_web12), 
    .c_i_m_write_addr               (c_i_m_write_addr12),
    .core_ins_input                 (core_ins_output12),

    .core_control_unit_web          (core_control_unit_web12), 
    .workload_completed_flag        (workload_completed_flag12),

    .MVMU_work_flag0                      (),
    .MVMU_work_flag1                      (),
    .MVMU_work_flag2                      (),
    .MVMU_work_flag3                      (),
    .MVMU_work_flag4                      (),
    .MVMU_work_flag5                      (),
    .MVMU_work_flag6                      (),
    .MVMU_work_flag7                      (),
    .MVMU_work_flag8                      (),
    .MVMU_work_flag9                      (),
    .MVMU_work_flag10                     (),
    .MVMU_work_flag11                     (),
    .MVMU_work_flag12                     (),
    .MVMU_work_flag13                     (),
    .MVMU_work_flag14                     (),
    .MVMU_work_flag15                     ()
);

Core Core13(
    .clk                             (clk), 
    .RSTn                            (RSTn), 

    .rewriting_speed          (rewriting_speed),

    .WS_web                         (WS_web          [13 *1  *16+:1  *16]),
    .WS_read_addr                   (WS_read_addr    [13 *32 *16+:32 *16]),
    .WS_length                      (WS_length       [13 *16 *16+:16 *16]),
    .WS_width                       (WS_width        [13 *6  *16+:6  *16]),
    .WS_depth_of_jump               (WS_depth_of_jump[13 *16 *16+:16 *16]),
    .updated_weight                 (WS_output       [13 *128*16+:128*16]),

    .AS_web                         (AS_web          [13 *1 *16+:1 *16]),
    .AS_read_addr                   (AS_read_addr    [13 *32*16+:32*16]),
    .AS_length                      (AS_length       [13 *16*16+:16*16]),
    .AS_width                       (AS_width        [13 *6 *16+:6 *16]),
    .AS_depth_of_jump               (AS_depth_of_jump[13 *16*16+:16*16]),
    .updated_input                  (AS_output       [13 *RI_DEPTH*16+:RI_DEPTH*16]),

    .RS_web                         (RS_web          [13 *1 *16+:1 *16]),
    .RS_write_addr                  (RS_write_addr   [13 *32*16+:32*16]),
    .Core_output                    (Core_output     [13 *WR_DEPTH*16+:WR_DEPTH*16]),

    .c_i_m_web                      (c_i_m_web13), 
    .c_i_m_write_addr               (c_i_m_write_addr13),
    .core_ins_input                 (core_ins_output13),

    .core_control_unit_web          (core_control_unit_web13), 
    .workload_completed_flag        (workload_completed_flag13),

    .MVMU_work_flag0                      (),
    .MVMU_work_flag1                      (),
    .MVMU_work_flag2                      (),
    .MVMU_work_flag3                      (),
    .MVMU_work_flag4                      (),
    .MVMU_work_flag5                      (),
    .MVMU_work_flag6                      (),
    .MVMU_work_flag7                      (),
    .MVMU_work_flag8                      (),
    .MVMU_work_flag9                      (),
    .MVMU_work_flag10                     (),
    .MVMU_work_flag11                     (),
    .MVMU_work_flag12                     (),
    .MVMU_work_flag13                     (),
    .MVMU_work_flag14                     (),
    .MVMU_work_flag15                     ()
);

Core Core14(
    .clk                             (clk), 
    .RSTn                            (RSTn), 

    .rewriting_speed          (rewriting_speed),

    .WS_web                         (WS_web          [14 *1  *16+:1  *16]),
    .WS_read_addr                   (WS_read_addr    [14 *32 *16+:32 *16]),
    .WS_length                      (WS_length       [14 *16 *16+:16 *16]),
    .WS_width                       (WS_width        [14 *6  *16+:6  *16]),
    .WS_depth_of_jump               (WS_depth_of_jump[14 *16 *16+:16 *16]),
    .updated_weight                 (WS_output       [14 *128*16+:128*16]),

    .AS_web                         (AS_web          [14 *1 *16+:1 *16]),
    .AS_read_addr                   (AS_read_addr    [14 *32*16+:32*16]),
    .AS_length                      (AS_length       [14 *16*16+:16*16]),
    .AS_width                       (AS_width        [14 *6 *16+:6 *16]),
    .AS_depth_of_jump               (AS_depth_of_jump[14 *16*16+:16*16]),
    .updated_input                  (AS_output       [14 *RI_DEPTH*16+:RI_DEPTH*16]),

    .RS_web                         (RS_web          [14 *1 *16+:1 *16]),
    .RS_write_addr                  (RS_write_addr   [14 *32*16+:32*16]),
    .Core_output                    (Core_output     [14 *WR_DEPTH*16+:WR_DEPTH*16]),

    .c_i_m_web                      (c_i_m_web14), 
    .c_i_m_write_addr               (c_i_m_write_addr14),
    .core_ins_input                 (core_ins_output14),

    .core_control_unit_web          (core_control_unit_web14), 
    .workload_completed_flag        (workload_completed_flag14),

    .MVMU_work_flag0                      (),
    .MVMU_work_flag1                      (),
    .MVMU_work_flag2                      (),
    .MVMU_work_flag3                      (),
    .MVMU_work_flag4                      (),
    .MVMU_work_flag5                      (),
    .MVMU_work_flag6                      (),
    .MVMU_work_flag7                      (),
    .MVMU_work_flag8                      (),
    .MVMU_work_flag9                      (),
    .MVMU_work_flag10                     (),
    .MVMU_work_flag11                     (),
    .MVMU_work_flag12                     (),
    .MVMU_work_flag13                     (),
    .MVMU_work_flag14                     (),
    .MVMU_work_flag15                     ()
);

Core Core15(
    .clk                             (clk), 
    .RSTn                            (RSTn), 

    .rewriting_speed          (rewriting_speed),

    .WS_web                         (WS_web          [15 *1  *16+:1  *16]),
    .WS_read_addr                   (WS_read_addr    [15 *32 *16+:32 *16]),
    .WS_length                      (WS_length       [15 *16 *16+:16 *16]),
    .WS_width                       (WS_width        [15 *6  *16+:6  *16]),
    .WS_depth_of_jump               (WS_depth_of_jump[15 *16 *16+:16 *16]),
    .updated_weight                 (WS_output       [15 *128*16+:128*16]),

    .AS_web                         (AS_web          [15 *1 *16+:1 *16]),
    .AS_read_addr                   (AS_read_addr    [15 *32*16+:32*16]),
    .AS_length                      (AS_length       [15 *16*16+:16*16]),
    .AS_width                       (AS_width        [15 *6 *16+:6 *16]),
    .AS_depth_of_jump               (AS_depth_of_jump[15 *16*16+:16*16]),
    .updated_input                  (AS_output       [15 *RI_DEPTH*16+:RI_DEPTH*16]),

    .RS_web                         (RS_web          [15 *1 *16+:1 *16]),
    .RS_write_addr                  (RS_write_addr   [15 *32*16+:32*16]),
    .Core_output                    (Core_output     [15 *WR_DEPTH*16+:WR_DEPTH*16]),

    .c_i_m_web                      (c_i_m_web15), 
    .c_i_m_write_addr               (c_i_m_write_addr15),
    .core_ins_input                 (core_ins_output15),

    .core_control_unit_web          (core_control_unit_web15), 
    .workload_completed_flag        (workload_completed_flag15),

    .MVMU_work_flag0                      (),
    .MVMU_work_flag1                      (),
    .MVMU_work_flag2                      (),
    .MVMU_work_flag3                      (),
    .MVMU_work_flag4                      (),
    .MVMU_work_flag5                      (),
    .MVMU_work_flag6                      (),
    .MVMU_work_flag7                      (),
    .MVMU_work_flag8                      (),
    .MVMU_work_flag9                      (),
    .MVMU_work_flag10                     (),
    .MVMU_work_flag11                     (),
    .MVMU_work_flag12                     (),
    .MVMU_work_flag13                     (),
    .MVMU_work_flag14                     (),
    .MVMU_work_flag15                     ()
);

endmodule

