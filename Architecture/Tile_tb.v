`timescale 1ns/1ns
module Tile_tb; 
reg        clk;
reg        RSTn; 
reg [31:0] rmc_of_each_macro;

Tile Tile(
    .clk                      (clk), 
    .RSTn                     (RSTn),
    .rmc_of_each_macro        (rmc_of_each_macro)
);

initial begin
    clk  = 0;
    RSTn = 1;
    rmc_of_each_macro = 8*512;
end

initial begin
    forever #10 clk = ~clk;
end

always begin
#10 if(clk == 1) begin

    end
end

initial begin
    #48000000 $finish;
end

initial
begin            
    // $dumpfile("Tile_tb.vcd");  //生成vcd文件，记录仿真信息
    // $dumpvars(0, Tile_tb);  //指定层次数，记录信号
end 

endmodule

// iverilog -o "Tile_tb.vvp" Tile_tb.v Tile.v Instruction_generation_unit.v Tile_instruction_memory.v Tile_control_unit.v Weight_SRAM.v Activation_SRAM.v Result_SRAM.v SFU.v Core.v Core_instruction_memory.v CHAS_execution_unit.v Core_control_unit.v Memory_unit.v MVMU.v
// vvp Tile_tb.vvp
// gtkwave Tile_tb.vcd