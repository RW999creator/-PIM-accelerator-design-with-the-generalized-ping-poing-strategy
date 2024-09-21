module MVMU
#(  parameter DATA_WIDTH     = 8,
    parameter M_RAM_DEPTH    = 32*32,        // MVMU Dimension
    parameter B_RAM_DEPTH    = 32,           // Input/output buffer depth
    parameter NUM_OF_COLUMNS = 32,
    parameter RESULT_LIMIT   = 0
)
(
    input                                   clk,
    input                                   RSTn,                  // PIM enable
    input  [3:0]                            web,                   // write/read/PIM/clean/PIM_Pro
    input  [15:0]                           addr,                  // Radius:0 ~ 128*128-1
    input  [16*DATA_WIDTH-1:0]              data,                  // weight
    input  [DATA_WIDTH*B_RAM_DEPTH-1:0]     pim_in,                // data
    output reg [7:0]                        pim_q,                 // PIM output
    output reg [DATA_WIDTH*B_RAM_DEPTH-1:0] pim_pro_q,             // PIM_Pro output
    output reg                              pim_pro_o_flag,        // PIM_Pro output flag
    output reg [63:0]                       MVMU_work_flag,
    output reg [7:0]                        q                      // output  Sign bit:q[8],Data bit:q[7:0]
);

//--------------Internal variables---------------- 
reg [DATA_WIDTH-1:0]             memory [0:M_RAM_DEPTH-1];
reg [7:0]                        pim_pro_e_flag;       // PIM_Pro execute flag
reg [31:0]                       pim_r;                // PIM calculation result

genvar write_i;
genvar memory_clean_i;
genvar i_buffer_clean_i;
integer memory_init_i;
integer PIM_com_i;

//--------------Code Starts Here------------------ 
initial begin
    pim_q[7:0] = 0;
    pim_pro_q[DATA_WIDTH*B_RAM_DEPTH-1:0] = 0;
    pim_pro_o_flag = 0;
    pim_pro_e_flag[7:0] = 0;
    pim_r[31:0] = 0;
    MVMU_work_flag = 0;
    q[7:0] = 0;
    // Memory and input buffer initialization
    for(memory_init_i = 0; memory_init_i <= (M_RAM_DEPTH-1); memory_init_i = memory_init_i + 1)
        memory[memory_init_i] = 0;
end

generate    // write
    for (write_i = 0; write_i < 16; write_i = write_i + 1) begin
        always @(posedge clk) begin
            if(web == 1) begin
                memory[addr[15:0] + write_i][7:0] <= data[write_i*8+7:write_i*8];
            end
        end
    end
endgenerate

generate    // clean the MVMU
    for (memory_clean_i = 0; memory_clean_i < M_RAM_DEPTH; memory_clean_i = memory_clean_i + 1) begin
        always @(posedge clk) begin
            if(web == 0) begin
                memory[memory_clean_i][7:0] <= 0;
            end
        end
    end
endgenerate

always @ (posedge clk) begin
    if(RSTn) begin
        if     (web == 2) begin                                                         // PIM
            pim_q = 0;
            pim_r = 0;
            for (PIM_com_i = 0; PIM_com_i < B_RAM_DEPTH; PIM_com_i = PIM_com_i + 1) begin
                pim_r = pim_r + memory[addr[15:0]*B_RAM_DEPTH + PIM_com_i][7:0] * pim_in[PIM_com_i*8+:8];
            end
            pim_q[7:0] = pim_r[7:0];                // Intercept the Complement Code
        end
        else if(web == 4) begin                                                         // PIM_Pro
            if     (pim_pro_e_flag <= (NUM_OF_COLUMNS-1)) begin     // PIM in NUM_OF_COLUMNS*BL
                pim_r = 0;
                for (PIM_com_i = 0; PIM_com_i < B_RAM_DEPTH; PIM_com_i = PIM_com_i + 1) begin
                    pim_r = pim_r + memory[pim_pro_e_flag*B_RAM_DEPTH + PIM_com_i][7:0] * pim_in[PIM_com_i*8+:8];
                end
                pim_pro_q[pim_pro_e_flag*8+:8] = pim_r[(0+RESULT_LIMIT)+:8];
                pim_pro_e_flag = pim_pro_e_flag + 1;
            end
            else if(pim_pro_e_flag == NUM_OF_COLUMNS) begin     // PIM_Pro finished
                pim_pro_o_flag <= 1;
            end
        end
        else if(web == 5) begin                                                         // PIM idle
            pim_q <= 0;
            pim_r <= 0;
            pim_pro_e_flag <= 0;
            pim_pro_o_flag <= 0;
            pim_pro_q <= 0;
        end
    end
end

always @ (posedge clk) begin
    if(RSTn) begin
        if( web == 1 || web == 2 || (web == 4&&pim_pro_o_flag != 1) ) 
            MVMU_work_flag <= MVMU_work_flag + 1;
    end
end

endmodule