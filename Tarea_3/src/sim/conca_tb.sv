`timescale 1ns/1ps


module conca_tb();

logic [3:0] dec;
logic [3:0] uni;
logic [6:0] num;

concatenar_num conca(
    .dec(dec),
    .uni(uni),
    .num(num)
);

initial begin

$display("Testbench para operacion_binaria");

dec = 4'b0000;
uni = 4'b0001;

#10;
$display("dec = %b, uni = %b, num = %b, esperando = 0000001", dec, uni, num);


dec = 4'b0001;
uni = 4'b0001;

#10;
$display("dec = %b, uni = %b, num = %b, esperando = 0001011", dec, uni, num);


dec = 4'b0010;
uni = 4'b0001;

#10;
$display("dec = %b, uni = %b, num = %b, esperando = 0010101", dec, uni, num);

dec = 4'b0100;
uni = 4'b0001;

#10;
$display("dec = %b, uni = %b, num = %b, esperando = 0101001", dec, uni, num);

dec = 4'b1000;
uni = 4'b0001;

#10;
$display("dec = %b, uni = %b, num = %b, esperando = 1010001", dec, uni, num);

end

initial begin 
    $dumpfile("module_conca_tb.vcd");
    $dumpvars(0, conca_tb); 
end



endmodule