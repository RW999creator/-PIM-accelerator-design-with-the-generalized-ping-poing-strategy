module Core_instruction_memory
#(  parameter INSTRUCTION_WIDTH   = 64,
    parameter INSTRUCTION_DEPTH   = 65536,
    parameter INS_INTERCORE_DEPTH = 4096
)
(
    input        clk,
    input        RSTn,           // enable

    input                        web,        // write/output control
    input [15:0]                 c_i_m_write_addr,
    input [INS_INTERCORE_DEPTH-1:0] core_ins_input,

    input [15:0] addr0,
    input [15:0] addr1,
    input [15:0] addr2,
    input [15:0] addr3,
    input [15:0] addr4,
    input [15:0] addr5,
    input [15:0] addr6,
    input [15:0] addr7,
    input [15:0] addr8,
    input [15:0] addr9,
    input [15:0] addr10,
    input [15:0] addr11,
    input [15:0] addr12,
    input [15:0] addr13,
    input [15:0] addr14,
    input [15:0] addr15,
    output reg [INSTRUCTION_WIDTH-1:0] instruction0,
    output reg [INSTRUCTION_WIDTH-1:0] instruction1,
    output reg [INSTRUCTION_WIDTH-1:0] instruction2,
    output reg [INSTRUCTION_WIDTH-1:0] instruction3,
    output reg [INSTRUCTION_WIDTH-1:0] instruction4,
    output reg [INSTRUCTION_WIDTH-1:0] instruction5,
    output reg [INSTRUCTION_WIDTH-1:0] instruction6,
    output reg [INSTRUCTION_WIDTH-1:0] instruction7,
    output reg [INSTRUCTION_WIDTH-1:0] instruction8,
    output reg [INSTRUCTION_WIDTH-1:0] instruction9,
    output reg [INSTRUCTION_WIDTH-1:0] instruction10,
    output reg [INSTRUCTION_WIDTH-1:0] instruction11,
    output reg [INSTRUCTION_WIDTH-1:0] instruction12,
    output reg [INSTRUCTION_WIDTH-1:0] instruction13,
    output reg [INSTRUCTION_WIDTH-1:0] instruction14,
    output reg [INSTRUCTION_WIDTH-1:0] instruction15
);

reg [INSTRUCTION_WIDTH-1:0] instruction_memory [0:INSTRUCTION_DEPTH-1];

integer init_i;
integer write_i;

//--------------Code Starts Here------------------ 

initial begin
    for(init_i = 0; init_i <= INSTRUCTION_DEPTH-1; init_i = init_i + 1) begin
        instruction_memory[init_i][INSTRUCTION_WIDTH-1:0] = 0;
    end
end

always @(posedge clk or negedge RSTn) begin
    if( web ) begin
        for(write_i = 0; write_i <= 63; write_i = write_i + 1) begin
            instruction_memory[c_i_m_write_addr*64+write_i][INSTRUCTION_WIDTH-1:0] = core_ins_input[write_i*INSTRUCTION_WIDTH+:INSTRUCTION_WIDTH];
        end
    end

    instruction0  <= instruction_memory[addr0 +0 ][INSTRUCTION_WIDTH-1:0];
    instruction1  <= instruction_memory[addr1 +1 ][INSTRUCTION_WIDTH-1:0];
    instruction2  <= instruction_memory[addr2 +2 ][INSTRUCTION_WIDTH-1:0];
    instruction3  <= instruction_memory[addr3 +3 ][INSTRUCTION_WIDTH-1:0];
    instruction4  <= instruction_memory[addr4 +4 ][INSTRUCTION_WIDTH-1:0];
    instruction5  <= instruction_memory[addr5 +5 ][INSTRUCTION_WIDTH-1:0];
    instruction6  <= instruction_memory[addr6 +6 ][INSTRUCTION_WIDTH-1:0];
    instruction7  <= instruction_memory[addr7 +7 ][INSTRUCTION_WIDTH-1:0];
    instruction8  <= instruction_memory[addr8 +8 ][INSTRUCTION_WIDTH-1:0];
    instruction9  <= instruction_memory[addr9 +9 ][INSTRUCTION_WIDTH-1:0];
    instruction10 <= instruction_memory[addr10+10][INSTRUCTION_WIDTH-1:0];
    instruction11 <= instruction_memory[addr11+11][INSTRUCTION_WIDTH-1:0];
    instruction12 <= instruction_memory[addr12+12][INSTRUCTION_WIDTH-1:0];
    instruction13 <= instruction_memory[addr13+13][INSTRUCTION_WIDTH-1:0];
    instruction14 <= instruction_memory[addr14+14][INSTRUCTION_WIDTH-1:0];
    instruction15 <= instruction_memory[addr15+15][INSTRUCTION_WIDTH-1:0];
end

endmodule