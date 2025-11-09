module signed_cmp(
	input logic N,
	input logic Z,
	input logic V,
	output logic GT,
	output logic LT,
	output logic GE,
	output logic LE
);

assign GT = (~N^V) & ~Z;
assign LT = (N^V);
assign GE = ~(N^V);
assign LE = (N^V) | Z;

endmodule