`timescale 1ns / 1ps


module teclado_TB;


	reg clk;
	reg [3:0]fila;
	wire [3:0]col;
	wire[3:0]posicion;
	wire opr;
		
	reg [3:0]valorS;
	

	
	// Instantiate the Unit Under Test (UUT)
	
	Teclado  uut(.clk(clk),.fila(fila),.col(col),.posicion(posicion),.opr(opr));
	
	
	
	initial begin
		clk=0;
			assign valorS=posicion;
		fila=4'b0010;
		
		#5;
		fila=4'b0000;

		#10;
		fila=4'b1000;

		#10;
		fila=4'b0000;

		#10;
		fila=4'b0010;
	
	end

	initial begin
		forever begin
			#10 clk = ~clk;
		end
	end
	
	
   initial begin: TEST_CASE
     $dumpfile("teclado_TB.vcd");
     #(250) $finish;
   end

	


endmodule
