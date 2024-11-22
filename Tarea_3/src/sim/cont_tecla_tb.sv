`timescale 1ns/1ps

module cont_tecla_tb;

    // Señales del testbench
    logic clk;
    logic rst;
    logic [3:0] tecla_pre;
    logic [2:0] tecla_cont;

    // Instancia del módulo a probar
    cont_tecla inst_cont (
        .clk(clk),
        .rst(rst),
        .tecla_pre(tecla_pre),
        .tecla_cont(tecla_cont)
    );

    // Generador de reloj (50 MHz ~ 20 ns de periodo)
    always #10 clk = ~clk;

    // Bloque inicial para probar el diseño
    initial begin
        // Inicialización de señales
        clk = 0;
        rst = 1;  // Activa reset inicialmente
        tecla_pre = 4'b0000;

        // Desactiva reset tras dos ciclos de reloj
        #20 rst = 0;

        // Cambios en tecla_pre
        #15 tecla_pre = 4'b0001;  // Cambio 1
        #20 tecla_pre = 4'b0010;  // Cambio 2
        #20 tecla_pre = 4'b0011;  // Cambio 3
        #20 tecla_pre = 4'b0100;  // Cambio 4

        // Mantener tecla_pre sin cambios
        #40 tecla_pre = 4'b0100;

        // Cambio adicional
        #20 tecla_pre = 4'b1000;  // Cambio 5

        // Finalizar simulación
        #50 $finish;
    end

    // Bloque para monitorear las señales en tiempo real
    initial begin
        $monitor("Tiempo: %0t | rst: %b | tecla_pre: %b | tecla_cont: %d",
                 $time, rst, tecla_pre, tecla_cont);
    end

    // Bloque para generar archivo de diagrama de tiempos
    initial begin
        $dumpfile("cont_tecla_tb.vcd");
        $dumpvars(0, cont_tecla_tb);
    end
endmodule
