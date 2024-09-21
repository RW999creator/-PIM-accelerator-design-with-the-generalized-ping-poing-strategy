module Core_control_unit
#(  parameter DATA_WIDTH         = 8,
    parameter RW_DEPTH           = 8192,        // read weight bandwidth: 32*32*8
    parameter RI_DEPTH           = 2048,        // read input bandwidth: 32*8*4
    parameter INSTRUCTION_WIDTH  = 64,          // 64*256
    parameter MU_DATA_ADDR       = 4096,
    parameter MVMU_I_DEPTH       = 256,
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
    input clk,
    input RSTn,        // enable
    input web,         // work/idle control

    input      [7:0] rewriting_speed,

    // Core_instruction_memory control
    output reg [15:0]                  instruction_addr0,
    output reg [15:0]                  instruction_addr1,
    output reg [15:0]                  instruction_addr2,
    output reg [15:0]                  instruction_addr3,
    input      [INSTRUCTION_WIDTH-1:0] new_instruction0,
    input      [INSTRUCTION_WIDTH-1:0] new_instruction1,
    input      [INSTRUCTION_WIDTH-1:0] new_instruction2,
    input      [INSTRUCTION_WIDTH-1:0] new_instruction3,

    // for CHAS_execution_unit
    output reg CCU_workload_completed_flag0,
    output reg CCU_workload_completed_flag1,
    output reg CCU_workload_completed_flag2,
    output reg CCU_workload_completed_flag3,
    output reg [INSTRUCTION_WIDTH-1:0] instruction0,
    output reg [INSTRUCTION_WIDTH-1:0] instruction1,
    output reg [INSTRUCTION_WIDTH-1:0] instruction2,
    output reg [INSTRUCTION_WIDTH-1:0] instruction3,
    output reg                         finish_flag0,
    output reg                         finish_flag1,
    output reg                         finish_flag2,
    output reg                         finish_flag3,
    input                              start_flag0,
    input                              start_flag1,
    input                              start_flag2,
    input                              start_flag3,

    // Weight_SRAM control
    output reg        WS_web0,              // Weight_SRAM read control
    output reg        WS_web1,
    output reg        WS_web2,
    output reg        WS_web3,
    output reg [31:0] WS_read_addr0,        // Weight_SRAM read addr
    output reg [31:0] WS_read_addr1,
    output reg [31:0] WS_read_addr2,
    output reg [31:0] WS_read_addr3,
    output reg [15:0] WS_length0,
    output reg [15:0] WS_length1,
    output reg [15:0] WS_length2,
    output reg [15:0] WS_length3,
    output reg [5:0]  WS_width0,
    output reg [5:0]  WS_width1,
    output reg [5:0]  WS_width2,
    output reg [5:0]  WS_width3,
    output reg [15:0] WS_depth_of_jump0,
    output reg [15:0] WS_depth_of_jump1,
    output reg [15:0] WS_depth_of_jump2,
    output reg [15:0] WS_depth_of_jump3,

    // Activation_SRAM control
    output reg        AS_web0,              // A_SRAM read control
    output reg        AS_web1,
    output reg        AS_web2,
    output reg        AS_web3,
    output reg [31:0] AS_read_addr0,        // A_SRAM read addr
    output reg [31:0] AS_read_addr1,
    output reg [31:0] AS_read_addr2,
    output reg [31:0] AS_read_addr3,
    output reg [15:0] AS_length0,
    output reg [15:0] AS_length1,
    output reg [15:0] AS_length2,
    output reg [15:0] AS_length3,
    output reg [5:0]  AS_width0,
    output reg [5:0]  AS_width1,
    output reg [5:0]  AS_width2,
    output reg [5:0]  AS_width3,
    output reg [15:0] AS_depth_of_jump0,
    output reg [15:0] AS_depth_of_jump1,
    output reg [15:0] AS_depth_of_jump2,
    output reg [15:0] AS_depth_of_jump3,

    // Result_SRAM control
    output reg        RS_web0,              // Result_SRAM write control
    output reg        RS_web1,
    output reg        RS_web2,
    output reg        RS_web3,
    output reg [31:0] RS_write_addr0,       // Result_SRAM write addr
    output reg [31:0] RS_write_addr1,
    output reg [31:0] RS_write_addr2,
    output reg [31:0] RS_write_addr3,

    // Memory_unit control
    output reg [23:0]  MU_web,              // write/read/clean control
    output reg [127:0] MU_output_addr,
    output reg [31:0]  MU_core_output_addr0,
    output reg [31:0]  MU_core_output_addr1,
    output reg [31:0]  MU_core_output_addr2,
    output reg [31:0]  MU_core_output_addr3,
    output reg [31:0]  MU_I_input_addr0,        // input input addr
    output reg [31:0]  MU_I_input_addr1,
    output reg [31:0]  MU_I_input_addr2,
    output reg [31:0]  MU_I_input_addr3,
    output reg [7:0]   Batch_of_data0,       // Select the input addr required by the MVMU 
    output reg [7:0]   Batch_of_data1,
    output reg [7:0]   Batch_of_data2,
    output reg [7:0]   Batch_of_data3,

    // MVMU control
    output reg [15:0] MVMU_web,                  // write/read/PIM/clean/PIM_Pro
    output reg [63:0] MVMU_addr,                 // write/read/PIM/clean/PIM_Pro
    input      [3:0]  MVMU_pim_pro_o_flag        // PIM_Pro output flag
);

//--------------Internal variables---------------- 

// Flag
reg [7:0]  RW_flag0;       // read weight flag
reg [7:0]  RW_flag1;
reg [7:0]  RW_flag2;
reg [7:0]  RW_flag3;
reg [7:0]  RI_flag0;       // read input flag
reg [7:0]  RI_flag1;
reg [7:0]  RI_flag2;
reg [7:0]  RI_flag3;
reg [7:0]  MVMU_write_flag0;
reg [7:0]  MVMU_write_flag1;
reg [7:0]  MVMU_write_flag2;
reg [7:0]  MVMU_write_flag3;
reg [15:0] rewriting_flag0;
reg [15:0] rewriting_flag1;
reg [15:0] rewriting_flag2;
reg [15:0] rewriting_flag3;
reg [7:0]  PIM_flag0;
reg [7:0]  PIM_flag1;
reg [7:0]  PIM_flag2;
reg [7:0]  PIM_flag3;
reg [7:0]  WRM_flag0;
reg [7:0]  WRM_flag1;
reg [7:0]  WRM_flag2;
reg [7:0]  WRM_flag3;
reg [7:0]  MU_output_flag0;
reg [7:0]  MU_output_flag1;
reg [7:0]  MU_output_flag2;
reg [7:0]  MU_output_flag3;
reg [31:0] wait_flag0; 
reg [31:0] wait_flag1;
reg [31:0] wait_flag2;
reg [31:0] wait_flag3;

// cycles
reg [31:0] cycles_of_RWS;
reg [31:0] cycles_of_RDS;
reg [31:0] cycles_of_PIM;
reg [31:0] cycles_of_WRM;
reg [31:0] cycles_of_WMS;
reg [31:0] cycles_of_W;

integer f;

//--------------Code Starts Here------------------ 
initial begin
    // Weight_SRAM control
    WS_web0           = 0;
    WS_web1           = 0;
    WS_web2           = 0;
    WS_web3           = 0;
    WS_read_addr0     = 0;
    WS_read_addr1     = 0;
    WS_read_addr2     = 0;
    WS_read_addr3     = 0;
    WS_length0        = 0;
    WS_length1        = 0;
    WS_length2        = 0;
    WS_length3        = 0;
    WS_width0         = 0;
    WS_width1         = 0;
    WS_width2         = 0;
    WS_width3         = 0;
    WS_depth_of_jump0 = 0;
    WS_depth_of_jump1 = 0;
    WS_depth_of_jump2 = 0;
    WS_depth_of_jump3 = 0;

    // Activation_SRAM control
    AS_web0           = 0;
    AS_web1           = 0;
    AS_web2           = 0;
    AS_web3           = 0;
    AS_read_addr0     = 0;
    AS_read_addr1     = 0;
    AS_read_addr2     = 0;
    AS_read_addr3     = 0;
    AS_length0        = 0;
    AS_length1        = 0;
    AS_length2        = 0;
    AS_length3        = 0;
    AS_width0         = 0;
    AS_width1         = 0;
    AS_width2         = 0;
    AS_width3         = 0;
    AS_depth_of_jump0 = 0;
    AS_depth_of_jump1 = 0;
    AS_depth_of_jump2 = 0;
    AS_depth_of_jump3 = 0;

    // Result_SRAM control
    RS_web0        = 0;
    RS_web1        = 0;
    RS_web2        = 0;
    RS_web3        = 0;
    RS_write_addr0 = 0;
    RS_write_addr1 = 0;
    RS_write_addr2 = 0;
    RS_write_addr3 = 0;

    // Memory_unit control
    MU_web              = 0;
    MU_output_addr      = 0;
    MU_core_output_addr0 = 0;
    MU_core_output_addr1 = 0;
    MU_core_output_addr2 = 0;
    MU_core_output_addr3 = 0;
    MU_I_input_addr0    = 0;
    MU_I_input_addr1    = 0;
    MU_I_input_addr2    = 0;
    MU_I_input_addr3    = 0;
    Batch_of_data0      = 0;
    Batch_of_data1      = 0;
    Batch_of_data2      = 0;
    Batch_of_data3      = 0;

    // MVMU control
    MVMU_web  = 0;
    MVMU_addr = 0;

    // Core_instruction_memory control
    instruction_addr0 = 0;
    instruction_addr1 = 0;
    instruction_addr2 = 0;
    instruction_addr3 = 0;

    instruction0 = 0;
    instruction1 = 0;
    instruction2 = 0;
    instruction3 = 0;

    // Flag
    finish_flag0     = 1;
    finish_flag1     = 1;
    finish_flag2     = 1;
    finish_flag3     = 1;
    RW_flag0         = 0;
    RW_flag1         = 0;
    RW_flag2         = 0;
    RW_flag3         = 0;
    RI_flag0         = 0;
    RI_flag1         = 0;
    RI_flag2         = 0;
    RI_flag3         = 0;
    PIM_flag0        = 0;
    PIM_flag1        = 0;
    PIM_flag2        = 0;
    PIM_flag3        = 0;
    rewriting_flag0  = 0;
    rewriting_flag1  = 0;
    rewriting_flag2  = 0;
    rewriting_flag3  = 0;
    WRM_flag0        = 0;
    WRM_flag1        = 0;
    WRM_flag2        = 0;
    WRM_flag3        = 0;
    MU_output_flag0  = 0;
    MU_output_flag1  = 0;
    MU_output_flag2  = 0;
    MU_output_flag3  = 0;
    wait_flag0       = 0;
    wait_flag1       = 0;
    wait_flag2       = 0;
    wait_flag3       = 0;

    // cycles
    cycles_of_RWS = 0;
    cycles_of_RDS = 0;
    cycles_of_PIM = 0;
    cycles_of_WRM = 0;
    cycles_of_WMS = 0;
    cycles_of_W   = 0;
end

// update the instruction
always @ (posedge clk) begin
    if(RSTn) begin
        if( web ) begin
            if( (finish_flag0) && (start_flag0) ) begin
                instruction0 <= new_instruction0;
                finish_flag0 <= 0;
                instruction_addr0 <= instruction_addr0 + 16;
            end
            if( (finish_flag1) && (start_flag1) ) begin
                instruction1 <= new_instruction1;
                finish_flag1 <= 0;
                instruction_addr1 <= instruction_addr1 + 16;
            end
            if( (finish_flag2) && (start_flag2) ) begin
                instruction2 <= new_instruction2;
                finish_flag2 <= 0;
                instruction_addr2 <= instruction_addr2 + 16;
            end
            if( (finish_flag3) && (start_flag3) ) begin
                instruction3 <= new_instruction3;
                finish_flag3 <= 0;
                instruction_addr3 <= instruction_addr3 + 16;
            end
        end
        else begin
            finish_flag0      <= 1;
            finish_flag1      <= 1;
            finish_flag2      <= 1;
            finish_flag3      <= 1;
            instruction_addr0 <= 0;
            instruction_addr1 <= 0;
            instruction_addr2 <= 0;
            instruction_addr3 <= 0;
        end
    end
end

always @ (posedge clk) begin
    if(RSTn) begin
        if( web ) begin
            // core0
            if( !finish_flag0 ) begin
                case ( instruction0[63:60] )
                    RDS: begin
                        AS_web0             <= 1;                                                         // set Activation_SRAM to read mode
                        AS_read_addr0       <= instruction0[17:0];                                         // give Activation_SRAM read addr
                        AS_length0          <= instruction0[33:18];                                        // give Activation_SRAM length
                        AS_width0           <= instruction0[39:34];                                        // give Activation_SRAM width
                        AS_depth_of_jump0   <= instruction0[55:40];                                        // give Activation_SRAM depth of jump
                        MU_web[16]          <= 1;                                                         // start MU core input
                        MU_I_input_addr0    <= MU_DATA_ADDR+0*2048;         // give the MU core input addr
                        RI_flag0            <= RI_flag0 + 1;                                               // update flag
                        if(RI_flag0 == 3) begin        // Activation_SRAM reading completed in 2 cycles
                            finish_flag0         <= 1;
                            AS_web0             <= 0;
                            AS_read_addr0       <= 0;
                            AS_length0          <= 0;
                            AS_width0           <= 0;
                            AS_depth_of_jump0   <= 0;
                            MU_web[16]          <= 0;
                            MU_I_input_addr0    <= 0;
                            RI_flag0            <= 0;
                        end
                    end
                    RWM: begin
                        if(rewriting_flag0 >= 256*4/rewriting_speed) begin
                            WS_web0             <= 0;
                            WS_read_addr0       <= 0;
                            WS_length0          <= 0;
                            WS_width0           <= 0;
                            WS_depth_of_jump0   <= 0;
                        end
                        else begin
                            WS_web0             <= 1;                                          // set Weight_SRAM to read mode
                            WS_read_addr0       <= instruction0[23:0 ];                        // give Weight_SRAM read addr
                            WS_length0          <= instruction0[33:24];                        // give Weight_SRAM length
                            WS_width0           <= instruction0[39:34];                        // give Weight_SRAM width
                            WS_depth_of_jump0   <= instruction0[55:40];                        // give Weight_SRAM depth of jump
                        end
                        rewriting_flag0 <= rewriting_flag0 + 1;        // refresh addrs
                        if(rewriting_flag0 >= 2) begin
                            MVMU_web [(0*4 )+:4 ] <= 1;                        // start MVMUs write
                            MVMU_addr[(0*16)+:16] <= (rewriting_flag0-2)*rewriting_speed;        // give MVMUs write addr
                        end
                        if(rewriting_flag0 == 256*4/rewriting_speed+2) begin        // MVMUs writing completed in 256 cycles
                            finish_flag0               <= 1;
                            MVMU_web      [(0*4 )+:4 ] <= 5;        // start MVMUs write
                            MVMU_addr     [(0*16)+:16] <= 0;        // clean MVMUs write addr
                            rewriting_flag0            <= 0;
                        end
                    end
                    PIM: begin
                        MU_output_addr[32*0+:32] <= MU_DATA_ADDR+0*2048+instruction0[15:0 ];        // give MU output addr(data) for MVMUs
                        MU_web[0]                <= 1;                                                            // start MU output for MVMUs
                        PIM_flag0 <= 1;
                        if( PIM_flag0 )
                            MVMU_web[0*4+:4] <= 4;       // start MVMUs PIM
                        if(MVMU_pim_pro_o_flag[0] == 1) begin
                            finish_flag0 <= 1;
                            MU_output_addr[32*0+:32] <= 0;        // clean MU output addr
                            MU_web[0]                <= 0;        // stop MU output for MVMUs
                            PIM_flag0 <= 0;
                        end
                    end
                    WRM: begin
                        MU_web[4] <= 1;                            // start MU output for MVMUs
                        Batch_of_data0 <= instruction0[7:0];        // give MU input addr for MVMUs output
                        WRM_flag0 <= WRM_flag0 + 1;
                        if(WRM_flag0 == 2) begin        // completed in 2 cycles
                            finish_flag0        <= 1;
                            MU_web[4]          <= 0;        // stop MU input by MVMUs
                            Batch_of_data0     <= 0;        // clean MU input addr for MVMUs output
                            WRM_flag0          <= 0;
                            MVMU_web[(0*4)+:4] <= 5;        // PIM idle
                        end
                    end
                    WMS: begin
                        MU_web[8]            <= 1;        // start MU core output
                        MU_core_output_addr0 <= 0;        // give MU core output addr
                        MU_output_flag0      <= MU_output_flag0 + 1;
                        if(MU_output_flag0 == 1) begin
                            RS_web0        <= 1;                        // set Result_SRAM to write mode
                            RS_write_addr0 <= instruction0[23:0];        // give Result_SRAM write addr
                        end
                        if(MU_output_flag0 == 2) begin        // completed in 2 cycles
                            finish_flag0          <= 1;
                            MU_web[8]            <= 0;        // stop MU core output
                            MU_core_output_addr0 <= 0;        // clean MU core output addr
                            RS_web0              <= 0;        // stop Result_SRAM  written
                            RS_write_addr0       <= 0;        // clean Result_SRAM write addr
                            MU_output_flag0      <= 0;
                        end
                    end
                    W  : begin
                        wait_flag0 <= wait_flag0 + 1;
                        if(wait_flag0 == instruction0[31:0]-2) begin
                            wait_flag0  <= 0;
                            finish_flag0 <= 1;
                        end
                    end
                    S  : begin
                        CCU_workload_completed_flag0 <= 1;
                    end
                endcase
            end
            // core1
            if( !finish_flag1 ) begin
                case ( instruction1[63:60] )
                    RDS: begin
                        AS_web1             <= 1;                                                         // set Activation_SRAM to read mode
                        AS_read_addr1       <= instruction1[17:0];                                         // give Activation_SRAM read addr
                        AS_length1          <= instruction1[33:18];                                        // give Activation_SRAM length
                        AS_width1           <= instruction1[39:34];                                        // give Activation_SRAM width
                        AS_depth_of_jump1   <= instruction1[55:40];                                        // give Activation_SRAM depth of jump
                        MU_web[17]          <= 1;                                                         // start MU core input
                        MU_I_input_addr1    <= MU_DATA_ADDR+1*2048;         // give the MU core input addr
                        RI_flag1            <= RI_flag1 + 1;                                               // update flag
                        if(RI_flag1 == 3) begin        // Activation_SRAM reading completed in 2 cycles
                            finish_flag1         <= 1;
                            AS_web1             <= 0;
                            AS_read_addr1       <= 0;
                            AS_length1          <= 0;
                            AS_width1           <= 0;
                            AS_depth_of_jump1   <= 0;
                            MU_web[17]          <= 0;
                            MU_I_input_addr1    <= 0;
                            RI_flag1            <= 0;
                        end
                    end
                    RWM: begin
                        if(rewriting_flag1 >= 256*4/rewriting_speed) begin
                            WS_web1             <= 0;
                            WS_read_addr1       <= 0;
                            WS_length1          <= 0;
                            WS_width1           <= 0;
                            WS_depth_of_jump1   <= 0;
                        end
                        else begin
                            WS_web1             <= 1;                                             // set Weight_SRAM to read mode
                            WS_read_addr1       <= instruction1[23:0 ];                        // give Weight_SRAM read addr
                            WS_length1          <= instruction1[33:24];                        // give Weight_SRAM length
                            WS_width1           <= instruction1[39:34];                        // give Weight_SRAM width
                            WS_depth_of_jump1   <= instruction1[55:40];                        // give Weight_SRAM depth of jump
                        end
                        rewriting_flag1 <= rewriting_flag1 + 1;        // refresh addrs
                        if(rewriting_flag1 >= 2) begin
                            MVMU_web [(1*4 )+:4 ] <= 1;                       // start MVMUs write
                            MVMU_addr[(1*16)+:16] <= (rewriting_flag1-2)*rewriting_speed;        // give MVMUs write addr
                        end
                        if(rewriting_flag1 == 256*4/rewriting_speed+2) begin        // MVMUs writing completed 256 32 cycles
                            finish_flag1               <= 1;
                            MVMU_web      [(1*4 )+:4 ] <= 5;        // start MVMUs write
                            MVMU_addr     [(1*16)+:16] <= 0;        // clean MVMUs write addr
                            rewriting_flag1            <= 0;
                        end
                    end
                    PIM: begin
                        MU_output_addr[32*1+:32] <= MU_DATA_ADDR+1*2048+instruction1[15:0 ];        // give MU output addr(data) for MVMUs
                        MU_web[1]                <= 1;                                                            // start MU output for MVMUs
                        PIM_flag1 <= 1;
                        if( PIM_flag1 )
                            MVMU_web[1*4+:4] <= 4;       // start MVMUs PIM
                        if(MVMU_pim_pro_o_flag[1] == 1) begin
                            finish_flag1 <= 1;
                            MU_output_addr[32*1+:32] <= 0;        // clean MU output addr
                            MU_web[1]                <= 0;        // stop MU output for MVMUs
                            PIM_flag1 <= 0;
                        end
                    end
                    WRM: begin
                        MU_web[5] <= 1;                            // start MU output for MVMUs
                        Batch_of_data1 <= instruction1[7:0];        // give MU input addr for MVMUs output
                        WRM_flag1 <= WRM_flag1 + 1;
                        if(WRM_flag1 == 2) begin        // completed in 2 cycles
                            finish_flag1        <= 1;
                            MU_web[5]          <= 0;        // stop MU input by MVMUs
                            Batch_of_data1     <= 0;        // clean MU input addr for MVMUs output
                            WRM_flag1          <= 0;
                            MVMU_web[(1*4)+:4] <= 5;        // PIM idle
                        end
                    end
                    WMS: begin
                        MU_web[9]            <= 1;        // start MU core output
                        MU_core_output_addr1 <= 0;        // give MU core output addr
                        MU_output_flag1      <= MU_output_flag1 + 1;
                        if(MU_output_flag1 == 1) begin
                            RS_web1        <= 1;                        // set Result_SRAM to write mode
                            RS_write_addr1 <= instruction1[23:0];        // give Result_SRAM write addr
                        end
                        if(MU_output_flag1 == 2) begin        // completed in 2 cycles
                            finish_flag1          <= 1;
                            MU_web[9]            <= 0;        // stop MU core output
                            MU_core_output_addr1 <= 0;        // clean MU core output addr
                            RS_web1              <= 0;        // stop Result_SRAM  written
                            RS_write_addr1       <= 0;        // clean Result_SRAM write addr
                            MU_output_flag1      <= 0;
                        end
                    end
                    W  : begin
                        wait_flag1 <= wait_flag1 + 1;
                        if(wait_flag1 == instruction1[31:0]-2) begin
                            wait_flag1  <= 0;
                            finish_flag1 <= 1;
                        end
                    end
                    S  : begin
                        CCU_workload_completed_flag1 <= 1;
                    end
                endcase
            end
            // core2
            if( !finish_flag2 ) begin
                case ( instruction2[63:60] )
                    RDS: begin
                        AS_web2             <= 1;                                                         // set Activation_SRAM to read mode
                        AS_read_addr2       <= instruction2[17:0];                                         // give Activation_SRAM read addr
                        AS_length2          <= instruction2[33:18];                                        // give Activation_SRAM length
                        AS_width2           <= instruction2[39:34];                                        // give Activation_SRAM width
                        AS_depth_of_jump2   <= instruction2[55:40];                                        // give Activation_SRAM depth of jump
                        MU_web[18]          <= 1;                                                         // start MU core input
                        MU_I_input_addr2    <= MU_DATA_ADDR+2*2048;         // give the MU core input addr
                        RI_flag2            <= RI_flag2 + 1;                                               // update flag
                        if(RI_flag2 == 3) begin        // Activation_SRAM reading completed in 2 cycles
                            finish_flag2         <= 1;
                            AS_web2             <= 0;
                            AS_read_addr2       <= 0;
                            AS_length2          <= 0;
                            AS_width2           <= 0;
                            AS_depth_of_jump2   <= 0;
                            MU_web[18]          <= 0;
                            MU_I_input_addr2    <= 0;
                            RI_flag2            <= 0;
                        end
                    end
                    RWM: begin
                        if(rewriting_flag2 >= 256*4/rewriting_speed) begin
                            WS_web2             <= 0;
                            WS_read_addr2       <= 0;
                            WS_length2          <= 0;
                            WS_width2           <= 0;
                            WS_depth_of_jump2   <= 0;
                        end
                        else begin
                            WS_web2             <= 1;                                             // set Weight_SRAM to read mode
                            WS_read_addr2       <= instruction2[23:0 ];                        // give Weight_SRAM read addr
                            WS_length2          <= instruction2[33:24];                        // give Weight_SRAM length
                            WS_width2           <= instruction2[39:34];                        // give Weight_SRAM width
                            WS_depth_of_jump2   <= instruction2[55:40];                        // give Weight_SRAM depth of jump
                        end
                        rewriting_flag2 <= rewriting_flag2 + 1;        // refresh addrs
                        if(rewriting_flag2 >= 2) begin
                            MVMU_web [(2*4 )+:4 ] <= 1;                        // start MVMUs write
                            MVMU_addr[(2*16)+:16] <= (rewriting_flag2-2)*rewriting_speed;        // give MVMUs write addr
                        end
                        if(rewriting_flag2 == 256*4/rewriting_speed+2) begin        // MVMUs writing completed in 256 cycles
                            finish_flag2               <= 1;
                            MVMU_web      [(2*4 )+:4 ] <= 5;        // start MVMUs write
                            MVMU_addr     [(2*16)+:16] <= 0;        // clean MVMUs write addr
                            rewriting_flag2            <= 0;
                        end
                    end
                    PIM: begin
                        MU_output_addr[32*2+:32] <= MU_DATA_ADDR+2*2048+instruction2[15:0 ];        // give MU output addr(data) for MVMUs
                        MU_web[2]                <= 1;                                                            // start MU output for MVMUs
                        PIM_flag2 <= 1;
                        if( PIM_flag2 )
                            MVMU_web[2*4+:4] <= 4;       // start MVMUs PIM
                        if(MVMU_pim_pro_o_flag[2] == 1) begin
                            finish_flag2 <= 1;
                            MU_output_addr[32*2+:32] <= 0;        // clean MU output addr
                            MU_web[2]                <= 0;        // stop MU output for MVMUs
                            PIM_flag2 <= 0;
                        end
                    end
                    WRM: begin
                        MU_web[6] <= 1;                            // start MU output for MVMUs
                        Batch_of_data2 <= instruction2[7:0];        // give MU input addr for MVMUs output
                        WRM_flag2 <= WRM_flag2 + 1;
                        if(WRM_flag2 == 2) begin        // completed in 2 cycles
                            finish_flag2        <= 1;
                            MU_web[6]          <= 0;        // stop MU input by MVMUs
                            Batch_of_data2     <= 0;        // clean MU input addr for MVMUs output
                            WRM_flag2          <= 0;
                            MVMU_web[(2*4)+:4] <= 5;        // PIM idle
                        end
                    end
                    WMS: begin
                        MU_web[10]           <= 1;        // start MU core output
                        MU_core_output_addr2 <= 0;        // give MU core output addr
                        MU_output_flag2      <= MU_output_flag2 + 1;
                        if(MU_output_flag2 == 1) begin
                            RS_web2        <= 1;                        // set Result_SRAM to write mode
                            RS_write_addr2 <= instruction2[23:0];        // give Result_SRAM write addr
                        end
                        if(MU_output_flag2 == 2) begin        // completed in 2 cycles
                            finish_flag2          <= 1;
                            MU_web[10]           <= 0;        // stop MU core output
                            MU_core_output_addr2 <= 0;        // clean MU core output addr
                            RS_web2              <= 0;        // stop Result_SRAM  written
                            RS_write_addr2       <= 0;        // clean Result_SRAM write addr
                            MU_output_flag2      <= 0;
                        end
                    end
                    W  : begin
                        wait_flag2 <= wait_flag2 + 1;
                        if(wait_flag2 == instruction2[31:0]-2) begin
                            wait_flag2  <= 0;
                            finish_flag2 <= 1;
                        end
                    end
                    S  : begin
                        CCU_workload_completed_flag2 <= 1;
                    end
                endcase
            end
            // core3
            if( !finish_flag3 ) begin
                case ( instruction3[63:60] )
                    RDS: begin
                        AS_web3             <= 1;                                                         // set Activation_SRAM to read mode
                        AS_read_addr3       <= instruction3[17:0];                                         // give Activation_SRAM read addr
                        AS_length3          <= instruction3[33:18];                                        // give Activation_SRAM length
                        AS_width3           <= instruction3[39:34];                                        // give Activation_SRAM width
                        AS_depth_of_jump3   <= instruction3[55:40];                                        // give Activation_SRAM depth of jump
                        MU_web[19]          <= 1;                                                         // start MU core input
                        MU_I_input_addr3    <= MU_DATA_ADDR+3*2048;         // give the MU core input addr
                        RI_flag3            <= RI_flag3 + 1;                                               // update flag
                        if(RI_flag3 == 3) begin        // Activation_SRAM reading completed in 2 cycles
                            finish_flag3         <= 1;
                            AS_web3             <= 0;
                            AS_read_addr3       <= 0;
                            AS_length3          <= 0;
                            AS_width3           <= 0;
                            AS_depth_of_jump3   <= 0;
                            MU_web[19]          <= 0;
                            MU_I_input_addr3    <= 0;
                            RI_flag3            <= 0;
                        end
                    end
                    RWM: begin
                        if(rewriting_flag3 >= 256*4/rewriting_speed) begin
                            WS_web3             <= 0;
                            WS_read_addr3       <= 0;
                            WS_length3          <= 0;
                            WS_width3           <= 0;
                            WS_depth_of_jump3   <= 0;
                        end
                        else begin
                            WS_web3             <= 1;                                             // set Weight_SRAM to read mode
                            WS_read_addr3       <= instruction3[23:0 ];                        // give Weight_SRAM read addr
                            WS_length3          <= instruction3[33:24];                        // give Weight_SRAM length
                            WS_width3           <= instruction3[39:34];                        // give Weight_SRAM width
                            WS_depth_of_jump3   <= instruction3[55:40];                        // give Weight_SRAM depth of jump
                        end
                        rewriting_flag3 <= rewriting_flag3 + 1;        // refresh addrs
                        if(rewriting_flag3 >= 2) begin
                            MVMU_web [(3*4 )+:4 ] <= 1;                        // start MVMUs write
                            MVMU_addr[(3*16)+:16] <= (rewriting_flag3-2)*rewriting_speed;        // give MVMUs write addr
                        end
                        if(rewriting_flag3 == 256*4/rewriting_speed+2) begin        // MVMUs writing completed in 256 cycles
                            finish_flag3               <= 1;
                            MVMU_web      [(3*4 )+:4 ] <= 5;        // start MVMUs write
                            MVMU_addr     [(3*16)+:16] <= 0;        // clean MVMUs write addr
                            rewriting_flag3            <= 0;
                        end
                    end
                    PIM: begin
                        MU_output_addr[32*3+:32] <= MU_DATA_ADDR+3*2048+instruction3[15:0 ];        // give MU output addr(data) for MVMUs
                        MU_web[3]                <= 1;                                                            // start MU output for MVMUs
                        PIM_flag3 <= 1;
                        if( PIM_flag3 )
                            MVMU_web[3*4+:4] <= 4;       // start MVMUs PIM
                        if(MVMU_pim_pro_o_flag[3] == 1) begin
                            finish_flag3 <= 1;
                            MU_output_addr[32*3+:32] <= 0;        // clean MU output addr
                            MU_web[3]                <= 0;        // stop MU output for MVMUs
                            PIM_flag3 <= 0;
                        end
                    end
                    WRM: begin
                        MU_web[7] <= 1;                            // start MU output for MVMUs
                        Batch_of_data3 <= instruction3[7:0];        // give MU input addr for MVMUs output
                        WRM_flag3 <= WRM_flag3 + 1;
                        if(WRM_flag3 == 2) begin        // completed in 2 cycles
                            finish_flag3        <= 1;
                            MU_web[7]          <= 0;        // stop MU input by MVMUs
                            Batch_of_data3     <= 0;        // clean MU input addr for MVMUs output
                            WRM_flag3          <= 0;
                            MVMU_web[(3*4)+:4] <= 5;        // PIM idle
                        end
                    end
                    WMS: begin
                        MU_web[11]           <= 1;        // start MU core output
                        MU_core_output_addr3 <= 0;        // give MU core output addr
                        MU_output_flag3      <= MU_output_flag3 + 1;
                        if(MU_output_flag3 == 1) begin
                            RS_web3        <= 1;                        // set Result_SRAM to write mode
                            RS_write_addr3 <= instruction3[23:0];        // give Result_SRAM write addr
                        end
                        if(MU_output_flag3 == 2) begin        // completed in 2 cycles
                            finish_flag3          <= 1;
                            MU_web[11]           <= 0;        // stop MU core output
                            MU_core_output_addr3 <= 0;        // clean MU core output addr
                            RS_web3              <= 0;        // stop Result_SRAM  written
                            RS_write_addr3       <= 0;        // clean Result_SRAM write addr
                            MU_output_flag3      <= 0;
                        end
                    end
                    W  : begin
                        wait_flag3 <= wait_flag3 + 1;
                        if(wait_flag3 == instruction3[31:0]-2) begin
                            wait_flag3  <= 0;
                            finish_flag3 <= 1;
                        end
                    end
                    S  : begin
                        CCU_workload_completed_flag3 <= 1;
                    end
                endcase
            end
        end
        else begin
            CCU_workload_completed_flag0 <= 0;
            CCU_workload_completed_flag1 <= 0;
            CCU_workload_completed_flag2 <= 0;
            CCU_workload_completed_flag3 <= 0;
        end
    end
end

endmodule