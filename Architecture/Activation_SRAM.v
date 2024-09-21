module Activation_SRAM
#(  parameter MEM_DEPTH       = 32768,         // 32kB
    parameter MEM_WIDTH       = 8,             // 8bit
    parameter RI_DEPTH        = 16384          // read input bandwidth: 32*8*64
)
(
    input        clk,
    input        RSTn,          //enable
    input      [256           :0] AS_web,        //read control
    input      [256*32      -1:0] AS_read_addr,
    input      [256*16      -1:0] AS_length,
    input      [256*6       -1:0] AS_width,
    input      [256*16      -1:0] AS_depth_of_jump,
    output reg [256*RI_DEPTH-1:0] AS_output,

    input [262144-1:0] AS_SFU_input
);

//--------------Internal variables---------------- 

reg [MEM_WIDTH-1:0] memory [0:MEM_DEPTH-1];
reg [MEM_WIDTH-1:0] buffer_memory [0:32768-1];

genvar  i;
integer init_i;
integer length_i;
integer width_i;
integer SFU_input_i;

//--------------Code Starts Here------------------ 
initial begin
    $readmemb("D:/Llama3/test_activation_for_accelerator.txt", buffer_memory);

    for(init_i = 0; init_i <= MEM_DEPTH-1; init_i = init_i + 1)
        memory[init_i][MEM_WIDTH-1:0] = 0;

    for(init_i = 0; init_i <= 50176-1; init_i = init_i + 1)
        memory[init_i][MEM_WIDTH-1:0] = buffer_memory[init_i][MEM_WIDTH-1:0];
end

generate
    for (i = 0; i < 256; i = i + 1) begin
        always @(posedge clk) begin
            if( AS_web[i] )
                for(width_i = 0; width_i <= AS_width[i*6+:6]-1; width_i = width_i + 1)
                    for(length_i = 0; length_i <= AS_length[i*16+:16]-1; length_i = length_i + 1)
                        AS_output[i*RI_DEPTH+(width_i*AS_length[i*16+:16]+length_i)*MEM_WIDTH+:MEM_WIDTH] <= memory[AS_read_addr[i*32+:32]+width_i*AS_depth_of_jump[i*16+:16]+length_i][MEM_WIDTH-1:0];
            else 
                AS_output[i*RI_DEPTH+:RI_DEPTH] = 0;
        end
    end
endgenerate

always @ (posedge clk) begin
    if(RSTn) begin
        // From SFU
        if( AS_web[256] ) 
            for(SFU_input_i = 0; SFU_input_i <= 262144/MEM_WIDTH-1; SFU_input_i = SFU_input_i + 1)
                memory[SFU_input_i][MEM_WIDTH-1:0] <= AS_SFU_input[SFU_input_i*MEM_WIDTH+:MEM_WIDTH];
    end
end

endmodule

