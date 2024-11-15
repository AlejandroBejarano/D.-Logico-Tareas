`timescale 1ns/1ps

module divisor_tb;
    logic clk;
    logic clk_div;

    divisor divisor_tbb(
        .clk(clk),
        .clk_div(clk_div)
    );

    initial begin   

        clk = 0;
        forever begin
            #18.52 clk = ~clk;
        end
    end

    initial begin  
        $monitor("Tiempo: %0t | clk = %b | clk_div = %b", $time, clk, clk_div);
        
        // Para el diagrama de tiempos
        $dumpfile("module_divisor_tb.vcd");
        $dumpvars(0, divisor_tb); // Nombre correcto del testbench
    
        #10000 $finish;
    end
    
endmodule