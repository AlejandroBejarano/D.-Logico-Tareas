//Module de conexion 

module principal (

   input logic [3:0] GrayCode,
   input logic btn_in,       
   
   output logic led3, led2, led1, led0,
   output logic a, b, c, d, e, f, g,  // Salidas para el 7 segmentos uniades
   output logic ad, bd, cd, dd, ed, fd, gd  // Salidas para el 7 segmentos de decenas
);

logic [3:0] bit;

// Instancia
gray_to_binary g_to_b_inst (
   .Gray(GrayCode),
   .bin(bit)
);

// Instancia
binary_leds b_to_l_inst (
   .bin(bit),
   .Led({led3, led2, led1, led0})
);


decodificador_siete decodificador_unidades_inst (
   .led0(led0),
   .led1(led1),
   .led2(led2),
   .led3(led3),
   .a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g)
);

// Control para mostrar el número 1 en las decenas cuando el botón esté presionado
decodificador_decenas decodificador_decenas_inst (
   .btn_in(btn_in),   
   .ad(ad), .bd(bd), .cd(cd), .dd(dd), .ed(ed), .fd(fd), .gd(gd)
);

endmodule

//4.1
// Módulo para convertir código Gray a binario
module gray_to_binary (
   input logic [3:0] Gray,
   output logic [3:0] bin
);

   logic b3, b2, b1, b0;

   assign b3 = Gray[3];
   assign b2 = b3 ^ Gray[2];
   assign b1 = b2 ^ Gray[1];
   assign b0 = b1 ^ Gray[0];

   assign bin = {b3, b2, b1, b0};

endmodule

//4.2
//Con una instancia toma los valores de los bits para los Leds.
module binary_leds (
   input logic [3:0] bin,
   output logic [3:0] Led
);

   assign Led = bin;

endmodule

//4.3

// Módulo del decodificador para 7 segmentos (unidades)
module decodificador_siete (
   input logic led0, led1, led2, led3,
   output logic a, b, c, d, e, f, g
);

   assign a = (~led1 & ~led3) | (led1 & led3) | led2 | led0;
   assign b = (~led0 & ~led1) | (~led3) | (led0 & led1);
   assign c = (~led0) | (led3) | (led1);
   assign d = (~led1 & ~led3) | (~led0 & led1 & led3) | (led0 & ~led1) | (led0 & ~led3);
   assign e = (~led1 & ~led3) | (led0 & ~led1);
   assign f = (~led0 & ~led1) | (~led0 & led3) | led2 | (~led1 & led3);
   assign g = led2 | (~led0 & led3) | (led0 & ~led3) | (~led1 & led3);

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
