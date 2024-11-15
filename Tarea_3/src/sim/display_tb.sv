`timescale 1ns/1ps

module display_tb;

    logic clk;
    logic rst;
    logic [3:0] num1;
    logic [3:0] num2;
    logic [13:0] num;
    
    logic a, b, c, d, e, f, g;
    logic [3:0] Transis;


    display dispinst (
        .clk(clk),
        .rst(rst),
        .num1(num1),
        .num2(num2),
        .num(num),
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .f(f),
        .g(g),
        .Transis(Transis)
    );

    initial begin
        clk = 0;
        forever #2 clk = ~clk;
    end


    initial begin
        rst = 1;
        num1 = 4'b0;
        num2 = 4'b0;
        num = 14'b0;
        #20 rst = 0;

        // Prueba a Euni
        #10 num1 = 4'b0001;
        #20;
        $display("Estado: Euni, Salidas: a=%b b=%b c=%b d=%b e=%b f=%b g=%b Transis=%b", a, b, c, d, e, f, g, Transis);

        // Prueba a Edec
        #10 num2 = 4'b1001; 
        #40;
        $display("Estado: Edec, Salidas: a=%b b=%b c=%b d=%b e=%b f=%b g=%b Transis=%b", a, b, c, d, e, f, g, Transis);

        // Prueba a E2
        #10 num = 14'b00000000000001;
        #40;
        $display("Estado: E2, Salidas: a=%b b=%b c=%b d=%b e=%b f=%b g=%b Transis=%b", a, b, c, d, e, f, g, Transis);

        #20 $finish;
    end
    initial begin 
        $dumpfile("module_display_tb.vcd");
        $dumpvars(0, display_tb);
    end

endmodule
