`timescale 1ns/1ps

module almacenamiento_tb;

    // Señales de entrada
    logic clk;
    logic rst;
    logic almac;
    logic [3:0] num1_dec1;
    logic [3:0] num1_dec2;
    logic [3:0] num2_dec1;
    logic [3:0] num2_dec2;

    // Señales de salida
    logic [11:0] num_result1;
    logic [11:0] num_result2;

    // Instancia del módulo almacenamiento
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

    // Generación de reloj
    always #5 clk = ~clk;

    // Estímulos de prueba
    initial begin
        // Inicialización
        clk = 0;
        rst = 1;
        almac = 0;
        num1_dec1 = 4'b0000;
        num1_dec2 = 4'b0000;
        num2_dec1 = 4'b0000;
        num2_dec2 = 4'b0000;

        // Reset
        #10 rst = 0;

        // Probar primer conjunto de números (ejemplo: 8 y 4)
        #10 almac = 1;
        num1_dec1 = 4'b1000; // 8
        num1_dec2 = 4'b0100; // 4
        num2_dec1 = 4'b0011; // 3
        num2_dec2 = 4'b0101; // 5

        #10 almac = 0;

        // Espera para observación
        #50;

        // Probar segundo conjunto de números (ejemplo: 1 y 2, 6 y 7)
        #10 almac = 1;
        num1_dec1 = 4'b0001; // 1
        num1_dec2 = 4'b0010; // 2
        num2_dec1 = 4'b0110; // 6
        num2_dec2 = 4'b0111; // 7

        #10 almac = 0;

        // Fin de simulación
        #50 $finish;
    end

    // Monitor para ver los resultados
    initial begin
        $monitor("Time=%0t | num_result1=%0d | num_result2=%0d", $time, num_result1, num_result2);
    end

    // Generación de archivo de ondas
    initial begin
        $dumpfile("almacenamiento_tb.vcd");
        $dumpvars(0, almacenamiento_tb);
    end

endmodule