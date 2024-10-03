`timescale 1ns / 1ps

module sistema_calcu_tb;
    // Definición de señales
    logic clk;
    logic rst;
    logic col_0, col_1, col_2, col_3;
    logic [3:0] fila;
    logic [6:0] seg;
    logic [3:0] an;
    logic [13:0] resultado;

    // Instanciación del módulo a probar
    sistema_calculadora uut (
        .clk(clk),
        .rst(rst),
        .col_0(col_0),
        .col_1(col_1),
        .col_2(col_2),
        .col_3(col_3),
        .fila(fila),
        .an(an),
        .seg(seg),
        .resultado(resultado)
    );

    // Generación del reloj
    initial begin
        clk = 0;
        forever #20 clk = ~clk; // 27 MHz
    end

    // Proceso de prueba
    initial begin
        // Inicializar señales
        rst = 1;
        col_0 = 0;
        col_1 = 0;
        col_2 = 0;
        col_3 = 0;
        #400;

        // Desactivar el reset
        rst = 0;
        #400;

        // Simulación de entradas
        // Presionar tecla en fila 0, columna 0
        col_0 = 1; // Columna 0 activa
        #40; // Esperar para capturar el rebote
        col_0 = 0; // Liberar columna 0
        #40;

        // Presionar tecla en fila 0, columna 1
        col_1 = 1; // Columna 1 activa
        #40; // Esperar para capturar el rebote
        col_1 = 0; // Liberar columna 1
        #40;

        // Simular una operación de suma
        // Presionar tecla en fila 1, columna 0 (por ejemplo, sumar)
        col_0 = 1; // Columna 0 activa
        #40; 
        col_0 = 0; // Liberar columna 0
        #40;

        // Presionar tecla en fila 1, columna 1 (por ejemplo, igual)
        col_1 = 1; // Columna 1 activa
        #40; 
        col_1 = 0; // Liberar columna 1
        #40;

        // Finalizar la simulación
        $finish;
    end
    initial begin // Para el diagrama de tiempos
        $dumpfile("module_sistema_calcu_tb.vcd");
        $dumpvars(0, sistema_calcu_tb); // Nombre correcto del testbench
    end


endmodule
