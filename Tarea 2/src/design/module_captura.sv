


//eliminar suma y igual capturardor, teclas_pre 1,2,3
//aumentar vector de numeros en almacenamiento [15:0], asignar ubicacion a numeros
// Nuevo modulo union de 3 numeros en 1
//display logica de tarea 1, a FSM, con clk a 27, con transistores por turno con el clock
//

//ideas
//capturador saca 3 numeros de 4 bits
//nuevo modulo 


module general (
    input logic clk,
    input logic rst
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
    always_ff @(posedge clk)begin

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
    output logic [11:0] numero1,  
    output logic [11:0] numero2
);

    logic [1:0] indice_numero1; 
    logic [1:0] indice_numero2; 

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            // Inicializa los valores
            indice_numero1 <= 0;
            indice_numero2 <= 0;
            numero1 <= 12'b0;
            numero2 <= 12'b0;
        end else begin
            if (reset_datos) begin
                numero1 <= 12'b0;
                numero2 <= 12'b0;
                indice_numero1 <= 0;
                indice_numero2 <= 0;
            end else begin
                if (cargar_numero1) begin
                    case (indice_numero1)
                        2'b00: numero1[3:0]   <= tecla_pre;
                        2'b01: numero1[7:4]   <= tecla_pre;
                        2'b10: numero1[11:8]  <= tecla_pre;
                        default: ; // Agregar un caso por defecto para manejar índices no válidos
                    endcase
                    // Incrementar índice y reiniciar si es necesario
                    if (indice_numero1 < 2'b10) begin
                        indice_numero1 <= indice_numero1 + 1;
                    end else begin
                        indice_numero1 <= 0; // Reinicia si se supera el límite
                    end
                end else if (cargar_numero2) begin
                    case (indice_numero2)
                        2'b00: numero2[3:0]   <= tecla_pre;
                        2'b01: numero2[7:4]   <= tecla_pre;
                        2'b10: numero2[11:8]  <= tecla_pre;
                        default: ; // Agregar un caso por defecto para manejar índices no válidos
                    endcase
                    // Incrementar índice y reiniciar si es necesario
                    if (indice_numero2 < 2'b10) begin
                        indice_numero2 <= indice_numero2 + 1;
                    end else begin
                        indice_numero2 <= 0; // Reinicia si se supera el límite
                    end
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

//  Module para los 4 display con los dos numeros de 3 digitos
module display(
   input logic rst,
   input logic clk,
   input logic a,
   input logic b,
   input logic [11:0] numero1,  
   input logic [11:0] numero2,  
   output logic [3:0] an,
   output logic [6:0] seg
);

    // Declaración de constantes
    localparam N = 18; 

    // Declaraciones de señales internas
    logic [N-1:0] q_reg;
    logic [N-1:0] q_next;
    logic [3:0] numero1_in;
    logic [3:0] numero2_in;


    always_ff @(posedge clk or posedge rst) begin 
        if (rst)
            q_reg <= 0;
        else 
            q_reg <= q_next;
    end 

    assign q_next = q_reg + 1;


    // Inicio del contador y selección del dígito
    always_comb begin 
        if (state == cargar_numero1) begin 
            case (q_reg[N-1:N-2])
                2'b00: begin 
                    an = 4'b1110;
                    numero1_in = numero1[3:0];    // Parte baja del vector numero1
                end 
                2'b01: begin
                    an = 4'b1101;
                    numero1_in = numero1[7:4];    // Parte media del vector numero1
                end 
                2'b10: begin 
                    an = 4'b1011;
                    numero1_in = numero1[11:8];   // Parte alta del vector numero1
                end 
                default: begin 
                    an = 4'b0111;  // No se usa el último display
                    numero1_in = 4'b0000;  // Vacío
                end 
            endcase 
        end else if (state == cargar_numero2) begin
            case (q_reg[N-1:N-2])
                2'b00: begin 
                    an = 4'b1110;
                    numero2_in = numero2[3:0];    // Parte baja del vector numero2
                end 
                2'b01: begin
                    an = 4'b1101;
                    numero2_in = numero2[7:4];    // Parte media del vector numero2
                end 
                2'b10: begin 
                    an = 4'b1011;
                    numero2_in = numero2[11:8];   // Parte alta del vector numero2
                end 
                default: begin 
                    an = 4'b1111;  // No se usa este display
                    numero2_in = 4'b0000;  // Vacío
                end 
            endcase      
        end
    end 


    always_comb begin
        logic [3:0] numero_actual_in;
        if (rst) begin 
            numero_actual_in = 4'h0;
        end else begin
            // Selecciona entre numero1 y numero2
            if (state == cargar_numero1) begin 
                numero_actual_in = numero1_in;
            end
        end 
    end 
endmodule 



module SumaAri (
    input logic clk,           // Señal de reloj
    input logic rst,         // Señal de reset activa baja
    input logic [11:0] num1,   // Primer número de entrada (3 dígitos decimales)
    input logic [11:0] num2,   // Segundo número de entrada (3 dígitos decimales)
    output logic [13:0] sum    // Resultado de la suma (máximo 4 dígitos decimales)
);

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            sum <= 14'd0; // Resetear el resultado de la suma
        end else begin
            sum <= num1 + num2; // Realizar la suma aritmética
        end
    end

endmodule





 
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
