`timescale 1ns/1ps

module almacenamiento_tb;

    // Entradas del módulo
    logic clk;
    logic rst;
    logic almac;
    logic [3:0] num1_dec1;
    logic [3:0] num1_dec2;
    logic [3:0] num2_dec1;
    logic [3:0] num2_dec2;

    // Salidas del módulo
    logic [11:0] num_result1;
    logic [11:0] num_result2;

    // Instancia del módulo
    almacenamiento uut (
        .clk(clk),
        .rst(rst),
        .almac(almac),
        .num1_dec1(num1_dec1),
        .num1_dec2(num1_dec2),
        .num2_dec1(num2_dec1),
        .num2_dec2(num2_dec2),
        .num_result1(num_result1),
        .num_result2(num_result2)
    );

    // Generador de reloj
    always begin
        #5 clk = ~clk;  // Genera un reloj con periodo de 10 unidades de tiempo
    end

    // Estímulos de prueba
    initial begin
        // Inicialización de señales
        clk = 0;
        rst = 0;
        almac = 0;
        num1_dec1 = 4'b0000;
        num1_dec2 = 4'b0000;
        num2_dec1 = 4'b0000;
        num2_dec2 = 4'b0000;

        // Aplicar reset
        rst = 1;
        #10;
        rst = 0;

        // Activar la señal de almacenar y probar con diferentes combinaciones de entradas
        almac = 1;

        // Primer ciclo de almacenamiento: 4 y 7 concatenados como 47
        num1_dec1 = 4'b0100; num1_dec2 = 4'b0111; // 47 en decimal
        num2_dec1 = 4'b0000; num2_dec2 = 4'b0000; // 0 en decimal
        #10;

        // Segundo ciclo de almacenamiento: 8 y 3 concatenados como 83
        num1_dec1 = 4'b0000; num1_dec2 = 4'b0000; // 0 en decimal
        num2_dec1 = 4'b1000; num2_dec2 = 4'b0011; // 83 en decimal
        #10;

        // Finalizar la simulación
        $finish;
    end

    initial begin
        $dumpfile("almacenamiento_tb.vcd");
        $dumpvars(0, almacenamiento_tb);
    end

endmodule
