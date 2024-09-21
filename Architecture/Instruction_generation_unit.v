module Instruction_generation_unit
#(  parameter INSTRUCTION_WIDTH    = 64,
    parameter INTERCORE_DEPTH      = 8192,
    parameter HL_INSTRUCTION_DEPTH = 1024,
    parameter MEM_WIDTH            = 8,
    parameter ARRAY_SIZE           = 32,
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
    parameter MMM = 11,
    parameter GBI = 12,
    parameter RWM = 13,
    parameter S   = 0
)
(
    input        clk,
    input        RSTn,           // enable

    input        web,        // 

    input [INSTRUCTION_WIDTH-1:0] input_instruction,

    output reg [15:0] TIM_read_addr,
    output reg [15:0] TIM_write_addr,
    output reg [INTERCORE_DEPTH-1:0] basic_instruction,
    output reg        done_flag
);

reg [INSTRUCTION_WIDTH-1:0] instruction_library [0:18-1];

reg [INSTRUCTION_WIDTH-1:0] HL_instruction;        // High level instruction

reg        finish_flag;
reg [15:0] add_flag;
reg        output_flag;
reg [7:0]  Execute_flag;        // 
reg [7:0]  RW_flag;             // read weight flag
reg [7:0]  RI_flag;             // read input flag
reg [7:0]  RWM_flag;
reg [7:0]  PIM_macro_flag;
reg [7:0]  PIM_batch_flag;
reg [7:0]  WRM_macro_flag;
reg [7:0]  WRM_batch_flag;
reg [7:0]  WMS_flag;
reg [7:0]  S_flag;

integer init_i;
integer write_i;

//--------------Code Starts Here------------------ 

initial begin
    basic_instruction = 0;

    TIM_read_addr = 0;
    TIM_write_addr = 0;

    done_flag = 0;

    finish_flag    = 1;
    add_flag       = 0;
    output_flag    = 0;
    Execute_flag   = 0;
    RW_flag        = 0;
    RI_flag        = 0;
    RWM_flag       = 0;
    PIM_macro_flag = 0;
    PIM_batch_flag = 0;
    WRM_macro_flag = 0;
    WRM_batch_flag = 0;
    WMS_flag       = 0;
    S_flag         = 0;
end


always @(posedge clk or negedge RSTn) begin
    if( web ) begin

        if( finish_flag ) begin
            HL_instruction <= input_instruction;
            TIM_read_addr  <= TIM_read_addr + 1;
            finish_flag    <= 0;
        end

        if(( !finish_flag ) && ( add_flag <= INTERCORE_DEPTH/INSTRUCTION_WIDTH-1 )) begin
            if     (HL_instruction[63:60] == MMM) begin
                if     ( Execute_flag == 0 ) begin        // RDS
                    if( RI_flag*ARRAY_SIZE*ARRAY_SIZE < HL_instruction[19:10]*HL_instruction[9 :0 ] ) begin
                        basic_instruction[add_flag*INSTRUCTION_WIDTH+60+:4 ] <= RDS;
                        basic_instruction[add_flag*INSTRUCTION_WIDTH+0 +:18] <= HL_instruction[59:54]*ARRAY_SIZE + (RI_flag/(HL_instruction[19:10]/ARRAY_SIZE))*ARRAY_SIZE;        // Activation_SRAM read addr
                        basic_instruction[add_flag*INSTRUCTION_WIDTH+18+:16] <= ARRAY_SIZE;                   // length
                        basic_instruction[add_flag*INSTRUCTION_WIDTH+34+:6 ] <= HL_instruction[39:30];        // width
                        case ( 1 )                                                                   // depth of jump
                            HL_instruction[41:40] == 0: begin basic_instruction[add_flag*INSTRUCTION_WIDTH+40+:16] <= 512; end
                            HL_instruction[41:40] == 1: begin basic_instruction[add_flag*INSTRUCTION_WIDTH+40+:16] <= 512; end
                            HL_instruction[41:40] == 2: begin basic_instruction[add_flag*INSTRUCTION_WIDTH+40+:16] <= 64 ; end
                        endcase
                        basic_instruction[add_flag*INSTRUCTION_WIDTH+56+:4 ] <= RI_flag%4;             // MU write addr
                        RI_flag  <= RI_flag + 1;
                        add_flag <= add_flag + 1;
                    end
                    else begin
                        if( RI_flag >= 16 ) begin
                            RI_flag <= 0;
                            Execute_flag <= Execute_flag + 2;
                        end
                        else begin
                            basic_instruction[add_flag*INSTRUCTION_WIDTH+60+:4 ] <= S;
                            basic_instruction[add_flag*INSTRUCTION_WIDTH+0 +:60] <= 0;
                            // basic_instruction[add_flag*INSTRUCTION_WIDTH+56+:4 ] <= RI_flag;
                            // basic_instruction[add_flag*INSTRUCTION_WIDTH+0 +:32] <= 5;
                            RI_flag  <= RI_flag + 1;
                            add_flag <= add_flag + 1;
                        end
                    end
                end

                else if( Execute_flag == 2 ) begin        // RWM
                    if( RWM_flag*ARRAY_SIZE*ARRAY_SIZE < HL_instruction[19:10]*HL_instruction[9 :0 ] ) begin
                        basic_instruction[add_flag*INSTRUCTION_WIDTH+60+:4 ] <= RWM;
                        basic_instruction[add_flag*INSTRUCTION_WIDTH+56+:4 ] <= RWM_flag;        // MVMUx
                        case ( 1 )                                                                            // Weight_SRAM read addr
                            HL_instruction[41:40] == 0: begin 
                                basic_instruction[add_flag*INSTRUCTION_WIDTH+0 +:24] <= HL_instruction[47:42]*ARRAY_SIZE                             + 
                                                                                        HL_instruction[53:48]*ARRAY_SIZE*512                         + 
                                                                                        (RWM_flag%(HL_instruction[19:10]/ARRAY_SIZE))*ARRAY_SIZE*512 +
                                                                                        (RWM_flag/(HL_instruction[19:10]/ARRAY_SIZE))*ARRAY_SIZE       ; 
                            end
                            HL_instruction[41:40] == 1: begin
                                basic_instruction[add_flag*INSTRUCTION_WIDTH+0 +:24] <= HL_instruction[47:42]*ARRAY_SIZE                             + 
                                                                                        HL_instruction[53:48]*ARRAY_SIZE*512                         + 
                                                                                        (RWM_flag%(HL_instruction[19:10]/ARRAY_SIZE))*ARRAY_SIZE*512 +
                                                                                        (RWM_flag/(HL_instruction[19:10]/ARRAY_SIZE))*ARRAY_SIZE     + 401408; 
                            end
                            HL_instruction[41:40] == 2: begin 
                                basic_instruction[add_flag*INSTRUCTION_WIDTH+0 +:24] <= HL_instruction[47:42]*ARRAY_SIZE                             + 
                                                                                        HL_instruction[53:48]*ARRAY_SIZE*64                          + 
                                                                                        (RWM_flag%(HL_instruction[19:10]/ARRAY_SIZE))*ARRAY_SIZE*64  +
                                                                                        (RWM_flag/(HL_instruction[19:10]/ARRAY_SIZE))*ARRAY_SIZE     + 434176; 
                            end
                        endcase
                        basic_instruction[add_flag*INSTRUCTION_WIDTH+24+:10] <= ARRAY_SIZE;        // length
                        if( HL_instruction[19:10] >= ARRAY_SIZE)        // width
                            basic_instruction[add_flag*INSTRUCTION_WIDTH+34+:6 ] <= ARRAY_SIZE;
                        else
                            basic_instruction[add_flag*INSTRUCTION_WIDTH+34+:6 ] <= HL_instruction[19:10];
                        case ( 1 )                                                                            // depth of jump
                            HL_instruction[41:40] == 0: begin basic_instruction[add_flag*INSTRUCTION_WIDTH+40+:16] <= 512; end
                            HL_instruction[41:40] == 1: begin basic_instruction[add_flag*INSTRUCTION_WIDTH+40+:16] <= 128; end
                            HL_instruction[41:40] == 2: begin basic_instruction[add_flag*INSTRUCTION_WIDTH+40+:16] <= 64 ; end
                        endcase
                        RWM_flag <= RWM_flag + 1;
                        add_flag <= add_flag + 1;
                    end
                    else begin
                        if( RWM_flag >= 16 ) begin
                            RWM_flag <= 0;
                            Execute_flag <= Execute_flag + 1;
                        end
                        else begin
                            basic_instruction[add_flag*INSTRUCTION_WIDTH+60+:4 ] <= S;
                            basic_instruction[add_flag*INSTRUCTION_WIDTH+0 +:60] <= 0;
                            // basic_instruction[add_flag*INSTRUCTION_WIDTH+60+:4 ] <= W;
                            // basic_instruction[add_flag*INSTRUCTION_WIDTH+56+:4 ] <= RWM_flag;
                            // basic_instruction[add_flag*INSTRUCTION_WIDTH+0 +:32] <= 260;
                            RWM_flag <= RWM_flag + 1;
                            add_flag <= add_flag + 1;
                        end
                    end
                end

                else if( Execute_flag == 3 ) begin        // PIM
                    if( PIM_macro_flag*ARRAY_SIZE*ARRAY_SIZE < HL_instruction[19:10]*HL_instruction[9 :0 ] ) begin
                        basic_instruction[add_flag*INSTRUCTION_WIDTH+60+:4 ] <= PIM;
                        basic_instruction[add_flag*INSTRUCTION_WIDTH+56+:4 ] <= PIM_macro_flag;    // ??? useless ???
                        if( HL_instruction[29:20] <= ARRAY_SIZE )
                            basic_instruction[add_flag*INSTRUCTION_WIDTH+0 +:16] <= PIM_batch_flag*HL_instruction[29:20];
                        else
                            basic_instruction[add_flag*INSTRUCTION_WIDTH+0 +:16] <= PIM_batch_flag*ARRAY_SIZE;
                        PIM_macro_flag <= PIM_macro_flag + 1;
                        add_flag <= add_flag + 1;
                    end
                    else begin
                        if( PIM_macro_flag >= 16 ) begin
                            PIM_macro_flag <= 0;
                            PIM_batch_flag <= PIM_batch_flag + 1;
                            Execute_flag <= Execute_flag + 1;
                        end
                        else begin
                            basic_instruction[add_flag*INSTRUCTION_WIDTH+60+:4 ] <= S;
                            basic_instruction[add_flag*INSTRUCTION_WIDTH+0 +:60] <= 0;
                            // basic_instruction[add_flag*INSTRUCTION_WIDTH+60+:4 ] <= W;
                            // basic_instruction[add_flag*INSTRUCTION_WIDTH+56+:4 ] <= PIM_macro_flag;
                            // basic_instruction[add_flag*INSTRUCTION_WIDTH+0 +:32] <= 37;
                            PIM_macro_flag <= PIM_macro_flag + 1;
                            add_flag       <= add_flag + 1;
                        end
                    end
                end

                else if( Execute_flag == 4 ) begin        // WRM
                    if( WRM_macro_flag*ARRAY_SIZE*ARRAY_SIZE < HL_instruction[19:10]*HL_instruction[9 :0 ] ) begin
                        basic_instruction[add_flag*INSTRUCTION_WIDTH+60+:4] <= WRM;
                        basic_instruction[add_flag*INSTRUCTION_WIDTH+56+:4] <= WRM_macro_flag;        // ??? useless ???
                        basic_instruction[add_flag*INSTRUCTION_WIDTH+0 +:8] <= WRM_batch_flag;        // batch_of_data
                        WRM_macro_flag <= WRM_macro_flag + 1;
                        add_flag <= add_flag + 1;
                    end
                    else begin
                        if( WRM_macro_flag >= 16 ) begin
                            WRM_macro_flag <= 0;
                            WRM_batch_flag <= WRM_batch_flag + 1;
                            if( WRM_batch_flag + 1 == HL_instruction[39:30] ) begin
                                PIM_batch_flag <= 0;
                                WRM_batch_flag <= 0;
                                Execute_flag   <= 0;
                                finish_flag    <= 1;
                            end
                            else
                                Execute_flag <= Execute_flag - 1;
                        end
                        else begin
                            basic_instruction[add_flag*INSTRUCTION_WIDTH+60+:4 ] <= S;
                            basic_instruction[add_flag*INSTRUCTION_WIDTH+0 +:60] <= 0;
                            // basic_instruction[add_flag*INSTRUCTION_WIDTH+60+:4 ] <= W;
                            // basic_instruction[add_flag*INSTRUCTION_WIDTH+56+:4 ] <= WRM_macro_flag;
                            // basic_instruction[add_flag*INSTRUCTION_WIDTH+0 +:32] <= 4;
                            WRM_macro_flag <= WRM_macro_flag + 1;
                            add_flag       <= add_flag + 1;
                        end
                    end
                end

            end
            else if(HL_instruction[63:60] == WMS) begin
                basic_instruction[add_flag*INSTRUCTION_WIDTH+60+:4 ] <= WMS;
                basic_instruction[add_flag*INSTRUCTION_WIDTH+56+:4 ] <= WMS_flag;
                WMS_flag <= WMS_flag + 1;
                add_flag <= add_flag + 1;
                if( WMS_flag+1 >= 16 ) begin
                    WMS_flag <= 0;
                    finish_flag <= 1;
                end
            end
            else if(HL_instruction[63:60] == S  ) begin
                basic_instruction[add_flag*INSTRUCTION_WIDTH+60+:4 ] <= S;
                basic_instruction[add_flag*INSTRUCTION_WIDTH+0 +:60] <= 0;
                S_flag   <= S_flag + 1;
                add_flag <= add_flag + 1;
                if( S_flag+1 >= 16 ) begin
                    S_flag      <= 0;
                    finish_flag <= 1;
                end
            end
            else begin
                basic_instruction[add_flag*INSTRUCTION_WIDTH+:INSTRUCTION_WIDTH] <= HL_instruction;
                add_flag <= add_flag + 1;
                finish_flag <= 1;
            end
        end

        if( add_flag == INTERCORE_DEPTH/INSTRUCTION_WIDTH ) begin
            TIM_write_addr    <= TIM_write_addr + INTERCORE_DEPTH/INSTRUCTION_WIDTH;
            basic_instruction <= 0;
            add_flag          <= 0;
        end

        if( TIM_read_addr == HL_INSTRUCTION_DEPTH )
            done_flag <= 1;

    end
    else
        done_flag <= 0;
end

endmodule