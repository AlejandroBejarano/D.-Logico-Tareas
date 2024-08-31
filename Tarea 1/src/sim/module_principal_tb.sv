`timescale 1ns/1ps

module principal_tb;
    logic [3:0] gray;
    logic [3:0] bit_4;
    logic [3:0] leds;
    logic a, b, c, d, e, f, g;
    logic btn_in;
    logic bd, cd;


    gray_to_binary g_t_inst (
        .Gray(gray),
        .bin(bit_4)
    );

    binary_leds b_l_inst (
        .bin(bit_4),
        .Led(leds)
    );

    decodificador_siete d_s_inst(
        .bin(bit_4),
        .a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g)
    );

    decodificador_decenas d_d_inst(
        .btn_in(btn_in),
        .bd(bd), .cd(cd)
    );





    initial begin

        gray = 4'b0000; #10;
        gray = 4'b0001; #10;
        gray = 4'b0010; #10;
        gray = 4'b0011; #10;
        gray = 4'b0100; #10;
        gray = 4'b0101; #10;
        gray = 4'b0110; #10;
        gray = 4'b0111; #10;
        gray = 4'b1000; #10;
        gray = 4'b1001; #10;
        gray = 4'b1010; #10;
        gray = 4'b1011; #10;
        gray = 4'b1100; #10;
        gray = 4'b1101; #10;
        gray = 4'b1110; #10;
        gray = 4'b1111; #10;


        $finish;

    end



    initial begin
        $dumpfile("module_principal_tb.vcd");
        $dumpvars(0, principal_tb);
    end

endmodule