`timescale 1ns/1ps

module Top_tb(

	);
	localparam R = 6;
	localparam T = 20;
	reg clk, reset;
	
	//wire [R - 1:0]ciclo;
	wire pwm_out;
	reg[11:0]N=1;
	wire [11:0] n;
	
	//instanciacion del modulo
	Top uut(
		//.N(N),
		.clk(clk),
		.salidaPWM(pwm_out),
		.n(n)
	);
	
	
	
	initial
		#(2**(R+1)*36*N*T*20) $stop;
		
	//Generando señal de reloj
	
	always
	begin
		clk = 1'b0;
		#(T / 2);
		clk = 1'b1;
		#(T / 2);
	end
	
	
	initial
	begin
	
	
	
		reset = 1'b0;
		#2
		reset = 1'b1;
		
		
	#(2**(R+1)*36*N*T*2+1000) N = 2;
	
	#(2**(R+1)*36*N*T*2+2000) N = 3;
	
	#(2**(R+1)*36*N*T*2+200) N = 4;
	end
	
		
endmodule 