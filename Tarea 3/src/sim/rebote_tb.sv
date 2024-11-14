`timescale 1ns / 1ps

module rebote_tb;

    reg boton;
    reg clk;
    
    logic boton_sal;

    rebote rebote_tbb(
        .boton(boton),
        .clk(clk),
        .boton_sal(boton_sal)
    );

    always #1000000 clk = ~clk; // Reloj de (1 MHz)

    initial begin
        clk = 0;
        forever begin
            #10 clk = ~clk;
        end
    end

    initial begin
        boton = 0;
        #25;
        boton = 1;
        #2;
        boton = 0;
        #20;
        boton = 1;
        #2;
        boton = 0;
        #1;
        boton = 1;
        #1;
        boton = 0;
        #1;
        boton = 1;
        #50;
        boton = 0;
        #400;
        boton = 0;
        #2;
        boton = 1;
        #2;
        boton = 0;
        #2;
        boton = 1;
        #2;
        boton = 0;
        #2;
        boton = 1;
        #50;
        boton = 0;
        #400;
        boton = 0;
        #2;
        boton = 1;
        #2;
        boton = 0;
        #2;
        boton = 1;
        #2;
        boton = 0;
        #2;
        boton = 1;
        #50;
        boton = 0;
        #400;
        boton = 1;
        #5;
        boton = 0;
        #2;
        boton = 1;
        #20;
        boton = 0;
        #80;
        boton = 1;
        #30;
        boton = 0;
        #3;
        boton = 1;
        #2;
        boton = 0;
        #100;
        boton = 1;
        #1;
        boton = 0;
        #100;
        boton = 1;
        #1;
        boton = 0;
        #2;
        boton = 1;
        #6;
        boton = 0;
        #2;
        boton = 1;
        #25;
        boton = 0;
        #100;
        boton = 1;

        $finish;
    end

    initial begin // Para el diagrama de tiempos
        $dumpfile("module_rebote_tb.vcd");
        $dumpvars(0, rebote_tb); // Nombre correcto del testbench
    end

endmodule