module Tile_control_unit
#(  parameter INSTRUCTION_WIDTH = 64,
    parameter RWS = 1,
    parameter RDS = 2,
    parameter PIM = 3,
    parameter WRS = 4,
    parameter WMS = 5,
    parameter SO1 = 6,
    parameter SO2 = 7,
    parameter SIC = 8,
    parameter SCS = 9,
    parameter W   = 10,
    parameter MMM = 11,
    parameter GBI = 12,
    parameter RWM = 13,
    parameter S   = 0
)
(
    input         clk,
    input         RSTn,                   // enable

    // Bandwidth utilization record 
    input [63:0] counter,
    input [63:0] peak_bandwidth,
    input [63:0] utilization_time,

    // macros input record
    input [63:0] MVMU_work_flag0,
    input [63:0] MVMU_work_flag1,
    input [63:0] MVMU_work_flag2,
    input [63:0] MVMU_work_flag3,
    input [63:0] MVMU_work_flag4,
    input [63:0] MVMU_work_flag5,
    input [63:0] MVMU_work_flag6,
    input [63:0] MVMU_work_flag7,
    input [63:0] MVMU_work_flag8,
    input [63:0] MVMU_work_flag9,
    input [63:0] MVMU_work_flag10,
    input [63:0] MVMU_work_flag11,
    input [63:0] MVMU_work_flag12,
    input [63:0] MVMU_work_flag13,
    input [63:0] MVMU_work_flag14,
    input [63:0] MVMU_work_flag15,

    // Instruction_generation_unit control
    output reg IGU_web,
    input      IGU_done_flag,

    // Tile_instruction_memory control
    output reg [2:0]  t_i_m_web,        // read/output control
    output reg [15:0] start_ins_addr0,
    output reg [15:0] start_ins_addr1,
    output reg [15:0] start_ins_addr2,
    output reg [15:0] start_ins_addr3,
    output reg [15:0] start_ins_addr4,
    output reg [15:0] start_ins_addr5,
    output reg [15:0] start_ins_addr6,
    output reg [15:0] start_ins_addr7,
    output reg [15:0] start_ins_addr8,
    output reg [15:0] start_ins_addr9,
    output reg [15:0] start_ins_addr10,
    output reg [15:0] start_ins_addr11,
    output reg [15:0] start_ins_addr12,
    output reg [15:0] start_ins_addr13,
    output reg [15:0] start_ins_addr14,
    output reg [15:0] start_ins_addr15,
    output reg [15:0] end_ins_addr0,
    output reg [15:0] end_ins_addr1,
    output reg [15:0] end_ins_addr2,
    output reg [15:0] end_ins_addr3,
    output reg [15:0] end_ins_addr4,
    output reg [15:0] end_ins_addr5,
    output reg [15:0] end_ins_addr6,
    output reg [15:0] end_ins_addr7,
    output reg [15:0] end_ins_addr8,
    output reg [15:0] end_ins_addr9,
    output reg [15:0] end_ins_addr10,
    output reg [15:0] end_ins_addr11,
    output reg [15:0] end_ins_addr12,
    output reg [15:0] end_ins_addr13,
    output reg [15:0] end_ins_addr14,
    output reg [15:0] end_ins_addr15,
    output reg [15:0] core_ins_output_flag,
    output reg [15:0] instruction_addr,
    input      [INSTRUCTION_WIDTH-1:0] new_instruction,

    // Core_instruction_memory control
    output reg       c_i_m_web0,
    output reg       c_i_m_web1,
    output reg       c_i_m_web2,
    output reg       c_i_m_web3,
    output reg       c_i_m_web4,
    output reg       c_i_m_web5,
    output reg       c_i_m_web6,
    output reg       c_i_m_web7,
    output reg       c_i_m_web8,
    output reg       c_i_m_web9,
    output reg       c_i_m_web10,
    output reg       c_i_m_web11,
    output reg       c_i_m_web12,
    output reg       c_i_m_web13,
    output reg       c_i_m_web14,
    output reg       c_i_m_web15,
    output reg [15:0] c_i_m_write_addr0,
    output reg [15:0] c_i_m_write_addr1,
    output reg [15:0] c_i_m_write_addr2,
    output reg [15:0] c_i_m_write_addr3,
    output reg [15:0] c_i_m_write_addr4,
    output reg [15:0] c_i_m_write_addr5,
    output reg [15:0] c_i_m_write_addr6,
    output reg [15:0] c_i_m_write_addr7,
    output reg [15:0] c_i_m_write_addr8,
    output reg [15:0] c_i_m_write_addr9,
    output reg [15:0] c_i_m_write_addr10,
    output reg [15:0] c_i_m_write_addr11,
    output reg [15:0] c_i_m_write_addr12,
    output reg [15:0] c_i_m_write_addr13,
    output reg [15:0] c_i_m_write_addr14,
    output reg [15:0] c_i_m_write_addr15,

    // Core_control_unit control
    output reg core_control_unit_web0,
    output reg core_control_unit_web1,
    output reg core_control_unit_web2,
    output reg core_control_unit_web3,
    output reg core_control_unit_web4,
    output reg core_control_unit_web5,
    output reg core_control_unit_web6,
    output reg core_control_unit_web7,
    output reg core_control_unit_web8,
    output reg core_control_unit_web9,
    output reg core_control_unit_web10,
    output reg core_control_unit_web11,
    output reg core_control_unit_web12,
    output reg core_control_unit_web13,
    output reg core_control_unit_web14,
    output reg core_control_unit_web15,
    input      workload_completed_flag0,
    input      workload_completed_flag1,
    input      workload_completed_flag2,
    input      workload_completed_flag3,
    input      workload_completed_flag4,
    input      workload_completed_flag5,
    input      workload_completed_flag6,
    input      workload_completed_flag7,
    input      workload_completed_flag8,
    input      workload_completed_flag9,
    input      workload_completed_flag10,
    input      workload_completed_flag11,
    input      workload_completed_flag12,
    input      workload_completed_flag13,
    input      workload_completed_flag14,
    input      workload_completed_flag15,

    // Activation_SRAM control
    output reg AS_web_SFU,

    // Result_SRAM control
    output reg RS_web_SFU,
    input [31:0] num_of_wm,        // number of working macros
    input [31:0] result_memory_usage,

    // SFU control
    output reg [3:0] SFU_web,         // SFU for layer1/layer2/layer3 control
    output reg [3:0] Result_column, 
    output reg [5:0] Result_picture,    

    output reg [6:0] MVMUa,    
    output reg [4:0] MVMUb, 
    output reg [4:0] MVMUc, 
    output reg [4:0] MVMUd, 
    output reg [5:0] timea,    
    output reg [5:0] timeb, 
    output reg [5:0] MVMUg, 
    output reg [5:0] MVMUh,

    input  SFU_flag
);

//--------------Internal variables---------------- 

// Controller
reg [INSTRUCTION_WIDTH-1:0] instruction;

// Flag
reg [7:0] init_flag;
reg [7:0] finish_flag;
reg [7:0] SFU_output_flag;
reg [31:0] send_ins_flag;
reg [7:0] SO1_flag;
reg [7:0] SIC_flag;
reg [7:0] GBI_flag;
reg       layer1_flag;

// cycles
reg [31:0] cycles_of_SO1;
reg [31:0] cycles_of_SO2;
reg [31:0] cycles_of_SIC;
reg [31:0] cycles_of_SCS;
reg [31:0] cycles_of_GBI;
reg [31:0] cycles_of_layer1;
reg [31:0] u_time_of_layer1;
reg [63:0] M_work_flag0_layer1;

integer f;
integer g;

//--------------Code Starts Here------------------ 
initial begin

    instruction[63:60] = 12;
    instruction[59:0 ] = 0;

    // Instruction_generation_unit control
    IGU_web = 0;

    // Tile_instruction_memory control
    t_i_m_web        = 2'b01;
    finish_flag      = 0;
    instruction_addr = 0;

    // Core_instruction_memory control
    c_i_m_web0 = 0;
    c_i_m_web1 = 0;
    c_i_m_web2 = 0;
    c_i_m_web3 = 0;
    c_i_m_web4 = 0;
    c_i_m_web5 = 0;
    c_i_m_web6 = 0;
    c_i_m_web7 = 0;
    c_i_m_web8 = 0;
    c_i_m_web9 = 0;
    c_i_m_web10= 0;
    c_i_m_web11= 0;
    c_i_m_web12= 0;
    c_i_m_web13= 0;
    c_i_m_web14= 0;
    c_i_m_web15= 0;

    // Result_SRAM control
    AS_web_SFU = 0;
    RS_web_SFU = 0;

    // SFU control
    Result_column  = 0; 
    Result_picture = 0;    
    MVMUa          = 0;    
    MVMUb          = 0; 
    MVMUc          = 0; 
    MVMUd          = 0; 
    timea          = 0;    
    timeb          = 0; 
    MVMUg          = 0; 
    MVMUh          = 0;

    // init
    init_flag = 0;

    // Flag
    SFU_output_flag = 0;
    send_ins_flag   = 0;
    SO1_flag        = 0;
    SIC_flag        = 0;
    GBI_flag        = 0;
    layer1_flag     = 0;

    // cycles
    cycles_of_SO1 = 0;
    cycles_of_SO2 = 0;
    cycles_of_SIC = 0;
    cycles_of_SCS = 0;
    cycles_of_GBI = 0;
    cycles_of_layer1 = 0;
    u_time_of_layer1 = 0;
    M_work_flag0_layer1 = 0;
end

// update the instruction
always @ (posedge clk) begin
    if(RSTn) begin
        if( init_flag ) begin
            if( finish_flag ) begin
                instruction      <= new_instruction;
                finish_flag      <= 0;                                    
                instruction_addr <= instruction_addr + 1;
            end
        end
        else
            init_flag <= init_flag + 1;
    end
end

always @ (posedge clk) begin
    if(RSTn) begin
        if( !finish_flag ) begin
            case (instruction[63:60])
                SO1: begin
                    if( !SO1_flag ) begin
                        timea <= instruction[37:32];   
                        timeb <= instruction[43:38];
                        SO1_flag <= 1;
                    end
                    else begin
                        RS_web_SFU     <= 1;        // start Shared_memory output for SFU
                        SFU_web[3:0]   <= 4;        // choose SFU mode
                        Result_column  <= instruction[3:0];
                        Result_picture <= instruction[9:4];   
                        MVMUa <= instruction[16:10];   
                        MVMUb <= instruction[21:17];
                        MVMUc <= instruction[26:22];
                        MVMUd <= instruction[31:27];
                        MVMUg <= instruction[49:44];
                        MVMUh <= instruction[55:50];
                    end
                    if(SFU_flag == 1) begin        // SFU output
                        finish_flag    <= 1;                       
                        RS_web_SFU     <= 0;        // stop Shared_memory output for SFU
                        SFU_web[3:0]   <= 5;        // SFU idle
                        Result_column  <= 0;
                        Result_picture <= 0;   
                        MVMUa <= 0;   
                        MVMUb <= 0;
                        MVMUc <= 0;
                        MVMUd <= 0;
                        timea <= 0;   
                        timeb <= 0;
                        MVMUg <= 0;
                        MVMUh <= 0;
                        SO1_flag <= 0;
                    end
                end
                SO2: begin
                    SFU_web[3:0] <= instruction[3:0];        // choose SFU for layer1/2/3
                    if(SFU_flag == 1) begin                               // SFU output
                        AS_web_SFU      <= 1;                          // start Shared_memory input from SFU
                        SFU_output_flag <= SFU_output_flag + 1;        // update flag
                        if(SFU_output_flag == 2) begin        // SFU output completed in 2 cycles
                            finish_flag     <= 1;
                            SFU_web[3:0]    <= 0;        // stop SFU operation
                            AS_web_SFU      <= 0;        // stop Shared_memory input from SFU
                            SFU_output_flag <= 0;
                        end
                    end
                end
                SIC: begin
                    t_i_m_web[1]         <= 1;                         // start tile_ins_mem core output
                    if(instruction[63 :60 ] == SIC) begin
                        case (instruction[47:32])   
                            0: begin
                                start_ins_addr0 <=  instruction[15:0 ] + send_ins_flag*INSTRUCTION_WIDTH;
                                end_ins_addr0   <= (instruction[15:0 ] + (send_ins_flag+1)*INSTRUCTION_WIDTH) < instruction[31:16] ?
                                                    instruction[15:0 ] + (send_ins_flag+1)*INSTRUCTION_WIDTH-1 : instruction[31:16];
                            end
                            1: begin
                                start_ins_addr1 <=  instruction[15:0 ] + send_ins_flag*INSTRUCTION_WIDTH;
                                end_ins_addr1   <= (instruction[15:0 ] + (send_ins_flag+1)*INSTRUCTION_WIDTH) < instruction[31:16] ?
                                                    instruction[15:0 ] + (send_ins_flag+1)*INSTRUCTION_WIDTH-1 : instruction[31:16];
                            end
                            2: begin
                                start_ins_addr2 <=  instruction[15:0 ] + send_ins_flag*INSTRUCTION_WIDTH;
                                end_ins_addr2   <= (instruction[15:0 ] + (send_ins_flag+1)*INSTRUCTION_WIDTH) < instruction[31:16] ?
                                                    instruction[15:0 ] + (send_ins_flag+1)*INSTRUCTION_WIDTH-1 : instruction[31:16];
                            end
                            3: begin
                                start_ins_addr3 <=  instruction[15:0 ] + send_ins_flag*INSTRUCTION_WIDTH;
                                end_ins_addr3   <= (instruction[15:0 ] + (send_ins_flag+1)*INSTRUCTION_WIDTH) < instruction[31:16] ?
                                                    instruction[15:0 ] + (send_ins_flag+1)*INSTRUCTION_WIDTH-1 : instruction[31:16];
                            end
                            4: begin
                                start_ins_addr4 <=  instruction[15:0 ] + send_ins_flag*INSTRUCTION_WIDTH;
                                end_ins_addr4   <= (instruction[15:0 ] + (send_ins_flag+1)*INSTRUCTION_WIDTH) < instruction[31:16] ?
                                                    instruction[15:0 ] + (send_ins_flag+1)*INSTRUCTION_WIDTH-1 : instruction[31:16];
                            end
                            5: begin
                                start_ins_addr5 <=  instruction[15:0 ] + send_ins_flag*INSTRUCTION_WIDTH;
                                end_ins_addr5   <= (instruction[15:0 ] + (send_ins_flag+1)*INSTRUCTION_WIDTH) < instruction[31:16] ?
                                                    instruction[15:0 ] + (send_ins_flag+1)*INSTRUCTION_WIDTH-1 : instruction[31:16];
                            end
                            6: begin
                                start_ins_addr6 <=  instruction[15:0 ] + send_ins_flag*INSTRUCTION_WIDTH;
                                end_ins_addr6   <= (instruction[15:0 ] + (send_ins_flag+1)*INSTRUCTION_WIDTH) < instruction[31:16] ?
                                                    instruction[15:0 ] + (send_ins_flag+1)*INSTRUCTION_WIDTH-1 : instruction[31:16];
                            end
                            7: begin
                                start_ins_addr7 <=  instruction[15:0 ] + send_ins_flag*INSTRUCTION_WIDTH;
                                end_ins_addr7   <= (instruction[15:0 ] + (send_ins_flag+1)*INSTRUCTION_WIDTH) < instruction[31:16] ?
                                                    instruction[15:0 ] + (send_ins_flag+1)*INSTRUCTION_WIDTH-1 : instruction[31:16];
                            end
                            8: begin
                                start_ins_addr8 <=  instruction[15:0 ] + send_ins_flag*INSTRUCTION_WIDTH;
                                end_ins_addr8   <= (instruction[15:0 ] + (send_ins_flag+1)*INSTRUCTION_WIDTH) < instruction[31:16] ?
                                                    instruction[15:0 ] + (send_ins_flag+1)*INSTRUCTION_WIDTH-1 : instruction[31:16];
                            end
                            9: begin
                                start_ins_addr9 <=  instruction[15:0 ] + send_ins_flag*INSTRUCTION_WIDTH;
                                end_ins_addr9   <= (instruction[15:0 ] + (send_ins_flag+1)*INSTRUCTION_WIDTH) < instruction[31:16] ?
                                                    instruction[15:0 ] + (send_ins_flag+1)*INSTRUCTION_WIDTH-1 : instruction[31:16];
                            end
                            10: begin
                                start_ins_addr10 <=  instruction[15:0 ] + send_ins_flag*INSTRUCTION_WIDTH;
                                end_ins_addr10   <= (instruction[15:0 ] + (send_ins_flag+1)*INSTRUCTION_WIDTH) < instruction[31:16] ?
                                                    instruction[15:0 ] + (send_ins_flag+1)*INSTRUCTION_WIDTH-1 : instruction[31:16];
                            end
                            11: begin
                                start_ins_addr11 <=  instruction[15:0 ] + send_ins_flag*INSTRUCTION_WIDTH;
                                end_ins_addr11   <= (instruction[15:0 ] + (send_ins_flag+1)*INSTRUCTION_WIDTH) < instruction[31:16] ?
                                                    instruction[15:0 ] + (send_ins_flag+1)*INSTRUCTION_WIDTH-1 : instruction[31:16];
                            end
                            12: begin
                                start_ins_addr12 <=  instruction[15:0 ] + send_ins_flag*INSTRUCTION_WIDTH;
                                end_ins_addr12   <= (instruction[15:0 ] + (send_ins_flag+1)*INSTRUCTION_WIDTH) < instruction[31:16] ?
                                                    instruction[15:0 ] + (send_ins_flag+1)*INSTRUCTION_WIDTH-1 : instruction[31:16];
                            end
                            13: begin
                                start_ins_addr13 <=  instruction[15:0 ] + send_ins_flag*INSTRUCTION_WIDTH;
                                end_ins_addr13   <= (instruction[15:0 ] + (send_ins_flag+1)*INSTRUCTION_WIDTH) < instruction[31:16] ?
                                                    instruction[15:0 ] + (send_ins_flag+1)*INSTRUCTION_WIDTH-1 : instruction[31:16];
                            end
                            14: begin
                                start_ins_addr14 <=  instruction[15:0 ] + send_ins_flag*INSTRUCTION_WIDTH;
                                end_ins_addr14   <= (instruction[15:0 ] + (send_ins_flag+1)*INSTRUCTION_WIDTH) < instruction[31:16] ?
                                                    instruction[15:0 ] + (send_ins_flag+1)*INSTRUCTION_WIDTH-1 : instruction[31:16];
                            end
                            15: begin
                                start_ins_addr15 <=  instruction[15:0 ] + send_ins_flag*INSTRUCTION_WIDTH;
                                end_ins_addr15   <= (instruction[15:0 ] + (send_ins_flag+1)*INSTRUCTION_WIDTH) < instruction[31:16] ?
                                                    instruction[15:0 ] + (send_ins_flag+1)*INSTRUCTION_WIDTH-1 : instruction[31:16];
                            end
                        endcase
                        core_ins_output_flag[instruction[47:32]] <= 1;        // choose the core
                        if( SIC_flag ) begin
                            case (instruction[47:32])                             // start core_ins_mem input
                                0: begin    c_i_m_web0 <= 1; 
                                            c_i_m_write_addr0 <= send_ins_flag-1; end
                                1: begin    c_i_m_web1 <= 1; 
                                            c_i_m_write_addr1 <= send_ins_flag-1; end
                                2: begin    c_i_m_web2 <= 1; 
                                            c_i_m_write_addr2 <= send_ins_flag-1; end
                                3: begin    c_i_m_web3 <= 1; 
                                            c_i_m_write_addr3 <= send_ins_flag-1; end
                                4: begin    c_i_m_web4 <= 1; 
                                            c_i_m_write_addr4 <= send_ins_flag-1; end
                                5: begin    c_i_m_web5 <= 1; 
                                            c_i_m_write_addr5 <= send_ins_flag-1; end
                                6: begin    c_i_m_web6 <= 1; 
                                            c_i_m_write_addr6 <= send_ins_flag-1; end
                                7: begin    c_i_m_web7 <= 1; 
                                            c_i_m_write_addr7 <= send_ins_flag-1; end
                                8: begin    c_i_m_web8 <= 1; 
                                            c_i_m_write_addr8 <= send_ins_flag-1; end
                                9: begin    c_i_m_web9 <= 1; 
                                            c_i_m_write_addr9 <= send_ins_flag-1; end
                                10: begin    c_i_m_web10 <= 1; 
                                            c_i_m_write_addr10 <= send_ins_flag-1; end
                                11: begin    c_i_m_web11 <= 1; 
                                            c_i_m_write_addr11 <= send_ins_flag-1; end
                                12: begin    c_i_m_web12 <= 1; 
                                            c_i_m_write_addr12 <= send_ins_flag-1; end
                                13: begin    c_i_m_web13 <= 1; 
                                            c_i_m_write_addr13 <= send_ins_flag-1; end
                                14: begin    c_i_m_web14 <= 1; 
                                            c_i_m_write_addr14 <= send_ins_flag-1; end
                                15: begin    c_i_m_web15 <= 1; 
                                            c_i_m_write_addr15 <= send_ins_flag-1; end
                            endcase
                        end
                    end
                    SIC_flag      <= 1;
                    send_ins_flag <= send_ins_flag + 1;                // update flag
                    if( send_ins_flag*INSTRUCTION_WIDTH >= instruction[31:16]-instruction[15:0 ] ) begin
                        t_i_m_web[1]         <= 0;        // stop tile_ins_mem core output
                        start_ins_addr0      <= 0;
                        start_ins_addr1      <= 0;
                        start_ins_addr2      <= 0;
                        start_ins_addr3      <= 0;
                        start_ins_addr4      <= 0;
                        start_ins_addr5      <= 0;
                        start_ins_addr6      <= 0;
                        start_ins_addr7      <= 0;
                        start_ins_addr8      <= 0;
                        start_ins_addr9      <= 0;
                        start_ins_addr10     <= 0;
                        start_ins_addr11     <= 0;
                        start_ins_addr12     <= 0;
                        start_ins_addr13     <= 0;
                        start_ins_addr14     <= 0;
                        start_ins_addr15     <= 0;
                        end_ins_addr0        <= 0;
                        end_ins_addr1        <= 0;
                        end_ins_addr2        <= 0;
                        end_ins_addr3        <= 0;
                        end_ins_addr4        <= 0;
                        end_ins_addr5        <= 0;
                        end_ins_addr6        <= 0;
                        end_ins_addr7        <= 0;
                        end_ins_addr8        <= 0;
                        end_ins_addr9        <= 0;
                        end_ins_addr10       <= 0;
                        end_ins_addr11       <= 0;
                        end_ins_addr12       <= 0;
                        end_ins_addr13       <= 0;
                        end_ins_addr14       <= 0;
                        end_ins_addr15       <= 0;
                        core_ins_output_flag <= 0;
                    end
                    if( (send_ins_flag-1)*INSTRUCTION_WIDTH >= instruction[31:16]-instruction[15:0 ] &&
                        (send_ins_flag >= 1) ) begin
                        finish_flag          <= 1;
                        c_i_m_web0 <= 0;               // stop core_ins_mem input
                        c_i_m_web1 <= 0; 
                        c_i_m_web2 <= 0; 
                        c_i_m_web3 <= 0; 
                        c_i_m_web4 <= 0; 
                        c_i_m_web5 <= 0;
                        c_i_m_web6 <= 0; 
                        c_i_m_web7 <= 0;
                        c_i_m_web8 <= 0;               // stop core_ins_mem input
                        c_i_m_web9 <= 0; 
                        c_i_m_web10<= 0; 
                        c_i_m_web11<= 0; 
                        c_i_m_web12<= 0; 
                        c_i_m_web13<= 0;
                        c_i_m_web14<= 0; 
                        c_i_m_web15<= 0;
                        c_i_m_write_addr0 <= 0;
                        c_i_m_write_addr1 <= 0;
                        c_i_m_write_addr2 <= 0;
                        c_i_m_write_addr3 <= 0;
                        c_i_m_write_addr4 <= 0;
                        c_i_m_write_addr5 <= 0;
                        c_i_m_write_addr6 <= 0;
                        c_i_m_write_addr7 <= 0;
                        c_i_m_write_addr8 <= 0;
                        c_i_m_write_addr9 <= 0;
                        c_i_m_write_addr10<= 0;
                        c_i_m_write_addr11<= 0;
                        c_i_m_write_addr12<= 0;
                        c_i_m_write_addr13<= 0;
                        c_i_m_write_addr14<= 0;
                        c_i_m_write_addr15<= 0;
                        send_ins_flag <= 0;
                        SIC_flag <= 0;
                    end
                end
                SCS: begin
                    core_control_unit_web0 <= instruction[0];
                    core_control_unit_web1 <= instruction[1];
                    core_control_unit_web2 <= instruction[2];
                    core_control_unit_web3 <= instruction[3];
                    core_control_unit_web4 <= instruction[4];
                    core_control_unit_web5 <= instruction[5];
                    core_control_unit_web6 <= instruction[6];
                    core_control_unit_web7 <= instruction[7];
                    core_control_unit_web8 <= instruction[8];
                    core_control_unit_web9 <= instruction[9];
                    core_control_unit_web10<= instruction[10];
                    core_control_unit_web11<= instruction[11];
                    core_control_unit_web12<= instruction[12];
                    core_control_unit_web13<= instruction[13];
                    core_control_unit_web14<= instruction[14];
                    core_control_unit_web15<= instruction[15];
                    // The core0 state represents the state of all cores
                    if(workload_completed_flag0 == 1) begin
                        finish_flag            <= 1;
                        core_control_unit_web0 <= 0;
                        core_control_unit_web1 <= 0;
                        core_control_unit_web2 <= 0;
                        core_control_unit_web3 <= 0;
                        core_control_unit_web4 <= 0;
                        core_control_unit_web5 <= 0;
                        core_control_unit_web6 <= 0;
                        core_control_unit_web7 <= 0;
                        core_control_unit_web8 <= 0;
                        core_control_unit_web9 <= 0;
                        core_control_unit_web10<= 0;
                        core_control_unit_web11<= 0;
                        core_control_unit_web12<= 0;
                        core_control_unit_web13<= 0;
                        core_control_unit_web14<= 0;
                        core_control_unit_web15<= 0;
                    end
                end
                GBI: begin
                    t_i_m_web[2] <= 1;
                    if( GBI_flag )
                        IGU_web <= 1;
                    else 
                        GBI_flag <= GBI_flag + 1;
                    if( IGU_done_flag ) begin
                        t_i_m_web[2] <= 0;
                        IGU_web      <= 0;
                        GBI_flag     <= 0;
                        finish_flag  <= 1;
                    end
                end
                S: begin
                    // 打开新文件，具有 "写" 权限
                    f = $fopen("Cycles of tlie instructions.txt", "w");
                    // 将 lfsr 数组中的值写入文件，每个值占一行
                    $fwrite(f, "Cycles of SO1 of layer1: %d.\n", cycles_of_SO1);
                    $fwrite(f, "Cycles of SO2: %d.\n", cycles_of_SO2);
                    $fwrite(f, "Cycles of SIC: %d.\n", cycles_of_SIC);
                    $fwrite(f, "Cycles of SCS: %d.\n", cycles_of_SCS);
                    // 关闭文件
                    $fclose(f);

                    // 打开新文件，具有 "写" 权限
                    g = $fopen("Bandwidth utilization record.txt", "w");
                    // 将 lfsr 数组中的值写入文件，每个值占一行
                    $fwrite(g, "Cycles: %d.\n"                    , counter             );
                    $fwrite(g, "Cycles of layer1: %d.\n"          , cycles_of_layer1    );
                    $fwrite(g, "Peak bandwidth: %d.\n"            , peak_bandwidth      );
                    $fwrite(g, "Number of working macros: %d.\n"  , num_of_wm           );
                    $fwrite(g, "Utilization time: %d.\n"          , utilization_time    );
                    $fwrite(g, "Utilization time of layer1: %d.\n", u_time_of_layer1    );
                    $fwrite(g, "MVMU work cycles: %d.\n"          , MVMU_work_flag0     );
                    $fwrite(g, "MVMU work cycles of layer1: %d.\n", M_work_flag0_layer1 );
                    $fwrite(g, "Result memory usage: %d.\n"       , result_memory_usage );
                    $fwrite(g, "Cycles_of_IGU: %d.\n"             , cycles_of_GBI       );
                    // 关闭文件
                    $fclose(g);

                    $finish;
                end
                default: begin
                    finish_flag      <= 1;
                    instruction_addr <= instruction_addr + 1;
                end          
            endcase
        end
    end
end

always @ (posedge clk) begin
    if(RSTn) begin
        if( !finish_flag ) begin
            case (instruction[63:60])
                SO1: begin
                    if( !u_time_of_layer1 ) begin
                        u_time_of_layer1 <= utilization_time;
                        M_work_flag0_layer1 <= MVMU_work_flag0;
                    end
                    if( !layer1_flag )
                        cycles_of_SO1 <=cycles_of_SO1 + 1;        // record the cycles for SO1
                end
                SO2: begin
                    layer1_flag   <= 1;
                    cycles_of_SO2 <=cycles_of_SO2 + 1;        // record the cycles for SO2
                end
                SIC: begin
                    cycles_of_SIC <=cycles_of_SIC + 1;        // record the cycles for SIC
                end
                SCS: begin
                    if( !layer1_flag )
                        cycles_of_layer1 <=cycles_of_layer1 + 1;        // record the cycles for layer1
                    cycles_of_SCS <= cycles_of_SCS + 1;        // record the cycles for SCS
                end
                GBI: begin
                    cycles_of_GBI <=cycles_of_GBI + 1;        // record the cycles for GBI
                end
                default: begin
                end          
            endcase
        end
    end
end


endmodule