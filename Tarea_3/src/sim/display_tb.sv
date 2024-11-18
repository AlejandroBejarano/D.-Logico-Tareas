module display_tb();

    parameter CLK_PERIOD = 10; // Periodo del reloj en unidades de tiempo (en este caso, ns)
    
    logic [6:0] Seg;
    logic clk;
    logic [15:0] result;
    logic [3:0] anodes;

    display DUT(
        
        .Seg(Seg),
        .clk(clk),
        .result(result),
        .anodes(anodes)  );

   
   initial begin
   clk = 0;
   forever #5 clk = ~clk;
   end 
    // Inicialización de las entradas
    initial begin
        //clk = 0; // Inicialmente, el reloj está en bajo
        result = 16'b0001000001111000;  
        #1000;
        $finish; // Finalizar la simulación después de realizar las pruebas
    end
        
    initial begin // Para el diagrama de tiempos
        $dumpfile("display_tb.vcd");
        $dumpvars(0, display_tb); // Nombre correcto del testbench
    end
endmodule
