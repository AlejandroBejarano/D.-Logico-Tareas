 module gray_to_binary (
    input logic g3, g2, g1, g0,
    output logic b3,b2,b1,b0   
 );
 assign b3 = g3;
 assign b2 = b3 ^ g2;
 assign b1 = b2 ^ g1;
 assign b0 = b1 ^ g0;
    
 endmodule



module binary_leds (
    input bit3, bit2, bit1, bit0,
    output led3, led2, led1, led0
 );

 gray_to_binary leds (
    .b3(bit3),
    .b2(bit2),
    .b1(bit1),
    .b0(bit0)
 );

assign bit3 = led3;
assign bit2 = led2;
assign bit1 = led1;
assign bit0 = led0;

 end module
