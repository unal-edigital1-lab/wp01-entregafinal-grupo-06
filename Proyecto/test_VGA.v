`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:46:19 11/04/2020
// Design Name: 
// Module Name:    test_VGA
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module test_VGA(
    input wire clk,           
    input wire rst,         		
	 //Dirección memoria color en posiciones
	 output reg [3:0] posicion,
	 input wire [2:0] dirColor,
	
	// VGA input/output  
    output wire VGA_Hsync_n,  // horizontal sync output
    output wire VGA_Vsync_n,  // vertical sync output
    output wire VGA_R,	// 4-bit VGA red output
    output wire VGA_G,  // 4-bit VGA green output
    output wire VGA_B  // 4-bit VGA blue output	
);


localparam AW = 4; /*Número de bits necesitados para las direcciones de memoria. En este caso
como se utilizan solo 16 posiciones para representar 16 rectangulos en toda la pantalla, solo se necesitan
4 bits.
*/
localparam DW = 3; //número de bits para el color, como se tiene RGB 111, solo son 3 bits.


localparam RED_VGA =   3'b100;
localparam GREEN_VGA = 3'b010;
localparam BLUE_VGA =  3'b001;


wire clk25M;


wire  [AW-1: 0] DP_RAM_addr_in;  
wire  [DW-1: 0] DP_RAM_data_in;
wire DP_RAM_regW;

reg  [AW-1: 0] DP_RAM_addr_out;  
	

wire [DW-1:0]data_mem;	   // Salida de dp_ram al driver VGA
wire [DW-1:0]data_RGB444;  // salida del driver VGA al puerto
wire [9:0]VGA_posX;		   // Determinar la pos de memoria que viene del VGA
wire [8:0]VGA_posY;		   // Determinar la pos de memoria que viene del VGA


	assign VGA_R = data_RGB444[2];
	assign VGA_G = data_RGB444[1];
	assign VGA_B = data_RGB444[0];

	//Divisor de frecuencia de 50M a 25M
	reg [1:0] cfreq=0;
	assign clk25M = cfreq[0];
	always @(posedge clk) begin
			cfreq<=cfreq+1;
	end
/* ****************************************************************************
buffer_ram_dp buffer memoria dual port y reloj de lectura y escritura separados
Se debe configurar AW  según los calculos realizados en el Wp01
se recomiendia dejar DW a 8, con el fin de optimizar recursos  y hacer RGB 332
**************************************************************************** */
buffer_ram_dp #( AW,DW,"C:/Users/equip/Documents/GitHub/wp01-testvga-grupo-6/Proyecto/image.men")
	DP_RAM(  
	.clk_w(clk), 
	.addr_in(DP_RAM_addr_in), 
	.data_in(DP_RAM_data_in),
	.regwrite(DP_RAM_regW), 
	.clk_r(clk25M), 
	.addr_out(DP_RAM_addr_out),
	.data_out(data_mem)
	);
	

VGA_Driver640x480 VGA640x480
(
	.rst(rst),
	.clk(clk25M), 				// 25MHz  para 60 hz de 640x480
	.pixelIn(data_mem), 		// entrada del valor de color  pixel RGB 444 
	.pixelOut(data_RGB444), // salida del valor pixel a la VGA 
	.Hsync_n(VGA_Hsync_n),	// señal de sincronizaciÓn en horizontal negada
	.Vsync_n(VGA_Vsync_n),	// señal de sincronizaciÓn en vertical negada 
	.posX(VGA_posX), 			// posición en horizontal del pixel siguiente
	.posY(VGA_posY) 			// posición en vertical  del pixel siguiente

);
/* 
always @ (VGA_posX, VGA_posY) begin

		if ((VGA_posX<=160) && (VGA_posY<=120)) begin posicion=15;	DP_RAM_addr_out=dirColor;	end
	
		else if ((VGA_posX<=320) && (VGA_posY<=120)) begin posicion=11;	DP_RAM_addr_out=dirColor;	end
		
		else if ((VGA_posX<=480) && (VGA_posY<=120)) begin posicion=7;	DP_RAM_addr_out=dirColor;	end
		
		else if ((VGA_posX<=640) && (VGA_posY<=120)) begin posicion=3;	DP_RAM_addr_out=dirColor;	end
		
		else if ((VGA_posX<=160) && (VGA_posY<=240)) begin posicion=14;	DP_RAM_addr_out=dirColor;	end
		
		else if ((VGA_posX<=320) && (VGA_posY<=240)) begin posicion=10;	DP_RAM_addr_out=dirColor;	end
		
		else if ((VGA_posX<=480) && (VGA_posY<=240)) begin posicion=6;	DP_RAM_addr_out=dirColor;	end
		
		else if ((VGA_posX<=640) && (VGA_posY<=240)) begin posicion=2;	DP_RAM_addr_out=dirColor;	end
		
		else if ((VGA_posX<=160) && (VGA_posY<=360)) begin posicion=13;	DP_RAM_addr_out=dirColor;	end
		
		else if ((VGA_posX<=320) && (VGA_posY<=360)) begin posicion=9;	DP_RAM_addr_out=dirColor;	end
		
		else if ((VGA_posX<=480) && (VGA_posY<=360)) begin posicion=5;	DP_RAM_addr_out=dirColor;	end	
		
		else if ((VGA_posX<=640) && (VGA_posY<=360)) begin posicion=1;	DP_RAM_addr_out=dirColor;	end
		
		else if ((VGA_posX<=160) && (VGA_posY<=480)) begin posicion=12;	DP_RAM_addr_out=dirColor;	end
		
		else if ((VGA_posX<=320) && (VGA_posY<=480)) begin posicion=8;	DP_RAM_addr_out=dirColor;	end
		
		else if ((VGA_posX<=480) && (VGA_posY<=480)) begin posicion=4;	DP_RAM_addr_out=dirColor;	end
		
		else if ((VGA_posX<=640) && (VGA_posY<=480)) begin posicion=0;	DP_RAM_addr_out=dirColor;	end
		

	else begin DP_RAM_addr_out=0;	end

end
*/

/*
En estos condicionales se tienen todas las posibilidades y la referencia para el color de cada rectángulo.
Por ser un driver de 480x640, se dividen en 4 cada dimensión y se tienen valores para dividir rectángulos.
Cuando la posición en X y Y corresponden a los cuadros, posición adquiere el valor correspondiente al lugar 
del teclado semejante a la pantalla. Esta es la dirección para leer el dato del banco de registros.

dirColor es el valor de lectura del banco de registros. Tiene un valor entre 0 y 7, el cual se utiliza como la dirección
para la memoria utilizada para los colores, que tiene 7 valores posibles para el rgb111 y están en orden:

111-Blanco
100-Rojo
010-Verde
001-Azul
110-Amarillo
011-Cyan
101-Magenta
000-Negro

De este modo se almacenan los colores para cada rectángulo.

Cuando no se cumplen estas condiciones, la dirección a la memoria de colores es 0, es decir, a blanco. Esto aplica para bordes de la pantalla
y algunos pixeles que no se tienen en cuenta por errores de precisión.
*/
always @ (VGA_posX, VGA_posY) begin
		if ((VGA_posX<=160) && (VGA_posY<=120)&&(VGA_posX>=0)&&(VGA_posY>=0)) begin posicion=15;	DP_RAM_addr_out=dirColor;	end
	
		else if ((VGA_posX<=320) && (VGA_posY<=120)&&(VGA_posX>160)&&(VGA_posY>0)) begin posicion=11;	DP_RAM_addr_out=dirColor;	end
		
		else if ((VGA_posX<=480) && (VGA_posY<=120)&&(VGA_posX>320)&&(VGA_posY>0)) begin posicion=7;	DP_RAM_addr_out=dirColor;	end
		
		else if ((VGA_posX<=640) && (VGA_posY<=120)&&(VGA_posX>480)&&(VGA_posY>0)) begin posicion=3;	DP_RAM_addr_out=dirColor;	end
		
		else if ((VGA_posX<=160) && (VGA_posY<=240)&&(VGA_posX>0)&&(VGA_posY>120)) begin posicion=14;	DP_RAM_addr_out=dirColor;	end
		
		else if ((VGA_posX<=320) && (VGA_posY<=240)&&(VGA_posX>160)&&(VGA_posY>120)) begin posicion=10;	DP_RAM_addr_out=dirColor;	end
		
		else if ((VGA_posX<=480) && (VGA_posY<=240)&&(VGA_posX>320)&&(VGA_posY>120)) begin posicion=6;	DP_RAM_addr_out=dirColor;	end
		
		else if ((VGA_posX<=640) && (VGA_posY<=240)&&(VGA_posX>480)&&(VGA_posY>120)) begin posicion=2;	DP_RAM_addr_out=dirColor;	end
		
		else if ((VGA_posX<=160) && (VGA_posY<=360)&&(VGA_posX>0)&&(VGA_posY>240)) begin posicion=13;	DP_RAM_addr_out=dirColor;	end
		
		else if ((VGA_posX<=320) && (VGA_posY<=360)&&(VGA_posX>160)&&(VGA_posY>240)) begin posicion=9;	DP_RAM_addr_out=dirColor;	end
		
		else if ((VGA_posX<=480) && (VGA_posY<=360)&&(VGA_posX>320)&&(VGA_posY>240)) begin posicion=5;	DP_RAM_addr_out=dirColor;	end
		
		else if ((VGA_posX<=640) && (VGA_posY<=360)&&(VGA_posX>480)&&(VGA_posY>240)) begin posicion=1;	DP_RAM_addr_out=dirColor;	end
		
		else if ((VGA_posX<=160) && (VGA_posY<=480)&&(VGA_posX>0)&&(VGA_posY>360)) begin posicion=12;	DP_RAM_addr_out=dirColor;	end
		
		else if ((VGA_posX<=320) && (VGA_posY<=480)&&(VGA_posX>160)&&(VGA_posY>360)) begin posicion=8;	DP_RAM_addr_out=dirColor;	end
		
		else if ((VGA_posX<=480) && (VGA_posY<=480)&&(VGA_posX>320)&&(VGA_posY>360)) begin posicion=4;	DP_RAM_addr_out=dirColor;	end
		
		else if ((VGA_posX<=640) && (VGA_posY<=480)&&(VGA_posX>480)&&(VGA_posY>360)) begin posicion=0;	DP_RAM_addr_out=dirColor;	end
		

	else begin DP_RAM_addr_out=0;	end

end


endmodule
