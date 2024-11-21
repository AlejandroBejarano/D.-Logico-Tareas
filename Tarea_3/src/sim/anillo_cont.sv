`timescale 1ns/1ps

module anillo_tb;
parameter WIDTH = 4;

reg clk;
reg rst;
logic [WIDTH-1:0] fila;

anillo_ctdr anillo_inst_tb(
    .clk(clk),
    .rst(rst),
    .fila(fila)
);

always #500 clk = ~clk;

initial begin

    {clk, rst} <= 0;

    $monitor ("T=%0t fila=%b", $time, fila);
    repeat (2) @(posedge clk);
    rst <= 1;
    repeat (15) @(posedge clk);
    #10000;
    $finish;
end

initial begin 
    $dumpfile("module_cont_anillo_tb.vcd");
    $dumpvars(0, anillo_tb); 
end

endmodule