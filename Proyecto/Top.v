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

wire [3:0] posT;
wire [3:0] posVGA;
wire opr;
wire [3:0] datOutR;
	
Teclado teclado(
.clk(clk),
.fila(fila),
.col(col),
.posicion(posT),
.opr(opr)
);
	
BancoRegistro #( 4,3,"C:/Users/equip/Documents/GitHub/wp01-testvga-grupo-6/Proyecto/memDir.men")banco(
.addrR(posVGA),
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

Display display(.clk(clk),.numA(datOutR),.sseg(sseg),.an(an));
	
endmodule	