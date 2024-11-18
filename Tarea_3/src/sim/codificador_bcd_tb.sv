`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 

module codificador_bcd_tb();

    logic [15:0] binary_in;
    logic [15:0] bcd_out;
    logic clk;
    codificador_bcd DUT(
        .clk(clk),
        .binary_in(binary_in),
        .bcd_out(bcd_out));


    // Inicialización de las entradas
   initial begin
   clk = 0;
   forever #1 clk = ~clk;
   end 
    initial begin
        clk = 0; // Inicialmente, el reloj está en bajo
        binary_in = 16'd1234;
        #1000;
        
        $finish; // Finalizar la simulación después de realizar las pruebas
    end
        // Para el diagrama de tiempos
    initial begin 
        $dumpfile("codificador_bcd_tb.vcd");
        $dumpvars(0, codificador_bcd_tb); 
    end
endmodule