`timescale 1ns/1ps

module cont_anillo;

    logic clk;
    logic rst;
    logic [3:0] fila;


    cont_anillo cont_tb(
        .clk(clk),
        .rst(rst),
        .fila(fila)
    );



    always #18.5 clk = ~clk;



    initial begin
        
        clk=0;
        rst=1;
        #1;
        rst=0;
        #100;


        #500000;
        $finish;
    end

    // Para el diagrama de tiempos
    initial begin 
        $dumpfile("module_cont_anillo_tb.vcd");
        $dumpvars(0, cont_anillo); 
    end

endmodule
