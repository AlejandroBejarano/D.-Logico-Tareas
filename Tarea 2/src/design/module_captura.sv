module general (
    input logic clk;
    input logic rst;
);
endmodule 

//4.1

module capturador_de_teclas(
    input logic clk,
    input logic rst,
    input logic col_0, 
    input logic col_1, 
    input logic col_2, 
    input logic col_3,


    output logic [3:0]tecla_pre, 
    output logic suma,     
    output logic igual
);

    logic [3:0]fila_ent;
    logic clk_div;
    logic col_00;
    logic col_11;
    logic col_22;
    logic col_33;

    cont_anillo cont_ani_inst(
        .clk(clk),
        .rst(rst),
        .fila(fila_ent)
    );

    rebote rebote_ins0(
        .clk(clk),
        .boton(col_0),
        .boton_sal(col_00)
    );
        rebote rebote_ins1(
        .clk(clk),
        .boton(col_1),
        .boton_sal(col_11)
    );
        rebote rebote_ins2(
        .clk(clk),
        .boton(col_2),
        .boton_sal(col_22)
    );
        rebote rebote_ins3(
        .clk(clk),
        .boton(col_3),
        .boton_sal(col_33)
    );

    detector_columna detector_col_inst(
        .clk(clk),
        .rst(rst),
        .fila(fila_ent),
        .col_0(col_00),
        .col_1(col_11),
        .col_2(col_22),
        .col_3(col_33),
        .tecla_pre(tecla_pre),
        .suma(suma),
        .igual(igual)
    );

    divisor divisor_inst(
        .clk(clk),
        .clk_div(clk_div)
    );

endmodule

module cont_anillo(
    input logic clk,
    input logic rst,
    output logic [3:0]fila
);
logic [3:0]fila_encendida;

//Contador de anillo
    always_ff @(posedge clk or posedge rst)begin

        //Enciende la primera fila, para dar corriente.
        if (rst)begin
            fila_encendida <= 4'b0001;  
        end

        //Pasa a encender la siguiente fila cada nuevo ciclo del clock, se turna en activar las filas, para dar corriente.
        //Es un shifter, fila 1:0001 , fila 2: 0010 , fila 3: 0100, fila 4: 1000.
        else begin
            fila_encendida <= {fila_encendida[2:0], fila_encendida[3]};
        end
    end
    //Se le asigna la salida.
    assign fila = fila_encendida;
endmodule

module detector_columna (
    input logic clk,
    input logic rst,
    input logic [3:0]fila,  //entrada de contador de anillo;
    
    //entradas fisicas a FPGA
    input logic col_0, 
    input logic col_1, 
    input logic col_2, 
    input logic col_3, 

    output logic [3:0]tecla_pre,    //salida de teclas en bits
    output logic suma,         //salida de codigo de suma
    output logic igual        //salida de codigo de igual
);

    //se definen estados de la FSM
    typedef enum logic [4:0] { 
        F0, F1 , F2, F3, 
        F0C0, F0C1, F0C2, F0C3,
        F1C0, F1C1, F1C2, F1C3,
        F2C0, F2C1, F2C2, F2C3,
        F3C0, F3C1, F3C2, F3C3
    } estado;

    estado estado_act, estado_sig;
    logic [3:0] salida;


    //Para el estado actual
    always_ff @(posedge clk)begin
        if (rst)begin
            estado_act <= F0;
        end 
        else begin
            estado_act <= estado_sig;
        end
    end

    //Logica combinacional de la FSM, entre los estados
    always_comb begin
        estado_sig = estado_act; //Estado por defecto
        case(estado_act)

            //Primero verifica si la fila esta activa, si no pasa a la otra
            //Si esta activa, depende de cual col este activa, se da el siguiente estado
            F0: begin
                if(fila == 4'b0001) begin
                    if (col_0) estado_sig = F0C0; 
                    else if (col_1) estado_sig = F0C1;
                    else if (col_2) estado_sig = F0C2;
                    else if (col_3) estado_sig = F0C3;
                    else estado_sig = F1;
                end
                else begin 
                    estado_sig = F1;
                end
            end
            F1: begin
                if (fila == 4'b0010)begin
                    if (col_0) estado_sig = F1C0; 
                    else if (col_1) estado_sig = F1C1;
                    else if (col_2) estado_sig = F1C2;
                    else if (col_3) estado_sig = F1C3;
                    else estado_sig = F2;
                end
                else begin 
                    estado_sig = F2;
                end
            end
            F2: begin
                if(fila == 4'b0100) begin
                    if (col_0) estado_sig = F2C0;
                    else if (col_1) estado_sig = F2C1;
                    else if (col_2) estado_sig = F2C2;
                    else if (col_3) estado_sig = F2C3;
                    else estado_sig = F3;
                end
                else begin 
                    estado_sig = F3;
                end
            end
            F3: begin
                if (fila == 4'b1000)begin
                    if (col_0) estado_sig = F3C0;
                    else if (col_1) estado_sig = F3C1;
                    else if (col_2) estado_sig = F3C2;
                    else if (col_3) estado_sig = F3C3;
                    else estado_sig = F0;
                end
                else begin 
                    estado_sig = F0;
                end
            end
            default: estado_sig = F0;
        endcase     
    end 

    //Detectar estado y asignar codigo binario al estado para saber las teclas en binario
    always_ff @(posedge clk) begin 
        if (rst)begin 
            salida <= 4'b0000;
        end
        else begin
            case (estado_sig)
                F0C0: salida <= 4'b0000; //1
                F0C1: salida <= 4'b0001; //2
                F0C2: salida <= 4'b0010; //3
                F0C3: salida <= 4'b0011; //A
                F1C0: salida <= 4'b0100; //4
                F1C1: salida <= 4'b0101; //5
                F1C2: salida <= 4'b0110; //6
                F1C3: salida <= 4'b0111; //B
                F2C0: salida <= 4'b1000; //7
                F2C1: salida <= 4'b1001; //8
                F2C2: salida <= 4'b1010; //9
                F2C3: salida <= 4'b1011; //C
                F3C0: salida <= 4'b1100; //E
                F3C1: salida <= 4'b1101; //0
                F3C2: salida <= 4'b1110; //F
                F3C3: salida <= 4'b1111; //D
                default: salida <= 4'b0000;
            endcase
        end
    end
    
    //asigna la salida
    assign tecla_pre = salida;
    //se activa la suma
    assign suma= (tecla_pre == 4'b0011);
    //se activa el igual
    assign igual = (tecla_pre == 4'b0111);

endmodule


module divisor (
    input logic clk,
    output reg clk_div
);

    parameter frecuencia = 27000000; //27 Mhz
    parameter fre = 1000000; //1Mhz
    parameter max_cuenta = frecuencia / (2*fre); //13.5 ciclos aprox 

    reg [4:0]cuenta;

    initial begin 
        cuenta = 0;
        clk_div = 0;
    end

    always_ff @(posedge clk) begin 
        if (cuenta == max_cuenta) begin //la cantidad de ciclos en alto o bajo
            clk_div <= ~clk_div;
            cuenta <= 0;
        end
        else begin
            cuenta <= cuenta+1;

        end
    end

endmodule



module rebote(
    input logic clk,
    input logic boton,
    output logic boton_sal
); 
    logic clk_hab;
    //Salidas de FF D, Q2_com es el complemento.
    logic q1, q2, q2_com, q0;

    divisor clk_ha( clk, clk_hab);

    FF_D_habilitador ff1(clk, clk_hab, boton, q0);
    FF_D_habilitador ff2(clk, clk_hab, q0, q1);
    FF_D_habilitador ff3(clk, clk_hab, q1, q2);

    assign q2_com = ~q2;
    assign boton_sal = q1 & q2_com; //AND para salida
endmodule


//FF_D se actualiza cuando clk_hab esta en alto.
module FF_D_habilitador(
    input logic clk, 
    input logic clk_hab,
    input logic D, 
    output reg Q=0
);
    always_ff @ (posedge clk) begin
        if(clk_hab == 1) 
            Q <= D;
    end
endmodule 


//***************************************

module almacenamiento_datos (
    input logic clk,
    input logic rst,
    input logic [3:0] tecla_pre,   
    input logic cargar_numero1,    
    input logic cargar_numero2,    
    input logic reset_datos,       
    output logic [3:0] numero1[2:0],  
    output logic [3:0] numero2[2:0],
);

    logic [1:0] indice_numero1; 
    logic [1:0] indice_numero2; 

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            // Inicializa los valores
            indice_numero1 <= 0;
            indice_numero2 <= 0;
            numero1[0] <= 0;
            numero1[1] <= 0;
            numero1[2] <= 0;
            numero2[0] <= 0;
            numero2[1] <= 0;
            numero2[2] <= 0;
        end else begin
            if (reset_datos) begin
                // Reinicia los números
                numero1[0] <= 0;
                numero1[1] <= 0;
                numero1[2] <= 0;
                numero2[0] <= 0;
                numero2[1] <= 0;
                numero2[2] <= 0;
                indice_numero1 <= 0;
                indice_numero2 <= 0;
            end else begin
                if (cargar_numero1) begin
                    // Cargar el primer número
                    numero1[indice_numero1] <= tecla_pre;
                    indice_numero1 <= indice_numero1 + 1;
                end else if (cargar_numero2) begin
                    // Cargar el segundo número
                    numero2[indice_numero2] <= tecla_pre;
                    indice_numero2 <= indice_numero2 + 1;
                end
            end
        end
    end

endmodule


module maquina_estado (
    input logic clk,
    input logic rst,
    input logic a,   // Tecla para sumar
    input logic b,   // Tecla para igualar
    input logic c,   // Tecla para eliminar
    input logic [3:0] tecla_pre,
    output logic cargar_numero1,  
    output logic cargar_numero2,  
    output logic rst_datos,     
    output logic igual,           
    output logic clk_out
);

    // Definición de estados
    typedef enum logic [1:0] {S0, S1, S2} statetype;
    statetype state, nextstate;

    // Registro de estado
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S0;
        end else begin
            state <= nextstate;
        end
    end

    // Lógica de cambio de estado
    always_comb begin
        nextstate = state; 
        cargar_numero1 = 0;
        cargar_numero2 = 0;
        reset_datos = 0;
        igual = 0;

        case (state)
            S0: begin
                if (a) begin
                    cargar_numero1 = 1; 
                    nextstate = S1;
                end else if (c) begin
                    reset_datos = 1; 
                end
            end
            S1: begin
                if (a) begin
                    cargar_numero2 = 1; 
                    nextstate = S2;
                end else if (c) begin
                    reset_datos = 1; 
                    nextstate = S0;
                end
            end
            S2: begin
                igual = 1; // Señal de igual cuando se llega al estado S2
                if (c) begin
                    reset_datos = 1; // Reiniciar datos cuando se presiona 'c'
                    nextstate = S0;
                end
            end
        endcase
    end

endmodule

module binaria_segmentos(

   input logic [3:0] bin,
   output logic a, b, c, d, e, f, g
);

   assign a = ~((~bin[1] & ~bin[3]) | (bin[1] & bin[3]) | bin[2] | bin[0]);
   assign b = ~((~bin[0] & ~bin[1]) | (~bin[3]) | (bin[0] & bin[1]));
   assign c = ~(~bin[0] | bin[3] | bin[1]);
   assign d = ~((~bin[1] & ~bin[3]) | (~bin[0] & bin[1] & bin[3]) | (bin[0] & ~bin[1]) | (bin[0] & ~bin[3]));
   assign e = ~((~bin[1] & ~bin[3]) | (bin[0] & ~bin[1]));
   assign f = ~((~bin[0] & ~bin[1]) | (~bin[0] & bin[3]) | bin[2] | (~bin[1] & bin[3]));
   assign g = ~(bin[2] | (~bin[0] & bin[3]) | (bin[0] & ~bin[3]) | (~bin[1] & bin[3]));

endmodule


);

endmodule
/*
//Sincronizacion a 27 Mhz
    parameter int frecuencia = 27000000;
    parameter int freq_out = 10000;
    parameter int max_count = frecuencia / (2 * freq_out);

    logic [8:0] count;

    // Inicialización de variables
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            clk_out <= 0;
        end else begin
            if (count == max_count) begin
                clk_out <= ~clk_out;
                count <= 0;
            end else begin
                count <= count + 1;
            end
        end
    end

*/



/*Ocupamos:
Modulo #1
1. El escaneo de filas
2. Detección de columna, ya con esto se saca que tecla se preciosa
3. Eliminar el rebote mecánico 
Modulo #2
4. Luego sincronizarlo a 27MHz
5. La maquina de estado
Modulo #3
6. Conversión del número a binario para la suma y los 7-segmentos
*/
