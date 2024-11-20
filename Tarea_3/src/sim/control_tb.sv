`timescale 1ns/1ps


module control_tb;

    // Señales del testbench
    logic clk_tb;
    logic rst_tb;
    logic col_0_tb, col_1_tb, col_2_tb, col_3_tb;
    logic [6:0] seg_tb;
    logic [3:0] an_tb;
    logic [3:0] fila_tb; // Controlado por el DUT, no asignado directamente

    // Instancia del DUT (Device Under Test)
    control DUT (
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

    // Monitor para observar las filas y columnas
    initial begin
        $monitor("Time: %0t | fila_tb: %b | col_0_tb: %b | col_1_tb: %b | col_2_tb: %b | col_3_tb: %b",
                 $time, fila_tb, col_0_tb, col_1_tb, col_2_tb, col_3_tb);
    end

    // Secuencia de pruebas
    initial begin
        // Inicialización
        rst_tb = 1;
        col_0_tb = 0;
        col_1_tb = 0;
        col_2_tb = 0;
        col_3_tb = 0;
        fila_tb = 4'b0000; // Inicializar filas en 0

        #50 rst_tb = 0; // Salir del reset

        // Activar cada fila de forma secuencial y simular tecla presionada
        fila_tb = 4'b0001; // Fila 0 activa
        #10 col_0_tb = 1; #50 col_0_tb = 0; // Simular tecla "1"
        #50 fila_tb = 4'b0010; // Fila 1 activa
        #10 col_1_tb = 1; #50 col_1_tb = 0; // Simular tecla "5"
        #50 fila_tb = 4'b0100; // Fila 2 activa
        #10 col_2_tb = 1; #50 col_2_tb = 0; // Simular tecla "9"
        #50 fila_tb = 4'b1000; // Fila 3 activa
        #10 col_3_tb = 1; #50 col_3_tb = 0; // Simular tecla "D"

        // Simulación de operaciones con filas y columnas
        fila_tb = 4'b0100; // Activar fila 2
        #10 col_1_tb = 1; #50 col_1_tb = 0; // Presionar "8"

        fila_tb = 4'b0010; // Activar fila 1
        #10 col_0_tb = 1; #50 col_0_tb = 0; // Presionar "+"

        fila_tb = 4'b0001; // Activar fila 0
        #10 col_2_tb = 1; #50 col_2_tb = 0; // Presionar "3"

        fila_tb = 4'b1000; // Activar fila 3
        #10 col_3_tb = 1; #50 col_3_tb = 0; // Presionar "="

        // Finalizar simulación
        #100;
        $finish;
    end

    initial begin
        $dumpfile("control_tb.vcd");
        $dumpvars(0, control_tb);
    end
endmodule
