module Tile_instruction_memory
#(  parameter INSTRUCTION_WIDTH    = 64,
    parameter HL_INSTRUCTION_DEPTH = 1024,
    parameter INSTRUCTION_DEPTH    = 65536,
    parameter INTERCORE_DEPTH      = 8192,
    parameter INS_INTERCORE_DEPTH  = 4096,
    parameter RWS = 1,
    parameter RDS = 2,
    parameter SMS = 3,
    parameter WRM = 4,
    parameter WMS = 5,
    parameter SO1 = 6,
    parameter SO2 = 7,
    parameter SIC = 8,
    parameter SCS = 9,
    parameter W   = 10,
    parameter MMM = 11,
    parameter GBI = 12,
    parameter S   = 0
)
(
    input        clk,
    input        RSTn,       // enable

    input [2:0]  web,        // read/output/generation control
    input [15:0] start_ins_addr0,
    input [15:0] start_ins_addr1,
    input [15:0] start_ins_addr2,
    input [15:0] start_ins_addr3,
    input [15:0] start_ins_addr4,
    input [15:0] start_ins_addr5,
    input [15:0] start_ins_addr6,
    input [15:0] start_ins_addr7,
    input [15:0] start_ins_addr8,
    input [15:0] start_ins_addr9,
    input [15:0] start_ins_addr10,
    input [15:0] start_ins_addr11,
    input [15:0] start_ins_addr12,
    input [15:0] start_ins_addr13,
    input [15:0] start_ins_addr14,
    input [15:0] start_ins_addr15,
    input [15:0] end_ins_addr0,
    input [15:0] end_ins_addr1,
    input [15:0] end_ins_addr2,
    input [15:0] end_ins_addr3,
    input [15:0] end_ins_addr4,
    input [15:0] end_ins_addr5,
    input [15:0] end_ins_addr6,
    input [15:0] end_ins_addr7,
    input [15:0] end_ins_addr8,
    input [15:0] end_ins_addr9,
    input [15:0] end_ins_addr10,
    input [15:0] end_ins_addr11,
    input [15:0] end_ins_addr12,
    input [15:0] end_ins_addr13,
    input [15:0] end_ins_addr14,
    input [15:0] end_ins_addr15,
    input [15:0] core_ins_output_flag,

    output reg [INS_INTERCORE_DEPTH-1:0] core_ins_output0,
    output reg [INS_INTERCORE_DEPTH-1:0] core_ins_output1,
    output reg [INS_INTERCORE_DEPTH-1:0] core_ins_output2,
    output reg [INS_INTERCORE_DEPTH-1:0] core_ins_output3,
    output reg [INS_INTERCORE_DEPTH-1:0] core_ins_output4,
    output reg [INS_INTERCORE_DEPTH-1:0] core_ins_output5,
    output reg [INS_INTERCORE_DEPTH-1:0] core_ins_output6,
    output reg [INS_INTERCORE_DEPTH-1:0] core_ins_output7,
    output reg [INS_INTERCORE_DEPTH-1:0] core_ins_output8,
    output reg [INS_INTERCORE_DEPTH-1:0] core_ins_output9,
    output reg [INS_INTERCORE_DEPTH-1:0] core_ins_output10,
    output reg [INS_INTERCORE_DEPTH-1:0] core_ins_output11,
    output reg [INS_INTERCORE_DEPTH-1:0] core_ins_output12,
    output reg [INS_INTERCORE_DEPTH-1:0] core_ins_output13,
    output reg [INS_INTERCORE_DEPTH-1:0] core_ins_output14,
    output reg [INS_INTERCORE_DEPTH-1:0] core_ins_output15,

    input [15:0] addr,
    output reg [INSTRUCTION_WIDTH-1:0] instruction,

    input [15:0] HL_read_addr,
    input [15:0] write_addr,
    input [INTERCORE_DEPTH-1:0] basic_instruction,
    output reg [INSTRUCTION_WIDTH-1:0] HL_instruction,
    input IGU_done_flag
);

reg [INSTRUCTION_WIDTH-1:0] HL_instruction_memory    [0:HL_INSTRUCTION_DEPTH-1];
reg [INSTRUCTION_WIDTH-1:0] Basic_instruction_memory [0:INSTRUCTION_DEPTH   -1];

integer output_i;
integer write_i;
integer print_i;
integer f;

//--------------Code Starts Here------------------ 

initial begin
    $readmemb("D:/python project/pythonProject/GPP-PIM operation code.txt", HL_instruction_memory);

    core_ins_output0 = 0;
    core_ins_output1 = 0;
    core_ins_output2 = 0;
    core_ins_output3 = 0;
end

always @(posedge clk or negedge RSTn) begin

    if( web[2] ) begin
        HL_instruction <= HL_instruction_memory[HL_read_addr][INSTRUCTION_WIDTH-1:0];
        for(write_i = 0; write_i <= 127; write_i = write_i + 1)
            Basic_instruction_memory[write_addr+write_i][INSTRUCTION_WIDTH-1:0] <= basic_instruction[write_i*INSTRUCTION_WIDTH+:INSTRUCTION_WIDTH];
    end

    if( web[1] ) begin
        if( core_ins_output_flag[0] ) begin
            for(output_i = 0; output_i <= 63; output_i = output_i + 1) begin
                if(start_ins_addr0+output_i <= end_ins_addr0)
                    core_ins_output0[output_i*INSTRUCTION_WIDTH+:INSTRUCTION_WIDTH] <= Basic_instruction_memory[start_ins_addr0+output_i][INSTRUCTION_WIDTH-1:0];
                else
                    core_ins_output0[output_i*INSTRUCTION_WIDTH+:INSTRUCTION_WIDTH] <= 0;
            end
        end
        if( core_ins_output_flag[1] ) begin
            for(output_i = 0; output_i <= 63; output_i = output_i + 1) begin
                if(start_ins_addr1+output_i <= end_ins_addr1)
                    core_ins_output1[output_i*INSTRUCTION_WIDTH+:INSTRUCTION_WIDTH] <= Basic_instruction_memory[start_ins_addr1+output_i][INSTRUCTION_WIDTH-1:0];
                else
                    core_ins_output1[output_i*INSTRUCTION_WIDTH+:INSTRUCTION_WIDTH] <= 0;
            end
        end
        if( core_ins_output_flag[2] ) begin
            for(output_i = 0; output_i <= 63; output_i = output_i + 1) begin
                if(start_ins_addr2+output_i <= end_ins_addr2)
                    core_ins_output2[output_i*INSTRUCTION_WIDTH+:INSTRUCTION_WIDTH] <= Basic_instruction_memory[start_ins_addr2+output_i][INSTRUCTION_WIDTH-1:0];
                else
                    core_ins_output2[output_i*INSTRUCTION_WIDTH+:INSTRUCTION_WIDTH] <= 0;
            end
        end
        if( core_ins_output_flag[3] ) begin
            for(output_i = 0; output_i <= 63; output_i = output_i + 1) begin
                if(start_ins_addr3+output_i <= end_ins_addr3)
                    core_ins_output3[output_i*INSTRUCTION_WIDTH+:INSTRUCTION_WIDTH] <= Basic_instruction_memory[start_ins_addr3+output_i][INSTRUCTION_WIDTH-1:0];
                else
                    core_ins_output3[output_i*INSTRUCTION_WIDTH+:INSTRUCTION_WIDTH] <= 0;
            end
        end
        if( core_ins_output_flag[4] ) begin
            for(output_i = 0; output_i <= 63; output_i = output_i + 1) begin
                if(start_ins_addr4+output_i <= end_ins_addr4)
                    core_ins_output4[output_i*INSTRUCTION_WIDTH+:INSTRUCTION_WIDTH] <= Basic_instruction_memory[start_ins_addr4+output_i][INSTRUCTION_WIDTH-1:0];
                else
                    core_ins_output4[output_i*INSTRUCTION_WIDTH+:INSTRUCTION_WIDTH] <= 0;
            end
        end
        if( core_ins_output_flag[5] ) begin
            for(output_i = 0; output_i <= 63; output_i = output_i + 1) begin
                if(start_ins_addr5+output_i <= end_ins_addr5)
                    core_ins_output5[output_i*INSTRUCTION_WIDTH+:INSTRUCTION_WIDTH] <= Basic_instruction_memory[start_ins_addr5+output_i][INSTRUCTION_WIDTH-1:0];
                else
                    core_ins_output5[output_i*INSTRUCTION_WIDTH+:INSTRUCTION_WIDTH] <= 0;
            end
        end
        if( core_ins_output_flag[6] ) begin
            for(output_i = 0; output_i <= 63; output_i = output_i + 1) begin
                if(start_ins_addr6+output_i <= end_ins_addr6)
                    core_ins_output6[output_i*INSTRUCTION_WIDTH+:INSTRUCTION_WIDTH] <= Basic_instruction_memory[start_ins_addr6+output_i][INSTRUCTION_WIDTH-1:0];
                else
                    core_ins_output6[output_i*INSTRUCTION_WIDTH+:INSTRUCTION_WIDTH] <= 0;
            end
        end
        if( core_ins_output_flag[7] ) begin
            for(output_i = 0; output_i <= 63; output_i = output_i + 1) begin
                if(start_ins_addr7+output_i <= end_ins_addr7)
                    core_ins_output7[output_i*INSTRUCTION_WIDTH+:INSTRUCTION_WIDTH] <= Basic_instruction_memory[start_ins_addr7+output_i][INSTRUCTION_WIDTH-1:0];
                else
                    core_ins_output7[output_i*INSTRUCTION_WIDTH+:INSTRUCTION_WIDTH] <= 0;
            end
        end
        if( core_ins_output_flag[8] ) begin
            for(output_i = 0; output_i <= 63; output_i = output_i + 1) begin
                if(start_ins_addr8+output_i <= end_ins_addr8)
                    core_ins_output8[output_i*INSTRUCTION_WIDTH+:INSTRUCTION_WIDTH] <= Basic_instruction_memory[start_ins_addr8+output_i][INSTRUCTION_WIDTH-1:0];
                else
                    core_ins_output8[output_i*INSTRUCTION_WIDTH+:INSTRUCTION_WIDTH] <= 0;
            end
        end
        if( core_ins_output_flag[9] ) begin
            for(output_i = 0; output_i <= 63; output_i = output_i + 1) begin
                if(start_ins_addr9+output_i <= end_ins_addr9)
                    core_ins_output9[output_i*INSTRUCTION_WIDTH+:INSTRUCTION_WIDTH] <= Basic_instruction_memory[start_ins_addr9+output_i][INSTRUCTION_WIDTH-1:0];
                else
                    core_ins_output9[output_i*INSTRUCTION_WIDTH+:INSTRUCTION_WIDTH] <= 0;
            end
        end
        if( core_ins_output_flag[10] ) begin
            for(output_i = 0; output_i <= 63; output_i = output_i + 1) begin
                if(start_ins_addr10+output_i <= end_ins_addr10)
                    core_ins_output10[output_i*INSTRUCTION_WIDTH+:INSTRUCTION_WIDTH] <= Basic_instruction_memory[start_ins_addr10+output_i][INSTRUCTION_WIDTH-1:0];
                else
                    core_ins_output10[output_i*INSTRUCTION_WIDTH+:INSTRUCTION_WIDTH] <= 0;
            end
        end
        if( core_ins_output_flag[11] ) begin
            for(output_i = 0; output_i <= 63; output_i = output_i + 1) begin
                if(start_ins_addr11+output_i <= end_ins_addr11)
                    core_ins_output11[output_i*INSTRUCTION_WIDTH+:INSTRUCTION_WIDTH] <= Basic_instruction_memory[start_ins_addr11+output_i][INSTRUCTION_WIDTH-1:0];
                else
                    core_ins_output11[output_i*INSTRUCTION_WIDTH+:INSTRUCTION_WIDTH] <= 0;
            end
        end
        if( core_ins_output_flag[12] ) begin
            for(output_i = 0; output_i <= 63; output_i = output_i + 1) begin
                if(start_ins_addr12+output_i <= end_ins_addr12)
                    core_ins_output12[output_i*INSTRUCTION_WIDTH+:INSTRUCTION_WIDTH] <= Basic_instruction_memory[start_ins_addr12+output_i][INSTRUCTION_WIDTH-1:0];
                else
                    core_ins_output12[output_i*INSTRUCTION_WIDTH+:INSTRUCTION_WIDTH] <= 0;
            end
        end
        if( core_ins_output_flag[13] ) begin
            for(output_i = 0; output_i <= 63; output_i = output_i + 1) begin
                if(start_ins_addr13+output_i <= end_ins_addr13)
                    core_ins_output13[output_i*INSTRUCTION_WIDTH+:INSTRUCTION_WIDTH] <= Basic_instruction_memory[start_ins_addr13+output_i][INSTRUCTION_WIDTH-1:0];
                else
                    core_ins_output13[output_i*INSTRUCTION_WIDTH+:INSTRUCTION_WIDTH] <= 0;
            end
        end
        if( core_ins_output_flag[14] ) begin
            for(output_i = 0; output_i <= 63; output_i = output_i + 1) begin
                if(start_ins_addr14+output_i <= end_ins_addr14)
                    core_ins_output14[output_i*INSTRUCTION_WIDTH+:INSTRUCTION_WIDTH] <= Basic_instruction_memory[start_ins_addr14+output_i][INSTRUCTION_WIDTH-1:0];
                else
                    core_ins_output14[output_i*INSTRUCTION_WIDTH+:INSTRUCTION_WIDTH] <= 0;
            end
        end
        if( core_ins_output_flag[15] ) begin
            for(output_i = 0; output_i <= 63; output_i = output_i + 1) begin
                if(start_ins_addr15+output_i <= end_ins_addr15)
                    core_ins_output15[output_i*INSTRUCTION_WIDTH+:INSTRUCTION_WIDTH] <= Basic_instruction_memory[start_ins_addr15+output_i][INSTRUCTION_WIDTH-1:0];
                else
                    core_ins_output15[output_i*INSTRUCTION_WIDTH+:INSTRUCTION_WIDTH] <= 0;
            end
        end
    end
    else begin
        core_ins_output0 <= 0;
        core_ins_output1 <= 0;
        core_ins_output2 <= 0;
        core_ins_output3 <= 0;
        core_ins_output4 <= 0;
        core_ins_output5 <= 0;
        core_ins_output6 <= 0;
        core_ins_output7 <= 0;
        core_ins_output8 <= 0;
        core_ins_output9 <= 0;
        core_ins_output10<= 0;
        core_ins_output11<= 0;
        core_ins_output12<= 0;
        core_ins_output13<= 0;
        core_ins_output14<= 0;
        core_ins_output15<= 0;
    end

    if( web[0] ) begin
        instruction[0+:INSTRUCTION_WIDTH] <= Basic_instruction_memory[addr][0+:INSTRUCTION_WIDTH];
    end

    if( IGU_done_flag ) begin
        // 打开名为 "output.txt" 的新文件，具有 "写" 权限
        f = $fopen("Basic instructions.txt", "w");
        // 将 lfsr 数组中的值写入文件，每个值占一行
        for (print_i = 0; print_i <= INSTRUCTION_DEPTH-1; print_i = print_i + 1)
            $fwrite(f, "%b\n", Basic_instruction_memory[print_i][0+:INSTRUCTION_WIDTH]);
        // 关闭文件
        $fclose(f);
    end

end

endmodule