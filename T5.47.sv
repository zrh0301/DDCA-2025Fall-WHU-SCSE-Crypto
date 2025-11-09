module f_add(
	input logic [31:0] a,b,
	output logic [31:0] res
);

logic [7:0] exp_a,exp_b;
logic [23:0] m_a,m_b;

assign exp_a = a[30:23];
assign exp_b = b[30:23];
assign m_a = {1'b1,a[22:0]};
assign m_b = {1'b1,b[22:0]};

logic [7:0] exp_diff;
logic [23:0] m_a_aligned,m_b_shifted;
assign exp_diff = (exp_a > exp_b) ? (exp_a - exp_b) : (exp_b - exp_a);
assign m_b_shifted = (exp_a > exp_b) ? (m_b >> exp_diff) : m_b;
assign m_a_aligned = (exp_a > exp_b) ? m_a : (m_a >> exp_diff);

logic [24:0] m_sum;
assign m_sum = m_a_aligned + m_b_shifted;

logic [23:0] m_norm;
logic [7:0] exp_res;
always_comb begin
    if (m_sum[24]) begin
        m_norm = m_sum[24:1]; 
        exp_res = ((exp_a > exp_b)?exp_a:exp_b) + 1;
    end 
    else begin
        m_norm = m_sum[23:0];
        exp_res = (exp_a > exp_b)?exp_a:exp_b;
    end
end

assign res = {1'b0,exp_res,m_norm[22:0]};

endmodule