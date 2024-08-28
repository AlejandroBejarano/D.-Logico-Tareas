
// Modulo de conexion
/*
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
*/

//4.1

 module gray_to_binary (
    input logic [3:0] Gray,
    output logic [3:0] bin   
 );

   logic b3, b2, b1, b0;

   assign b3 = Gray[3];
   assign b2 = Gray[3] ^ Gray[2];
   assign b1 = Gray[2] ^ Gray[1];
   assign b0 = Gray[1] ^ Gray[0];

   assign bin = {b3,b2,b1,b0};

 endmodule



//4.2

/*
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
*/




//4.3


