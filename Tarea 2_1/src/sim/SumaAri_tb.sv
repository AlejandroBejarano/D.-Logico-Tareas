`timescale 1ns/1ps

module SumaAri_tb;

    // Señales de prueba
    logic clk;
    logic rst;
    logic [11:0] num1;
    logic [11:0] num2;
    logic [13:0] sum;

    // Instancia del módulo SumaAri
    SumaAri uut (
        .clk(clk),
        .rst_n(rst),
        .num1(num1),
        .num2(num2),
        .sum(sum)
    );

    // Generación de reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Periodo de 10ns
    end

initial begin
    // Inicializar señales
    rst = 0;
    num1 = 12'b000000000000; // Valor binario
    num2 = 12'b000000000000; // Valor binario

    // Reset del sistema
    #10 rst = 1;

    // Prueba de suma simple
    #10 num1 = 12'b1111011; num2 = 12'b111001000; // (123 y 456 en decimal)
    #10 num1 = 12'b1100010101; num2 = 12'b101000001; // (789 y 321 en decimal)

    // Finalizar simulación
    #50 $finish;
end


    initial begin
    $dumpfile("SumaAri.vcd");
    $dumpvars(0, SumaAri_tb);
    end


    // Monitor para imprimir resultados
    initial begin
        $monitor("Time: %0t | num1: %0d | num2: %0d | sum: %0d", $time, num1, num2, sum);
    end

endmodule
