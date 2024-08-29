`timescale 1ns/1ps

module deco_siete_tb;
   logic [3:0] bit;
   logic a, b, c, d, e, f, g;


   decodificador_siete decodificador_siete_tb(
    .bit(bin),
    .a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g) 

   );

    initial begin

        bit = 4'b0000; #10;
        bit = 4'b0001; #10;
        bit = 4'b0010; #10;
        bit = 4'b0011; #10;
        bit = 4'b0100; #10;
        bit = 4'b0101; #10;
        bit = 4'b0110; #10;
        bit = 4'b0111; #10;
        bit = 4'b1000; #10;
        bit = 4'b1001; #10;
        bit = 4'b1010; #10;
        bit = 4'b1011; #10;
        bit = 4'b1100; #10;
        bit = 4'b1101; #10;
        bit = 4'b1110; #10;
        bit = 4'b1111; #10;   


    end

    initial begin
        $dumpfile("module_deco_siete_tb.vcd");
        $dumpvars(0, deco_siete_tb);
    end

endmodule