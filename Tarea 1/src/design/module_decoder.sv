 module gray_to_binary (
    input logic g3, g2, g1, g0,
    output logic b3,b2,b1,b0   
 );
 assign b3 = g3;
 assign b2 = b3 ^ g2;
 assign b1 = b2 ^ g1;
 assign b0 = b1 ^ g0;
    
 endmodule


//Con una instancia toma los valores de los bits para los Leds.
module binary_leds (
    input logic bit3, bit2, bit1, bit0,
    output logic led3, led2, led1, led0
 );

 gray_to_binary leds (
    .b3(bit3),
    .b2(bit2),
    .b1(bit1),
    .b0(bit0)
 );

 end module



//Revisar Pong Chu FPGA, pag.68  , para hex_to_seven_seg
module binary_to_sevenseg (
   input logic bit3, bit2, bit1, bit0,
   output logic a, b, c, d, e, f, g
);

gray_to_binary 7segment (
   .b3(bit3),
   .b2(bit2),
   .b1(bit1),
   .b0(bit0)
);

endmodule
