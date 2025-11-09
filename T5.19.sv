module unsigned_cmp(
	input logic C,
	input logic Z,
	output logic HS,
	output logic LS,
	output logic HI,
	output logic LO
);

assign HS = C;
assign LO = ~C;
assign HI = C&~Z;
assign LS = ~C|Z;

endmodule