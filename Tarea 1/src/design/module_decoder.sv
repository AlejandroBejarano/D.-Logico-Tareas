
// Modulo de conexion

module principal (

   input logic [3:0] GrayCode,
   input logic btn_in;

   output logic led3, led2, led1, led0
   output logic a, b, c, d, e, f   //Anadir salidas, como la del 7-segmentos
   output logic ad, bd, cd, dd, ed, fd 
  
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
// Para las unidades de 7 setmentos 
module decodificador_siente (
   input logic led0, led1, led2, led3,
   output logic a, b, c, d, e, f, g
);

   assign a = (~led1 & ~led3) | (led1 & led3) | (led2) | (led0);
   assign b = (~led0 & ~led1) | (~led3) | (led0 & led1);
   assign c = (~led0) | (led3) | (led1);
   assign d = (~led1 & ~led3) | (~led0 & led1 & led3) | (led0 & ~led1) | (led0 & ~led3);
   assign e = (~led1 & ~led3) | (led0 & ~led1);
   assign f = (~led0 & ~led1) | (~led0 & led3) | (led2) | (~led1 & led3);
   assign g = (led2) | (~led0 & led3) | (led0 & ~led3) | (~led1 & led3);

endmodule

module control_button(
   input logic btn_in;
   ouput logic ad, bd, cd, dd, ed, fd, gd
);
endmodule
// Módulo del decodificador para 7 segmentos (decenas)
module decodificador_decenas (
   input logic btn_in,
   output logic ad, bd, cd, dd, ed, fd, gd
);

   // Cuando el botón está presionado, se muestra el número 1
   assign ad = btn_in ? 1'b0 : 1'b1;
   assign bd = btn_in ? 1'b1 : 1'b0;
   assign cd = btn_in ? 1'b1 : 1'b0;
   assign dd = btn_in ? 1'b0 : 1'b1;
   assign ed = btn_in ? 1'b0 : 1'b1;
   assign fd = btn_in ? 1'b0 : 1'b1;
   assign gd = btn_in ? 1'b0 : 1'b1;

endmodule




