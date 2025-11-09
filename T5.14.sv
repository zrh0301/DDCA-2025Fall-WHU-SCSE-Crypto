module ALU #(parameter N=32) (
	input logic [N-1:0] a,
	input logic [N-1:0] b,
	input logic [2:0] ctrl,
	output logic [N-1:0] res,
	output logic zero,
	output logic overflow
);

logic [N-1:0] b_in;
logic [N-1:0] sum;
logic c;
logic addSub;

assign addSub = ctrl[0];
assign b_in = b^{N{addSub}};
assign {c,sum} = a+b_in+addSub;
assign overflow = (a[N-1]&b[N-1]&~sum[N-1]) | (~a[N-1]&~b[N-1]&sum[N-1]);

always_comb begin
	case(ctrl)
		3'b000: res = a&b;
		3'b001: res = a|b;
		3'b010: res = sum;
		3'b011: res = ~(a|b);
		3'b101: res = (sum==0)?0:1;
		3'b110: res = sum;
		3'b111: res = {{N-1{1'b0}},sum[N-1]};
		default: res = 0;
	endcase
end

assign zero = (res == 0);

endmodule