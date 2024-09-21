module Core
#(  parameter INS_RW_DEPTH = 4096,
    parameter RW_DEPTH     = 8192,        // read weight bandwidth: 32*32*8
    parameter RI_DEPTH     = 16384,       // read input bandwidth: 32*8*64
    parameter WR_DEPTH     = 16384,       // write result bandwidth
    parameter MVMU_I_DEPTH = 256,
    parameter INSTRUCTION_WIDTH = 64
)
(
    input           clk,
    input           RSTn,       //enable

    input [7:0]     rewriting_speed,

    // Weight_SRAM control
    output reg [1  *16-1:0] WS_web,              // Weight_SRAM read control
    output reg [32 *16-1:0] WS_read_addr,        // Weight_SRAM read addr
    output reg [16 *16-1:0] WS_length,
    output reg [6  *16-1:0] WS_width,
    output reg [16 *16-1:0] WS_depth_of_jump,
    input      [128*16-1:0] updated_weight,

    // Activation_SRAM control
    output reg [1 *16-1:0] AS_web,              // A_SRAM read control
    output reg [32*16-1:0] AS_read_addr,        // A_SRAM read addr
    output reg [16*16-1:0] AS_length,
    output reg [6 *16-1:0] AS_width,
    output reg [16*16-1:0] AS_depth_of_jump,
    input      [RI_DEPTH*16-1:0] updated_input,

    // Result_SRAM control
    output reg [1 *16-1:0] RS_web,               // Result_SRAM write control
    output reg [32*16-1:0] RS_write_addr,        // Result_SRAM write addr
    output reg [WR_DEPTH*16-1:0] Core_output,

    // Core_instruction_memory
    input        c_i_m_web,
    input [15:0] c_i_m_write_addr,
    input [INS_RW_DEPTH-1:0] core_ins_input,

    // Core_control_unit
    input      core_control_unit_web,
    output reg workload_completed_flag,

    // MVMU
    output reg [63:0]  MVMU_work_flag0,
    output reg [63:0]  MVMU_work_flag1,
    output reg [63:0]  MVMU_work_flag2,
    output reg [63:0]  MVMU_work_flag3,
    output reg [63:0]  MVMU_work_flag4,
    output reg [63:0]  MVMU_work_flag5,
    output reg [63:0]  MVMU_work_flag6,
    output reg [63:0]  MVMU_work_flag7,
    output reg [63:0]  MVMU_work_flag8,
    output reg [63:0]  MVMU_work_flag9,
    output reg [63:0]  MVMU_work_flag10,
    output reg [63:0]  MVMU_work_flag11,
    output reg [63:0]  MVMU_work_flag12,
    output reg [63:0]  MVMU_work_flag13,
    output reg [63:0]  MVMU_work_flag14,
    output reg [63:0]  MVMU_work_flag15  
);

//--------------Internal variables---------------- 


//--------------Code Starts Here------------------ 
initial begin
    
end

// Core_instruction_memory
wire [15:0] instruction_addr0;
wire [15:0] instruction_addr1;
wire [15:0] instruction_addr2;
wire [15:0] instruction_addr3;
wire [15:0] instruction_addr4;
wire [15:0] instruction_addr5;
wire [15:0] instruction_addr6;
wire [15:0] instruction_addr7;
wire [15:0] instruction_addr8;
wire [15:0] instruction_addr9;
wire [15:0] instruction_addr10;
wire [15:0] instruction_addr11;
wire [15:0] instruction_addr12;
wire [15:0] instruction_addr13;
wire [15:0] instruction_addr14;
wire [15:0] instruction_addr15;
wire [63:0] new_instruction0;
wire [63:0] new_instruction1;
wire [63:0] new_instruction2;
wire [63:0] new_instruction3;
wire [63:0] new_instruction4;
wire [63:0] new_instruction5;
wire [63:0] new_instruction6;
wire [63:0] new_instruction7;
wire [63:0] new_instruction8;
wire [63:0] new_instruction9;
wire [63:0] new_instruction10;
wire [63:0] new_instruction11;
wire [63:0] new_instruction12;
wire [63:0] new_instruction13;
wire [63:0] new_instruction14;
wire [63:0] new_instruction15;

// CHAS_execution_unit
wire                         CCU_workload_completed_flag0;
wire                         CCU_workload_completed_flag1;
wire                         CCU_workload_completed_flag2;
wire                         CCU_workload_completed_flag3;
wire                         CCU_workload_completed_flag4;
wire                         CCU_workload_completed_flag5;
wire                         CCU_workload_completed_flag6;
wire                         CCU_workload_completed_flag7;
wire                         CCU_workload_completed_flag8;
wire                         CCU_workload_completed_flag9;
wire                         CCU_workload_completed_flag10;
wire                         CCU_workload_completed_flag11;
wire                         CCU_workload_completed_flag12;
wire                         CCU_workload_completed_flag13;
wire                         CCU_workload_completed_flag14;
wire                         CCU_workload_completed_flag15;
wire [INSTRUCTION_WIDTH-1:0] CCU_instruction0;
wire [INSTRUCTION_WIDTH-1:0] CCU_instruction1;
wire [INSTRUCTION_WIDTH-1:0] CCU_instruction2;
wire [INSTRUCTION_WIDTH-1:0] CCU_instruction3;
wire [INSTRUCTION_WIDTH-1:0] CCU_instruction4;
wire [INSTRUCTION_WIDTH-1:0] CCU_instruction5;
wire [INSTRUCTION_WIDTH-1:0] CCU_instruction6;
wire [INSTRUCTION_WIDTH-1:0] CCU_instruction7;
wire [INSTRUCTION_WIDTH-1:0] CCU_instruction8;
wire [INSTRUCTION_WIDTH-1:0] CCU_instruction9;
wire [INSTRUCTION_WIDTH-1:0] CCU_instruction10;
wire [INSTRUCTION_WIDTH-1:0] CCU_instruction11;
wire [INSTRUCTION_WIDTH-1:0] CCU_instruction12;
wire [INSTRUCTION_WIDTH-1:0] CCU_instruction13;
wire [INSTRUCTION_WIDTH-1:0] CCU_instruction14;
wire [INSTRUCTION_WIDTH-1:0] CCU_instruction15;
wire                         CCU_finish_flag0;
wire                         CCU_finish_flag1;
wire                         CCU_finish_flag2;
wire                         CCU_finish_flag3;
wire                         CCU_finish_flag4;
wire                         CCU_finish_flag5;
wire                         CCU_finish_flag6;
wire                         CCU_finish_flag7;
wire                         CCU_finish_flag8;
wire                         CCU_finish_flag9;
wire                         CCU_finish_flag10;
wire                         CCU_finish_flag11;
wire                         CCU_finish_flag12;
wire                         CCU_finish_flag13;
wire                         CCU_finish_flag14;
wire                         CCU_finish_flag15;
wire                         CCU_start_flag0;
wire                         CCU_start_flag1;
wire                         CCU_start_flag2;
wire                         CCU_start_flag3;
wire                         CCU_start_flag4;
wire                         CCU_start_flag5;
wire                         CCU_start_flag6;
wire                         CCU_start_flag7;
wire                         CCU_start_flag8;
wire                         CCU_start_flag9;
wire                         CCU_start_flag10;
wire                         CCU_start_flag11;
wire                         CCU_start_flag12;
wire                         CCU_start_flag13;
wire                         CCU_start_flag14;
wire                         CCU_start_flag15;

// Core_control_unit
wire         wire_workload_completed_flag;

wire         wire_WS_web0;              // Weight_SRAM read control
wire         wire_WS_web1;
wire         wire_WS_web2;
wire         wire_WS_web3;
wire         wire_WS_web4;
wire         wire_WS_web5;
wire         wire_WS_web6;
wire         wire_WS_web7;
wire         wire_WS_web8;
wire         wire_WS_web9;
wire         wire_WS_web10;
wire         wire_WS_web11;
wire         wire_WS_web12;
wire         wire_WS_web13;
wire         wire_WS_web14;
wire         wire_WS_web15;
wire [31:0]  wire_WS_read_addr0;        // Weight_SRAM read addr
wire [31:0]  wire_WS_read_addr1;
wire [31:0]  wire_WS_read_addr2;
wire [31:0]  wire_WS_read_addr3;
wire [31:0]  wire_WS_read_addr4;
wire [31:0]  wire_WS_read_addr5;
wire [31:0]  wire_WS_read_addr6;
wire [31:0]  wire_WS_read_addr7;
wire [31:0]  wire_WS_read_addr8;
wire [31:0]  wire_WS_read_addr9;
wire [31:0]  wire_WS_read_addr10;
wire [31:0]  wire_WS_read_addr11;
wire [31:0]  wire_WS_read_addr12;
wire [31:0]  wire_WS_read_addr13;
wire [31:0]  wire_WS_read_addr14;
wire [31:0]  wire_WS_read_addr15;
wire [15:0]  wire_WS_length0;
wire [15:0]  wire_WS_length1;
wire [15:0]  wire_WS_length2;
wire [15:0]  wire_WS_length3;
wire [15:0]  wire_WS_length4;
wire [15:0]  wire_WS_length5;
wire [15:0]  wire_WS_length6;
wire [15:0]  wire_WS_length7;
wire [15:0]  wire_WS_length8;
wire [15:0]  wire_WS_length9;
wire [15:0]  wire_WS_length10;
wire [15:0]  wire_WS_length11;
wire [15:0]  wire_WS_length12;
wire [15:0]  wire_WS_length13;
wire [15:0]  wire_WS_length14;
wire [15:0]  wire_WS_length15;
wire [5:0]   wire_WS_width0;
wire [5:0]   wire_WS_width1;
wire [5:0]   wire_WS_width2;
wire [5:0]   wire_WS_width3;
wire [5:0]   wire_WS_width4;
wire [5:0]   wire_WS_width5;
wire [5:0]   wire_WS_width6;
wire [5:0]   wire_WS_width7;
wire [5:0]   wire_WS_width8;
wire [5:0]   wire_WS_width9;
wire [5:0]   wire_WS_width10;
wire [5:0]   wire_WS_width11;
wire [5:0]   wire_WS_width12;
wire [5:0]   wire_WS_width13;
wire [5:0]   wire_WS_width14;
wire [5:0]   wire_WS_width15;
wire [15:0]  wire_WS_depth_of_jump0;
wire [15:0]  wire_WS_depth_of_jump1;
wire [15:0]  wire_WS_depth_of_jump2;
wire [15:0]  wire_WS_depth_of_jump3;
wire [15:0]  wire_WS_depth_of_jump4;
wire [15:0]  wire_WS_depth_of_jump5;
wire [15:0]  wire_WS_depth_of_jump6;
wire [15:0]  wire_WS_depth_of_jump7;
wire [15:0]  wire_WS_depth_of_jump8;
wire [15:0]  wire_WS_depth_of_jump9;
wire [15:0]  wire_WS_depth_of_jump10;
wire [15:0]  wire_WS_depth_of_jump11;
wire [15:0]  wire_WS_depth_of_jump12;
wire [15:0]  wire_WS_depth_of_jump13;
wire [15:0]  wire_WS_depth_of_jump14;
wire [15:0]  wire_WS_depth_of_jump15;

wire         wire_AS_web0;              // A_SRAM read control
wire         wire_AS_web1;
wire         wire_AS_web2;
wire         wire_AS_web3;
wire         wire_AS_web4;
wire         wire_AS_web5;
wire         wire_AS_web6;
wire         wire_AS_web7;
wire         wire_AS_web8;
wire         wire_AS_web9;
wire         wire_AS_web10;
wire         wire_AS_web11;
wire         wire_AS_web12;
wire         wire_AS_web13;
wire         wire_AS_web14;
wire         wire_AS_web15;
wire [31:0]  wire_AS_read_addr0;        // A_SRAM read addr
wire [31:0]  wire_AS_read_addr1;
wire [31:0]  wire_AS_read_addr2;
wire [31:0]  wire_AS_read_addr3;
wire [31:0]  wire_AS_read_addr4;
wire [31:0]  wire_AS_read_addr5;
wire [31:0]  wire_AS_read_addr6;
wire [31:0]  wire_AS_read_addr7;
wire [31:0]  wire_AS_read_addr8;
wire [31:0]  wire_AS_read_addr9;
wire [31:0]  wire_AS_read_addr10;
wire [31:0]  wire_AS_read_addr11;
wire [31:0]  wire_AS_read_addr12;
wire [31:0]  wire_AS_read_addr13;
wire [31:0]  wire_AS_read_addr14;
wire [31:0]  wire_AS_read_addr15;
wire [15:0]  wire_AS_length0;
wire [15:0]  wire_AS_length1;
wire [15:0]  wire_AS_length2;
wire [15:0]  wire_AS_length3;
wire [15:0]  wire_AS_length4;
wire [15:0]  wire_AS_length5;
wire [15:0]  wire_AS_length6;
wire [15:0]  wire_AS_length7;
wire [15:0]  wire_AS_length8;
wire [15:0]  wire_AS_length9;
wire [15:0]  wire_AS_length10;
wire [15:0]  wire_AS_length11;
wire [15:0]  wire_AS_length12;
wire [15:0]  wire_AS_length13;
wire [15:0]  wire_AS_length14;
wire [15:0]  wire_AS_length15;
wire [5:0]   wire_AS_width0;
wire [5:0]   wire_AS_width1;
wire [5:0]   wire_AS_width2;
wire [5:0]   wire_AS_width3;
wire [5:0]   wire_AS_width4;
wire [5:0]   wire_AS_width5;
wire [5:0]   wire_AS_width6;
wire [5:0]   wire_AS_width7;
wire [5:0]   wire_AS_width8;
wire [5:0]   wire_AS_width9;
wire [5:0]   wire_AS_width10;
wire [5:0]   wire_AS_width11;
wire [5:0]   wire_AS_width12;
wire [5:0]   wire_AS_width13;
wire [5:0]   wire_AS_width14;
wire [5:0]   wire_AS_width15;
wire [15:0]  wire_AS_depth_of_jump0;
wire [15:0]  wire_AS_depth_of_jump1;
wire [15:0]  wire_AS_depth_of_jump2;
wire [15:0]  wire_AS_depth_of_jump3;
wire [15:0]  wire_AS_depth_of_jump4;
wire [15:0]  wire_AS_depth_of_jump5;
wire [15:0]  wire_AS_depth_of_jump6;
wire [15:0]  wire_AS_depth_of_jump7;
wire [15:0]  wire_AS_depth_of_jump8;
wire [15:0]  wire_AS_depth_of_jump9;
wire [15:0]  wire_AS_depth_of_jump10;
wire [15:0]  wire_AS_depth_of_jump11;
wire [15:0]  wire_AS_depth_of_jump12;
wire [15:0]  wire_AS_depth_of_jump13;
wire [15:0]  wire_AS_depth_of_jump14;
wire [15:0]  wire_AS_depth_of_jump15;

wire         wire_RS_web0;               // Result_SRAM write control
wire         wire_RS_web1;
wire         wire_RS_web2;
wire         wire_RS_web3;
wire         wire_RS_web4;
wire         wire_RS_web5;
wire         wire_RS_web6;
wire         wire_RS_web7;
wire         wire_RS_web8;
wire         wire_RS_web9;
wire         wire_RS_web10;
wire         wire_RS_web11;
wire         wire_RS_web12;
wire         wire_RS_web13;
wire         wire_RS_web14;
wire         wire_RS_web15;
wire [31:0]  wire_RS_write_addr0;        // Result_SRAM write addr
wire [31:0]  wire_RS_write_addr1;
wire [31:0]  wire_RS_write_addr2;
wire [31:0]  wire_RS_write_addr3;
wire [31:0]  wire_RS_write_addr4;
wire [31:0]  wire_RS_write_addr5;
wire [31:0]  wire_RS_write_addr6;
wire [31:0]  wire_RS_write_addr7;
wire [31:0]  wire_RS_write_addr8;
wire [31:0]  wire_RS_write_addr9;
wire [31:0]  wire_RS_write_addr10;
wire [31:0]  wire_RS_write_addr11;
wire [31:0]  wire_RS_write_addr12;
wire [31:0]  wire_RS_write_addr13;
wire [31:0]  wire_RS_write_addr14;
wire [31:0]  wire_RS_write_addr15;

wire [1:0]   wire_S_m_web;               // Shared_memory read control
wire [31:0]  wire_S_m_read_addr;         // Shared_memory read addr
wire [15:0]  wire_length;
wire [5:0]   wire_width;
wire [15:0]  wire_depth_of_jump;
wire [31:0]  wire_S_m_write_addr;        // Shared_memory write addr

wire [127:0] MU_output_addr0;
wire [127:0] MU_output_addr1;
wire [127:0] MU_output_addr2;
wire [127:0] MU_output_addr3;

wire [15:0] CCU_MVMU_web0;
wire [15:0] CCU_MVMU_web1;
wire [15:0] CCU_MVMU_web2;
wire [15:0] CCU_MVMU_web3;
wire [63:0] CCU_MVMU_addr0;                 // write/read/PIM/clean/PIM_Pro
wire [63:0] CCU_MVMU_addr1;
wire [63:0] CCU_MVMU_addr2;
wire [63:0] CCU_MVMU_addr3;
wire [3:0]  MVMU_pim_pro_o_flag0;       // PIM_Pro output flag
wire [3:0]  MVMU_pim_pro_o_flag1;
wire [3:0]  MVMU_pim_pro_o_flag2;
wire [3:0]  MVMU_pim_pro_o_flag3;

// MU
wire [23:0]  MU_web0;                     // write/read/clean control
wire [23:0]  MU_web1;
wire [23:0]  MU_web2;
wire [23:0]  MU_web3;

wire [31:0] MU_core_output_addr0;
wire [31:0] MU_core_output_addr1;
wire [31:0] MU_core_output_addr2;
wire [31:0] MU_core_output_addr3;
wire [31:0] MU_core_output_addr4;
wire [31:0] MU_core_output_addr5;
wire [31:0] MU_core_output_addr6;
wire [31:0] MU_core_output_addr7;
wire [31:0] MU_core_output_addr8;
wire [31:0] MU_core_output_addr9;
wire [31:0] MU_core_output_addr10;
wire [31:0] MU_core_output_addr11;
wire [31:0] MU_core_output_addr12;
wire [31:0] MU_core_output_addr13;
wire [31:0] MU_core_output_addr14;
wire [31:0] MU_core_output_addr15;
wire [31:0] MU_I_input_addr0;
wire [31:0] MU_I_input_addr1;
wire [31:0] MU_I_input_addr2;
wire [31:0] MU_I_input_addr3;
wire [31:0] MU_I_input_addr4;
wire [31:0] MU_I_input_addr5;
wire [31:0] MU_I_input_addr6;
wire [31:0] MU_I_input_addr7;
wire [31:0] MU_I_input_addr8;
wire [31:0] MU_I_input_addr9;
wire [31:0] MU_I_input_addr10;
wire [31:0] MU_I_input_addr11;
wire [31:0] MU_I_input_addr12;
wire [31:0] MU_I_input_addr13;
wire [31:0] MU_I_input_addr14;
wire [31:0] MU_I_input_addr15;
wire [WR_DEPTH-1:0] wire_core_output0;
wire [WR_DEPTH-1:0] wire_core_output1;
wire [WR_DEPTH-1:0] wire_core_output2;
wire [WR_DEPTH-1:0] wire_core_output3;
wire [WR_DEPTH-1:0] wire_core_output4;
wire [WR_DEPTH-1:0] wire_core_output5;
wire [WR_DEPTH-1:0] wire_core_output6;
wire [WR_DEPTH-1:0] wire_core_output7;
wire [WR_DEPTH-1:0] wire_core_output8;
wire [WR_DEPTH-1:0] wire_core_output9;
wire [WR_DEPTH-1:0] wire_core_output10;
wire [WR_DEPTH-1:0] wire_core_output11;
wire [WR_DEPTH-1:0] wire_core_output12;
wire [WR_DEPTH-1:0] wire_core_output13;
wire [WR_DEPTH-1:0] wire_core_output14;
wire [WR_DEPTH-1:0] wire_core_output15;

wire [7:0]  Batch_of_data0;                 // Select the input addr required by the MVMU 
wire [7:0]  Batch_of_data1;
wire [7:0]  Batch_of_data2;
wire [7:0]  Batch_of_data3;
wire [7:0]  Batch_of_data4;
wire [7:0]  Batch_of_data5;
wire [7:0]  Batch_of_data6;
wire [7:0]  Batch_of_data7;
wire [7:0]  Batch_of_data8;
wire [7:0]  Batch_of_data9;
wire [7:0]  Batch_of_data10;
wire [7:0]  Batch_of_data11;
wire [7:0]  Batch_of_data12;
wire [7:0]  Batch_of_data13;
wire [7:0]  Batch_of_data14;
wire [7:0]  Batch_of_data15;

wire [MVMU_I_DEPTH-1:0] MVMU_input0;         //MVMU0 input
wire [MVMU_I_DEPTH-1:0] MVMU_input1;         //MVMU1 input
wire [MVMU_I_DEPTH-1:0] MVMU_input2;         //MVMU2 input
wire [MVMU_I_DEPTH-1:0] MVMU_input3;         //MVMU3 input
wire [MVMU_I_DEPTH-1:0] MVMU_input4;         //MVMU4 input
wire [MVMU_I_DEPTH-1:0] MVMU_input5;         //MVMU5 input
wire [MVMU_I_DEPTH-1:0] MVMU_input6;         //MVMU6 input
wire [MVMU_I_DEPTH-1:0] MVMU_input7;         //MVMU7 input
wire [MVMU_I_DEPTH-1:0] MVMU_input8;         //MVMU8 input
wire [MVMU_I_DEPTH-1:0] MVMU_input9;         //MVMU9 input
wire [MVMU_I_DEPTH-1:0] MVMU_input10;         //MVMU10 input
wire [MVMU_I_DEPTH-1:0] MVMU_input11;         //MVMU11 input
wire [MVMU_I_DEPTH-1:0] MVMU_input12;         //MVMU12 input
wire [MVMU_I_DEPTH-1:0] MVMU_input13;         //MVMU13 input
wire [MVMU_I_DEPTH-1:0] MVMU_input14;         //MVMU14 input
wire [MVMU_I_DEPTH-1:0] MVMU_input15;         //MVMU15 input

wire [31:0] MVMU_output_addr0;
wire [31:0] MVMU_output_addr1;
wire [31:0] MVMU_output_addr2;
wire [31:0] MVMU_output_addr3;
wire [31:0] MVMU_output_addr4;
wire [31:0] MVMU_output_addr5;
wire [31:0] MVMU_output_addr6;
wire [31:0] MVMU_output_addr7;
wire [31:0] MVMU_output_addr8;
wire [31:0] MVMU_output_addr9;
wire [31:0] MVMU_output_addr10;
wire [31:0] MVMU_output_addr11;
wire [31:0] MVMU_output_addr12;
wire [31:0] MVMU_output_addr13;
wire [31:0] MVMU_output_addr14;
wire [31:0] MVMU_output_addr15;

wire [MVMU_I_DEPTH-1:0] MVMU_output0;        //MVMU0 output
wire [MVMU_I_DEPTH-1:0] MVMU_output1;        //MVMU1 output
wire [MVMU_I_DEPTH-1:0] MVMU_output2;        //MVMU2 output
wire [MVMU_I_DEPTH-1:0] MVMU_output3;        //MVMU3 output
wire [MVMU_I_DEPTH-1:0] MVMU_output4;        //MVMU4 output
wire [MVMU_I_DEPTH-1:0] MVMU_output5;        //MVMU5 output
wire [MVMU_I_DEPTH-1:0] MVMU_output6;        //MVMU6 output
wire [MVMU_I_DEPTH-1:0] MVMU_output7;        //MVMU7 output
wire [MVMU_I_DEPTH-1:0] MVMU_output8;        //MVMU8 output
wire [MVMU_I_DEPTH-1:0] MVMU_output9;        //MVMU9 output
wire [MVMU_I_DEPTH-1:0] MVMU_output10;        //MVMU10 output
wire [MVMU_I_DEPTH-1:0] MVMU_output11;        //MVMU11 output
wire [MVMU_I_DEPTH-1:0] MVMU_output12;        //MVMU12 output
wire [MVMU_I_DEPTH-1:0] MVMU_output13;        //MVMU13 output
wire [MVMU_I_DEPTH-1:0] MVMU_output14;        //MVMU14 output
wire [MVMU_I_DEPTH-1:0] MVMU_output15;        //MVMU15 output

// MVMUs
wire [3:0] MVMU_web0;
wire [3:0] MVMU_web1;
wire [3:0] MVMU_web2;
wire [3:0] MVMU_web3;
wire [3:0] MVMU_web4;
wire [3:0] MVMU_web5;
wire [3:0] MVMU_web6;
wire [3:0] MVMU_web7;
wire [3:0] MVMU_web8;
wire [3:0] MVMU_web9;
wire [3:0] MVMU_web10;
wire [3:0] MVMU_web11;
wire [3:0] MVMU_web12;
wire [3:0] MVMU_web13;
wire [3:0] MVMU_web14;
wire [3:0] MVMU_web15;

wire [15:0] MVMU_addr0;
wire [15:0] MVMU_addr1;
wire [15:0] MVMU_addr2;
wire [15:0] MVMU_addr3;
wire [15:0] MVMU_addr4;
wire [15:0] MVMU_addr5;
wire [15:0] MVMU_addr6;
wire [15:0] MVMU_addr7;
wire [15:0] MVMU_addr8;
wire [15:0] MVMU_addr9;
wire [15:0] MVMU_addr10;
wire [15:0] MVMU_addr11;
wire [15:0] MVMU_addr12;
wire [15:0] MVMU_addr13;
wire [15:0] MVMU_addr14;
wire [15:0] MVMU_addr15;

wire [7:0] pim_q0;
wire [7:0] pim_q1;
wire [7:0] pim_q2;
wire [7:0] pim_q3;
wire [7:0] pim_q4;
wire [7:0] pim_q5;
wire [7:0] pim_q6;
wire [7:0] pim_q7;
wire [7:0] pim_q8;
wire [7:0] pim_q9;
wire [7:0] pim_q10;
wire [7:0] pim_q11;
wire [7:0] pim_q12;
wire [7:0] pim_q13;
wire [7:0] pim_q14;
wire [7:0] pim_q15;

wire pim_pro_o_flag0;
wire pim_pro_o_flag1;
wire pim_pro_o_flag2;
wire pim_pro_o_flag3;
wire pim_pro_o_flag4;
wire pim_pro_o_flag5;
wire pim_pro_o_flag6;
wire pim_pro_o_flag7;
wire pim_pro_o_flag8;
wire pim_pro_o_flag9;
wire pim_pro_o_flag10;
wire pim_pro_o_flag11;
wire pim_pro_o_flag12;
wire pim_pro_o_flag13;
wire pim_pro_o_flag14;
wire pim_pro_o_flag15;

wire [63:0] wire_MVMU_work_flag0;
wire [63:0] wire_MVMU_work_flag1;
wire [63:0] wire_MVMU_work_flag2;
wire [63:0] wire_MVMU_work_flag3;
wire [63:0] wire_MVMU_work_flag4;
wire [63:0] wire_MVMU_work_flag5;
wire [63:0] wire_MVMU_work_flag6;
wire [63:0] wire_MVMU_work_flag7;
wire [63:0] wire_MVMU_work_flag8;
wire [63:0] wire_MVMU_work_flag9;
wire [63:0] wire_MVMU_work_flag10;
wire [63:0] wire_MVMU_work_flag11;
wire [63:0] wire_MVMU_work_flag12;
wire [63:0] wire_MVMU_work_flag13;
wire [63:0] wire_MVMU_work_flag14;
wire [63:0] wire_MVMU_work_flag15;

wire [7:0] q0;
wire [7:0] q1;
wire [7:0] q2;
wire [7:0] q3;
wire [7:0] q4;
wire [7:0] q5;
wire [7:0] q6;
wire [7:0] q7;
wire [7:0] q8;
wire [7:0] q9;
wire [7:0] q10;
wire [7:0] q11;
wire [7:0] q12;
wire [7:0] q13;
wire [7:0] q14;
wire [7:0] q15;

// Connect
assign MVMU_output_addr0 [31:0] = MU_output_addr0[0  +:32];
assign MVMU_output_addr1 [31:0] = MU_output_addr0[32 +:32];
assign MVMU_output_addr2 [31:0] = MU_output_addr0[64 +:32];
assign MVMU_output_addr3 [31:0] = MU_output_addr0[96 +:32];
assign MVMU_output_addr4 [31:0] = MU_output_addr1[0  +:32];
assign MVMU_output_addr5 [31:0] = MU_output_addr1[32 +:32];
assign MVMU_output_addr6 [31:0] = MU_output_addr1[64 +:32];
assign MVMU_output_addr7 [31:0] = MU_output_addr1[96 +:32];
assign MVMU_output_addr8 [31:0] = MU_output_addr2[0  +:32];
assign MVMU_output_addr9 [31:0] = MU_output_addr2[32 +:32];
assign MVMU_output_addr10[31:0] = MU_output_addr2[64 +:32];
assign MVMU_output_addr11[31:0] = MU_output_addr2[96 +:32];
assign MVMU_output_addr12[31:0] = MU_output_addr3[0  +:32];
assign MVMU_output_addr13[31:0] = MU_output_addr3[32 +:32];
assign MVMU_output_addr14[31:0] = MU_output_addr3[64 +:32];
assign MVMU_output_addr15[31:0] = MU_output_addr3[96 +:32];

assign MVMU_web0 [3:0] = CCU_MVMU_web0[0 +:4];
assign MVMU_web1 [3:0] = CCU_MVMU_web0[4 +:4];
assign MVMU_web2 [3:0] = CCU_MVMU_web0[8 +:4];
assign MVMU_web3 [3:0] = CCU_MVMU_web0[12+:4];
assign MVMU_web4 [3:0] = CCU_MVMU_web1[0 +:4];
assign MVMU_web5 [3:0] = CCU_MVMU_web1[4 +:4];
assign MVMU_web6 [3:0] = CCU_MVMU_web1[8 +:4];
assign MVMU_web7 [3:0] = CCU_MVMU_web1[12+:4];
assign MVMU_web8 [3:0] = CCU_MVMU_web2[0 +:4];
assign MVMU_web9 [3:0] = CCU_MVMU_web2[4 +:4];
assign MVMU_web10[3:0] = CCU_MVMU_web2[8 +:4];
assign MVMU_web11[3:0] = CCU_MVMU_web2[12+:4];
assign MVMU_web12[3:0] = CCU_MVMU_web3[0 +:4];
assign MVMU_web13[3:0] = CCU_MVMU_web3[4 +:4];
assign MVMU_web14[3:0] = CCU_MVMU_web3[8 +:4];
assign MVMU_web15[3:0] = CCU_MVMU_web3[12+:4];

assign MVMU_addr0 [15:0] = CCU_MVMU_addr0[0  +:15];
assign MVMU_addr1 [15:0] = CCU_MVMU_addr0[16 +:15];
assign MVMU_addr2 [15:0] = CCU_MVMU_addr0[32 +:15];
assign MVMU_addr3 [15:0] = CCU_MVMU_addr0[48 +:15];
assign MVMU_addr4 [15:0] = CCU_MVMU_addr1[0  +:15];
assign MVMU_addr5 [15:0] = CCU_MVMU_addr1[16 +:15];
assign MVMU_addr6 [15:0] = CCU_MVMU_addr1[32 +:15];
assign MVMU_addr7 [15:0] = CCU_MVMU_addr1[48 +:15];
assign MVMU_addr8 [15:0] = CCU_MVMU_addr2[0  +:15];
assign MVMU_addr9 [15:0] = CCU_MVMU_addr2[16 +:15];
assign MVMU_addr10[15:0] = CCU_MVMU_addr2[32 +:15];
assign MVMU_addr11[15:0] = CCU_MVMU_addr2[48 +:15];
assign MVMU_addr12[15:0] = CCU_MVMU_addr3[0  +:15];
assign MVMU_addr13[15:0] = CCU_MVMU_addr3[16 +:15];
assign MVMU_addr14[15:0] = CCU_MVMU_addr3[32 +:15];
assign MVMU_addr15[15:0] = CCU_MVMU_addr3[48 +:15];

assign MVMU_pim_pro_o_flag0[0]  = pim_pro_o_flag0;
assign MVMU_pim_pro_o_flag0[1]  = pim_pro_o_flag1;
assign MVMU_pim_pro_o_flag0[2]  = pim_pro_o_flag2;
assign MVMU_pim_pro_o_flag0[3]  = pim_pro_o_flag3;
assign MVMU_pim_pro_o_flag1[0]  = pim_pro_o_flag4;
assign MVMU_pim_pro_o_flag1[1]  = pim_pro_o_flag5;
assign MVMU_pim_pro_o_flag1[2]  = pim_pro_o_flag6;
assign MVMU_pim_pro_o_flag1[3]  = pim_pro_o_flag7;
assign MVMU_pim_pro_o_flag2[0]  = pim_pro_o_flag8;
assign MVMU_pim_pro_o_flag2[1]  = pim_pro_o_flag9;
assign MVMU_pim_pro_o_flag2[2]  = pim_pro_o_flag10;
assign MVMU_pim_pro_o_flag2[3]  = pim_pro_o_flag11;
assign MVMU_pim_pro_o_flag3[0]  = pim_pro_o_flag12;
assign MVMU_pim_pro_o_flag3[1]  = pim_pro_o_flag13;
assign MVMU_pim_pro_o_flag3[2]  = pim_pro_o_flag14;
assign MVMU_pim_pro_o_flag3[3]  = pim_pro_o_flag15;

initial begin
    WS_web = 0;
    AS_web = 0;
end

always @ (posedge clk) begin
    if(RSTn) begin
        // Core_control_unit
        workload_completed_flag <= wire_workload_completed_flag;

        // MU
        Core_output[0 *WR_DEPTH+:WR_DEPTH] <= wire_core_output0;
        Core_output[1 *WR_DEPTH+:WR_DEPTH] <= wire_core_output1;
        Core_output[2 *WR_DEPTH+:WR_DEPTH] <= wire_core_output2;
        Core_output[3 *WR_DEPTH+:WR_DEPTH] <= wire_core_output3;
        Core_output[4 *WR_DEPTH+:WR_DEPTH] <= wire_core_output4;
        Core_output[5 *WR_DEPTH+:WR_DEPTH] <= wire_core_output5;
        Core_output[6 *WR_DEPTH+:WR_DEPTH] <= wire_core_output6;
        Core_output[7 *WR_DEPTH+:WR_DEPTH] <= wire_core_output7;
        Core_output[8 *WR_DEPTH+:WR_DEPTH] <= wire_core_output8;
        Core_output[9 *WR_DEPTH+:WR_DEPTH] <= wire_core_output9;
        Core_output[10*WR_DEPTH+:WR_DEPTH] <= wire_core_output10;
        Core_output[11*WR_DEPTH+:WR_DEPTH] <= wire_core_output11;
        Core_output[12*WR_DEPTH+:WR_DEPTH] <= wire_core_output12;
        Core_output[13*WR_DEPTH+:WR_DEPTH] <= wire_core_output13;
        Core_output[14*WR_DEPTH+:WR_DEPTH] <= wire_core_output14;
        Core_output[15*WR_DEPTH+:WR_DEPTH] <= wire_core_output15;

        // Weight_SRAM
        WS_web[0]     <= wire_WS_web0;
        WS_web[1]     <= wire_WS_web1;
        WS_web[2]     <= wire_WS_web2;
        WS_web[3]     <= wire_WS_web3;
        WS_web[4]     <= wire_WS_web4;
        WS_web[5]     <= wire_WS_web5;
        WS_web[6]     <= wire_WS_web6;
        WS_web[7]     <= wire_WS_web7;
        WS_web[8]     <= wire_WS_web8;
        WS_web[9]     <= wire_WS_web9;
        WS_web[10]    <= wire_WS_web10;
        WS_web[11]    <= wire_WS_web11;
        WS_web[12]    <= wire_WS_web12;
        WS_web[13]    <= wire_WS_web13;
        WS_web[14]    <= wire_WS_web14;
        WS_web[15]    <= wire_WS_web15;
        WS_read_addr[0 *32+:32]     <= wire_WS_read_addr0;
        WS_read_addr[1 *32+:32]     <= wire_WS_read_addr1;
        WS_read_addr[2 *32+:32]     <= wire_WS_read_addr2;
        WS_read_addr[3 *32+:32]     <= wire_WS_read_addr3;
        WS_read_addr[4 *32+:32]     <= wire_WS_read_addr4;
        WS_read_addr[5 *32+:32]     <= wire_WS_read_addr5;
        WS_read_addr[6 *32+:32]     <= wire_WS_read_addr6;
        WS_read_addr[7 *32+:32]     <= wire_WS_read_addr7;
        WS_read_addr[8 *32+:32]     <= wire_WS_read_addr8;
        WS_read_addr[9 *32+:32]     <= wire_WS_read_addr9;
        WS_read_addr[10*32+:32]    <= wire_WS_read_addr10;
        WS_read_addr[11*32+:32]    <= wire_WS_read_addr11;
        WS_read_addr[12*32+:32]    <= wire_WS_read_addr12;
        WS_read_addr[13*32+:32]    <= wire_WS_read_addr13;
        WS_read_addr[14*32+:32]    <= wire_WS_read_addr14;
        WS_read_addr[15*32+:32]    <= wire_WS_read_addr15;
        WS_length[0 *16+:16]    <= wire_WS_length0;
        WS_length[1 *16+:16]    <= wire_WS_length1;
        WS_length[2 *16+:16]    <= wire_WS_length2;
        WS_length[3 *16+:16]    <= wire_WS_length3;
        WS_length[4 *16+:16]    <= wire_WS_length4;
        WS_length[5 *16+:16]    <= wire_WS_length5;
        WS_length[6 *16+:16]    <= wire_WS_length6;
        WS_length[7 *16+:16]    <= wire_WS_length7;
        WS_length[8 *16+:16]    <= wire_WS_length8;
        WS_length[9 *16+:16]    <= wire_WS_length9;
        WS_length[10*16+:16]    <= wire_WS_length10;
        WS_length[11*16+:16]    <= wire_WS_length11;
        WS_length[12*16+:16]    <= wire_WS_length12;
        WS_length[13*16+:16]    <= wire_WS_length13;
        WS_length[14*16+:16]    <= wire_WS_length14;
        WS_length[15*16+:16]    <= wire_WS_length15;
        WS_width[0 *6 +:6 ]    <= wire_WS_width0;
        WS_width[1 *6 +:6 ]    <= wire_WS_width1;
        WS_width[2 *6 +:6 ]    <= wire_WS_width2;
        WS_width[3 *6 +:6 ]    <= wire_WS_width3;
        WS_width[4 *6 +:6 ]    <= wire_WS_width4;
        WS_width[5 *6 +:6 ]    <= wire_WS_width5;
        WS_width[6 *6 +:6 ]    <= wire_WS_width6;
        WS_width[7 *6 +:6 ]    <= wire_WS_width7;
        WS_width[8 *6 +:6 ]    <= wire_WS_width8;
        WS_width[9 *6 +:6 ]    <= wire_WS_width9;
        WS_width[10*6 +:6 ]    <= wire_WS_width10;
        WS_width[11*6 +:6 ]    <= wire_WS_width11;
        WS_width[12*6 +:6 ]    <= wire_WS_width12;
        WS_width[13*6 +:6 ]    <= wire_WS_width13;
        WS_width[14*6 +:6 ]    <= wire_WS_width14;
        WS_width[15*6 +:6 ]    <= wire_WS_width15;
        WS_depth_of_jump[0 *16+:16]    <= wire_WS_depth_of_jump0;
        WS_depth_of_jump[1 *16+:16]    <= wire_WS_depth_of_jump1;
        WS_depth_of_jump[2 *16+:16]    <= wire_WS_depth_of_jump2;
        WS_depth_of_jump[3 *16+:16]    <= wire_WS_depth_of_jump3;
        WS_depth_of_jump[4 *16+:16]    <= wire_WS_depth_of_jump4;
        WS_depth_of_jump[5 *16+:16]    <= wire_WS_depth_of_jump5;
        WS_depth_of_jump[6 *16+:16]    <= wire_WS_depth_of_jump6;
        WS_depth_of_jump[7 *16+:16]    <= wire_WS_depth_of_jump7;
        WS_depth_of_jump[8 *16+:16]    <= wire_WS_depth_of_jump8;
        WS_depth_of_jump[9 *16+:16]    <= wire_WS_depth_of_jump9;
        WS_depth_of_jump[10*16+:16]    <= wire_WS_depth_of_jump10;
        WS_depth_of_jump[11*16+:16]    <= wire_WS_depth_of_jump11;
        WS_depth_of_jump[12*16+:16]    <= wire_WS_depth_of_jump12;
        WS_depth_of_jump[13*16+:16]    <= wire_WS_depth_of_jump13;
        WS_depth_of_jump[14*16+:16]    <= wire_WS_depth_of_jump14;
        WS_depth_of_jump[15*16+:16]    <= wire_WS_depth_of_jump15;

        // Activation_SRAM
        AS_web[0]     <= wire_AS_web0;
        AS_web[1]     <= wire_AS_web1;
        AS_web[2]     <= wire_AS_web2;
        AS_web[3]     <= wire_AS_web3;
        AS_web[4]     <= wire_AS_web4;
        AS_web[5]     <= wire_AS_web5;
        AS_web[6]     <= wire_AS_web6;
        AS_web[7]     <= wire_AS_web7;
        AS_web[8]     <= wire_AS_web8;
        AS_web[9]     <= wire_AS_web9;
        AS_web[10]    <= wire_AS_web10;
        AS_web[11]    <= wire_AS_web11;
        AS_web[12]    <= wire_AS_web12;
        AS_web[13]    <= wire_AS_web13;
        AS_web[14]    <= wire_AS_web14;
        AS_web[15]    <= wire_AS_web15;
        AS_read_addr[0 *32+:32]     <= wire_AS_read_addr0;
        AS_read_addr[1 *32+:32]     <= wire_AS_read_addr1;
        AS_read_addr[2 *32+:32]     <= wire_AS_read_addr2;
        AS_read_addr[3 *32+:32]     <= wire_AS_read_addr3;
        AS_read_addr[4 *32+:32]     <= wire_AS_read_addr4;
        AS_read_addr[5 *32+:32]     <= wire_AS_read_addr5;
        AS_read_addr[6 *32+:32]     <= wire_AS_read_addr6;
        AS_read_addr[7 *32+:32]     <= wire_AS_read_addr7;
        AS_read_addr[8 *32+:32]     <= wire_AS_read_addr8;
        AS_read_addr[9 *32+:32]     <= wire_AS_read_addr9;
        AS_read_addr[10*32+:32]    <= wire_AS_read_addr10;
        AS_read_addr[11*32+:32]    <= wire_AS_read_addr11;
        AS_read_addr[12*32+:32]    <= wire_AS_read_addr12;
        AS_read_addr[13*32+:32]    <= wire_AS_read_addr13;
        AS_read_addr[14*32+:32]    <= wire_AS_read_addr14;
        AS_read_addr[15*32+:32]    <= wire_AS_read_addr15;
        AS_length[0 *16+:16]     <= wire_AS_length0;
        AS_length[1 *16+:16]     <= wire_AS_length1;
        AS_length[2 *16+:16]     <= wire_AS_length2;
        AS_length[3 *16+:16]     <= wire_AS_length3;
        AS_length[4 *16+:16]     <= wire_AS_length4;
        AS_length[5 *16+:16]     <= wire_AS_length5;
        AS_length[6 *16+:16]     <= wire_AS_length6;
        AS_length[7 *16+:16]     <= wire_AS_length7;
        AS_length[8 *16+:16]     <= wire_AS_length8;
        AS_length[9 *16+:16]     <= wire_AS_length9;
        AS_length[10*16+:16]    <= wire_AS_length10;
        AS_length[11*16+:16]    <= wire_AS_length11;
        AS_length[12*16+:16]    <= wire_AS_length12;
        AS_length[13*16+:16]    <= wire_AS_length13;
        AS_length[14*16+:16]    <= wire_AS_length14;
        AS_length[15*16+:16]    <= wire_AS_length15;
        AS_width[0 *6+:6]     <= wire_AS_width0;
        AS_width[1 *6+:6]     <= wire_AS_width1;
        AS_width[2 *6+:6]     <= wire_AS_width2;
        AS_width[3 *6+:6]     <= wire_AS_width3;
        AS_width[4 *6+:6]     <= wire_AS_width4;
        AS_width[5 *6+:6]     <= wire_AS_width5;
        AS_width[6 *6+:6]     <= wire_AS_width6;
        AS_width[7 *6+:6]     <= wire_AS_width7;
        AS_width[8 *6+:6]     <= wire_AS_width8;
        AS_width[9 *6+:6]     <= wire_AS_width9;
        AS_width[10*6+:6]    <= wire_AS_width10;
        AS_width[11*6+:6]    <= wire_AS_width11;
        AS_width[12*6+:6]    <= wire_AS_width12;
        AS_width[13*6+:6]    <= wire_AS_width13;
        AS_width[14*6+:6]    <= wire_AS_width14;
        AS_width[15*6+:6]    <= wire_AS_width15;
        AS_depth_of_jump[0 *16+:16]     <= wire_AS_depth_of_jump0;
        AS_depth_of_jump[1 *16+:16]     <= wire_AS_depth_of_jump1;
        AS_depth_of_jump[2 *16+:16]     <= wire_AS_depth_of_jump2;
        AS_depth_of_jump[3 *16+:16]     <= wire_AS_depth_of_jump3;
        AS_depth_of_jump[4 *16+:16]     <= wire_AS_depth_of_jump4;
        AS_depth_of_jump[5 *16+:16]     <= wire_AS_depth_of_jump5;
        AS_depth_of_jump[6 *16+:16]     <= wire_AS_depth_of_jump6;
        AS_depth_of_jump[7 *16+:16]     <= wire_AS_depth_of_jump7;
        AS_depth_of_jump[8 *16+:16]     <= wire_AS_depth_of_jump8;
        AS_depth_of_jump[9 *16+:16]     <= wire_AS_depth_of_jump9;
        AS_depth_of_jump[10*16+:16]    <= wire_AS_depth_of_jump10;
        AS_depth_of_jump[11*16+:16]    <= wire_AS_depth_of_jump11;
        AS_depth_of_jump[12*16+:16]    <= wire_AS_depth_of_jump12;
        AS_depth_of_jump[13*16+:16]    <= wire_AS_depth_of_jump13;
        AS_depth_of_jump[14*16+:16]    <= wire_AS_depth_of_jump14;
        AS_depth_of_jump[15*16+:16]    <= wire_AS_depth_of_jump15;

        // Result_SRAM
        RS_web[0]     <= wire_RS_web0;
        RS_web[1]     <= wire_RS_web1;
        RS_web[2]     <= wire_RS_web2;
        RS_web[3]     <= wire_RS_web3;
        RS_web[4]     <= wire_RS_web4;
        RS_web[5]     <= wire_RS_web5;
        RS_web[6]     <= wire_RS_web6;
        RS_web[7]     <= wire_RS_web7;
        RS_web[8]     <= wire_RS_web8;
        RS_web[9]     <= wire_RS_web9;
        RS_web[10]    <= wire_RS_web10;
        RS_web[11]    <= wire_RS_web11;
        RS_web[12]    <= wire_RS_web12;
        RS_web[13]    <= wire_RS_web13;
        RS_web[14]    <= wire_RS_web14;
        RS_web[15]    <= wire_RS_web15;
        RS_write_addr[0 *32+:32]    <= wire_RS_write_addr0;
        RS_write_addr[1 *32+:32]    <= wire_RS_write_addr1;
        RS_write_addr[2 *32+:32]    <= wire_RS_write_addr2;
        RS_write_addr[3 *32+:32]    <= wire_RS_write_addr3;
        RS_write_addr[4 *32+:32]    <= wire_RS_write_addr4;
        RS_write_addr[5 *32+:32]    <= wire_RS_write_addr5;
        RS_write_addr[6 *32+:32]    <= wire_RS_write_addr6;
        RS_write_addr[7 *32+:32]    <= wire_RS_write_addr7;
        RS_write_addr[8 *32+:32]    <= wire_RS_write_addr8;
        RS_write_addr[9 *32+:32]    <= wire_RS_write_addr9;
        RS_write_addr[10*32+:32]    <= wire_RS_write_addr10;
        RS_write_addr[11*32+:32]    <= wire_RS_write_addr11;
        RS_write_addr[12*32+:32]    <= wire_RS_write_addr12;
        RS_write_addr[13*32+:32]    <= wire_RS_write_addr13;
        RS_write_addr[14*32+:32]    <= wire_RS_write_addr14;
        RS_write_addr[15*32+:32]    <= wire_RS_write_addr15;

        // MVMU
        MVMU_work_flag0 <= wire_MVMU_work_flag0;
        MVMU_work_flag1 <= wire_MVMU_work_flag1;
        MVMU_work_flag2 <= wire_MVMU_work_flag2;
        MVMU_work_flag3 <= wire_MVMU_work_flag3;
        MVMU_work_flag4 <= wire_MVMU_work_flag4;
        MVMU_work_flag5 <= wire_MVMU_work_flag5;
        MVMU_work_flag6 <= wire_MVMU_work_flag6;
        MVMU_work_flag7 <= wire_MVMU_work_flag7;
        MVMU_work_flag8 <= wire_MVMU_work_flag8;
        MVMU_work_flag9 <= wire_MVMU_work_flag9;
        MVMU_work_flag10 <= wire_MVMU_work_flag10;
        MVMU_work_flag11 <= wire_MVMU_work_flag11;
        MVMU_work_flag12 <= wire_MVMU_work_flag12;
        MVMU_work_flag13 <= wire_MVMU_work_flag13;
        MVMU_work_flag14 <= wire_MVMU_work_flag14;
        MVMU_work_flag15 <= wire_MVMU_work_flag15;
    end
end

Core_instruction_memory Core_instruction_memory(
    .clk                             (clk), 
    .RSTn                            (RSTn), 
    .web                             (c_i_m_web), 
    .c_i_m_write_addr                (c_i_m_write_addr),
    .core_ins_input                  (core_ins_input), 

    .addr0                           (instruction_addr0),
    .addr1                           (instruction_addr1),
    .addr2                           (instruction_addr2),
    .addr3                           (instruction_addr3),
    .addr4                           (instruction_addr4),
    .addr5                           (instruction_addr5),
    .addr6                           (instruction_addr6),
    .addr7                           (instruction_addr7),
    .addr8                           (instruction_addr8),
    .addr9                           (instruction_addr9),
    .addr10                          (instruction_addr10),
    .addr11                          (instruction_addr11),
    .addr12                          (instruction_addr12),
    .addr13                          (instruction_addr13),
    .addr14                          (instruction_addr14),
    .addr15                          (instruction_addr15),
    .instruction0                    (new_instruction0),
    .instruction1                    (new_instruction1),
    .instruction2                    (new_instruction2),
    .instruction3                    (new_instruction3),
    .instruction4                    (new_instruction4),
    .instruction5                    (new_instruction5),
    .instruction6                    (new_instruction6),
    .instruction7                    (new_instruction7),
    .instruction8                    (new_instruction8),
    .instruction9                    (new_instruction9),
    .instruction10                   (new_instruction10),
    .instruction11                   (new_instruction11),
    .instruction12                   (new_instruction12),
    .instruction13                   (new_instruction13),
    .instruction14                   (new_instruction14),
    .instruction15                   (new_instruction15)
);

CHAS_execution_unit CHAS_execution_unit(
    .clk                                 (clk), 
    .RSTn                                (RSTn), 
    .web                                 (core_control_unit_web), 

    .rewriting_speed          (rewriting_speed),

    .CCU_workload_completed_flag0        (CCU_workload_completed_flag0),
    .CCU_workload_completed_flag1        (CCU_workload_completed_flag1), 
    .CCU_workload_completed_flag2        (CCU_workload_completed_flag2), 
    .CCU_workload_completed_flag3        (CCU_workload_completed_flag3), 
    .CCU_workload_completed_flag4        (CCU_workload_completed_flag4),
    .CCU_workload_completed_flag5        (CCU_workload_completed_flag5), 
    .CCU_workload_completed_flag6        (CCU_workload_completed_flag6), 
    .CCU_workload_completed_flag7        (CCU_workload_completed_flag7), 
    .CCU_workload_completed_flag8        (CCU_workload_completed_flag8),
    .CCU_workload_completed_flag9        (CCU_workload_completed_flag9), 
    .CCU_workload_completed_flag10       (CCU_workload_completed_flag10), 
    .CCU_workload_completed_flag11       (CCU_workload_completed_flag11), 
    .CCU_workload_completed_flag12       (CCU_workload_completed_flag12),
    .CCU_workload_completed_flag13       (CCU_workload_completed_flag13), 
    .CCU_workload_completed_flag14       (CCU_workload_completed_flag14), 
    .CCU_workload_completed_flag15       (CCU_workload_completed_flag15), 
    .CCU_instruction0                    (CCU_instruction0),
    .CCU_instruction1                    (CCU_instruction1),
    .CCU_instruction2                    (CCU_instruction2),
    .CCU_instruction3                    (CCU_instruction3),
    .CCU_instruction4                    (CCU_instruction4),
    .CCU_instruction5                    (CCU_instruction5),
    .CCU_instruction6                    (CCU_instruction6),
    .CCU_instruction7                    (CCU_instruction7),
    .CCU_instruction8                    (CCU_instruction8),
    .CCU_instruction9                    (CCU_instruction9),
    .CCU_instruction10                   (CCU_instruction10),
    .CCU_instruction11                   (CCU_instruction11),
    .CCU_instruction12                   (CCU_instruction12),
    .CCU_instruction13                   (CCU_instruction13),
    .CCU_instruction14                   (CCU_instruction14),
    .CCU_instruction15                   (CCU_instruction15),
    .CCU_finish_flag0                    (CCU_finish_flag0),
    .CCU_finish_flag1                    (CCU_finish_flag1),
    .CCU_finish_flag2                    (CCU_finish_flag2),
    .CCU_finish_flag3                    (CCU_finish_flag3),
    .CCU_finish_flag4                    (CCU_finish_flag4),
    .CCU_finish_flag5                    (CCU_finish_flag5),
    .CCU_finish_flag6                    (CCU_finish_flag6),
    .CCU_finish_flag7                    (CCU_finish_flag7),
    .CCU_finish_flag8                    (CCU_finish_flag8),
    .CCU_finish_flag9                    (CCU_finish_flag9),
    .CCU_finish_flag10                   (CCU_finish_flag10),
    .CCU_finish_flag11                   (CCU_finish_flag11),
    .CCU_finish_flag12                   (CCU_finish_flag12),
    .CCU_finish_flag13                   (CCU_finish_flag13),
    .CCU_finish_flag14                   (CCU_finish_flag14),
    .CCU_finish_flag15                   (CCU_finish_flag15),
    .CCU_start_flag0                     (CCU_start_flag0),
    .CCU_start_flag1                     (CCU_start_flag1),
    .CCU_start_flag2                     (CCU_start_flag2),
    .CCU_start_flag3                     (CCU_start_flag3),
    .CCU_start_flag4                     (CCU_start_flag4),
    .CCU_start_flag5                     (CCU_start_flag5),
    .CCU_start_flag6                     (CCU_start_flag6),
    .CCU_start_flag7                     (CCU_start_flag7),
    .CCU_start_flag8                     (CCU_start_flag8),
    .CCU_start_flag9                     (CCU_start_flag9),
    .CCU_start_flag10                    (CCU_start_flag10),
    .CCU_start_flag11                    (CCU_start_flag11),
    .CCU_start_flag12                    (CCU_start_flag12),
    .CCU_start_flag13                    (CCU_start_flag13),
    .CCU_start_flag14                    (CCU_start_flag14),
    .CCU_start_flag15                    (CCU_start_flag15),

    .workload_completed_flag             (wire_workload_completed_flag)
);

Core_control_unit Core_control_unit0(
    .clk                             (clk), 
    .RSTn                            (RSTn), 
    .web                             (core_control_unit_web), 

    .rewriting_speed          (rewriting_speed),

    .instruction_addr0               (instruction_addr0),
    .instruction_addr1               (instruction_addr1),
    .instruction_addr2               (instruction_addr2),
    .instruction_addr3               (instruction_addr3),
    .new_instruction0                (new_instruction0),
    .new_instruction1                (new_instruction1),
    .new_instruction2                (new_instruction2),
    .new_instruction3                (new_instruction3),

    .CCU_workload_completed_flag0         (CCU_workload_completed_flag0),
    .CCU_workload_completed_flag1         (CCU_workload_completed_flag1), 
    .CCU_workload_completed_flag2         (CCU_workload_completed_flag2), 
    .CCU_workload_completed_flag3         (CCU_workload_completed_flag3), 
    .instruction0                    (CCU_instruction0),
    .instruction1                    (CCU_instruction1),
    .instruction2                    (CCU_instruction2),
    .instruction3                    (CCU_instruction3),
    .finish_flag0                    (CCU_finish_flag0),
    .finish_flag1                    (CCU_finish_flag1),
    .finish_flag2                    (CCU_finish_flag2),
    .finish_flag3                    (CCU_finish_flag3),
    .start_flag0                     (CCU_start_flag0),
    .start_flag1                     (CCU_start_flag1),
    .start_flag2                     (CCU_start_flag2),
    .start_flag3                     (CCU_start_flag3),

    .WS_web0                          (wire_WS_web0),
    .WS_web1                          (wire_WS_web1),
    .WS_web2                          (wire_WS_web2),
    .WS_web3                          (wire_WS_web3),
    .WS_read_addr0                    (wire_WS_read_addr0),
    .WS_read_addr1                    (wire_WS_read_addr1),
    .WS_read_addr2                    (wire_WS_read_addr2),
    .WS_read_addr3                    (wire_WS_read_addr3),
    .WS_length0                       (wire_WS_length0),
    .WS_length1                       (wire_WS_length1),
    .WS_length2                       (wire_WS_length2),
    .WS_length3                       (wire_WS_length3),
    .WS_width0                        (wire_WS_width0),
    .WS_width1                        (wire_WS_width1),
    .WS_width2                        (wire_WS_width2),
    .WS_width3                        (wire_WS_width3),
    .WS_depth_of_jump0                (wire_WS_depth_of_jump0),
    .WS_depth_of_jump1                (wire_WS_depth_of_jump1),
    .WS_depth_of_jump2                (wire_WS_depth_of_jump2),
    .WS_depth_of_jump3                (wire_WS_depth_of_jump3),

    .AS_web0                          (wire_AS_web0),
    .AS_web1                          (wire_AS_web1),
    .AS_web2                          (wire_AS_web2),
    .AS_web3                          (wire_AS_web3),
    .AS_read_addr0                    (wire_AS_read_addr0),
    .AS_read_addr1                    (wire_AS_read_addr1),
    .AS_read_addr2                    (wire_AS_read_addr2),
    .AS_read_addr3                    (wire_AS_read_addr3),
    .AS_length0                       (wire_AS_length0),
    .AS_length1                       (wire_AS_length1),
    .AS_length2                       (wire_AS_length2),
    .AS_length3                       (wire_AS_length3),
    .AS_width0                        (wire_AS_width0),
    .AS_width1                        (wire_AS_width1),
    .AS_width2                        (wire_AS_width2),
    .AS_width3                        (wire_AS_width3),
    .AS_depth_of_jump0                (wire_AS_depth_of_jump0),
    .AS_depth_of_jump1                (wire_AS_depth_of_jump1),
    .AS_depth_of_jump2                (wire_AS_depth_of_jump2),
    .AS_depth_of_jump3                (wire_AS_depth_of_jump3),

    .RS_web0                          (wire_RS_web0),
    .RS_web1                          (wire_RS_web1),
    .RS_web2                          (wire_RS_web2),
    .RS_web3                          (wire_RS_web3),
    .RS_write_addr0                   (wire_RS_write_addr0), 
    .RS_write_addr1                   (wire_RS_write_addr1), 
    .RS_write_addr2                   (wire_RS_write_addr2), 
    .RS_write_addr3                   (wire_RS_write_addr3), 

    .MU_web                          (MU_web0), 
    .MU_output_addr                  (MU_output_addr0), 
    .MU_core_output_addr0            (MU_core_output_addr0),
    .MU_core_output_addr1            (MU_core_output_addr1),
    .MU_core_output_addr2            (MU_core_output_addr2),
    .MU_core_output_addr3            (MU_core_output_addr3),
    .MU_I_input_addr0                (MU_I_input_addr0),
    .MU_I_input_addr1                (MU_I_input_addr1),
    .MU_I_input_addr2                (MU_I_input_addr2),
    .MU_I_input_addr3                (MU_I_input_addr3),
    .Batch_of_data0                  (Batch_of_data0),  
    .Batch_of_data1                  (Batch_of_data1),  
    .Batch_of_data2                  (Batch_of_data2),  
    .Batch_of_data3                  (Batch_of_data3),  

    .MVMU_web                        (CCU_MVMU_web0), 
    .MVMU_addr                       (CCU_MVMU_addr0),
    .MVMU_pim_pro_o_flag             (MVMU_pim_pro_o_flag0)
);

Core_control_unit Core_control_unit1(
    .clk                             (clk), 
    .RSTn                            (RSTn), 
    .web                             (core_control_unit_web), 

    .rewriting_speed          (rewriting_speed),

    .instruction_addr0               (instruction_addr4),
    .instruction_addr1               (instruction_addr5),
    .instruction_addr2               (instruction_addr6),
    .instruction_addr3               (instruction_addr7),
    .new_instruction0                (new_instruction4),
    .new_instruction1                (new_instruction5),
    .new_instruction2                (new_instruction6),
    .new_instruction3                (new_instruction7),

    .CCU_workload_completed_flag0         (CCU_workload_completed_flag4),
    .CCU_workload_completed_flag1         (CCU_workload_completed_flag5), 
    .CCU_workload_completed_flag2         (CCU_workload_completed_flag6), 
    .CCU_workload_completed_flag3         (CCU_workload_completed_flag7), 
    .instruction0                    (CCU_instruction4),
    .instruction1                    (CCU_instruction5),
    .instruction2                    (CCU_instruction6),
    .instruction3                    (CCU_instruction7),
    .finish_flag0                    (CCU_finish_flag4),
    .finish_flag1                    (CCU_finish_flag5),
    .finish_flag2                    (CCU_finish_flag6),
    .finish_flag3                    (CCU_finish_flag7),
    .start_flag0                     (CCU_start_flag4),
    .start_flag1                     (CCU_start_flag5),
    .start_flag2                     (CCU_start_flag6),
    .start_flag3                     (CCU_start_flag7),

    .WS_web0                          (wire_WS_web4),
    .WS_web1                          (wire_WS_web5),
    .WS_web2                          (wire_WS_web6),
    .WS_web3                          (wire_WS_web7),
    .WS_read_addr0                    (wire_WS_read_addr4),
    .WS_read_addr1                    (wire_WS_read_addr5),
    .WS_read_addr2                    (wire_WS_read_addr6),
    .WS_read_addr3                    (wire_WS_read_addr7),
    .WS_length0                       (wire_WS_length4),
    .WS_length1                       (wire_WS_length5),
    .WS_length2                       (wire_WS_length6),
    .WS_length3                       (wire_WS_length7),
    .WS_width0                        (wire_WS_width4),
    .WS_width1                        (wire_WS_width5),
    .WS_width2                        (wire_WS_width6),
    .WS_width3                        (wire_WS_width7),
    .WS_depth_of_jump0                (wire_WS_depth_of_jump4),
    .WS_depth_of_jump1                (wire_WS_depth_of_jump5),
    .WS_depth_of_jump2                (wire_WS_depth_of_jump6),
    .WS_depth_of_jump3                (wire_WS_depth_of_jump7),

    .AS_web0                          (wire_AS_web4),
    .AS_web1                          (wire_AS_web5),
    .AS_web2                          (wire_AS_web6),
    .AS_web3                          (wire_AS_web7),
    .AS_read_addr0                    (wire_AS_read_addr4),
    .AS_read_addr1                    (wire_AS_read_addr5),
    .AS_read_addr2                    (wire_AS_read_addr6),
    .AS_read_addr3                    (wire_AS_read_addr7),
    .AS_length0                       (wire_AS_length4),
    .AS_length1                       (wire_AS_length5),
    .AS_length2                       (wire_AS_length6),
    .AS_length3                       (wire_AS_length7),
    .AS_width0                        (wire_AS_width4),
    .AS_width1                        (wire_AS_width5),
    .AS_width2                        (wire_AS_width6),
    .AS_width3                        (wire_AS_width7),
    .AS_depth_of_jump0                (wire_AS_depth_of_jump4),
    .AS_depth_of_jump1                (wire_AS_depth_of_jump5),
    .AS_depth_of_jump2                (wire_AS_depth_of_jump6),
    .AS_depth_of_jump3                (wire_AS_depth_of_jump7),

    .RS_web0                          (wire_RS_web4),
    .RS_web1                          (wire_RS_web5),
    .RS_web2                          (wire_RS_web6),
    .RS_web3                          (wire_RS_web7),
    .RS_write_addr0                   (wire_RS_write_addr4), 
    .RS_write_addr1                   (wire_RS_write_addr5), 
    .RS_write_addr2                   (wire_RS_write_addr6), 
    .RS_write_addr3                   (wire_RS_write_addr7), 

    .MU_web                          (MU_web1), 
    .MU_output_addr                  (MU_output_addr1), 
    .MU_core_output_addr0            (MU_core_output_addr4),
    .MU_core_output_addr1            (MU_core_output_addr5),
    .MU_core_output_addr2            (MU_core_output_addr6),
    .MU_core_output_addr3            (MU_core_output_addr7),
    .MU_I_input_addr0                (MU_I_input_addr4),
    .MU_I_input_addr1                (MU_I_input_addr5),
    .MU_I_input_addr2                (MU_I_input_addr6),
    .MU_I_input_addr3                (MU_I_input_addr7),
    .Batch_of_data0                  (Batch_of_data4),  
    .Batch_of_data1                  (Batch_of_data5),  
    .Batch_of_data2                  (Batch_of_data6),  
    .Batch_of_data3                  (Batch_of_data7),  

    .MVMU_web                        (CCU_MVMU_web1), 
    .MVMU_addr                       (CCU_MVMU_addr1),
    .MVMU_pim_pro_o_flag             (MVMU_pim_pro_o_flag1)
);

Core_control_unit Core_control_unit2(
    .clk                             (clk), 
    .RSTn                            (RSTn), 
    .web                             (core_control_unit_web), 

    .rewriting_speed          (rewriting_speed),

    .instruction_addr0               (instruction_addr8),
    .instruction_addr1               (instruction_addr9),
    .instruction_addr2               (instruction_addr10),
    .instruction_addr3               (instruction_addr11),
    .new_instruction0                (new_instruction8),
    .new_instruction1                (new_instruction9),
    .new_instruction2                (new_instruction10),
    .new_instruction3                (new_instruction11),

    .CCU_workload_completed_flag0         (CCU_workload_completed_flag8),
    .CCU_workload_completed_flag1         (CCU_workload_completed_flag9), 
    .CCU_workload_completed_flag2         (CCU_workload_completed_flag10), 
    .CCU_workload_completed_flag3         (CCU_workload_completed_flag11), 
    .instruction0                    (CCU_instruction8),
    .instruction1                    (CCU_instruction9),
    .instruction2                    (CCU_instruction10),
    .instruction3                    (CCU_instruction11),
    .finish_flag0                    (CCU_finish_flag8),
    .finish_flag1                    (CCU_finish_flag9),
    .finish_flag2                    (CCU_finish_flag10),
    .finish_flag3                    (CCU_finish_flag11),
    .start_flag0                     (CCU_start_flag8),
    .start_flag1                     (CCU_start_flag9),
    .start_flag2                     (CCU_start_flag10),
    .start_flag3                     (CCU_start_flag11),

    .WS_web0                          (wire_WS_web8),
    .WS_web1                          (wire_WS_web9),
    .WS_web2                          (wire_WS_web10),
    .WS_web3                          (wire_WS_web11),
    .WS_read_addr0                    (wire_WS_read_addr8),
    .WS_read_addr1                    (wire_WS_read_addr9),
    .WS_read_addr2                    (wire_WS_read_addr10),
    .WS_read_addr3                    (wire_WS_read_addr11),
    .WS_length0                       (wire_WS_length8),
    .WS_length1                       (wire_WS_length9),
    .WS_length2                       (wire_WS_length10),
    .WS_length3                       (wire_WS_length11),
    .WS_width0                        (wire_WS_width8),
    .WS_width1                        (wire_WS_width9),
    .WS_width2                        (wire_WS_width10),
    .WS_width3                        (wire_WS_width11),
    .WS_depth_of_jump0                (wire_WS_depth_of_jump8),
    .WS_depth_of_jump1                (wire_WS_depth_of_jump9),
    .WS_depth_of_jump2                (wire_WS_depth_of_jump10),
    .WS_depth_of_jump3                (wire_WS_depth_of_jump11),

    .AS_web0                          (wire_AS_web8),
    .AS_web1                          (wire_AS_web9),
    .AS_web2                          (wire_AS_web10),
    .AS_web3                          (wire_AS_web11),
    .AS_read_addr0                    (wire_AS_read_addr8),
    .AS_read_addr1                    (wire_AS_read_addr9),
    .AS_read_addr2                    (wire_AS_read_addr10),
    .AS_read_addr3                    (wire_AS_read_addr11),
    .AS_length0                       (wire_AS_length8),
    .AS_length1                       (wire_AS_length9),
    .AS_length2                       (wire_AS_length10),
    .AS_length3                       (wire_AS_length11),
    .AS_width0                        (wire_AS_width8),
    .AS_width1                        (wire_AS_width9),
    .AS_width2                        (wire_AS_width10),
    .AS_width3                        (wire_AS_width11),
    .AS_depth_of_jump0                (wire_AS_depth_of_jump8),
    .AS_depth_of_jump1                (wire_AS_depth_of_jump9),
    .AS_depth_of_jump2                (wire_AS_depth_of_jump10),
    .AS_depth_of_jump3                (wire_AS_depth_of_jump11),

    .RS_web0                          (wire_RS_web8),
    .RS_web1                          (wire_RS_web9),
    .RS_web2                          (wire_RS_web10),
    .RS_web3                          (wire_RS_web11),
    .RS_write_addr0                   (wire_RS_write_addr8), 
    .RS_write_addr1                   (wire_RS_write_addr9), 
    .RS_write_addr2                   (wire_RS_write_addr10), 
    .RS_write_addr3                   (wire_RS_write_addr11), 

    .MU_web                          (MU_web2), 
    .MU_output_addr                  (MU_output_addr2), 
    .MU_core_output_addr0            (MU_core_output_addr8),
    .MU_core_output_addr1            (MU_core_output_addr9),
    .MU_core_output_addr2            (MU_core_output_addr10),
    .MU_core_output_addr3            (MU_core_output_addr11),
    .MU_I_input_addr0                (MU_I_input_addr8),
    .MU_I_input_addr1                (MU_I_input_addr9),
    .MU_I_input_addr2                (MU_I_input_addr10),
    .MU_I_input_addr3                (MU_I_input_addr11),
    .Batch_of_data0                  (Batch_of_data8),  
    .Batch_of_data1                  (Batch_of_data9),  
    .Batch_of_data2                  (Batch_of_data10),  
    .Batch_of_data3                  (Batch_of_data11),  

    .MVMU_web                        (CCU_MVMU_web2), 
    .MVMU_addr                       (CCU_MVMU_addr2),
    .MVMU_pim_pro_o_flag             (MVMU_pim_pro_o_flag2)
);

Core_control_unit Core_control_unit3(
    .clk                             (clk), 
    .RSTn                            (RSTn), 
    .web                             (core_control_unit_web), 

    .rewriting_speed          (rewriting_speed),

    .instruction_addr0               (instruction_addr12),
    .instruction_addr1               (instruction_addr13),
    .instruction_addr2               (instruction_addr14),
    .instruction_addr3               (instruction_addr15),
    .new_instruction0                (new_instruction12),
    .new_instruction1                (new_instruction13),
    .new_instruction2                (new_instruction14),
    .new_instruction3                (new_instruction15),

    .CCU_workload_completed_flag0         (CCU_workload_completed_flag12),
    .CCU_workload_completed_flag1         (CCU_workload_completed_flag13), 
    .CCU_workload_completed_flag2         (CCU_workload_completed_flag14), 
    .CCU_workload_completed_flag3         (CCU_workload_completed_flag15), 
    .instruction0                    (CCU_instruction12),
    .instruction1                    (CCU_instruction13),
    .instruction2                    (CCU_instruction14),
    .instruction3                    (CCU_instruction15),
    .finish_flag0                    (CCU_finish_flag12),
    .finish_flag1                    (CCU_finish_flag13),
    .finish_flag2                    (CCU_finish_flag14),
    .finish_flag3                    (CCU_finish_flag15),
    .start_flag0                     (CCU_start_flag12),
    .start_flag1                     (CCU_start_flag13),
    .start_flag2                     (CCU_start_flag14),
    .start_flag3                     (CCU_start_flag15),

    .WS_web0                          (wire_WS_web12),
    .WS_web1                          (wire_WS_web13),
    .WS_web2                          (wire_WS_web14),
    .WS_web3                          (wire_WS_web15),
    .WS_read_addr0                    (wire_WS_read_addr12),
    .WS_read_addr1                    (wire_WS_read_addr13),
    .WS_read_addr2                    (wire_WS_read_addr14),
    .WS_read_addr3                    (wire_WS_read_addr15),
    .WS_length0                       (wire_WS_length12),
    .WS_length1                       (wire_WS_length13),
    .WS_length2                       (wire_WS_length14),
    .WS_length3                       (wire_WS_length15),
    .WS_width0                        (wire_WS_width12),
    .WS_width1                        (wire_WS_width13),
    .WS_width2                        (wire_WS_width14),
    .WS_width3                        (wire_WS_width15),
    .WS_depth_of_jump0                (wire_WS_depth_of_jump12),
    .WS_depth_of_jump1                (wire_WS_depth_of_jump13),
    .WS_depth_of_jump2                (wire_WS_depth_of_jump14),
    .WS_depth_of_jump3                (wire_WS_depth_of_jump15),

    .AS_web0                          (wire_AS_web12),
    .AS_web1                          (wire_AS_web13),
    .AS_web2                          (wire_AS_web14),
    .AS_web3                          (wire_AS_web15),
    .AS_read_addr0                    (wire_AS_read_addr12),
    .AS_read_addr1                    (wire_AS_read_addr13),
    .AS_read_addr2                    (wire_AS_read_addr14),
    .AS_read_addr3                    (wire_AS_read_addr15),
    .AS_length0                       (wire_AS_length12),
    .AS_length1                       (wire_AS_length13),
    .AS_length2                       (wire_AS_length14),
    .AS_length3                       (wire_AS_length15),
    .AS_width0                        (wire_AS_width12),
    .AS_width1                        (wire_AS_width13),
    .AS_width2                        (wire_AS_width14),
    .AS_width3                        (wire_AS_width15),
    .AS_depth_of_jump0                (wire_AS_depth_of_jump12),
    .AS_depth_of_jump1                (wire_AS_depth_of_jump13),
    .AS_depth_of_jump2                (wire_AS_depth_of_jump14),
    .AS_depth_of_jump3                (wire_AS_depth_of_jump15),

    .RS_web0                          (wire_RS_web12),
    .RS_web1                          (wire_RS_web13),
    .RS_web2                          (wire_RS_web14),
    .RS_web3                          (wire_RS_web15),
    .RS_write_addr0                   (wire_RS_write_addr12), 
    .RS_write_addr1                   (wire_RS_write_addr13), 
    .RS_write_addr2                   (wire_RS_write_addr14), 
    .RS_write_addr3                   (wire_RS_write_addr15), 

    .MU_web                          (MU_web3), 
    .MU_output_addr                  (MU_output_addr3), 
    .MU_core_output_addr0            (MU_core_output_addr12),
    .MU_core_output_addr1            (MU_core_output_addr13),
    .MU_core_output_addr2            (MU_core_output_addr14),
    .MU_core_output_addr3            (MU_core_output_addr15),
    .MU_I_input_addr0                (MU_I_input_addr12),
    .MU_I_input_addr1                (MU_I_input_addr13),
    .MU_I_input_addr2                (MU_I_input_addr14),
    .MU_I_input_addr3                (MU_I_input_addr15),
    .Batch_of_data0                  (Batch_of_data12),  
    .Batch_of_data1                  (Batch_of_data13),  
    .Batch_of_data2                  (Batch_of_data14),  
    .Batch_of_data3                  (Batch_of_data15),  

    .MVMU_web                        (CCU_MVMU_web3), 
    .MVMU_addr                       (CCU_MVMU_addr3),
    .MVMU_pim_pro_o_flag             (MVMU_pim_pro_o_flag3)
);

MU MU0(
    .clk                      (clk), 
    .RSTn                     (RSTn), 
    .web                      (MU_web0), 

    .Core_output_addr0        (MU_core_output_addr0),
    .Core_output_addr1        (MU_core_output_addr1),
    .Core_output_addr2        (MU_core_output_addr2),
    .Core_output_addr3        (MU_core_output_addr3),
    .Core_output0             (wire_core_output0), 
    .Core_output1             (wire_core_output1), 
    .Core_output2             (wire_core_output2), 
    .Core_output3             (wire_core_output3), 

    .i_input_addr0            (MU_I_input_addr0),
    .i_input_addr1            (MU_I_input_addr1),
    .i_input_addr2            (MU_I_input_addr2),
    .i_input_addr3            (MU_I_input_addr3),
    .updated_input0           (updated_input[0*RI_DEPTH+:RI_DEPTH]),
    .updated_input1           (updated_input[1*RI_DEPTH+:RI_DEPTH]),
    .updated_input2           (updated_input[2*RI_DEPTH+:RI_DEPTH]),
    .updated_input3           (updated_input[3*RI_DEPTH+:RI_DEPTH]),

    .Batch_of_data0           (Batch_of_data0),
    .Batch_of_data1           (Batch_of_data1),
    .Batch_of_data2           (Batch_of_data2),
    .Batch_of_data3           (Batch_of_data3),

    .MVMU_input0              (MVMU_input0),
    .MVMU_input1              (MVMU_input1),
    .MVMU_input2              (MVMU_input2),
    .MVMU_input3              (MVMU_input3),

    .MVMU_output_addr0        (MVMU_output_addr0),
    .MVMU_output_addr1        (MVMU_output_addr1),
    .MVMU_output_addr2        (MVMU_output_addr2),
    .MVMU_output_addr3        (MVMU_output_addr3),

    .MVMU_output0             (MVMU_output0),
    .MVMU_output1             (MVMU_output1),
    .MVMU_output2             (MVMU_output2),
    .MVMU_output3             (MVMU_output3)
);

MU MU1(
    .clk                      (clk), 
    .RSTn                     (RSTn), 
    .web                      (MU_web1), 

    .Core_output_addr0        (MU_core_output_addr4),
    .Core_output_addr1        (MU_core_output_addr5),
    .Core_output_addr2        (MU_core_output_addr6),
    .Core_output_addr3        (MU_core_output_addr7),
    .Core_output0             (wire_core_output4), 
    .Core_output1             (wire_core_output5), 
    .Core_output2             (wire_core_output6), 
    .Core_output3             (wire_core_output7), 

    .i_input_addr0            (MU_I_input_addr4),
    .i_input_addr1            (MU_I_input_addr5),
    .i_input_addr2            (MU_I_input_addr6),
    .i_input_addr3            (MU_I_input_addr7),
    .updated_input0           (updated_input[4*RI_DEPTH+:RI_DEPTH]),
    .updated_input1           (updated_input[5*RI_DEPTH+:RI_DEPTH]),
    .updated_input2           (updated_input[6*RI_DEPTH+:RI_DEPTH]),
    .updated_input3           (updated_input[7*RI_DEPTH+:RI_DEPTH]),

    .Batch_of_data0           (Batch_of_data4),
    .Batch_of_data1           (Batch_of_data5),
    .Batch_of_data2           (Batch_of_data6),
    .Batch_of_data3           (Batch_of_data7),

    .MVMU_input0              (MVMU_input4),
    .MVMU_input1              (MVMU_input5),
    .MVMU_input2              (MVMU_input6),
    .MVMU_input3              (MVMU_input7),

    .MVMU_output_addr0        (MVMU_output_addr4),
    .MVMU_output_addr1        (MVMU_output_addr5),
    .MVMU_output_addr2        (MVMU_output_addr6),
    .MVMU_output_addr3        (MVMU_output_addr7),

    .MVMU_output0             (MVMU_output4),
    .MVMU_output1             (MVMU_output5),
    .MVMU_output2             (MVMU_output6),
    .MVMU_output3             (MVMU_output7)
);

MU MU2(
    .clk                      (clk), 
    .RSTn                     (RSTn), 
    .web                      (MU_web2), 

    .Core_output_addr0        (MU_core_output_addr8),
    .Core_output_addr1        (MU_core_output_addr9),
    .Core_output_addr2        (MU_core_output_addr10),
    .Core_output_addr3        (MU_core_output_addr11),
    .Core_output0             (wire_core_output8), 
    .Core_output1             (wire_core_output9), 
    .Core_output2             (wire_core_output10), 
    .Core_output3             (wire_core_output11), 

    .i_input_addr0            (MU_I_input_addr8),
    .i_input_addr1            (MU_I_input_addr9),
    .i_input_addr2            (MU_I_input_addr10),
    .i_input_addr3            (MU_I_input_addr11),
    .updated_input0           (updated_input[8*RI_DEPTH+:RI_DEPTH]),
    .updated_input1           (updated_input[9*RI_DEPTH+:RI_DEPTH]),
    .updated_input2           (updated_input[10*RI_DEPTH+:RI_DEPTH]),
    .updated_input3           (updated_input[11*RI_DEPTH+:RI_DEPTH]),

    .Batch_of_data0           (Batch_of_data8),
    .Batch_of_data1           (Batch_of_data9),
    .Batch_of_data2           (Batch_of_data10),
    .Batch_of_data3           (Batch_of_data11),

    .MVMU_input0              (MVMU_input8),
    .MVMU_input1              (MVMU_input9),
    .MVMU_input2              (MVMU_input10),
    .MVMU_input3              (MVMU_input11),

    .MVMU_output_addr0        (MVMU_output_addr8),
    .MVMU_output_addr1        (MVMU_output_addr9),
    .MVMU_output_addr2        (MVMU_output_addr10),
    .MVMU_output_addr3        (MVMU_output_addr11),

    .MVMU_output0             (MVMU_output8),
    .MVMU_output1             (MVMU_output9),
    .MVMU_output2             (MVMU_output10),
    .MVMU_output3             (MVMU_output11)
);

MU MU3(
    .clk                      (clk), 
    .RSTn                     (RSTn), 
    .web                      (MU_web3), 

    .Core_output_addr0        (MU_core_output_addr12),
    .Core_output_addr1        (MU_core_output_addr13),
    .Core_output_addr2        (MU_core_output_addr14),
    .Core_output_addr3        (MU_core_output_addr15),
    .Core_output0             (wire_core_output12), 
    .Core_output1             (wire_core_output13), 
    .Core_output2             (wire_core_output14), 
    .Core_output3             (wire_core_output15), 

    .i_input_addr0            (MU_I_input_addr12),
    .i_input_addr1            (MU_I_input_addr13),
    .i_input_addr2            (MU_I_input_addr14),
    .i_input_addr3            (MU_I_input_addr15),
    .updated_input0           (updated_input[12*RI_DEPTH+:RI_DEPTH]),
    .updated_input1           (updated_input[13*RI_DEPTH+:RI_DEPTH]),
    .updated_input2           (updated_input[14*RI_DEPTH+:RI_DEPTH]),
    .updated_input3           (updated_input[15*RI_DEPTH+:RI_DEPTH]),

    .Batch_of_data0           (Batch_of_data12),
    .Batch_of_data1           (Batch_of_data13),
    .Batch_of_data2           (Batch_of_data14),
    .Batch_of_data3           (Batch_of_data15),

    .MVMU_input0              (MVMU_input12),
    .MVMU_input1              (MVMU_input13),
    .MVMU_input2              (MVMU_input14),
    .MVMU_input3              (MVMU_input15),

    .MVMU_output_addr0        (MVMU_output_addr12),
    .MVMU_output_addr1        (MVMU_output_addr13),
    .MVMU_output_addr2        (MVMU_output_addr14),
    .MVMU_output_addr3        (MVMU_output_addr15),

    .MVMU_output0             (MVMU_output12),
    .MVMU_output1             (MVMU_output13),
    .MVMU_output2             (MVMU_output14),
    .MVMU_output3             (MVMU_output15)
);

MVMU MVMU0(
    .clk                    (clk), 
    .RSTn                   (RSTn), 
    .web                    (MVMU_web0), 
    .addr                   (MVMU_addr0), 
    .data                   (updated_weight[0*128+:128]), 
    .pim_in                 (MVMU_output0),
    .pim_q                  (pim_q0),
    .pim_pro_q              (MVMU_input0), 
    .pim_pro_o_flag         (pim_pro_o_flag0),
    .MVMU_work_flag         (wire_MVMU_work_flag0),
    .q                      (q0)
);

MVMU MVMU1(
    .clk                    (clk), 
    .RSTn                   (RSTn), 
    .web                    (MVMU_web1), 
    .addr                   (MVMU_addr1), 
    .data                   (updated_weight[1*128+:128]), 
    .pim_in                 (MVMU_output1),
    .pim_q                  (pim_q1),
    .pim_pro_q              (MVMU_input1), 
    .pim_pro_o_flag         (pim_pro_o_flag1),
    .MVMU_work_flag         (wire_MVMU_work_flag1),
    .q                      (q1)
);

MVMU MVMU2(
    .clk                    (clk), 
    .RSTn                   (RSTn), 
    .web                    (MVMU_web2), 
    .addr                   (MVMU_addr2), 
    .data                   (updated_weight[2*128+:128]), 
    .pim_in                 (MVMU_output2),
    .pim_q                  (pim_q2),
    .pim_pro_q              (MVMU_input2), 
    .pim_pro_o_flag         (pim_pro_o_flag2),
    .MVMU_work_flag         (wire_MVMU_work_flag2),
    .q                      (q2)
);

MVMU MVMU3(
    .clk                    (clk), 
    .RSTn                   (RSTn), 
    .web                    (MVMU_web3), 
    .addr                   (MVMU_addr3), 
    .data                   (updated_weight[3*128+:128]), 
    .pim_in                 (MVMU_output3),
    .pim_q                  (pim_q3),
    .pim_pro_q              (MVMU_input3), 
    .pim_pro_o_flag         (pim_pro_o_flag3),
    .MVMU_work_flag         (wire_MVMU_work_flag3),
    .q                      (q3)
);

MVMU MVMU4(
    .clk                    (clk), 
    .RSTn                   (RSTn), 
    .web                    (MVMU_web4), 
    .addr                   (MVMU_addr4), 
    .data                   (updated_weight[4*128+:128]), 
    .pim_in                 (MVMU_output4),
    .pim_q                  (pim_q4),
    .pim_pro_q              (MVMU_input4), 
    .pim_pro_o_flag         (pim_pro_o_flag4),
    .MVMU_work_flag         (wire_MVMU_work_flag4),
    .q                      (q4)
);

MVMU MVMU5(
    .clk                    (clk), 
    .RSTn                   (RSTn), 
    .web                    (MVMU_web5), 
    .addr                   (MVMU_addr5), 
    .data                   (updated_weight[5*128+:128]), 
    .pim_in                 (MVMU_output5),
    .pim_q                  (pim_q5),
    .pim_pro_q              (MVMU_input5), 
    .pim_pro_o_flag         (pim_pro_o_flag5),
    .MVMU_work_flag         (wire_MVMU_work_flag5),
    .q                      (q5)
);

MVMU MVMU6(
    .clk                    (clk), 
    .RSTn                   (RSTn), 
    .web                    (MVMU_web6), 
    .addr                   (MVMU_addr6), 
    .data                   (updated_weight[6*128+:128]), 
    .pim_in                 (MVMU_output6),
    .pim_q                  (pim_q6),
    .pim_pro_q              (MVMU_input6), 
    .pim_pro_o_flag         (pim_pro_o_flag6),
    .MVMU_work_flag         (wire_MVMU_work_flag6),
    .q                      (q6)
);

MVMU MVMU7(
    .clk                    (clk), 
    .RSTn                   (RSTn), 
    .web                    (MVMU_web7), 
    .addr                   (MVMU_addr7), 
    .data                   (updated_weight[7*128+:128]), 
    .pim_in                 (MVMU_output7),
    .pim_q                  (pim_q7),
    .pim_pro_q              (MVMU_input7), 
    .pim_pro_o_flag         (pim_pro_o_flag7),
    .MVMU_work_flag         (wire_MVMU_work_flag7),
    .q                      (q7)
);

MVMU MVMU8(
    .clk                    (clk), 
    .RSTn                   (RSTn), 
    .web                    (MVMU_web8), 
    .addr                   (MVMU_addr8), 
    .data                   (updated_weight[8*128+:128]), 
    .pim_in                 (MVMU_output8),
    .pim_q                  (pim_q8),
    .pim_pro_q              (MVMU_input8), 
    .pim_pro_o_flag         (pim_pro_o_flag8),
    .MVMU_work_flag         (wire_MVMU_work_flag8),
    .q                      (q8)
);

MVMU MVMU9(
    .clk                    (clk), 
    .RSTn                   (RSTn), 
    .web                    (MVMU_web9), 
    .addr                   (MVMU_addr9), 
    .data                   (updated_weight[9*128+:128]), 
    .pim_in                 (MVMU_output9),
    .pim_q                  (pim_q9),
    .pim_pro_q              (MVMU_input9), 
    .pim_pro_o_flag         (pim_pro_o_flag9),
    .MVMU_work_flag         (wire_MVMU_work_flag9),
    .q                      (q9)
);

MVMU MVMU10(
    .clk                    (clk), 
    .RSTn                   (RSTn), 
    .web                    (MVMU_web10), 
    .addr                   (MVMU_addr10), 
    .data                   (updated_weight[10*128+:128]), 
    .pim_in                 (MVMU_output10),
    .pim_q                  (pim_q10),
    .pim_pro_q              (MVMU_input10), 
    .pim_pro_o_flag         (pim_pro_o_flag10),
    .MVMU_work_flag         (wire_MVMU_work_flag10),
    .q                      (q10)
);

MVMU MVMU11(
    .clk                    (clk), 
    .RSTn                   (RSTn), 
    .web                    (MVMU_web11), 
    .addr                   (MVMU_addr11), 
    .data                   (updated_weight[11*128+:128]), 
    .pim_in                 (MVMU_output11),
    .pim_q                  (pim_q11),
    .pim_pro_q              (MVMU_input11), 
    .pim_pro_o_flag         (pim_pro_o_flag11),
    .MVMU_work_flag         (wire_MVMU_work_flag11),
    .q                      (q11)
);

MVMU MVMU12(
    .clk                    (clk), 
    .RSTn                   (RSTn), 
    .web                    (MVMU_web12), 
    .addr                   (MVMU_addr12), 
    .data                   (updated_weight[12*128+:128]), 
    .pim_in                 (MVMU_output12),
    .pim_q                  (pim_q12),
    .pim_pro_q              (MVMU_input12), 
    .pim_pro_o_flag         (pim_pro_o_flag12),
    .MVMU_work_flag         (wire_MVMU_work_flag12),
    .q                      (q12)
);

MVMU MVMU13(
    .clk                    (clk), 
    .RSTn                   (RSTn), 
    .web                    (MVMU_web13), 
    .addr                   (MVMU_addr13), 
    .data                   (updated_weight[13*128+:128]), 
    .pim_in                 (MVMU_output13),
    .pim_q                  (pim_q13),
    .pim_pro_q              (MVMU_input13), 
    .pim_pro_o_flag         (pim_pro_o_flag13),
    .MVMU_work_flag         (wire_MVMU_work_flag13),
    .q                      (q13)
);

MVMU MVMU14(
    .clk                    (clk), 
    .RSTn                   (RSTn), 
    .web                    (MVMU_web14), 
    .addr                   (MVMU_addr14), 
    .data                   (updated_weight[14*128+:128]), 
    .pim_in                 (MVMU_output14),
    .pim_q                  (pim_q14),
    .pim_pro_q              (MVMU_input14), 
    .pim_pro_o_flag         (pim_pro_o_flag14),
    .MVMU_work_flag         (wire_MVMU_work_flag14),
    .q                      (q14)
);

MVMU MVMU15(
    .clk                    (clk), 
    .RSTn                   (RSTn), 
    .web                    (MVMU_web15), 
    .addr                   (MVMU_addr15), 
    .data                   (updated_weight[15*128+:128]), 
    .pim_in                 (MVMU_output15),
    .pim_q                  (pim_q15),
    .pim_pro_q              (MVMU_input15), 
    .pim_pro_o_flag         (pim_pro_o_flag15),
    .MVMU_work_flag         (wire_MVMU_work_flag15),
    .q                      (q15)
);

endmodule

