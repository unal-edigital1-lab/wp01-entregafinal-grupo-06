`timescale 1ns/1ps

module pwm_basico_tb(

	);
	localparam R = 8;
	localparam T = 10;
	reg clk, reset;
	//wire [R - 1:0]ciclo;
	wire pwm_out;
	wire enable;
	
	//instanciacion del modulo
	pwm_basico #(.R(R)) uut (
		.clk(clk),
		.reset(reset),
		//.ciclo(ciclo),
		.enable(enable),
		.pwm_out(pwm_out)
	);
	
	
	
	initial
		#(7 * 2**(R+10) * T) $stop;
		
		
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
