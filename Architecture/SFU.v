module SFU
#(  parameter MEM_WIDTH = 8,             // 8bit
    parameter B_RAM_DEPTH = 32,              // MVMU input/output buffer depth
    parameter BIAS1_DEPTH = 1023,            // Layer1 bias: 128*8
    parameter BIAS2_DEPTH = 511,             // Layer2 bias: 64*8
    parameter BIAS3_DEPTH = 79,              // Layer3 bias: 10*8
    parameter H_BUFFER_DEPTH = 256*64*512,       // Handling buffer
    parameter R_BUFFER_DEPTH = 524288,         // Result buffer
    parameter SFU_READ_TIME = 256*64*512*8/32768,
    parameter TIME_FRAME = 64
)
(
    input       clk,
    input       RSTn,           // enable
    input [3:0] SFU_web,        // 0: clean; 4: Step1; 5: Step1_idle; 1/2/3: Step2(choose layer1/2/3)
    input [31:0] rmc_of_each_macro,
    input [3:0] Result_column, 
    input [5:0] Result_picture,    

    input [6:0] MVMUa,    
    input [4:0] MVMUb, 
    input [4:0] MVMUc, 
    input [4:0] MVMUd, 
    input [5:0] timea,    
    input [5:0] timeb, 
    input [5:0] MVMUg, 
    input [5:0] MVMUh, 

    input [32768-1:0] SFU_data_input,      // Read the data from MU

    output reg [31:0] SFU_RS_read_addr,        // Read addr for Shared_memory   
    output reg        SFU_flag,                 // Finish flag

    output reg [262144-1:0] SFU_output
);

//--------------Internal variables---------------- 
reg [BIAS1_DEPTH:0] bias1_memory [0:1];
reg [BIAS2_DEPTH:0] bias2_memory [0:1];
reg [BIAS3_DEPTH:0] bias3_memory [0:1];

reg [MEM_WIDTH  -1:0] Input_buffer  [0:H_BUFFER_DEPTH-1];
reg [MEM_WIDTH*2-1:0] Handle_buffer [0:H_BUFFER_DEPTH-1];
reg [R_BUFFER_DEPTH-1:0] Result_buffer;

reg [R_BUFFER_DEPTH:0] Result;

reg [3:0]  Execute_flag;
reg [15:0] Read_flag;
reg [3:0]  transition_flag;
reg [7:0]  splice_t_flag;


integer extension_i;
integer f;
integer splice_c_i;        // splice column i     
integer splice_t_i;        // splice time i   

integer bias_p_i;          // bias picture i     
integer bias_c_i;          // bias column i  

integer ReLU_c_i;          // ReLU column i  

integer IB_i;
integer HB_i;

integer print_i;

//--------------Code Starts Here------------------ 
initial begin
    $readmemb("D:/JRP-Item/Experiment/Parameter/MLP for MNIST/Layer 1 bias.json"  , bias1_memory, 0, 0);
    $readmemb("D:/JRP-Item/Experiment/Parameter/MLP for MNIST/Layer 2 bias.json"  , bias2_memory, 0, 0);
    $readmemb("D:/JRP-Item/Experiment/Parameter/MLP for MNIST/Layer 3 bias.json"  , bias3_memory, 0, 0);

    bias1_memory[1][BIAS1_DEPTH:0] = 0;
    bias2_memory[1][BIAS2_DEPTH:0] = 0;
    bias3_memory[1][BIAS3_DEPTH:0] = 0;

    SFU_RS_read_addr[31:0] = 0;
    SFU_flag = 0;
    SFU_output = 0;

    for(IB_i = 0; IB_i <= H_BUFFER_DEPTH-1; IB_i = IB_i + 1)
        Input_buffer [IB_i][MEM_WIDTH  -1:0] = 0;
    for(HB_i = 0; HB_i <= H_BUFFER_DEPTH-1; HB_i = HB_i + 1)
        Handle_buffer[HB_i][MEM_WIDTH*2-1:0] = 0;

    Result_buffer = 0;

    Result = 0;

    Execute_flag = 0;
    Read_flag = 0;
    transition_flag = 0;
    splice_t_flag = 0;
end

// generate
//     for (extension_i = 0; extension_i <= 4194304-1; extension_i = extension_i + 1) begin
//         always @(posedge clk) begin
//             if(Execute_flag == 3) begin
//                 if(Input_buffer[extension_i][7] == 0)
//                     Handle_buffer[extension_i][15:8] <= 8'b00000000;
//                 else
//                     Handle_buffer[extension_i][15:8] <= 8'b11111111;
//                 Handle_buffer[extension_i][7:0] <= Input_buffer[extension_i][7:0];
//             end
//         end
//     end
// endgenerate

always @ (posedge clk) begin
    if(RSTn) begin
        if(SFU_web == 0) begin                                          // SFU clean
            Execute_flag <= 0;
            SFU_flag <= 0;
            for(IB_i = 0; IB_i <= H_BUFFER_DEPTH-1; IB_i = IB_i + 1)
                Input_buffer [IB_i][MEM_WIDTH  -1:0] = 0;
            for(HB_i = 0; HB_i <= H_BUFFER_DEPTH-1; HB_i = HB_i + 1)
                Handle_buffer[HB_i][MEM_WIDTH*2-1:0] = 0;
            Result_buffer[R_BUFFER_DEPTH:0] <= 0;
            SFU_output <= 0;
        end
        else if(SFU_web == 4) begin                                                      // SFU Step1 working
            if     (Execute_flag == 0) begin     // Get the read addr
                SFU_RS_read_addr[31:0] <= 0; 
                Read_flag <= Read_flag + 1;
                if(Read_flag == 1) begin       // 
                    SFU_RS_read_addr[31:0] <= 32768/MEM_WIDTH; 
                    Execute_flag <= Execute_flag + 1;
                end
            end
            else if(Execute_flag == 1) begin     // Read the data from MU
                for(IB_i = 0; IB_i <= 32768/MEM_WIDTH-1; IB_i = IB_i + 1)
                    Input_buffer[(Read_flag-2)*32768/MEM_WIDTH+IB_i][MEM_WIDTH-1:0] <= 
                        SFU_data_input[IB_i*MEM_WIDTH+:MEM_WIDTH];
                SFU_RS_read_addr[31:0] <= Read_flag*32768/MEM_WIDTH;        // Update the MU read addr
                Read_flag <= Read_flag + 1;
                if(Read_flag == SFU_READ_TIME+1) begin       // Finish reading
                    Read_flag <= 0;
                    SFU_RS_read_addr <= 0;
                    Execute_flag <= Execute_flag + 1;
                end
            end
            else if(Execute_flag == 2) begin
                Execute_flag <= Execute_flag + 1;
            end
            else if(Execute_flag == 3) begin        // Extend data bits
                if( transition_flag*16384*256 < H_BUFFER_DEPTH ) begin
                    transition_flag <= transition_flag + 1;
                    for (extension_i = 0; extension_i <= 16384*256-1; extension_i = extension_i + 1) begin
                        if(Input_buffer[transition_flag*16384*256+extension_i][7] == 0)
                            Handle_buffer[transition_flag*16384*256+extension_i][15:8] <= 8'b00000000;
                        else
                            Handle_buffer[transition_flag*16384*256+extension_i][15:8] <= 8'b11111111;
                        Handle_buffer[transition_flag*16384*256+extension_i][7:0] <= Input_buffer[transition_flag*16384*256+extension_i][7:0];
                    end
                end
                else begin
                    transition_flag <= 0;
                    Execute_flag <= Execute_flag + 1;
                end
            end
            else if(Execute_flag == 4) begin     // Splicing
                if(SFU_flag == 0) begin
                    splice_t_flag <= 1;
                    if( !splice_t_flag ) begin
                        for (splice_t_i = timea; splice_t_i <= timeb; splice_t_i = splice_t_i + 1) begin
                            for (splice_c_i = 0; splice_c_i <= B_RAM_DEPTH-1; splice_c_i = splice_c_i + 1) begin       // B_RAM_DEPTH*columns for every MVMU PIM_Pro output
                                Result_buffer[Result_picture*16*512+Result_column*512+splice_c_i*16+:16] = 
                                Result_buffer[Result_picture*16*512+Result_column*512+splice_c_i*16+:16] +
                                    (MVMUa ? Handle_buffer[(MVMUa                                 -1)*rmc_of_each_macro+splice_t_i*32*TIME_FRAME+Result_picture*32+splice_c_i][2*MEM_WIDTH-1:0] : 0) +
                                    (MVMUb ? Handle_buffer[(MVMUa+MVMUb                           -1)*rmc_of_each_macro+splice_t_i*32*TIME_FRAME+Result_picture*32+splice_c_i][2*MEM_WIDTH-1:0] : 0) +
                                    (MVMUc ? Handle_buffer[(MVMUa+MVMUb+MVMUc                     -1)*rmc_of_each_macro+splice_t_i*32*TIME_FRAME+Result_picture*32+splice_c_i][2*MEM_WIDTH-1:0] : 0) +
                                    (MVMUd ? Handle_buffer[(MVMUa+MVMUb+MVMUc+MVMUd               -1)*rmc_of_each_macro+splice_t_i*32*TIME_FRAME+Result_picture*32+splice_c_i][2*MEM_WIDTH-1:0] : 0) +
                                    (MVMUg ? Handle_buffer[(MVMUa+MVMUb+MVMUc+MVMUd+MVMUg         -1)*rmc_of_each_macro+splice_t_i*32*TIME_FRAME+Result_picture*32+splice_c_i][2*MEM_WIDTH-1:0] : 0) +
                                    (MVMUh ? Handle_buffer[(MVMUa+MVMUb+MVMUc+MVMUd+MVMUg+MVMUh   -1)*rmc_of_each_macro+splice_t_i*32*TIME_FRAME+Result_picture*32+splice_c_i][2*MEM_WIDTH-1:0] : 0) +
                                    (MVMUh ? Handle_buffer[(MVMUa+MVMUb+MVMUc+MVMUd+MVMUg+MVMUh*2 -1)*rmc_of_each_macro+splice_t_i*32*TIME_FRAME+Result_picture*32+splice_c_i][2*MEM_WIDTH-1:0] : 0) +
                                    (MVMUh ? Handle_buffer[(MVMUa+MVMUb+MVMUc+MVMUd+MVMUg+MVMUh*3 -1)*rmc_of_each_macro+splice_t_i*32*TIME_FRAME+Result_picture*32+splice_c_i][2*MEM_WIDTH-1:0] : 0) ;
                                    // (MVMUh ? Handle_buffer[(MVMUa+MVMUb+MVMUc+MVMUd+MVMUg+MVMUh*4 -1)*rmc_of_each_macro+splice_t_i*32*TIME_FRAME+Result_picture*32+splice_c_i][2*MEM_WIDTH-1:0] : 0) +
                                    // (MVMUh ? Handle_buffer[(MVMUa+MVMUb+MVMUc+MVMUd+MVMUg+MVMUh*5 -1)*rmc_of_each_macro+splice_t_i*32*TIME_FRAME+Result_picture*32+splice_c_i][2*MEM_WIDTH-1:0] : 0) +
                                    // (MVMUh ? Handle_buffer[(MVMUa+MVMUb+MVMUc+MVMUd+MVMUg+MVMUh*6 -1)*rmc_of_each_macro+splice_t_i*32*TIME_FRAME+Result_picture*32+splice_c_i][2*MEM_WIDTH-1:0] : 0) +
                                    // (MVMUh ? Handle_buffer[(MVMUa+MVMUb+MVMUc+MVMUd+MVMUg+MVMUh*7 -1)*rmc_of_each_macro+splice_t_i*32*TIME_FRAME+Result_picture*32+splice_c_i][2*MEM_WIDTH-1:0] : 0) +
                                    // (MVMUh ? Handle_buffer[(MVMUa+MVMUb+MVMUc+MVMUd+MVMUg+MVMUh*8 -1)*rmc_of_each_macro+splice_t_i*32*TIME_FRAME+Result_picture*32+splice_c_i][2*MEM_WIDTH-1:0] : 0) +
                                    // (MVMUh ? Handle_buffer[(MVMUa+MVMUb+MVMUc+MVMUd+MVMUg+MVMUh*9 -1)*rmc_of_each_macro+splice_t_i*32*TIME_FRAME+Result_picture*32+splice_c_i][2*MEM_WIDTH-1:0] : 0) +
                                    // (MVMUh ? Handle_buffer[(MVMUa+MVMUb+MVMUc+MVMUd+MVMUg+MVMUh*10-1)*rmc_of_each_macro+splice_t_i*32*TIME_FRAME+Result_picture*32+splice_c_i][2*MEM_WIDTH-1:0] : 0) +
                                    // (MVMUh ? Handle_buffer[(MVMUa+MVMUb+MVMUc+MVMUd+MVMUg+MVMUh*11-1)*rmc_of_each_macro+splice_t_i*32*TIME_FRAME+Result_picture*32+splice_c_i][2*MEM_WIDTH-1:0] : 0) ;
                            end
                        end
                    end
                    else begin
                        splice_t_flag <= 0;
                        SFU_flag <= 1;
                    end
                end
            end
        end
        else if(SFU_web == 5) begin        // SFU idle
            SFU_flag <= 0;
        end
        else if((SFU_web == 1)||(SFU_web == 2)||(SFU_web == 3)) begin 
            if     (Execute_flag == 15) begin     // adding the bias
                // // layer1
                // if     (SFU_web == 1) begin
                //     for (bias_p_i = 0; bias_p_i <= 3; bias_p_i = bias_p_i + 1) begin             // 4*picture
                //         for (bias_c_i = 0; bias_c_i <= 127; bias_c_i = bias_c_i + 1) begin       // 128*column
                //             Result_buffer[bias_p_i*1024+bias_c_i*8+:8] <= Result_buffer[bias_p_i*1024+bias_c_i*8+:8] + bias1_memory[0][bias_c_i*8+:8];
                //         end
                //     end
                //     Execute_flag <= Execute_flag + 1;
                // end
                // // layer2
                // else if(SFU_web == 2) begin
                //     for (bias_p_i = 0; bias_p_i <= 3; bias_p_i = bias_p_i + 1) begin             // 4*picture
                //         for (bias_c_i = 0; bias_c_i <= 63; bias_c_i = bias_c_i + 1) begin        // 64*column
                //             Result_buffer[bias_p_i*1024+bias_c_i*8+:8] <= Result_buffer[bias_p_i*1024+bias_c_i*8+:8] + bias2_memory[0][bias_c_i*8+:8];
                //         end
                //     end
                //     Execute_flag <= Execute_flag + 1;
                // end
                // // layer3
                // else if(SFU_web == 3) begin
                //     for (bias_p_i = 0; bias_p_i <= 3; bias_p_i = bias_p_i + 1) begin             // 4*picture
                //         for (bias_c_i = 0; bias_c_i <= 9; bias_c_i = bias_c_i + 1) begin         // 10*column
                //             Result_buffer[bias_p_i*1024+bias_c_i*8+:8] <= Result_buffer[bias_p_i*1024+bias_c_i*8+:8] + bias3_memory[0][bias_c_i*8+:8];
                //         end
                //     end
                //     Execute_flag <= Execute_flag + 1;
                // end
            end
            else if(Execute_flag == 4) begin     // Activation Function
                if((SFU_web == 1)||(SFU_web == 2)) begin
                    for (bias_c_i = 0; bias_c_i <= R_BUFFER_DEPTH-1; bias_c_i = bias_c_i + 1) begin         // Sigmoid
                        if(Result_buffer[bias_c_i*16+15] == 1) begin
                            SFU_output[bias_c_i*8+:8] <= 0;
                        end
                        else if(Result_buffer[bias_c_i*16+:16] == 0) begin
                            SFU_output[bias_c_i*8+:8] <= 0;
                        end
                        else
                            SFU_output[bias_c_i*8+:8] <= 1;
                        // if(Result_buffer[bias_c_i*16+15] == 1) begin
                        //     SFU_output[bias_c_i*8+:8] <= 0;
                        // end
                        // else if(Result_buffer[bias_c_i*16+:16] <= 64) begin
                        //     SFU_output[bias_c_i*8+:8] <= 0;
                        // end
                        // else
                        //     SFU_output[bias_c_i*8+:8] <= 1;
                    end
                end
                else begin
                    for (bias_c_i = 0; bias_c_i <= R_BUFFER_DEPTH-1; bias_c_i = bias_c_i + 1) begin         // ReLU specially for output layer
                        if(Result_buffer[bias_c_i*16+15] == 1) begin
                            Result[bias_c_i*16+:16] <= 0;
                        end
                        else
                            Result[bias_c_i*16+:16] <= Result_buffer[bias_c_i*16+:16];
                    end
                end
                Execute_flag <= Execute_flag + 1;
            end
            else if(Execute_flag == 5) begin     // Finish
                if(SFU_web == 1) begin
                    // 打开名为 "Result.txt" 的新文件，具有 "写" 权限
                    f = $fopen("layer 1 output.txt", "w");
                    // 将 lfsr 数组中的值写入文件，每个值占一行
                    for (print_i = 0; print_i <= 31; print_i = print_i + 1) begin
                        $fwrite(f, "%d~%d  : %d  %d  %d  %d  %d  %d  %d  %d  %d  %d  %d  %d  %d  %d  %d  %d.\n", 
                        print_i*16,print_i*16+15,
                        SFU_output[8*(0 +print_i*16) +:1], SFU_output[8*(1 +print_i*16) +:1], 
                        SFU_output[8*(2 +print_i*16) +:1], SFU_output[8*(3 +print_i*16) +:1],
                        SFU_output[8*(4 +print_i*16) +:1], SFU_output[8*(5 +print_i*16) +:1], 
                        SFU_output[8*(6 +print_i*16) +:1], SFU_output[8*(7 +print_i*16) +:1],
                        SFU_output[8*(8 +print_i*16) +:1], SFU_output[8*(9 +print_i*16) +:1], 
                        SFU_output[8*(10+print_i*16) +:1], SFU_output[8*(11+print_i*16) +:1], 
                        SFU_output[8*(12+print_i*16) +:1], SFU_output[8*(13+print_i*16) +:1], 
                        SFU_output[8*(14+print_i*16) +:1], SFU_output[8*(15+print_i*16) +:1]);
                    end
                    // 关闭文件
                    $fclose(f);
                end
                if(SFU_web == 2) begin
                    // 打开名为 "Result.txt" 的新文件，具有 "写" 权限
                    f = $fopen("layer 2 output without sigmoid.txt", "w");
                    // 将 lfsr 数组中的值写入文件，每个值占一行
                    $fwrite(f, "0~7  : %d  %d  %d  %d  %d  %d  %d  %d.\n", 
                    Result_buffer[16*0 +:16], Result_buffer[16*1 +:16], Result_buffer[16*2 +:16], Result_buffer[16*3 +:16],
                    Result_buffer[16*4 +:16], Result_buffer[16*5 +:16], Result_buffer[16*6 +:16], Result_buffer[16*7 +:16],);
                    $fwrite(f, "8~15 : %d  %d  %d  %d  %d  %d  %d  %d.\n", 
                    Result_buffer[16*8 +:16], Result_buffer[16*9 +:16], Result_buffer[16*10+:16], Result_buffer[16*11+:16],
                    Result_buffer[16*12+:16], Result_buffer[16*13+:16], Result_buffer[16*14+:16], Result_buffer[16*15+:16],);
                    $fwrite(f, "16~23: %d  %d  %d  %d  %d  %d  %d  %d.\n", 
                    Result_buffer[16*16+:16], Result_buffer[16*17+:16], Result_buffer[16*18+:16], Result_buffer[16*19+:16],
                    Result_buffer[16*20+:16], Result_buffer[16*21+:16], Result_buffer[16*22+:16], Result_buffer[16*23+:16],);
                    $fwrite(f, "24~31: %d  %d  %d  %d  %d  %d  %d  %d.\n", 
                    Result_buffer[16*24+:16], Result_buffer[16*25+:16], Result_buffer[16*26+:16], Result_buffer[16*27+:16], 
                    Result_buffer[16*28+:16], Result_buffer[16*29+:16], Result_buffer[16*30+:16], Result_buffer[16*31+:16],);
                    $fwrite(f, "0~7  : %d  %d  %d  %d  %d  %d  %d  %d.\n", 
                    Result_buffer[16*32+:16], Result_buffer[16*33+:16], Result_buffer[16*34+:16], Result_buffer[16*35+:16],
                    Result_buffer[16*36+:16], Result_buffer[16*37+:16], Result_buffer[16*38+:16], Result_buffer[16*39+:16],);
                    $fwrite(f, "8~15 : %d  %d  %d  %d  %d  %d  %d  %d.\n", 
                    Result_buffer[16*40+:16], Result_buffer[16*41+:16], Result_buffer[16*42+:16], Result_buffer[16*43+:16],
                    Result_buffer[16*44+:16], Result_buffer[16*45+:16], Result_buffer[16*46+:16], Result_buffer[16*47+:16],);
                    $fwrite(f, "16~23: %d  %d  %d  %d  %d  %d  %d  %d.\n", 
                    Result_buffer[16*48+:16], Result_buffer[16*49+:16], Result_buffer[16*50+:16], Result_buffer[16*51+:16],
                    Result_buffer[16*52+:16], Result_buffer[16*53+:16], Result_buffer[16*54+:16], Result_buffer[16*55+:16],);
                    $fwrite(f, "24~31: %d  %d  %d  %d  %d  %d  %d  %d.\n", 
                    Result_buffer[16*56+:16], Result_buffer[16*57+:16], Result_buffer[16*58+:16], Result_buffer[16*59+:16], 
                    Result_buffer[16*60+:16], Result_buffer[16*61+:16], Result_buffer[16*62+:16], Result_buffer[16*63+:16],);
                    // 关闭文件
                    $fclose(f);

                    // 打开名为 "Result.txt" 的新文件，具有 "写" 权限
                    f = $fopen("layer 2 output.txt", "w");
                    // 将 lfsr 数组中的值写入文件，每个值占一行
                    for (print_i = 0; print_i <= 32-1; print_i = print_i + 1) begin
                        $fwrite(f, "%d~%d  : %d  %d  %d  %d  %d  %d  %d  %d.\n", 
                        print_i*8,print_i*8+7,
                        SFU_output[8*(0+print_i*8) +:1], SFU_output[8*(1+print_i*8) +:1], 
                        SFU_output[8*(2+print_i*8) +:1], SFU_output[8*(3+print_i*8) +:1],
                        SFU_output[8*(4+print_i*8) +:1], SFU_output[8*(5+print_i*8) +:1], 
                        SFU_output[8*(6+print_i*8) +:1], SFU_output[8*(7+print_i*8) +:1]);
                    end
                    // 关闭文件
                    $fclose(f);
                end
                if(SFU_web == 3) begin
                    // 打开名为 "Result.txt" 的新文件，具有 "写" 权限
                    f = $fopen("Result.txt", "w");
                    // 将 lfsr 数组中的值写入文件，每个值占一行
                    for (print_i = 0; print_i <= 8-1; print_i = print_i + 1) begin
                        $fwrite(f, "number%d: %d  %d  %d  %d  %d  %d  %d  %d  %d  %d.\n", 
                        print_i,
                        Result[16*(print_i*32+0) +:16], Result[16*(print_i*32+1) +:16], 
                        Result[16*(print_i*32+2) +:16], Result[16*(print_i*32+3) +:16], 
                        Result[16*(print_i*32+4) +:16], Result[16*(print_i*32+5) +:16], 
                        Result[16*(print_i*32+6) +:16], Result[16*(print_i*32+7) +:16], 
                        Result[16*(print_i*32+8) +:16], Result[16*(print_i*32+9) +:16]);
                    end
                    $fwrite(f, "First number: %d  %d  %d  %d  %d  %d  %d  %d  %d  %d.\n", 
                    Result[16*0 +:16], Result[16*1 +:16], Result[16*2 +:16], Result[16*3 +:16], Result[16*4 +:16], 
                    Result[16*5 +:16], Result[16*6 +:16], Result[16*7 +:16], Result[16*8 +:16], Result[16*9 +:16]);
                    $fwrite(f, "Second number: %d  %d  %d  %d  %d  %d  %d  %d  %d  %d.\n", 
                    Result[16*32+:16], Result[16*33+:16], Result[16*34+:16], Result[16*35+:16], Result[16*36+:16], 
                    Result[16*37+:16], Result[16*38+:16], Result[16*39+:16], Result[16*40+:16], Result[16*41+:16]);
                    $fwrite(f, "Third number: %d  %d  %d  %d  %d  %d  %d  %d  %d  %d.\n", 
                    Result[16*64+:16], Result[16*65+:16], Result[16*66+:16], Result[16*67+:16], Result[16*68+:16], 
                    Result[16*69+:16], Result[16*70+:16], Result[16*71+:16], Result[16*72+:16], Result[16*73+:16]);
                    $fwrite(f, "Fourth number: %d  %d  %d  %d  %d  %d  %d  %d  %d  %d.\n", 
                    Result[16*96+:16], Result[16*97+:16], Result[16*98+:16], Result[16*99+:16], Result[16*100+:16], 
                    Result[16*101+:16], Result[16*102+:16], Result[16*103+:16], Result[16*104+:16], Result[16*105+:16]);
                    // 关闭文件
                    $fclose(f);
                end
                SFU_flag <= 1;
            end
        end
    end
end

endmodule