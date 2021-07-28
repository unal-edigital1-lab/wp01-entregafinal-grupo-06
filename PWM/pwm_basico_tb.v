`timescale 1ns/1ps

module pwm_basico_tb(

	);
	localparam R = 6;
	localparam T = 20;
	localparam N = 3;
	reg clk, reset;
	
	//wire [R - 1:0]ciclo;
	wire pwm_out;
	
	
	
	//instanciacion del modulo
	pwm_basico #(.R(R),.N(N)) uut (
		.clk(clk),
		//.reset(reset),
		.pwm_out(pwm_out)
		//.ciclo(ciclo)
	);
	
	
	
	initial
		#(2**(R+3)*36*N*T) $stop;
		
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

	end
		
endmodule
