`timescale 1ns/1ps


module Top(clk , rst, col , fila, led, opr);
	input clk;
	input rst;
	output [3:0]col;
	input [3:0]fila;
	output [15:0] led;
	output opr;
	

Teclado teclado
(
.clk(clk),
.fila(fila),
.col(col),
.posicion(led),
.opr(opr)
);
	
	
	
endmodule	