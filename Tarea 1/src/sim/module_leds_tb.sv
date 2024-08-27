`timescale 1ps/1ps

module module_leds_tb (
    input logic [3:0] bin,
    output logic [3:0] leds;

);

    binary_leds binary_leds_tb(
        .bin(bin),
        .Led(leds)
    );

    initial begin

        bin = 4`b0000; #10
        bin = 4`b0001; #10
        bin = 4`b0010; #10
        bin = 4`b0011; #10
        bin = 4`b0100; #10
        bin = 4`b0101; #10
        bin = 4`b0110; #10
        bin = 4`b0111; #10
        bin = 4`b1000; #10
        bin = 4`b1001; #10
        bin = 4`b1010; #10
        bin = 4`b1011; #10
        bin = 4`b1100; #10
        bin = 4`b1101; #10
        bin = 4`b1110; #10
        bin = 4`b1111; #10

    end


endmodule