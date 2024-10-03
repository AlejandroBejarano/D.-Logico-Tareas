`timescale 1ns/1ps

module display_tb;

    // Señales de entrada
    logic rst;
    logic clk;
    logic a;
    logic b;
    logic [3:0] numero1_hex0;
    logic [3:0] numero1_hex1;
    logic [3:0] numero1_hex2;
    logic [3:0] numero1_hex3;
    logic [3:0] numero2_hex0;
    logic [3:0] numero2_hex1;
    logic [3:0] numero2_hex2;
    logic [3:0] numero2_hex3;

    // Señales de salida
    logic [3:0] an;
    logic [6:0] seg;

    // Instancia del módulo display
    display uut (
        .rst(rst),
        .clk(clk),
        .a(a),
        .b(b),
        .numero1_hex0(numero1_hex0),
        .numero1_hex1(numero1_hex1),
        .numero1_hex2(numero1_hex2),
        .numero1_hex3(numero1_hex3),
        .numero2_hex0(numero2_hex0),
        .numero2_hex1(numero2_hex1),
        .numero2_hex2(numero2_hex2),
        .numero2_hex3(numero2_hex3),
        .an(an),
        .seg(seg)
    );

    // Generación del reloj
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // Periodo de 20ns
    end

    // Secuencia de prueba
    initial begin
        // Inicialización
        rst = 1;
        a = 0;
        b = 0;
        numero1_hex0 = 4'h0;
        numero1_hex1 = 4'h0;
        numero1_hex2 = 4'h0;
        numero1_hex3 = 4'h0;
        numero2_hex0 = 4'h0;
        numero2_hex1 = 4'h0;
        numero2_hex2 = 4'h0;
        numero2_hex3 = 4'h0;

        #30 rst = 0;

        // Cargar el primer número en numero1
        #20 numero1_hex0 = 4'h5;  // 5
        numero1_hex1 = 4'h3;      // 3
        numero1_hex2 = 4'h9;      // 9
        numero1_hex3 = 4'h0;      // No se utilizao

        // Selecciona número1 para mostrar
        #20 a = 1;
        #20 a = 0;

        // Cargar el segundo número en numero2
        #40 numero2_hex0 = 4'h1;  // 1
        numero2_hex1 = 4'h6;      // 6
        numero2_hex2 = 4'h7;      // 7
        numero2_hex3 = 4'h0;      // No utilizado

        #20 b = 1;
        #20 b = 0;

        #40 rst = 1;
        #20 rst = 0;


        #100 
        $finish;
    end

  
    initial begin
        $monitor("Time=%0t | an=%b | seg=%b | numero1=%h%h%h | numero2=%h%h%h",
            $time, an, seg, numero1_hex2, numero1_hex1, numero1_hex0,
            numero2_hex2, numero2_hex1, numero2_hex0);
    end


    initial begin
        $dumpfile("display_tb.vcd");
        $dumpvars(0, display_tb);
    end

endmodule
