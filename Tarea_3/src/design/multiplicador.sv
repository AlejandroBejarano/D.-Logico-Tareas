//Contador de anillo filas
//******************************
//******************************
module anillo_ctdr #(parameter WIDTH = 4) //Se define el tamano del contador 4.
(
    input clk,
    input rst,
    output reg [WIDTH-1:0] fila
);

always_ff @(posedge clk) begin
    if (!rst)
        fila <=1; //Se inicializa encendiendo el primer bit.
    else begin
        fila[WIDTH-1] <= fila[0];
        for (int i = 0; i < WIDTH-1; i=i+1 ) begin  //Es un shifter
            fila[i] <= fila[i+1];
        end
    end
end
endmodule


//Detector de teclas con FSM.
//*************************************
//*************************************
module detector_columna (
    input logic clk,
    input logic rst,
    input logic [3:0]fila,  //entrada de contador de anillo;
    
    //entradas fisicas a FPGA
    input logic col_0, 
    input logic col_1, 
    input logic col_2, 
    input logic col_3, 

    output logic [3:0]tecla_pre,    //salida de teclas en bits.
    output logic menos,             //salida de codigo de signo menos.
    output logic multiplicador,       //salida de multiplicador. 
    output logic igual              //salida de codigo de igual.
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
    always_ff @(posedge clk or posedge rst)begin
        if (rst)begin
            estado_act <= F0; //estado de espera
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
    always_ff @(posedge clk or posedge rst) begin 
        if (rst)begin 
            salida <= 4'b0000;
        end
        else begin
            case (estado_act)
                F0C0: salida <= 4'b0000; //1
                F0C1: salida <= 4'b0001; //2
                F0C2: salida <= 4'b0010; //3
                F0C3: salida <= 4'b0011; //A  (menos)
                F1C0: salida <= 4'b0100; //4
                F1C1: salida <= 4'b0101; //5
                F1C2: salida <= 4'b0110; //6
                F1C3: salida <= 4'b0111; //B  (multiplicador)
                F2C0: salida <= 4'b1000; //7
                F2C1: salida <= 4'b1001; //8
                F2C2: salida <= 4'b1010; //9
                F2C3: salida <= 4'b1011; //C  (igual)
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
    //se activa el menos

    always_comb begin
        menos = (salida == 4'b0011);
        multiplicador = (salida == 4'b0111);
        igual = (salida == 4'b1011);
    end

endmodule



// divisor de clk
//*******************************
//*******************************
module divisor (
    input logic clk,
    output reg clk_div
);

    parameter frecuencia = 27000000; //27 Mhz
    parameter fre = 1000000; //10hz
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


// Rebote mecanico
//****************************
//****************************
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


//Almacenamiento
//**********************************
//**********************************
module almacenamiento(
    input logic clk,
    input logic rst,
    input logic almac,
    input logic [3:0] num1_dec1,   // Primer número de 4 bits para numero1
    input logic [3:0] num1_dec2,   // Segundo número de 4 bits para numero1
    input logic [3:0] num2_dec1,   // Primer número de 4 bits para numero2
    input logic [3:0] num2_dec2,   // Segundo número de 4 bits para numero2
    output logic [11:0] num_result1,  // Resultado de la concatenación de num1
    output logic [11:0] num_result2   // Resultado de la concatenación de num2
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            num_result1 <= 12'b0;
            num_result2 <= 12'b0;
        end else if (almac) begin
            // Concatenar los números de 4 bits y almacenarlos
            num_result1 <= {num1_dec1, num1_dec2}; // Concatenación de num1_dec1 y num1_dec2
            num_result2 <= {num2_dec1, num2_dec2}; // Concatenación de num2_dec1 y num2_dec2
        end
    end

endmodule


//Separador de numeros
//*****************************************
//*****************************************
module separar_num (
    input logic [13:0] num,
    output logic [3:0] uni, dec, cen, mill
);

logic [3:0] bcd_uni, bcd_dec, bcd_cen, bcd_mill;
integer i;

always_comb begin
    // Inicializar todas las variables a 0
    bcd_uni = 0;
    bcd_dec = 0;
    bcd_cen = 0;
    bcd_mill = 0;

    for (i = 13; i >= 0; i = i - 1) begin
        // Revisar y ajustar cada grupo de 4 bits antes de desplazar
        if (bcd_uni >= 5) bcd_uni = bcd_uni + 3;
        if (bcd_dec >= 5) bcd_dec = bcd_dec + 3;
        if (bcd_cen >= 5) bcd_cen = bcd_cen + 3;
        if (bcd_mill >= 5) bcd_mill = bcd_mill + 3;

        // Desplazamiento manualmente de los bits
        bcd_mill = {bcd_mill[2:0], bcd_cen[3]};
        bcd_cen = {bcd_cen[2:0], bcd_dec[3]};
        bcd_dec = {bcd_dec[2:0], bcd_uni[3]};
        bcd_uni = {bcd_uni[2:0], num[i]};
    end
end
assign uni = bcd_uni;
assign dec = bcd_dec;
assign cen = bcd_cen;
assign mill = bcd_mill;

endmodule


//Idea 7-seg
//**************************************
//**************************************
`timescale 1ns / 1ps
module display (
    input logic clk,
    output logic [6:0] Seg,
    output logic [3:0] anodes,
    input logic [15:0] result
);

    logic [6:0] number;
    logic [3:0] state = 4'b0000; // Inicialización del estado
    logic [15:0] data;
    logic [3:0] dig;
    logic slow_clock = 0;
    integer count = 0;

    assign data = result;

    // Generador de reloj lento
    always_ff @(posedge clk) begin
        if (count > 2) begin// cambiar count > 100000 al probar la fpga
            count <= 0;
            slow_clock <= ~slow_clock;
        end else begin
            count <= count + 1;
        end
    end

    // Control de anodos y segmentos
    always_ff @(posedge slow_clock) begin
        case (state)
            4'b0000: begin
                anodes = 4'b1110;
                state = 4'b0001;
                dig = data[3:0];
            end
            4'b0001: begin
                anodes = 4'b1101;
                state = 4'b0010;
                dig = data[7:4];
            end
            4'b0010: begin
                anodes = 4'b1011;
                state = 4'b0011;
                dig = data[11:8];
            end
            4'b0011: begin
                anodes = 4'b0111;
                state = 4'b0000;
                dig = data[15:12];
            end
        endcase

        case (dig)
            4'b0000: number = 7'b1000000; // 0
            4'b0001: number = 7'b1111001; // 1
            4'b0010: number = 7'b0100100; // 2
            4'b0011: number = 7'b0110000; // 3
            4'b0100: number = 7'b0011001; // 4
            4'b0101: number = 7'b0010010; // 5
            4'b0110: number = 7'b0000010; // 6
            4'b0111: number = 7'b1111000; // 7
            4'b1000: number = 7'b0000000; // 8
            4'b1001: number = 7'b0011000; // 9
            4'b1010: number = 7'b0001000; // A
            4'b1011: number = 7'b0000011; // B
            4'b1100: number = 7'b1000110; // C
            4'b1101: number = 7'b0100001; // D
            4'b1110: number = 7'b0000110; // E
            4'b1111: number = 7'b0001110; // F
            default: number = 7'b0000000; // Apagado
        endcase
    end

    assign Seg = number;

endmodule


// Modulo de multiplicador
//*************************
//*************************
module multiplicador(
    input  logic [7:0] A, // Primer número de dos dígitos
    input  logic [7:0] B, // Segundo número de dos dígitos
    input  logic clk,     // Señal de reloj
    input  logic start,   // Señal para comenzar la multiplicación
    output logic [15:0] resultado, // Resultado de la multiplicación
    output logic done    // Indica cuando la multiplicación ha terminado
);
    logic [15:0] acumulador;
    logic [7:0] contador;
    logic [7:0] multiplicando;
    logic [7:0] multiplicador;
    logic busy;

    always_ff @(posedge clk) begin
        if (start) begin
            // Inicializamos los valores
            acumulador <= 16'd0;
            multiplicando <= A;
            multiplicador <= B;
            contador <= 8'd0;
            busy <= 1;
            done <= 0;
        end else if (busy) begin
            if (contador < multiplicador) begin
                acumulador <= acumulador + multiplicando;
                contador <= contador + 1;
            end else begin
                resultado <= acumulador;
                done <= 1;
                busy <= 0;
            end
        end
    end

endmodule


//Modulo del BCD
//****************************************
//****************************************
//Para dividir los numeros esteros
module codificador_bcd (
    input  logic        clk,          // Reloj de entrada
    input  logic [15:0] binary_in,    // Entrada binaria de 16 bits
    output logic [15:0] bcd_out       // Salida BCD de 16 bits
);
    // Variables internas
    logic [31:0] shift_reg;  // Registro de desplazamiento (16 bits BCD + 16 bits binarios)
    int state;               // Estado del contador para controlar las iteraciones

    always_ff @(posedge clk) begin
        if (state == 0) begin
            // Inicializar el registro de desplazamiento y contador
            shift_reg = {16'b0, binary_in};  // Concatenar 16 bits de ceros y la entrada binaria
            state = 1;  // Ir al primer estado
        end else if (state <= 16) begin
            // Algoritmo "Double Dabble" paso a paso
            for (int j = 0; j < 4; j++) begin
                if (shift_reg[19 + 4*j -: 4] >= 5) begin
                    shift_reg[19 + 4*j -: 4] += 3;
                end
            end
            shift_reg = shift_reg << 1;  // Desplazar a la izquierda
            state = state + 1;           // Incrementar estado
        end else begin
            // Asignar la salida BCD cuando el proceso termine
            bcd_out = shift_reg[31:16];
            state = 0;  // Reiniciar el estado para la próxima operación
        end
    end
endmodule

