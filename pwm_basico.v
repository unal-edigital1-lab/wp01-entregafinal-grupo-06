`timescale 1ns/1ps

module pwm_basico
	#(parameter R = 8)(
	input clk,
	input reset,
	//output reg [R - 1:0] ciclo,
	output pwm_out,
	output enable
	);
	
	
	//Contador de flanco positivo
	reg [R - 1:0] Q_reg;
	reg [R - 1:0] ciclo;
	reg [2:0]true =0;
			// Divisor de frecuecia
	//wire enable;
	reg [26:0] cfreq=0;
	assign enable = cfreq[1];
	always @(posedge clk) begin
			cfreq<=cfreq+1;
	end
	
	
	always @(posedge enable, negedge reset)
	begin
		if (~reset)
			Q_reg <= 'b0;
		else
		
		Q_reg <= Q_reg+1;
		
	end
	
	
	always @(*) begin
	if(Q_reg==255) true=true+1;	
	case(true)
			0: ciclo=8'b10111110; // F1C1
			1: ciclo=8'b11111111; // F1C2
			2: ciclo=8'b10001000; // F1C3
			3: ciclo=8'b10011001; // F1C4
			4: ciclo=8'b01100110; // F2C1
			5: ciclo=8'b00110011; // F2C2
			6: ciclo=8'b00000000; // F2C3
			7: ciclo=8'b10011001; // F2C4
			default:     ciclo=8'b00000000; // F1C1
		endcase
	end
	
	
	
	
	
	assign pwm_out = (Q_reg < ciclo);
	
endmodule	
	
