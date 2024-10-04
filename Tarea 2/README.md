# Diseño digital sincrónico de una suma aritmética en un HDL


## 1. Resumen
Este informe presenta los detalles de un programa digital sincrónico, el cual está programado en un lenguaje de hardware (HDL), captura los datos de un teclado hexadecimal y los almacena en binario para después implementar una función aritmética como la suma, y por último, desplegar el resultado en un display de 4 dígitos.


## 2. Problema, objetivos y especificaciones 
### Problema 
Diseñar un sistema digital sincrónico en una FPGA, implementando un método que procese diferentes datos y señales con el mismo reloj, para evitar errores de sincronización. Además, se deben capturar dos números de 3 dígitos cada uno a partir de un teclado hexadecimal, los cuales se presentarán en el display de 4 dígitos a medida que se vayan digitando. Luego, se implementará la función de suma aritmética para que estos dos valores se sumen y el resultado se presente en el display de 7 segmentos. Asimismo, se debe generar un testbench básico para corroborar que todo el sistema funcione correctamente.

### Objetivos
- Elaborar una correcta implementación de un diseño digital sincrónico en una FPGA.
- Diseñar diferentes algoritmos en un HDL para la captura de datos de un teclado hexadecimal mecánico, sincronización de datos asincrónicos y despliegue de datos en dispositivos de 7 segmentos.
- Implementar una función de suma aritmética en un HDL.
- Construir un testbench básico para cada módulo, con el fin de verificar su correcto funcionamiento.

### Especificaciones 
- Subsistema de lectura del teclado hexadecimal con captura de datos, eliminación de rebote y sincronización de los datos a partir de un teclado mecánico.
- Subsistema de suma aritmética de los dos datos.
- Subsistema de despliegue de los números ingresados y del resultado de la suma en cuatro dispositivos de 7 segmentos.
- El circuito deberá funcionar a una frecuencia de reloj de 27 MHz.

## 4. Diseño

Para realizar pedido se realizó, una partición de este mismo, en 4 subsistemas

### 4.1 Descripción general de cada subsistema

#### Capturador de teclas

Para la creación del módulo capturador de teclas se diseñó el siguiente diagrama:

![Diagrama de bloques del capturador de teclas](Fotos/Capturador de teclas diagrama.png)

De esto se tiene que, se utiliza un contador de anillo para activar las filas secuencialmente con un clk, seguidamente se implementa una FSM para detectar columnas activas, y por último se desarrolla un antirrebote de la señal detectada de la columna encendida.

Con ello se desarrolló primeramente el módulo de contador de anillo, con ello se tienen las siguientes entradas y salidas del modulo:

- `input logic clk`: Señal de clock a 27 MHz.
- `input logic rst`: Señal de reset utilizada para iniciar el estado del contador de anillo.
- `output logic [3:0]fila`: Señal de salida de 4 bits, que representa la fila encendida.

A partir de las entradas, con el clock a 27 MHz, 

```SystemVerilog
module cont_anillo(
    input logic clk,
    input logic rst,
    output logic [3:0]fila
);
logic [3:0]fila_encendida;
    always_ff @(posedge clk)begin
        if (rst)begin
            fila_encendida <= 4'b0001;  
        end
        else begin
            fila_encendida <= {fila_encendida[2:0], fila_encendida[3]};
        end
    end
    assign fila = fila_encendida;
endmodule
```
        //Pasa a encender la siguiente fila cada nuevo ciclo del clock, se turna en activar las filas, para dar corriente.
        //Es un shifter, fila 1:0001 , fila 2: 0010 , fila 3: 0100, fila 4: 1000.


- `entrada_i`: descripción de la entrada
- `salida_o`: descripción de la salida

```SystemVerilog
module mi_modulo(
    input logic     entrada_i,      
    output logic    salida_i 
    );
```



##### Testbench


##### Consumo de recursos




















#### Almacenamiento de datos

- `entrada_i`: descripción de la entrada
- `salida_o`: descripción de la salida

```SystemVerilog
module mi_modulo(
    input logic     entrada_i,      
    output logic    salida_i 
    );
```


##### Testbench


##### Consumo de recursos




#### Display


- `entrada_i`: descripción de la entrada
- `salida_o`: descripción de la salida

```SystemVerilog
module mi_modulo(
    input logic     entrada_i,      
    output logic    salida_i 
    );
```



##### Testbench


##### Consumo de recursos



#### Sumatoria


- `entrada_i`: descripción de la entrada
- `salida_o`: descripción de la salida

```SystemVerilog
module mi_modulo(
    input logic     entrada_i,      
    output logic    salida_i 
    );
```



##### Testbench


##### Consumo de recursos


#### Control


- `entrada_i`: descripción de la entrada
- `salida_o`: descripción de la salida

```SystemVerilog
module mi_modulo(
    input logic     entrada_i,      
    output logic    salida_i 
    );
```



##### Testbench


##### Consumo de recursos




## 5. Conclusiones





## 6. Análisis de principales problemas 








## 7. Referencias
[0] David Harris y Sarah Harris. *Digital Design and Computer Architecture. RISC-V Edition.* Morgan Kaufmann, 2022. ISBN: 978-0-12-820064-3





