module Weight_SRAM
#(  parameter MEM_DEPTH       = 262144,        // 256kB
    parameter MEM_WIDTH       = 8,             // 8bit
    parameter RW_DEPTH        = 8192           // read weight bandwidth: 32*32*8
)
(
    input        clk,
    input        RSTn,          //enable
    input      [256    -1:0] WS_web,        //read control
    input      [256*32 -1:0] WS_read_addr,
    input      [256*16 -1:0] WS_length,
    input      [256*6  -1:0] WS_width,
    input      [256*16 -1:0] WS_depth_of_jump,
    output reg [256*128-1:0] WS_output,

    output reg [63:0] counter,
    output reg [63:0] peak_bandwidth,
    output reg [63:0] utilization_time,
    output reg [7 :0] rewriting_speed
);

//--------------Internal variables---------------- 

reg [MEM_WIDTH-1:0] memory [0:MEM_DEPTH-1];

reg [MEM_WIDTH-1:0] buffer_memory0 [0:262144-1];
reg [MEM_WIDTH-1:0] buffer_memory1 [0:8191];
reg [MEM_WIDTH-1:0] buffer_memory2 [0:639];

reg [63:0]       current_working_MVMUs;
reg [256*16-1:0] length_flag;
reg [256*16-1:0] width_flag;

genvar  i;
integer init_0_i;
integer init_1_i;
integer init_2_i;
integer bandwidth_i;
integer output_i;

//--------------Code Starts Here------------------ 
initial begin
    $readmemb("D:/Llama3/weight_int8_for_accelerator.txt", buffer_memory0);
    $readmemb("D:/JRP-Item/Experiment/Parameter/MLP for MNIST 512 64 10/model_weights_layer2_int8 bit.txt", buffer_memory1);
    $readmemb("D:/JRP-Item/Experiment/Parameter/MLP for MNIST 512 64 10/model_weights_layer3_int8 bit.txt", buffer_memory2);

    for(init_0_i = 0; init_0_i <= 262144-1; init_0_i = init_0_i + 1)
        memory[0          +init_0_i][MEM_WIDTH-1:0] = buffer_memory0[init_0_i][MEM_WIDTH-1:0];

    for(init_1_i = 0; init_1_i <= 8191  ; init_1_i = init_1_i + 1)
        memory[401408     +init_1_i][MEM_WIDTH-1:0] = buffer_memory1[init_1_i][MEM_WIDTH-1:0];

    for(init_2_i = 0; init_2_i <= 639   ; init_2_i = init_2_i + 1)
        memory[401408+8192+init_2_i][MEM_WIDTH-1:0] = buffer_memory2[init_2_i][MEM_WIDTH-1:0];

    counter          = 0;
    peak_bandwidth   = 0;
    utilization_time = 0;
    rewriting_speed  = 4;

    current_working_MVMUs = 0;
end

always @ (posedge clk) begin
    if(RSTn) begin

        counter <= counter + 1;

        current_working_MVMUs = 0;
        for(bandwidth_i = 0; bandwidth_i < 128; bandwidth_i = bandwidth_i + 1)
            current_working_MVMUs = current_working_MVMUs + WS_web[bandwidth_i];

        if( peak_bandwidth <  current_working_MVMUs*rewriting_speed)
            peak_bandwidth <= current_working_MVMUs*rewriting_speed;

        if( WS_web )
            utilization_time <= utilization_time + 1;

    end
end

generate
    for (i = 0; i < 256; i = i + 1) begin
        always @(posedge clk) begin
            if( WS_web[i] ) 
                for(output_i = 0; output_i <= rewriting_speed-1; output_i = output_i + 1)
                    WS_output[i*128+output_i*MEM_WIDTH+:MEM_WIDTH] <= 
                        memory[WS_read_addr[i *32+:32]+width_flag[i*16+:16]*WS_depth_of_jump[i*16+:16]+length_flag[i*16+:16]+output_i][MEM_WIDTH-1:0];
            else 
                WS_output[i*128+:128] <= 0;
        end
    end
endgenerate

generate
    for (i = 0; i < 256; i = i + 1) begin
        always @(posedge clk) begin
            if( WS_web[i] ) begin
                length_flag[i*16+:16] <= (length_flag[i*16+:16] >= WS_length[i*16+:16]-rewriting_speed) ? 0 : length_flag[i*16+:16] + rewriting_speed;
                if( length_flag[i*16+:16] >= WS_length[i*16+:16]-rewriting_speed )
                    width_flag[i*16+:16]  <= width_flag[i*16+:16] + 1;
            end
            else begin
                length_flag[i*16+:16] <= 0;
                width_flag[i*16+:16]  <= 0;
        end
        end
    end
endgenerate

endmodule