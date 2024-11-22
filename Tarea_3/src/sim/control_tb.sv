`timescale 1ns/1ps


module control_tb;

    // Señales del testbench
    logic clk_tb;
    logic rst_tb;
    logic col_0_tb, col_1_tb, col_2_tb, col_3_tb;
    logic [6:0] seg_tb;
    logic [3:0] an_tb, fila_tb;

    // Instancia del DUT (Device Under Test)
    control DUT (
        .rst(rst_tb),
        .clk(clk_tb),
        .col_0(col_0_tb),
        .col_1(col_1_tb),
        .col_2(col_2_tb),
        .col_3(col_3_tb),
        .seg(seg_tb),
        .an(an_tb),
        .fila(fila_tb)
    );

    // Generador de reloj
    initial begin
        clk_tb = 0;
        forever #18.5 clk_tb = ~clk_tb; // Período de reloj de 10 ns (100 MHz)
    end

    // Secuencia de pruebas
    initial begin
        // Inicialización
        rst_tb = 0;
        col_0_tb = 0;
        col_1_tb = 0;
        col_2_tb = 0;
        col_3_tb = 0;

        #20; // Esperar algunos ciclos de reloj
        rst_tb = 1; // Salir del reset
        #5;
        rst_tb = 0;

        #1000;

        // Simulación de fila activa y tecla presionada
        //fila_tb = 4'b0001; // Activar primera fila
        #10000 col_0_tb = 1; // Simular tecla "1" presionada
        #20000 col_0_tb = 0;

        //fila_tb = 4'b0010; // Activar segunda fila
        #100000 col_1_tb = 1; // Simular tecla "5" presionada
        #20000 col_1_tb = 0;

        //fila_tb = 4'b0100; // Activar tercera fila
        #100000 col_2_tb = 1; // Simular tecla "9" presionada
        #2000 col_2_tb = 0;

        //fila_tb = 4'b1000; // Activar cuarta fila
        #100000 col_3_tb = 1; // Simular tecla "D" presionada
        #20000 col_3_tb = 0;

        // Simulación de una operación (suma)
        //fila_tb = 4'b0100;
        #100000 col_1_tb = 1; // Presionar "8"
        #20000 col_1_tb = 0;

        //fila_tb = 4'b0010;
        #100000 col_0_tb = 1; // Presionar "+"
        #20000 col_0_tb = 0;

        //fila_tb = 4'b0001;
        #100000 col_2_tb = 1; // Presionar "3"
        #20000 col_2_tb = 0;

        //fila_tb = 4'b1000;
        #100000 col_3_tb = 1; // Presionar "="
        #20000 col_3_tb = 0;

        // Finalizar simulación
        #100000;
        $finish;
    end

    initial begin
        $dumpfile("module_control_tb.vcd");
        $dumpvars(0, control_tb);
    end

endmodule
