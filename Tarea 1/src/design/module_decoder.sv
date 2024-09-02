
// Modulo de conexion

module principal (
   input logic [3:0] Gray,
   input logic [3:0] bin,
   input logic btn_in, 
   output logic [3:0] Led,
   output logic pin_uni,
   output logic pin_dec,
   output logic a, b, c, d, e, f, g,  // Salidas para el 7 segmentos uniades
   output logic bd, cd  // Salidas para el 7 segmentos de decenas
);

logic [3:0] bin_todos;

// Instancia
gray_to_binary g_to_b_inst (
   .Gray(Gray),
   .bin(bin_todos)
);

// Instancia
binary_leds b_to_l_inst (
   .bin(bin_todos),
   .Led(Led)
);

assign pin_uni = btn_in ? 1'b0 : 1'b1;
assign pin_dec = btn_in ? 1'b1 : 1'b0;


decodificador_siete decodificador_unidades_inst (
   .bin(bin_todos),
   .a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g)
);

// Control para mostrar el número 1 en las decenas cuando el botón esté presionado
decodificador_decenas decodificador_decenas_inst (
   .btn_in(btn_in),   
   .bd(bd), .cd(cd)
);

endmodule


//4.1

 module gray_to_binary (
    input logic [3:0] Gray,
    output logic [3:0] bin   
 );

   logic b3, b2, b1, b0;

   assign b3 = Gray[3];
   assign b2 = b3 ^ Gray[2];
   assign b1 = b2 ^ Gray[1];
   assign b0 = b1 ^ Gray[0];

   assign bin = {b3,b2,b1,b0};

 endmodule

//4.2


module binary_leds (
    input logic [3:0]bin,
    output logic [3:0] Led
 );

   assign bin[3] = Led[3];
   assign bin[2] = Led[2];
   assign bin[1] = Led[1];
   assign bin[0] = Led[0];

 endmodule


//4.3

// Módulo del decodificador para 7 segmentos (unidades)
module decodificador_siete (
   input logic [3:0] bin,
   output logic a, b, c, d, e, f, g
);

   assign a = (~bin[1] & ~bin[3]) | (bin[1] & bin[3]) | bin[2] | bin[0];
   assign b = (~bin[0] & ~bin[1]) | (~bin[3]) | (bin[0] & bin[1]);
   assign c = (~bin[0]) | (bin[3]) | (bin[1]);
   assign d = (~bin[1] & ~bin[3]) | (~bin[0] & bin[1] & bin[3]) | (bin[0] & ~bin[1]) | (bin[0] & ~bin[3]);
   assign e = (~bin[1] & ~bin[3]) | (bin[0] & ~bin[1]);
   assign f = (~bin[0] & ~bin[1]) | (~bin[0] & bin[3]) | bin[2] | (~bin[1] & bin[3]);
   assign g = bin[2] | (~bin[0] & bin[3]) | (bin[0] & ~bin[3]) | (~bin[1] & bin[3]);

endmodule

// Módulo del decodificador para 7 segmentos (decenas)
module decodificador_decenas (
   input logic btn_in,
   output logic bd, cd
);

   // Cuando el botón está presionado, se muestra el número 1
   assign bd = btn_in ? 1'b1 : 1'b0;
   assign cd = btn_in ? 1'b1 : 1'b0;


endmodule

