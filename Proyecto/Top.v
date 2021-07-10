`timescale 1ns/1ps


module Top(clk,rst,col,fila, opr,VGA_Hsync_n,VGA_Vsync_n,VGA_R,VGA_G,VGA_B,sseg,an);
	input clk;
	input rst;
	output [3:0]col;
	input [3:0]fila;
	output opr;
	output wire VGA_Hsync_n;  
	output wire VGA_Vsync_n;  
	output wire VGA_R;	
	output wire VGA_G;  
	output wire VGA_B;
	output [0:6] sseg;
	output [3:0] an;

	
wire[3:0] filaAntirrebote;
wire [3:0] posT;
wire [3:0] posVGA;
wire opr;
wire [3:0] datOutR;
wire [3:0] posDispay;	
	
	
	


antirrebote fila4(.clk(clk),.ButtonIn(fila[3]),.ButtonOut(filaAntirrebote[3]));
antirrebote fila3(.clk(clk),.ButtonIn(fila[2]),.ButtonOut(filaAntirrebote[2]));
antirrebote fila2(.clk(clk),.ButtonIn(fila[1]),.ButtonOut(filaAntirrebote[1]));
antirrebote fila1(.clk(clk),.ButtonIn(fila[0]),.ButtonOut(filaAntirrebote[0]));
	
	
	
Teclado teclado(
.clk(clk),
.fila(filaAntirrebote),
.col(col),
.posicion(posT),
.opr(opr)
);
	
BancoRegistro #( 4,3,"C:/Users/equip/Documents/GitHub/wp01-testvga-grupo-6/Proyecto/memDir.men")banco(
.addrR(posDispay),
.addrW(posT),
.RegWrite(opr),
.clk(clk),
.rst(~rst),
.datOutR(datOutR)
);

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




Display display(.clk(clk),.numA(datOutR),.sseg(sseg),.an(an),.posicion(posDispay);
	
	

endmodule 