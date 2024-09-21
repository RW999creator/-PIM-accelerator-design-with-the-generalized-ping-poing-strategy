module MU
#(  parameter MEM_DEPTH       = 128000,        // 128kB
    parameter MEM_WIDTH       = 8,             // 8bit
    parameter RI_DEPTH        = 16384,         // read input bandwidth: 32*8*64
    parameter WR_DEPTH        = 16384,         // write result bandwidth
    parameter MVMU_I_DEPTH    = 256,
    parameter MVMU0_W_ADDR = 0,                // MVMUs weights addr 32*32*4 = 4096
    parameter MVMU1_W_ADDR = 1024,
    parameter MVMU2_W_ADDR = 2048,
    parameter MVMU3_W_ADDR = 3072,
    parameter MU_DATA_ADDR = 4096,             // data addr 64*32*4 = 8192
    parameter MVMU0_R_ADDR = 12288,            // result addr 32*64*4 = 8192
    parameter MVMU1_R_ADDR = 14336,
    parameter MVMU2_R_ADDR = 16384,
    parameter MVMU3_R_ADDR = 18432
)
(
    input        clk,
    input        RSTn,       //enable
    input [23:0] web,        //control

    input      [31:0] Core_output_addr0,
    input      [31:0] Core_output_addr1,
    input      [31:0] Core_output_addr2,
    input      [31:0] Core_output_addr3,
    output reg [WR_DEPTH-1:0] Core_output0,        //Core output
    output reg [WR_DEPTH-1:0] Core_output1,
    output reg [WR_DEPTH-1:0] Core_output2,
    output reg [WR_DEPTH-1:0] Core_output3,

    input      [31:0] i_input_addr0,        // input input addr
    input      [31:0] i_input_addr1,
    input      [31:0] i_input_addr2,
    input      [31:0] i_input_addr3,
    input [RI_DEPTH-1:0] updated_input0,
    input [RI_DEPTH-1:0] updated_input1,
    input [RI_DEPTH-1:0] updated_input2,
    input [RI_DEPTH-1:0] updated_input3,

    input [7:0] Batch_of_data0,         //Select the input addr required by the MVMU 
    input [7:0] Batch_of_data1,
    input [7:0] Batch_of_data2,
    input [7:0] Batch_of_data3,

    input [MVMU_I_DEPTH-1:0] MVMU_input0,         //MVMU0 input
    input [MVMU_I_DEPTH-1:0] MVMU_input1,         //MVMU1 input
    input [MVMU_I_DEPTH-1:0] MVMU_input2,         //MVMU2 input
    input [MVMU_I_DEPTH-1:0] MVMU_input3,         //MVMU3 input
    
    input [31:0] MVMU_output_addr0,
    input [31:0] MVMU_output_addr1,
    input [31:0] MVMU_output_addr2,
    input [31:0] MVMU_output_addr3,
    output reg [31:0] MVMU_weight0,
    output reg [31:0] MVMU_weight1,
    output reg [31:0] MVMU_weight2,
    output reg [31:0] MVMU_weight3,
    output reg [MVMU_I_DEPTH-1:0] MVMU_output0,         //MVMU0 output
    output reg [MVMU_I_DEPTH-1:0] MVMU_output1,         //MVMU1 output
    output reg [MVMU_I_DEPTH-1:0] MVMU_output2,         //MVMU2 output
    output reg [MVMU_I_DEPTH-1:0] MVMU_output3          //MVMU3 output
);

//--------------Internal variables---------------- 
reg [MEM_WIDTH-1:0] memory [0:MEM_DEPTH-1];

integer init_i;
integer MVMU_output0_i;
integer MVMU_output1_i;
integer MVMU_output2_i;
integer MVMU_output3_i;
integer MVMU_input0_i;
integer MVMU_input1_i;
integer MVMU_input2_i;
integer MVMU_input3_i;
integer core_output_i0;
integer core_output_i1;
integer core_output_i2;
integer core_output_i3;
integer core_input_i;
integer w_input_i0;
integer w_input_i1;
integer w_input_i2;
integer w_input_i3;
integer i_input_i0;
integer i_input_i1;
integer i_input_i2;
integer i_input_i3;
//--------------Code Starts Here------------------ 
initial begin
    Core_output0 = 0;
    Core_output1 = 0;
    Core_output2 = 0;
    Core_output3 = 0;

    MVMU_output0 = 0;
    MVMU_output1 = 0;
    MVMU_output2 = 0;
    MVMU_output3 = 0;

    //Memory initialization
    for(init_i = 0; init_i <= 127999; init_i = init_i + 1)
        memory[init_i][MEM_WIDTH-1:0] = 0;
end

always @ (posedge clk) begin
    if(RSTn) begin

        // MVMU output
        if(web[0] == 1) 
            for(MVMU_output0_i = 0; MVMU_output0_i <= MVMU_I_DEPTH/MEM_WIDTH-1; MVMU_output0_i = MVMU_output0_i + 1)
                MVMU_output0[MVMU_output0_i*MEM_WIDTH+:MEM_WIDTH] <= memory[MVMU_output_addr0+MVMU_output0_i][MEM_WIDTH-1:0];        // MVMU0
        else            
            MVMU_output0[MVMU_I_DEPTH-1:0] <= 0; 


        if(web[1] == 1) 
            for(MVMU_output1_i = 0; MVMU_output1_i <= MVMU_I_DEPTH/MEM_WIDTH-1; MVMU_output1_i = MVMU_output1_i + 1)
                MVMU_output1[MVMU_output1_i*MEM_WIDTH+:MEM_WIDTH] <= memory[MVMU_output_addr1+MVMU_output1_i][MEM_WIDTH-1:0];        // MVMU1
        else            
            MVMU_output1[MVMU_I_DEPTH-1:0] <= 0; 


        if(web[2] == 1) 
            for(MVMU_output2_i = 0; MVMU_output2_i <= MVMU_I_DEPTH/MEM_WIDTH-1; MVMU_output2_i = MVMU_output2_i + 1)
                MVMU_output2[MVMU_output2_i*MEM_WIDTH+:MEM_WIDTH] <= memory[MVMU_output_addr2+MVMU_output2_i][MEM_WIDTH-1:0];        // MVMU2
        else            
            MVMU_output2[MVMU_I_DEPTH-1:0] <= 0; 


        if(web[3] == 1) 
            for(MVMU_output3_i = 0; MVMU_output3_i <= MVMU_I_DEPTH/MEM_WIDTH-1; MVMU_output3_i = MVMU_output3_i + 1)
                MVMU_output3[MVMU_output3_i*MEM_WIDTH+:MEM_WIDTH] <= memory[MVMU_output_addr3+MVMU_output3_i][MEM_WIDTH-1:0];        // MVMU3
        else            
            MVMU_output3[MVMU_I_DEPTH-1:0] <= 0; 


        // MVMU input
        if(web[4] == 1) 
            for(MVMU_input0_i = 0; MVMU_input0_i <= MVMU_I_DEPTH/MEM_WIDTH-1; MVMU_input0_i = MVMU_input0_i + 1)
                memory[MVMU0_R_ADDR+Batch_of_data0*MVMU_I_DEPTH/MEM_WIDTH+MVMU_input0_i][MEM_WIDTH-1:0] <= MVMU_input0[MVMU_input0_i*MEM_WIDTH+:MEM_WIDTH];        // MVMU0
        

        if(web[5] == 1) 
            for(MVMU_input1_i = 0; MVMU_input1_i <= MVMU_I_DEPTH/MEM_WIDTH-1; MVMU_input1_i = MVMU_input1_i + 1)
                memory[MVMU1_R_ADDR+Batch_of_data1*MVMU_I_DEPTH/MEM_WIDTH+MVMU_input1_i][MEM_WIDTH-1:0] <= MVMU_input1[MVMU_input1_i*MEM_WIDTH+:MEM_WIDTH];        // MVMU1


        if(web[6] == 1) 
            for(MVMU_input2_i = 0; MVMU_input2_i <= MVMU_I_DEPTH/MEM_WIDTH-1; MVMU_input2_i = MVMU_input2_i + 1)
                memory[MVMU2_R_ADDR+Batch_of_data2*MVMU_I_DEPTH/MEM_WIDTH+MVMU_input2_i][MEM_WIDTH-1:0] <= MVMU_input2[MVMU_input2_i*MEM_WIDTH+:MEM_WIDTH];        // MVMU2


        if(web[7] == 1) 
            for(MVMU_input3_i = 0; MVMU_input3_i <= MVMU_I_DEPTH/MEM_WIDTH-1; MVMU_input3_i = MVMU_input3_i + 1)
                memory[MVMU3_R_ADDR+Batch_of_data3*MVMU_I_DEPTH/MEM_WIDTH+MVMU_input3_i][MEM_WIDTH-1:0] <= MVMU_input3[MVMU_input3_i*MEM_WIDTH+:MEM_WIDTH];        // MVMU3

        
        // result output
        if(web[8] == 1)
            for(core_output_i0 = 0; core_output_i0 <= WR_DEPTH/MEM_WIDTH-1; core_output_i0 = core_output_i0 + 1)
                Core_output0[core_output_i0*MEM_WIDTH+:MEM_WIDTH] <= memory[MVMU0_R_ADDR+Core_output_addr0+core_output_i0][MEM_WIDTH-1:0];
        else            
            Core_output0[WR_DEPTH-1:0] <= 0;


        if(web[9] == 1)
            for(core_output_i1 = 0; core_output_i1 <= WR_DEPTH/MEM_WIDTH-1; core_output_i1 = core_output_i1 + 1)
                Core_output1[core_output_i1*MEM_WIDTH+:MEM_WIDTH] <= memory[MVMU1_R_ADDR+Core_output_addr1+core_output_i1][MEM_WIDTH-1:0];
        else            
            Core_output1[WR_DEPTH-1:0] <= 0;


        if(web[10] == 1)
            for(core_output_i2 = 0; core_output_i2 <= WR_DEPTH/MEM_WIDTH-1; core_output_i2 = core_output_i2 + 1)
                Core_output2[core_output_i2*MEM_WIDTH+:MEM_WIDTH] <= memory[MVMU2_R_ADDR+Core_output_addr2+core_output_i2][MEM_WIDTH-1:0];
        else            
            Core_output2[WR_DEPTH-1:0] <= 0;


        if(web[11] == 1)
            for(core_output_i3 = 0; core_output_i3 <= WR_DEPTH/MEM_WIDTH-1; core_output_i3 = core_output_i3 + 1)
                Core_output3[core_output_i3*MEM_WIDTH+:MEM_WIDTH] <= memory[MVMU3_R_ADDR+Core_output_addr3+core_output_i3][MEM_WIDTH-1:0];
        else            
            Core_output3[WR_DEPTH-1:0] <= 0;


        // input input
        if(web[16] == 1)
            for(i_input_i0 = 0; i_input_i0 <= RI_DEPTH/MEM_WIDTH-1; i_input_i0 = i_input_i0 + 1)
                memory[i_input_addr0+i_input_i0][MEM_WIDTH-1:0] <= updated_input0[i_input_i0*MEM_WIDTH+:MEM_WIDTH];


        if(web[17] == 1)
            for(i_input_i1 = 0; i_input_i1 <= RI_DEPTH/MEM_WIDTH-1; i_input_i1 = i_input_i1 + 1)
                memory[i_input_addr1+i_input_i1][MEM_WIDTH-1:0] <= updated_input1[i_input_i1*MEM_WIDTH+:MEM_WIDTH];


        if(web[18] == 1)
            for(i_input_i2 = 0; i_input_i2 <= RI_DEPTH/MEM_WIDTH-1; i_input_i2 = i_input_i2 + 1)
                memory[i_input_addr2+i_input_i2][MEM_WIDTH-1:0] <= updated_input2[i_input_i2*MEM_WIDTH+:MEM_WIDTH];


        if(web[19] == 1)
            for(i_input_i3 = 0; i_input_i3 <= RI_DEPTH/MEM_WIDTH-1; i_input_i3 = i_input_i3 + 1)
                memory[i_input_addr3+i_input_i3][MEM_WIDTH-1:0] <= updated_input3[i_input_i3*MEM_WIDTH+:MEM_WIDTH];

    end
end

endmodule