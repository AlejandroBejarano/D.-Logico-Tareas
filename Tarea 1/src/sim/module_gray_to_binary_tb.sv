`timescale 1ns/1ps

 module module_gray_to_binary_tb ;
    logic [3:0] Gray_Code;
    logic [3:0] bit_4;

    gray_to_binary gray_to_binary_inst(
        .Gray(Gray_Code),
        .bin(bit_4)
    );

    initial begin
        
        Gray_Code = 4'b0000; #10;
        Gray_Code = 4'b0001; #10;
        Gray_Code = 4'b0010; #10;
        Gray_Code = 4'b0011; #10;
        Gray_Code = 4'b0100; #10;
        Gray_Code = 4'b0101; #10;
        Gray_Code = 4'b0110; #10;
        Gray_Code = 4'b0111; #10;
        Gray_Code = 4'b1000; #10;
        Gray_Code = 4'b1001; #10;
        Gray_Code = 4'b1010; #10;
        Gray_Code = 4'b1011; #10;
        Gray_Code = 4'b1100; #10;
        Gray_Code = 4'b1101; #10;
        Gray_Code = 4'b1110; #10;
        Gray_Code = 4'b1111; #10;

    end


    initial begin
        $dumpfile("module_gray_to_binary_tb.vcd");
        $dumpvars(0, module_gray_to_binary_tb);
    end
    
 endmodule