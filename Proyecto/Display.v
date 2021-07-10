module Display(
	output [0:6] sseg,
	output reg [3:0] an,
	input wire [3:0] numA,
	output reg [3:0] posicion, 
	input clk);

reg [3:0]bcd;


//Bloque a 7-seg
BCDtoSSeg bcdtosseg(.BCD(bcd), .SSeg(sseg));

// Divisor de frecuecia
wire enable;
reg [26:0] cfreq=0;
assign enable = cfreq[16];
always @(posedge clk) begin
		cfreq<=cfreq+1;
end


assign bcd=numA[3:0]

//logica secuencial cambio de valores en display
reg [1:0] count=0;
always @(posedge enable) begin	 
		count<= count+1;
		an<=4'b1101; 
		case (count) 
			2'h0: begin posicion<=3;   an<=4'b1110; end 
			2'h1: begin posicion<=7;   an<=4'b1101; end 
			2'h2: begin posicion<11;   an<=4'b1011; end 
			2'h3: begin posicion<=15;   an<=4'b0111; end 	
		endcase
end

endmodule

