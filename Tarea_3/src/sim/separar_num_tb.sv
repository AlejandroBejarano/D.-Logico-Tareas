`timescale 1ns / 1ps

module separar_num_tb;

logic [13:0] num;
logic [3:0] uni, dec, cen, mill;

separar_num sepnum (
    .num(num),
    .uni(uni),
    .dec(dec),
    .cen(cen),
    .mill(mill)
);

initial begin

    $display ("            num     |  mill       |  cen      |   dec     |   uni   |");
    $monitor (" %b     |  %b       |   %b    |  %b     |  %b   |", num, mill, cen, dec, uni);

    num = 14'b0;  //0
    #10;
    num = 14'b10011001001001;  //9801
    #10;
    num = 14'b1110100100000;   //7456
    #10;
    num = 14'b1111101000;    //1000
    #10;
    num = 14'b1100100;   //100
    #10;
    num = 14'b1010;    //10
    #10;
    $finish;

end

initial begin // Para el diagrama de tiempos
    #80;
    $dumpfile("module_separar_num_tb.vcd");
    $dumpvars(0, separar_num_tb); // Nombre correcto del testbench
end

endmodule