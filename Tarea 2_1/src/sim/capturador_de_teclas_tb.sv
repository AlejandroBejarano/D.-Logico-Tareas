`timescale 1ns/1ps

module capturador_de_teclas_tb;

    logic clk;
    logic rst;
    logic col_0;
    logic col_1;
    logic col_2;
    logic col_3;

    logic [3:0] tecla_pre;
    logic suma;
    logic igual;

    capturador_de_teclas capturador_de_teclas_tbb(
        .clk(clk),
        .rst(rst),
        .col_0(col_0),
        .col_1(col_1),
        .col_2(col_2),
        .col_3(col_3),
        .tecla_pre(tecla_pre),
        .suma(suma),
        .igual(igual)
    );

    initial begin
        clk = 0;
        forever #18.5 clk = ~clk;
    end

    initial begin

        rst = 1;
        col_0 = 0;
        col_1 = 0;
        col_2 = 0;
        col_3 = 0;

        #20;
        rst = 0;

        #30 col_0 = 1;
        #5 col_0 = 0;
        #5 col_0 = 1;
        #1 col_0 = 0;
        #5 col_0 = 1;
        #3 col_0 = 0;
        #3 col_0 = 1;
        #200 col_0 = 0;
        #2 col_0 = 1;
        #200 col_0 = 0;
        #5 col_0 = 1;
        #3 col_0 = 0;

        #30 col_1 = 1;
        #5 col_1 = 0;
        #30 col_1 = 1;
        #30 col_1 = 0;
        #3 col_1 = 1;
        #4 col_1 = 0;

        #30 col_2 = 1;
        #4 col_2 = 0;
        #30 col_2 = 1;
        #30 col_2 = 0;
        #5 col_2 = 1;
        #3 col_2 = 0;

        #30 col_3 = 1;
        #5 col_3 = 0;
        #5 col_3 = 1;
        #30 col_3 = 0;
        #4 col_3 = 1;
        #30 col_3 = 0;

        #100;
        $finish;
    end
    initial begin
        $monitor("Time=%0t | tecla_pre=%b | suma=%b | igual=%b", $time, tecla_pre, suma, igual);
    end

    initial begin // Para el diagrama de tiempos
        $dumpfile("module_capturador_de_teclas_tb.vcd");
        $dumpvars(0, capturador_de_teclas_tb); // Nombre correcto del testbench
    end

endmodule