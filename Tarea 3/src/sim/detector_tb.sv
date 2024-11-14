`timescale 1ns/1ps

module detector_tb;

    // Declaración de señales
    logic clk;
    logic rst;
    logic [3:0] fila;
    logic col_0, col_1, col_2, col_3;
    logic [3:0] tecla_pre;
    logic menos;
    logic multiplicador;
    logic igual;

    // Instancia del módulo a probar
    detector_columna detector_columna_tb(
        .clk(clk),
        .rst(rst),
        .fila(fila),
        .col_0(col_0),
        .col_1(col_1),
        .col_2(col_2),
        .col_3(col_3),
        .tecla_pre(tecla_pre),
        .menos(menos),
        .multiplicador(multiplicador),
        .igual(igual)
    );

    // Generación del reloj
    always #500 clk = ~clk; // Reloj de (27 MHz)

    initial begin
        logic [3:0] num;

        $display ("Tecla Pre (bin)   |   Tecla_pre   |");
        $monitor ("      %b          |      %b       |", num, tecla_pre);

        // Inicialización
        clk = 0;
        rst = 1; // Activar reset
        fila = 4'b0000;
        col_0 = 0; col_1 = 0; col_2 = 0; col_3 = 0;
        #10 rst = 0; // Desactivar reset

        //F0
        //1
        fila = 4'b0001; col_0 = 1; col_1 = 0; col_2 = 0; col_3 = 0; num = 4'b0; #5000; 
        if (tecla_pre == 4'b0000) $display("tecla 1 = 0000 precionada correctamente");
        $display("tecla_pre (bin): %b", tecla_pre);

        //2
        #100;
        fila = 4'b0001; col_0 = 0; col_1 = 1;num = 4'b0001; #5100;
        if (tecla_pre == 4'b0001) $display("tecla 2 = 0001 precionada correctamente");
        $display("tecla_pre (bin): %b", tecla_pre);

        //3
        #1000;
        fila = 4'b0001; col_1 = 0; col_2 = 1;num = 4'b0010; #5100;
        if (tecla_pre == 4'b0010) $display("tecla 3 = 0010 precionada correctamente");
        $display("tecla_pre (bin): %b", tecla_pre);

        //A
        #1000;
        fila = 4'b0001; col_2 = 0; col_3 = 1;num = 4'b0011; #5000;
        if (tecla_pre == 4'b0011) $display("tecla A = 0011  precionada correctamente");
        $display("tecla_pre (bin): %b", tecla_pre);
        

        //F1
        //4
        #1000;
        fila = 4'b0010; col_0 = 1; col_1 = 0; col_2 = 0; col_3 = 0;num = 4'b0100; #5000;
        if (tecla_pre == 4'b0100) $display("tecla 4 = 0100 precionada correctamente");
        $display("tecla_pre (bin): %b", tecla_pre);

        //5
        #1000;
        fila = 4'b0010; col_0 = 0; col_1 = 1;num = 4'b0101; #5000;
        if (tecla_pre == 4'b0101) $display("tecla 5 = 0101 precionada correctamente");
        $display("tecla_pre (bin): %b", tecla_pre);

        //6
        #1000;
        fila = 4'b0010; col_1 = 0; col_2 = 1;num = 4'b0110; #5000;
        if (tecla_pre == 4'b0110) $display("tecla 6 = 0110 precionada correctamente");
        $display("tecla_pre (bin): %b", tecla_pre);

        //B
        #1000;
        fila = 4'b0010; col_2 = 0; col_3 = 1;num = 4'b0111; #5000;
        if (tecla_pre == 4'b0111) $display("tecla B = 0111 precionada correctamente");
        $display("tecla_pre (bin): %b", tecla_pre);


        //F2
        //7
        #10;
        fila = 4'b0100; col_0 = 1; col_1 = 0; col_2 = 0; col_3 = 0;num = 4'b1000; #8000;
        if (tecla_pre == 4'b1000) $display("tecla 7 = 1000 precionada correctamente");
        $display("tecla_pre (bin): %b", tecla_pre);

        //8
        #50;
        fila = 4'b0100; col_0 = 0; col_1 = 1;num = 4'b1001; #4000;
        if (tecla_pre == 4'b1001) $display("tecla 8 = 1001 precionada correctamente");
        $display("tecla_pre (bin): %b", tecla_pre);

        //9
        #50;
        fila = 4'b0100; col_1 = 0; col_2 = 1;num = 4'b1010;  #8000;
        if (tecla_pre == 4'b1010) $display("tecla 9 = 1010 precionada correctamente");
        $display("tecla_pre (bin): %b", tecla_pre);

        //C
        #50;
        fila = 4'b0100; col_2 = 0; col_3 = 1;num = 4'b1011; #8000;
        if (tecla_pre == 4'b1011) $display("tecla C = 1011 precionada correctamente");
        $display("tecla_pre (bin): %b", tecla_pre);


        //F3
        //E
        #100;
        fila = 4'b1000; col_0 = 1; col_1 = 0; col_2 = 0; col_3 = 0;num = 4'b1100; #5000;
        if (tecla_pre == 4'b1100) $display("tecla E = 1100 precionada correctamente");
        $display("tecla_pre (bin): %b", tecla_pre);

        //0
        #4.9;
        fila = 4'b1000; col_0 = 0; col_1 = 1;num = 4'b1101;  #5000;
        if (tecla_pre == 4'b1101) $display("tecla 0 = 1101 precionada correctamente");
        $display("tecla_pre (bin): %b", tecla_pre);

        //F
        #4.9;
        fila = 4'b1000; col_1 = 0; col_2 = 1;num = 4'b1110; #5000;
        if (tecla_pre == 4'b1110) $display("tecla F = 1110 precionada correctamente");
        $display("tecla_pre (bin): %b", tecla_pre);

        //D
        #4;
        fila = 4'b1000; col_2 = 0; col_3 = 1;num = 4'b1111; #5000;
        if (tecla_pre == 4'b1111) $display("tecla D = 1111 precionada correctamente");
        $display("tecla_pre (bin): %b", tecla_pre);
        
        $finish;
    end


    initial begin // Para el diagrama de tiempos
        $dumpfile("module_detector_tb.vcd");
        $dumpvars(0, detector_tb); // Nombre correcto del testbench
    end

endmodule

