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
	assign enable = cfreq[10];
	always @(posedge clk) begin
			cfreq<=cfreq+1;
	end
	
	
	always @(posedge enable, negedge reset)
	begin
		if (~reset)
			Q_reg <= 'b0;
		else
		
		Q_reg <= Q_reg+1;
		true<=true+1;	
					
	end
	
	
	always @(*) begin
		if(true==0)
		ciclo<=8'b10111110;
		else if(true==1)
		ciclo<=8'b11111111;
		else if(true==2)
		ciclo<=8'b10001000;
		else if(true==3)
		ciclo<=8'b10011001;
		else if(true==4)
		ciclo<=8'b1100110;
		else if(true==5)
		ciclo<=8'b110011;
		else if(true==6)
		ciclo<=8'b0;
		else if(true==7)
		ciclo<=8'b10011001;
	end
	
	assign pwm_out = (Q_reg < ciclo);
	
endmodule	
	
