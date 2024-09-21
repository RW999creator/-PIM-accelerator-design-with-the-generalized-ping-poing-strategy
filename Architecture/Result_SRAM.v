module Result_SRAM
#(  parameter MEM_DEPTH       = 128*4*512,        // 256macros 64pictures length:512B
    parameter MEM_WIDTH       = 8,            // 8bit
    parameter WR_DEPTH        = 16384         // write result bandwidth
)
(
    input        clk,
    input        RSTn,                      //enable
    input [256           :0] RS_web,        //read control
    input [256*32      -1:0] RS_write_addr,
    input [256*WR_DEPTH-1:0] RS_input,
    input [31:0] rmc_of_each_macro,
    output reg [31:0] result_memory_usage,
    output reg [31:0] num_of_wm,

    input [31:0] RS_SFU_read_addr,
    output reg [32768-1:0] RS_SFU_output
);

//--------------Internal variables---------------- 

reg [MEM_WIDTH-1:0] memory [0:MEM_DEPTH-1];
reg [256:0] last_RS_web;
reg [31:0] current_num_of_wm;

genvar  i;
integer init_i;
integer input_i;
integer output_i;
integer num_of_wm_i;

//--------------Code Starts Here------------------ 
initial begin
    for(init_i = 0; init_i <= MEM_DEPTH-1; init_i = init_i + 1)
        memory[init_i][MEM_WIDTH-1:0] = 0;

    result_memory_usage = 0;
    num_of_wm           = 0;
    last_RS_web         = 0;
    current_num_of_wm   = 0;
end

generate
    for (i = 0; i < 256; i = i + 1) begin
        always @(posedge clk) begin
            if( RS_web[i] )
                for(input_i = 0; input_i < rmc_of_each_macro; input_i = input_i + 1)
                    memory[i*rmc_of_each_macro+input_i][MEM_WIDTH-1:0] <= 
                    memory[i*rmc_of_each_macro+input_i][MEM_WIDTH-1:0] + RS_input[i*WR_DEPTH+input_i*MEM_WIDTH+:MEM_WIDTH];
        end
    end
endgenerate

always @ (posedge clk) begin
    if(RSTn) begin
        // From/to SFU
        if( RS_web[256] )
            for(output_i = 0; output_i <= 32768/MEM_WIDTH-1; output_i = output_i + 1)
                RS_SFU_output[output_i*MEM_WIDTH+:MEM_WIDTH] <= memory[RS_SFU_read_addr+output_i][MEM_WIDTH-1:0];
    end
end

always @ (posedge clk) begin
    if(RSTn) begin
        if( RS_web ) begin
            for (num_of_wm_i = 0; num_of_wm_i < 256; num_of_wm_i = num_of_wm_i + 1) begin
                if(RS_web[num_of_wm_i] && !last_RS_web[num_of_wm_i]) 
                    num_of_wm = num_of_wm + 1;
                if(RS_web[num_of_wm_i])
                    last_RS_web[num_of_wm_i] = RS_web[num_of_wm_i];
            end
        end
        else begin
            // if( num_of_wm <  current_num_of_wm )
            //     num_of_wm <= current_num_of_wm;
            if( result_memory_usage <  num_of_wm*rmc_of_each_macro )
                result_memory_usage <= num_of_wm*rmc_of_each_macro;
        end
    end
end

endmodule

