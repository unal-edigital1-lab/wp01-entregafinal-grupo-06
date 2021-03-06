`timescale 1ns / 1ps

module BancoRegistro #( 
         parameter BIT_ADDR = 4,  //   BIT_ADDR Número de bit para la dirección
         parameter BIT_DATO = 3, //		longitud dato: 2**BIT_DATO 
         parameter MEMORYREG ="C:/Users/equip/Documents/GitHub/wp01-testvga-grupo-6/Final/memDir.men"//Dirección de la memoria de los valores iniciales.
	)
	(
    input [BIT_ADDR-1:0] addrR,
    input [BIT_ADDR-1:0] addrW,
    input RegWrite,
    input clk,
    input rst,
    output [BIT_DATO-1:0] datOutR);

localparam NREG = 2 ** BIT_ADDR; // Cantidad de registros es igual a:
  
reg [BIT_DATO-1: 0] breg [NREG-1:0]; // Instanciar banco de registro 

assign  datOutR = breg[addrR]; //El dato de lectura corresponde al dato de la posición correspondiente del banco

reg [BIT_ADDR: 0] i;
localparam datRST= 0;
/* Cuando se ha pulsado RegWrite, en este caso corresponde al wire opr del top, se enciende, rst deberia de ser 0 y se aumenta en 1 el banco de registro en la 
posición indicada por el addrW, correspondiente al posT del top.

Cuando se pulsa rst, y este es de valor 1, se asignan todas las posiciones de memoria a un valor datRST=0, que va a corresponder a blanco.

*/
always @(negedge RegWrite or posedge rst) begin
      if(rst)begin
      for(i=0;i<NREG;i=i+1) 
         breg[i] <= datRST;  
      end else
     breg[addrW] <= breg[addrW]+1;
  end

// Lectura inicial de la memoria, utilizando el archivo que se carga en los parámetros del bloque.
initial begin  
   $readmemb(MEMORYREG, breg);
end   

endmodule

