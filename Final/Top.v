`timescale 1ns/1ps


module Top(clk,rst,col,fila,VGA_Hsync_n,VGA_Vsync_n,VGA_R,VGA_G,VGA_B,salidaPWM);
	input clk;							//reloj
	input rst;							//boton de reset
	output [3:0]col;					//Salida hacia las columnas del teclado matricial
	input [3:0]fila;					//Entrada de las filas del teclado matricial 
	output wire VGA_Hsync_n; 		// Bit de sincronización horizontal de la VGA
	output wire VGA_Vsync_n; 		// Bit de sincronización vertical de la VGA
	output wire VGA_R;				// Bit del color rojo de VGA
	output wire VGA_G;  				// Bit del color verde de VGA
	output wire VGA_B;  				// Bit del color azul de VGA
	output salidaPWM;


wire [3:0] posT;						//Wire que conecta la posición del boton hundido del teclado matricial, varía entre 0 y 15
wire [3:0] posVGA;					//valor que varía entre 0 y 15 y se usa para leer la posición de memoria del banco de registro
wire opr;								//wire de oprimido, que es 1 cuando un boton del teclado matricial está pulsado
wire [3:0] datOutRColor;			//Se usa para leer el dato del banco de registro con dirección configurada por posVGA	
wire[4:0] datOutRFreq;				//Se usa para leer el dato de la ROM.

wire wirePWM; 							//Wire que conecta la salida del PWM
assign salidaPWM=wirePWM & opr;	//Wire asignado a un pin de la fpga, se activa el PWM cuando está encendido opr.


/*
Para el teclado se tiene como salida col, que varía constantemente, y fila de entrada, que recolecta los valores para determinar
si algun botón está siendo pulsado.

posicion es un valor entre 0 y 15 que determina esta posición pulsada.
*/

Teclado teclado(
.clk(clk),
.fila(fila),
.col(col),
.posicion(posT),
.opr(opr)
);
	
/*
Módulo del banco de registro, RAM de 4 bits para direcciones y 3 para el valor. 
Se encuentra la dirección local del archivo de precarga de memoria, inicialmente todos están en 000.
El rst se niega debido a que en la FPGA el pulsador es normalmente cerrados.
*/

BancoRegistro #( 4,3,"C:/Users/equip/Documents/GitHub/wp01-testvga-grupo-6/Final/memDir.men")RAM(
.addrR(posVGA),
.addrW(posT),
.RegWrite(opr),
.clk(clk),
.rst(~rst),
.datOutR(datOutRColor)
);


/*Para el bloque de VGA se tienen unas modificaciones al entregado para el proyecto.

posicion es una salida dirigida al addrR para la dirección de lectura del banco de registro, y datOutRColor es el dato
de esa posición.

rst se niega por lo dicho anteriormente.*/

test_VGA VGA(
	.clk(clk),           
	.rst(~rst),
	.posicion(posVGA),
	.dirColor(datOutRColor),
	.VGA_Hsync_n(VGA_Hsync_n), 
	.VGA_Vsync_n(VGA_Vsync_n), 
	.VGA_R(VGA_R),	
	.VGA_G(VGA_G),  
	.VGA_B(VGA_B),   	
);


/*
Memoria ROM donde se almacenan los valores correspondientes del pwm para emitir las frecuencias deseadas. Se acceden a través de la posición
del teclado matricial activada. 4 bits de dirección y 5 bits para cada dato.
*/

BancoRegistro #(4,5,"C:/Users/equip/Documents/GitHub/wp01-testvga-grupo-6/Final/freq.men")ROM(
.addrR(posT),
.datOutR(datOutRFreq)
);


/*
Módulo del PWM, con entrada la lectura del dato de la ROM.
*/

pwm_basico#(6)pwm(.clk(clk),.datN(datOutRFreq),.pwm_out(wirePWM));


endmodule 