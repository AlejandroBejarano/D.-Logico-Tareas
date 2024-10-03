`timescale 1ns/1ps

module almacenamiento_tb;

//Declaracion de señales
    logic clk;
    logic rst;
    logic [3:0] tecla_pre;
    logic cargar_numero1;
    logic cargar_numero2;
    logic reset_datos;
    logic [3:0] numero1 [2:0];
    logic [3:0] numero2 [2:0];
    logic [1:0] indice_numero1;
    logic [1:0] indice_numero2;

//Instancia del modulo a probar
    almacenamiento_datos almacenamiento_datos_tb(
        .clk(clk),
        .rst(rst),
        .tecla_pre(tecla_pre),
        .cargar_numero1(cargar_numero1),
        .cargar_numero2(cargar_numero2),
        .reset_datos(reset_datos),
        .numero1(numero1),
        .numero2(numero2),
    );

    initial begin 
        clk = 0;
        forever #5 clk = ~clk;
    end 

    initial begin 
        rst = 1;
        tecla_pre = 0;
        cargar_numero1 = 0;
        cargar_numero2 = 0;
        reset_datos = 0;

        //Desactiva el reset
        #15 rst = 0;

        // Se cargan los nuevos datos en el numero1
        #10 tecla_pre = 4'b0101; // 5, numero 1
        cargar_numero1 = 1;
        #10 cargar_numero1 = 0;

        #10 tecla_pre = 4'b0011; // 2, numero 2
        cargar_numero1 = 1;
        #10 cargar_numero1 = 0;

        #10 tecla_pre = 4'b0110; //6, numero 3
        cargar_numero1 = 1;
        #10 cargar_numero1 = 0;

        // Se cragan los nuevos datso en el numero 2
        #10 tecla_pre = 4'b1001; //9, numero 1
        cargar_numero2 = 1;
        #10 cargar_numero2 = 0;

        #10 tecla_pre = 4'b0001; //1, numero 2
        cargar_numero2 = 1;
        #10 cargar_numero2 = 0;
        
        #10 tecla_pre = 4'b1000; //7, numero 3
        cargar_numero2 = 1;
        #10 cargar_numero2 = 0;

        #20 reset_datos = 1;
        #10 reset_datos = 0;

        #100 
        $finish
    end 
    initial begin 
        %monitor ("Time=%0t | numero1=%b%b%b | numero2=%b%b%b", $time, numero1[2], numero1[1], numero1[0], numero2[2], numero2[1], numero2[0]);
    end 

    initial begin // Para el diagrama de tiempos
        $dumpfile("almacenamiento_tb.vcd");
        $dumpvars(0, almacenamiento_tb); // Nombre correcto del testbench
    end

endmodule;
    