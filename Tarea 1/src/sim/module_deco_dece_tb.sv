`timescale 1ns/1ps

module deco_dece_tb;
   
   logic [3:0] bits;
   logic a, b, c, d, e, f, g;
   logic btn_in;
   logic ad, bd, cd, dd, ed, fd, gd;

    decodificador_siete deco_s_inst(
        .bin(bits),
        .a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g)
    );

    decodificador_decenas decodificador_decenas_inst(
        .btn_in(btn_in),
        .ad(ad), .bd(bd), .cd(cd), .dd(dd), .ed(ed), .fd(fd), .gd(gd)
    );

    initial begin

        bits = 4'b0000; 
        btn_in = 0;
        btn_in = 1; 
        btn_in = 0; 
        #10;

        bits = 4'b0001;
        btn_in = 0;
        btn_in = 1; 
        btn_in = 0; 
        #10;

        bits = 4'b0010; 
        btn_in = 0;
        btn_in = 1; 
        btn_in = 0; 
        #10;

        bits = 4'b0011;
        btn_in = 0;
        btn_in = 1; 
        btn_in = 0; 
        #10;

        bits = 4'b0100;
        btn_in = 0;
        btn_in = 1; 
        btn_in = 0; 
        #10;

        bits = 4'b0101;
        btn_in = 0;
        btn_in = 1; 
        btn_in = 0; 
        #10;

        bits = 4'b0110;
        btn_in = 0;
        btn_in = 1; 
        btn_in = 0; 
        #10;

        bits = 4'b0111; 
        btn_in = 0;
        btn_in = 1; 
        btn_in = 0; 
        #10;

        bits = 4'b1000; 
        btn_in = 0;
        btn_in = 1; 
        btn_in = 0; 
        #10;

        bits = 4'b1001; 
        btn_in = 0;
        btn_in = 1; 
        btn_in = 0; 
        #10;

        bits = 4'b1010; 
        btn_in = 0;
        btn_in = 1; 
        btn_in = 0; 
        #10;

        bits = 4'b1011; 
        btn_in = 0;
        btn_in = 1; 
        btn_in = 0; 
        #10;

        bits = 4'b1100; 
        btn_in = 0;
        btn_in = 1; 
        btn_in = 0; 
        #10;

        bits = 4'b1101; 
        btn_in = 0;
        btn_in = 1; 
        btn_in = 0; 
        #10;

        bits = 4'b1110; 
        btn_in = 0;
        btn_in = 1; 
        btn_in = 0; 
        #10;

        bits = 4'b1111; 
        btn_in = 0;
        btn_in = 1; 
        btn_in = 0; 
        #10;

        $finish;

    end

    initial begin
        $dumpfile("module_deco_dece_tb.vcd");
        $dumpvars(0, deco_dece_tb);
    end



endmodule