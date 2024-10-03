module sistema_calculadora (
    input logic clk,
    input logic rst,
    input logic col_0, 
    input logic col_1, 
    input logic col_2, 
    input logic col_3,
    output logic [3:0] fila, // La fila que será controlada por el contador de anillo
    output logic [3:0] an,       // Para los displays
    output logic [6:0] seg,      // Para los segmentos del display a,b,c,d,e,f,g
    output logic [13:0] resultado // Resultado de la suma
);

    // conexiones entre módulos
    logic [3:0] tecla_pre;
    logic suma, igual;
    logic clk_div;
    
    // Señales para almacenar números
    logic [11:0] numero1, numero2;
    logic cargar_numero1, cargar_numero2, reset_datos;

    //para filas
    logic [3:0] fila_contador;
    
    // Instanciar el contador de anillo que controla la fila
    cont_anillo cont_ani_inst(
        .clk(clk),
        .rst(rst),
        .fila(fila_contador) // Este módulo controla la fila
    );
    assign fila = fila_contador;



    // Instanciación de los módulos
    capturador_de_teclas capturador_inst(
        .clk(clk),
        .rst(rst),
        .col_0(col_0),
        .col_1(col_1),
        .col_2(col_2),
        .col_3(col_3),
        .fila_ent(fila_contador), // Conectamos a la fila del contador
        .tecla_pre(tecla_pre),
        .suma(suma),
        .igual(igual)
    );

    
    almacenamiento_datos almacenamiento_inst(
        .clk(clk),
        .rst(rst),
        .tecla_pre(tecla_pre),
        .cargar_numero1(cargar_numero1),
        .cargar_numero2(cargar_numero2),
        .reset_datos(reset_datos),
        .numero1(numero1),
        .numero2(numero2)
    );
    
    maquina_estado maquina_inst(
        .clk(clk),
        .rst(rst),
        .a(suma),
        .b(igual),
        .c(1'b0), // Conectar a la tecla de eliminar si la tienes
        .tecla_pre(tecla_pre),
        .cargar_numero1(cargar_numero1),
        .cargar_numero2(cargar_numero2),
        .rst_datos(reset_datos)
    );

    // Instanciar el módulo de suma
    SumaAri suma_inst(
        .clk(clk),
        .rst(rst),
        .num1(numero1),
        .num2(numero2),
        .sum(resultado)
    );

    // Instanciar el módulo de display
    display display_inst(
        .rst(rst),
        .clk(clk),
        .a(cargar_numero1),  // Cambia según tu lógica de visualización
        .b(cargar_numero2),
        .numero1(numero1),
        .numero2(numero2),
        .an(an),
        .seg(seg)
    );

    


endmodule

module capturador_de_teclas(
    input logic clk,
    input logic rst,
    input logic col_0, 
    input logic col_1, 
    input logic col_2, 
    input logic col_3,
 
    input logic [3:0] fila_ent, // Asegúrate de que esto se conecta correctamente
    output logic [3:0] tecla_pre, 
    output logic suma,     
    output logic igual
);

    logic clk_div;
    logic col_00;
    logic col_11;
    logic col_22;
    logic col_33;

    // Instanciar los módulos de rebote
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

    // Instanciar el detector de columnas
    detector_columna detector_col_inst(
        .clk(clk),
        .rst(rst),
        .fila(fila_ent), // Conexión correcta aquí
        .col_0(col_00),
        .col_1(col_11),
        .col_2(col_22),
        .col_3(col_33),
        .tecla_pre(tecla_pre),
        .suma(suma),
        .igual(igual)
    );

    // Instanciar el divisor de reloj
    divisor divisor_inst(
        .clk(clk),
        .clk_div(clk_div)
    );

endmodule


module cont_anillo(
    input logic clk,
    input logic rst,
    output logic [3:0] fila
);
    logic [3:0] fila_encendida;

    // Contador de anillo
    always_ff @(posedge clk or posedge rst) begin
        // Enciende la primera fila, para dar corriente.
        if (rst) begin
            fila_encendida <= 4'b0001;  
        end
        // Pasa a encender la siguiente fila cada nuevo ciclo del clock
        else begin
            fila_encendida <= {fila_encendida[2:0], fila_encendida[3]};
        end
    end

    // Se le asigna la salida.
    assign fila = fila_encendida;
endmodule

module detector_columna (
    input logic clk,
    input logic rst,
    input logic [3:0] fila,  // Entrada del contador de anillo
    
    // Entradas físicas a FPGA
    input logic col_0, 
    input logic col_1, 
    input logic col_2, 
    input logic col_3, 

    output logic [3:0] tecla_pre,    // Salida de teclas en bits
    output logic suma,         // Salida de código de suma
    output logic igual        // Salida de código de igual
);

    // Definición de estados de la FSM
    typedef enum logic [4:0] { 
        F0, F1, F2, F3, 
        F0C0, F0C1, F0C2, F0C3,
        F1C0, F1C1, F1C2, F1C3,
        F2C0, F2C1, F2C2, F2C3,
        F3C0, F3C1, F3C2, F3C3
    } estado;

    estado estado_act, estado_sig;
    logic [3:0] salida;

    // Para el estado actual
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            estado_act <= F0;
        end else begin
            estado_act <= estado_sig;
        end
    end

    // Lógica combinacional de la FSM, entre los estados
    always_comb begin
        // Asignación por defecto a la salida
        salida = 4'b0000;  // Valor por defecto para evitar latch
        estado_sig = estado_act; // Estado por defecto

        case (estado_act)
            F0: begin
                if (fila == 4'b0001) begin
                    if (col_0) estado_sig = F0C0; 
                    else if (col_1) estado_sig = F0C1;
                    else if (col_2) estado_sig = F0C2;
                    else if (col_3) estado_sig = F0C3;
                    else estado_sig = F1;
                end else begin 
                    estado_sig = F1;
                end
            end
            F1: begin
                if (fila == 4'b0010) begin
                    if (col_0) estado_sig = F1C0; 
                    else if (col_1) estado_sig = F1C1;
                    else if (col_2) estado_sig = F1C2;
                    else if (col_3) estado_sig = F1C3;
                    else estado_sig = F2;
                end else begin 
                    estado_sig = F2;
                end
            end
            F2: begin
                if (fila == 4'b0100) begin
                    if (col_0) estado_sig = F2C0;
                    else if (col_1) estado_sig = F2C1;
                    else if (col_2) estado_sig = F2C2;
                    else if (col_3) estado_sig = F2C3;
                    else estado_sig = F3;
                end else begin 
                    estado_sig = F3;
                end
            end
            F3: begin
                if (fila == 4'b1000) begin
                    if (col_0) estado_sig = F3C0;
                    else if (col_1) estado_sig = F3C1;
                    else if (col_2) estado_sig = F3C2;
                    else if (col_3) estado_sig = F3C3;
                    else estado_sig = F0;
                end else begin 
                    estado_sig = F0;
                end
            end
            // Manejo de las filas por teclas
            F0C0: begin salida = 4'b0000; estado_sig = F0; end
            F0C1: begin salida = 4'b0001; estado_sig = F0; end
            F0C2: begin salida = 4'b0010; estado_sig = F0; end
            F0C3: begin salida = 4'b0011; estado_sig = F0; end
            F1C0: begin salida = 4'b0100; estado_sig = F1; end
            F1C1: begin salida = 4'b0101; estado_sig = F1; end
            F1C2: begin salida = 4'b0110; estado_sig = F1; end
            F1C3: begin salida = 4'b0111; estado_sig = F1; end
            F2C0: begin salida = 4'b1000; estado_sig = F2; end
            F2C1: begin salida = 4'b1001; estado_sig = F2; end
            F2C2: begin salida = 4'b1010; estado_sig = F2; end
            F2C3: begin salida = 4'b1011; estado_sig = F2; end
            F3C0: begin salida = 4'b1100; estado_sig = F3; end
            F3C1: begin salida = 4'b1101; estado_sig = F3; end
            F3C2: begin salida = 4'b1110; estado_sig = F3; end
            F3C3: begin salida = 4'b1111; estado_sig = F3; end
        endcase
    end

    // Asignar la salida
    assign tecla_pre = salida;

    // Asignar las señales de suma e igual según sea necesario
    always_comb begin
        suma = (tecla_pre == 4'b0001); // Asignación de ejemplo, cambia según tu lógica
        igual = (tecla_pre == 4'b0010); // Asignación de ejemplo, cambia según tu lógica
    end

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
    input logic a,   // señal para suma
    input logic b,   // señal para igual
    input logic c,   // posiblemente para eliminar
    input logic [3:0] tecla_pre,
    output logic cargar_numero1,
    output logic cargar_numero2,
    output logic rst_datos
);

    typedef enum logic [2:0] {
        IDLE,
        CARGAR_NUMERO1,
        CARGAR_NUMERO2,
        REALIZAR_SUMA,
        MOSTRAR_RESULTADO
    } estado;

    estado estado_act, estado_sig;

    // Lógica de transición de estados
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            estado_act <= IDLE;
        end else begin
            estado_act <= estado_sig;
        end
    end

    // Lógica combinacional para determinar el siguiente estado
    always_comb begin
        estado_sig = estado_act; // por defecto sigue en el estado actual
        cargar_numero1 = 0;
        cargar_numero2 = 0;
        rst_datos = 0;

        case (estado_act)
            IDLE: begin
                if (tecla_pre != 4'b0000) begin // si hay una tecla presionada
                    cargar_numero1 = 1;
                    estado_sig = CARGAR_NUMERO1;
                end
            end
            CARGAR_NUMERO1: begin
                if (a) begin // si se presiona la tecla de suma
                    cargar_numero2 = 1;
                    estado_sig = CARGAR_NUMERO2;
                end else if (b) begin // si se presiona igual
                    estado_sig = REALIZAR_SUMA;
                end
            end
            CARGAR_NUMERO2: begin
                if (b) begin // si se presiona igual
                    estado_sig = REALIZAR_SUMA;
                end
            end
            REALIZAR_SUMA: begin
                // Realiza la suma
                estado_sig = MOSTRAR_RESULTADO;
            end
            MOSTRAR_RESULTADO: begin
                // Muestra el resultado
                if (rst) begin // resetea el sistema
                    estado_sig = IDLE;
                end
            end
            default: estado_sig = IDLE;
        endcase
    end
endmodule


//  Module para los 4 display con los dos numeros de 3 digitos
module display(
    input logic rst,                // Reset
    input logic clk,                // Reloj principal
    input logic a,                  // Control para mostrar el primer número
    input logic b,                  // Control para mostrar el segundo número
    input logic [11:0] numero1,     // Primer número de 12 bits
    input logic [11:0] numero2,     // Segundo número de 12 bits
    output logic [3:0] an,          // Señal de activación de los anodos (4 displays)
    output logic [6:0] seg          // Señal para los segmentos (7 segmentos)
);

    // Registros para el número a mostrar
    logic [3:0] numero_mostrar;     // Número actual que se mostrará en el display

    // Contador para seleccionar qué número y qué display activar
    logic [1:0] contador;           // Contador para rotar entre los displays

    // Contador de refresco para cambiar los displays secuencialmente
    logic [18:0] refresh_counter;   // Ajustado para generar la señal de refresco
    wire [1:0] display_select;      // Valor para seleccionar el display activo

    // Contador de refresco para cambiar entre los displays
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            refresh_counter <= 0;
        end else begin
            refresh_counter <= refresh_counter + 1;
        end
    end

    // Selecciona cuál display activar en cada ciclo de refresco
    assign display_select = refresh_counter[18:17];  // Usamos los bits más altos para dividir el reloj

    // Control de activación de los displays según el contador
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            contador <= 0;
            an <= 4'b1110;  // Activar el primer display
        end else begin
            case (display_select)
                2'b00: begin
                    an <= 4'b1110; // Activar el primer display
                    numero_mostrar <= numero1[3:0]; // Mostrar el nibble menos significativo de `numero1`
                end
                2'b01: begin
                    an <= 4'b1101; // Activar el segundo display
                    numero_mostrar <= numero1[7:4]; // Mostrar el segundo nibble de `numero1`
                end
                2'b10: begin
                    an <= 4'b1011; // Activar el tercer display
                    numero_mostrar <= numero2[3:0]; // Mostrar el nibble menos significativo de `numero2`
                end
                2'b11: begin
                    an <= 4'b0111; // Activar el cuarto display
                    numero_mostrar <= numero2[7:4]; // Mostrar el segundo nibble de `numero2`
                end
                default: begin
                    an <= 4'b1111; // Apagar tods los displays
                end
            endcase
        end
    end

    // Lógica de decodificación para los segmentos del display
    always_comb begin
        case (numero_mostrar)
            4'h0: seg = 7'b0111111; // 0
            4'h1: seg = 7'b0000110; // 1
            4'h2: seg = 7'b1011011; // 2
            4'h3: seg = 7'b1001111; // 3
            4'h4: seg = 7'b1100110; // 4
            4'h5: seg = 7'b1101101; // 5
            4'h6: seg = 7'b1111101; // 6
            4'h7: seg = 7'b0000111; // 7
            4'h8: seg = 7'b1111111; // 8
            4'h9: seg = 7'b1101111; // 9
            4'hA: seg = 7'b1110111; // A
            4'hB: seg = 7'b1111100; // B
            4'hC: seg = 7'b0111001; // C
            4'hD: seg = 7'b1011110; // D
            4'hE: seg = 7'b1111001; // E
            4'hF: seg = 7'b1110001; // F
            default: seg = 7'b0000000; // Apagar tods los segmentos
        endcase
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