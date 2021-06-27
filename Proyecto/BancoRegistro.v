`timescale 1ns / 1ps

module BancoRegistro #(      		 //   #( Parametros
			//parameter MEMORYREG ="./reg16.men",
         parameter BIT_ADDR = 4,  //   BIT_ADDR Número de bit para la dirección
         parameter BIT_DATO = 3,
         parameter MEMORYREG ="C:/Users/equip/Documents/GitHub/wp01-testvga-grupo-6/Proyecto/memDir.men"
			//parameter MEMORYREG ="C:/Users/andre/Documents/GitHub/wp01-testvga-grupo-6/Proyecto/memDir.men"
	)
	(
    input [BIT_ADDR-1:0] addrR,
    input [BIT_ADDR-1:0] addrW,
    input RegWrite,
    input clk,
    input rst,
    output [BIT_DATO-1:0] datOutR);

// La cantdiad de registros es igual a: 
localparam NREG = 2 ** BIT_ADDR;
localparam datRST= 0;
  
//configiración del banco de registro 
reg [BIT_DATO-1: 0] breg [NREG-1:0];

assign  datOutR = breg[addrR];

reg [BIT_ADDR: 0] i;
wire enable;
reg [26:0] cfreq=0;

assign enable = cfreq[5];
always @(posedge clk) begin
		cfreq<=cfreq+1;
end

//cambiar clk a enable para implementacion en fpga
always @(posedge RegWrite) begin
	/*if (rst)
    for(i=0;i<NREG;i=i+1)begin
     breg[i] <= datRST; 
    end*/ 
    //else if (RegWrite)
     breg[addrW] <= breg[addrW]+1;
  end

initial begin  
   $readmemb(MEMORYREG, breg);
end   

endmodule

