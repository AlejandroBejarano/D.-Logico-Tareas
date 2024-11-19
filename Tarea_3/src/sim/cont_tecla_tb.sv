`timescale 1ns/1ps

module cont_tecla_tb;

    // Señales del testbench
    logic clk;
    logic rst;
    logic [3:0] tecla_pre;
    logic [2:0] tecla_cont;

    cont_tecla inst_cont (
        .clk(clk),
        .rst(rst),
        .tecla_pre(tecla_pre),
        .tecla_cont(tecla_cont)
    );

    always #18.5 clk = ~clk;

    initial begin
        // Inicialización de señales
        clk = 0;
        rst = 1;
        tecla_pre = 4'b0000;

        #20 rst = 0;

        //tecla_pre con diferentes valores
        #15 tecla_pre = 4'b0001;  // Cambio 1
        #10 tecla_pre = 4'b0010;  // Cambio 2
        #10 tecla_pre = 4'b0011;  // Cambio 3
        #10 tecla_pre = 4'b0100;  // Cambio 4

        // No cambiar tecla_pre (sin cambio)
        #20 tecla_pre = 4'b0100;

        // Cambio adicional
        #10 tecla_pre = 4'b1000;  // Cambio 5

        // Finalizar simulación
        #30 $finish;
    end

    // Monitorear señales
    initial begin
        $monitor("Tiempo: %0t | rst: %b | tecla_pre: %b | tecla_cont: %d",
                 $time, rst, tecla_pre, tecla_cont);
    end

    initial begin // Para el diagrama de tiempos
        $dumpfile("module_cont_tecla_tb.vcd");
        $dumpvars(0, cont_tecla_tb); // Nombre correcto del testbench
    end
endmodule