


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




// Almacenamiento indi. de numeros (dec, uni)
//**********************************
//**********************************






//Modulo de concatenacion de numeros
//***********************************
//***********************************

module concatenar_num(
    input logic [3:0] dec,
    input logic [3:0] uni,
    output logic [6:0] num
);
always_comb begin
    num = (dec * 4'b1010) + uni; //Se multplica el numero de las dec por 10.
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



// 7 seg
//***********************************
//***********************************

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


//Idea 7-seg
//**************************************
//**************************************


module display (
    input logic clk,
    input logic rst,
    input logic [3:0] num1, //uni
    input logic [3:0] num2, //dec
    input logic [13:0] num, //mul
    
    output logic a,b,c,d,e,f,g,
    output logic [3:0] Transis
);

    logic [3:0] millm;
    logic [3:0] cenm;
    logic [3:0] decm;
    logic [3:0] unim;
    logic [3:0] uni;
    logic [3:0] dec;

    logic aa, bb, cc, dd, ee, ff, gg;
    logic aaa, bbb, ccc, ddd, eee, fff, ggg;
    logic aaaa, bbbb, cccc, dddd, eeee, ffff, gggg;
    logic aaaaa, bbbbb, ccccc, ddddd, eeeee, fffff, ggggg;
    logic aaaaaa, bbbbbb, cccccc, dddddd, eeeeee, ffffff, gggggg;
    logic aaaaaaa, bbbbbbb, ccccccc, ddddddd, eeeeeee, fffffff, ggggggg;

    separar_num inst_sep(
        .num(num),
        .uni(unim),
        .dec(decm),
        .cen(cenm),
        .mill(millm)
    );

    anillo_ctdr cont_Tran_mul(
        .clk(clk),
        .rst(rst),
        .fila(Transis)
    );

    decodificador_siete deco_tra1_mul (
        .bin(unim),
        .a(aa),
        .b(bb),
        .c(cc),
        .d(dd),
        .e(ee),
        .f(ff),
        .g(gg)
    );
    
    decodificador_siete deco_tra2_mul (
        .bin(decm),
        .a(aaa),
        .b(bbb),
        .c(ccc),
        .d(ddd),
        .e(eee),
        .f(fff),
        .g(ggg)
    );
    
    decodificador_siete deco_tra3_mul (
        .bin(cenm),
        .a(aaaa),
        .b(bbbb),
        .c(cccc),
        .d(dddd),
        .e(eeee),
        .f(ffff),
        .g(gggg)
    );

    decodificador_siete deco_tra4_mul (
        .bin(millm),
        .a(aaaaa),
        .b(bbbbb),
        .c(ccccc),
        .d(ddddd),
        .e(eeeee),
        .f(fffff),
        .g(ggggg)
    );
    
    decodificador_siete deco_num1 (
        .bin(num1),
        .a(aaaaaa),
        .b(bbbbbb),
        .c(cccccc),
        .d(dddddd),
        .e(eeeeee),
        .f(ffffff),
        .g(gggggg)
    );
    
    decodificador_siete deco_num2(
        .bin(num2),
        .a(aaaaaaa),
        .b(bbbbbbb),
        .c(ccccccc),
        .d(ddddddd),
        .e(eeeeeee),
        .f(fffffff),
        .g(ggggggg)
    );




    //se definen estados de la FSM
    typedef enum logic [2:0] { 
        E0, E1 , E2, Euni, Edec
    } estado;

    estado estado_act, estado_sig;
    logic [3:0] salida;


    //Para el estado actual
    always_ff @(posedge clk or posedge rst)begin
        if (rst)begin
            estado_act <= E0; //estado de espera
        end 
        else begin
            estado_act <= estado_sig;
        end
    end

    always_comb begin
        estado_sig = estado_act; //Estado por defecto
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        e = 0;
        f = 0;
        g = 0;
        case(estado_act)
            E0: begin
                if(num == 4'b0) begin
                    estado_sig = E1;
                end

                else if (num != 4'b0) estado_sig = E2;
                else begin 
                    estado_sig = E0;
                end
            end
            E1: begin
                if (num == 4'b0) begin
                    if (num2 == 4'b0) begin
                        if (num1 != 4'b0) estado_sig = Euni;
                    end
                end
                else if (num2 != 4'b0) estado_sig = Edec;
                else if (num != 4'b0) estado_sig = E0;
                else begin
                    estado_sig = E0;
                end
            end

            E2: begin
                if (num1 != 4'b0) estado_sig = E0;
                else if (num1 == 4'b0) begin
                    if (num != 4'b0) begin
                        if (Transis [0] == 1'b1 & Transis[1] == 1'b0 & Transis[2] == 1'b0 & Transis[3] ==1'b0) begin //uni
                            a = aa;
                            b = bb;
                            c = cc;
                            d = dd;
                            e = ee;
                            f = ff;
                            g = gg;
                        end
                        else if (Transis [0] == 1'b0 & Transis[1] == 1'b1 & Transis[2] == 1'b0 & Transis[3] ==1'b0) begin  //dec
                            a = aaa;
                            b = bbb;
                            c = ccc;
                            d = ddd;
                            e = eee;
                            f = fff;
                            g = ggg;
                        end
                        else if (Transis [0] == 1'b0 & Transis[1] == 1'b0 & Transis[2] == 1'b1 & Transis[3] ==1'b0) begin  //cen
                            a = aaaa;
                            b = bbbb;
                            c = cccc;
                            d = dddd;
                            e = eeee;
                            f = ffff;
                            g = gggg;
                        end
                        else if (Transis [0] == 1'b0 & Transis[1] == 1'b0 & Transis[2] == 1'b0 & Transis[3] ==1'b1) begin  //mill 
                            a = aaaaa;
                            b = bbbbb;
                            c = ccccc;
                            d = ddddd;
                            e = eeeee;
                            f = fffff;
                            g = ggggg;
                        end
                    end
                end
                else begin
                    estado_sig = E0;
                end
            end

            Euni: begin
                if (num1 == 4'b0) begin
                    if (num != 4'b0) estado_sig = E0;
                end
                else if (num1 != 4'b0) begin 
                    if (num2 != 4'b0) estado_sig = Edec;
                end
                else if (num1 != 4'b0)begin
                    if (num2 == 4'b0) begin
                        a = aaaaaa;
                        b = bbbbbb;
                        c = cccccc;
                        d = dddddd;
                        e = eeeeee;
                        f = ffffff;
                        g = gggggg;
                    end
                end
                else begin 
                    estado_sig = E0;
                end
                
            end
            Edec: begin
                if (num == 4'b0) begin
                    if (num1 != 4'b0) begin
                        if (num2 != 4'b0) begin
                            if (Transis[0] == 1'b1 & Transis[1] == 1'b0)begin
                                a = aaaaaa;
                                b = bbbbbb;
                                c = cccccc;
                                d = dddddd;
                                e = eeeeee;
                                f = ffffff;
                                g = gggggg;
                            end
                            else if (Transis [0] == 1'b0 & Transis[1] == 1'b1) begin
                                a = aaaaaaa;
                                b = bbbbbbb;
                                c = ccccccc;
                                d = ddddddd;
                                e = eeeeeee;
                                f = fffffff;
                                g = ggggggg;
                            end
                        end
                    end 
                end
                else if (num == 4'b0) begin
                    if (num1 == 4'b0) begin
                        if (num2 == 4'b0) estado_sig = E0;
                    end
                end
                else if (num != 4'b0) estado_sig = E0;
                else begin
                    estado_sig = E0;
                end
            end
            default: estado_sig = E0;
        endcase
    end
endmodule



//Multiplicador
//******************************
//******************************

typedef struct packed {
    logic load_A; 
    logic load_B; 
    logic load_add; 
    logic shift_HQ_LQ_Q_1; 
    logic add_sub; 
}   mult_control_t ;

module multiplicador#( parameter N = 8 )( 

    input logic clk,
    input logic rst,
    input logic [N-1:0] A,
    input logic [N-1:0] B,
    input mult_control_t mult_control,
    output logic [1:0] Q_LSB, 
    output logic [2*N-1:0] Y 

); 
  
    logic [N-1:0] M; 
    logic [N-1:0] adder_sub_out; 
    logic [2*N:0] shift; 
    logic [N-1:0] HQ; 
    logic [N-1:0] LQ; 
    logic Q_1; 
        
    // reg_M    
    always_ff@(posedge clk) begin 
        if (rst) 
            M <= 'b0; 
        else if (mult_control.load_A)
            M <= A;
    end 
    
    // adder/sub
    always_comb begin 
        if (mult_control.add_sub) begin
            adder_sub_out = M + HQ;
        end
        else begin
            adder_sub_out = M - HQ;
        end
    end 
    
    // Asignaciones continuas para evitar el uso de selectores constantes en bloques always_*
    assign HQ = shift[2*N:N+1];
    assign LQ = shift[N:1];
    assign Q_1 = shift[0];
    assign Q_LSB = {LQ[0], Q_1};
    assign Y = {HQ, LQ};

    // Shift registers
    always_ff@(posedge clk) begin 
        if (rst) 
            shift <= 'b0; 
        else if (mult_control.shift_HQ_LQ_Q_1) 
            // arithmetic shift 
            shift <= $signed(shift) >>> 1; 
        else begin 
            if (mult_control.load_B) 
                shift[N:1] <= B; 
            if (mult_control.load_add) 
                shift[2*N:N+1] <= adder_sub_out; 
        end 
    end 

endmodule