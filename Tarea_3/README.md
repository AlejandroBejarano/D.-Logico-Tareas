# Diseño digital sincrónico de una multiplicación con algoritmo de Booth
<h2 align="center">Alejandro Bejarano, Jimena Vargas</h2>



## 1. Resumen


##### Introducción
Se aborda el diseño de un sistema digital que puede capturar números desde un teclado y realizar una multiplicación con el algoritmo de Booth, mostrando el resultado en una pantalla de 7 segmentos. La idea principal es utilizar un HDL, específicamente SystemVerilog, para crear un sistema sincronizado, donde todos los componentes funcionan al mismo "reloj" interno de 27 MHz. Con ello se pretende que, al ingresar números con el teclado hexadecimal, estos se almacenen y luego se multipliquen correctamente, mostrando el resultado en tiempo real en un display de 4 dígitos, además todo el sistema se implementa en una FPGA.



## 2. Problema, objetivos y especificaciones 
### Problema 





## 3. Objetivos








### Especificaciones 







## 4. Diseño
Para realizar lo pedido, se realizó una partición de este mismo sistema a desarrollar, en varios subsistemas.


### 4.1 Descripción general de cada subsistema

#### Capturador de teclas

##### Entradas
##### Salidas
``` SystemVerilog

```


#### Almacenamiento de datos

##### Entradas
##### Salidas
``` SystemVerilog

```

#### Display


##### Entradas
##### Salidas
``` SystemVerilog

```

#### Multiplicador

##### Entradas
##### Salidas
``` SystemVerilog

```


#### Control (maquina de estado)

##### Entradas
##### Salidas
``` SystemVerilog

```


## 5. Conclusiones




## 6. Análisis de principales problemas 






## 7. Referencias





## 8. Anexos

### 8.1 Anexo: Testbench detector de columnas


### 8.2 Anexo: Testbench almacenamiento de datos


### 8.3 Anexo: Testbench display


### 8.4 Anexo Testbench multiplicador


### 8.5 Anexo: Testbench control FSM

