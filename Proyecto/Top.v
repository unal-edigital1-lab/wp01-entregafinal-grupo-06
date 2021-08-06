`timescale 1ns/1ps


module Top(clk,rst,col,fila,VGA_Hsync_n,VGA_Vsync_n,VGA_R,VGA_G,VGA_B,bell,oprN,sseg,an);
	input clk; //reloj
	input rst; //boton de reset
	output [3:0]col; //Salida hacia las columnas del teclado matricial
	input [3:0]fila; //Entrada de las filas del teclado matricial 
	output wire VGA_Hsync_n;  // Bit de sincronización horizontal de la VGA
	output wire VGA_Vsync_n;  // Bit de sincronización vertical de la VGA
	output wire VGA_R;	// Bit del color rojo de VGA
	output wire VGA_G;  // Bit del color verde de VGA
	output wire VGA_B;  // Bit del color azul de VGA
	output bell;
	//input [3:0] posT;
	//input opr;
	output oprN;
	output [0:6] sseg;
	output [3:0] an;
	
wire [3:0] posT; //Wire que conecta la posición del boton hundido del teclado matricial, varía entre 0 y 15
reg [3:0] RegPrueba;
wire [3:0] posVGA; //valor que varía entre 0 y 15 y se usa para leer la posición de memoria del banco de registro
wire opr; //wire de oprimido, que es 1 cuando un boton del teclado matricial está pulsado
wire [3:0] datOutR; //Se usa para leer el dato de lectura del banco de registro con dirección configurada por posVGA
wire [3:0] posDispay;	
wire [11:0] Nfreq; //Valor de N que determina la frecuencia de la señal del PWM
wire salidaPWM;

assign bell=salidaPWM; //
assign oprN=~opr;



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
Módulo del banco de registro, 4 bits para direcciones y 3 para el valor. 
Se encuentra la dirección local del archivo de precarga de memoria, inicialmente todos están en 000.

El rst se niega debido a que en la FPGA el pulsador es normalmente cerrados.
*/	
BancoRegistro #( 4,3,"C:/Users/equip/Documents/GitHub/wp01-testvga-grupo-6/Proyecto/memDir.men")banco(
.addrR(posVGA),
.addrW(posT),
.RegWrite(opr),
.clk(clk),
.rst(~rst),
.datOutR(datOutR)
);

/*
Para el bloque de VGA se tienen unas modificaciones al entregado para el proyecto.

posicion es una salida dirigida al addrR para la dirección de lectura del banco de registro, y datOutR es el dato
de esa posición.

rst se niega por lo dicho anteriormente.
*/

test_VGA VGA(
	.clk(clk),           
	.rst(~rst),
	.posicion(posVGA),
	.dirColor(datOutR),
	.VGA_Hsync_n(VGA_Hsync_n), 
	.VGA_Vsync_n(VGA_Vsync_n), 
	.VGA_R(VGA_R),	
	.VGA_G(VGA_G),  
	.VGA_B(VGA_B),   	
);

<<<<<<< HEAD
parameter [9:0] mil=1000;
parameter [5:0] mult=50;
=======
reg [9:0] mil=1000;
>>>>>>> parent of fa7bf9a (Final push)
reg [3:0] posPWM=0;
	
	always @(posedge opr) begin
		posPWM<=posT;
	end

<<<<<<< HEAD
	assign Nfreq=mil+mult*posPWM;
	
pwm_basico#(6)pwm(.clk(clk),.Nentrada(Nfreq),.pwm_out(salidaPWM),.opr(opr));
=======
always @(*) begin
	Nfreq=mil+50*posPWM;
end 
	
	
	
//assign Nfreq=mil+50*posPWM;

pwm_basico#(6)pwm(.clk(clk),.Nentrada(Nfreq),.pwm_out(salidaPWM));
>>>>>>> parent of fa7bf9a (Final push)

//Display display(.sseg(sseg),.an(an),.numA(Nfreq), .clk(clk));


endmodule 