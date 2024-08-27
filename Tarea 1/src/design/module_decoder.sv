
// Modulo de conexion

module principal (
   input logic [3:0] GrayCode,

   output logic led3, led2, led1, led0
   //Anadir mas salidas, como la del 7-segmentos

);

logic [3:0]bit;

   //Instancia
   gray_to_binary g_to_b_inst (
      .Gray(GrayCode),
      .bin(bit)
      
   );

   //Instancia
   binary_leds b_to_l_inst (
      .bit3(b3),
      .bit2(b2),
      .bit1(b1),
      .bit0(b0),
      .led3(led3),
      .led2(led2),
      .led1(led1),
      .led0(led0)
   );

endmodule


//4.1

 module gray_to_binary (
    input logic [3:0] Gray,
    output logic [3:0] bin;   
 );

   logic b3, b2, b1, b0;

   assign b3 = g3;
   assign b2 = b3 ^ g2;
   assign b1 = b2 ^ g1;
   assign b0 = b1 ^ g0;

   assign bin = {b3,b2,b1,b0};

 endmodule


//4.2

//Con una instancia toma los valores de los bits para los Leds.
module binary_leds (
    input logic [3:0]bin,
    output logic [3:0] Led

 );

   logic bit3, bit2, bit1, bit1;

   assign bit3 = led3;
   assign bit2 = led2;
   assign bit1 = led1;
   assign bit0 = led0;

 endmodule





//4.3

module binary_to_hexadecimal (
   input logic ,
   ouput logic 
);

endmodule

module hexadecimal_to_sevensegment (

);


endmodule



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




module control_button(
   input logic ,
   output logic ,

);
endmodule






