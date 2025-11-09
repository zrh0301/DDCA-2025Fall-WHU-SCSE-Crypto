module fmul(
    input  logic [31:0] a,
    input  logic [31:0] b,
    output logic [31:0] y
);

    logic [7:0]  ea, eb;
    logic [22:0] fa, fb;
    logic        sa, sb;
    assign sa = a[31];
    assign sb = b[31];
    assign ea = a[30:23];
    assign eb = b[30:23];
    assign fa = a[22:0];
    assign fb = b[22:0];

    logic [23:0] ma, mb;
    assign ma = (ea == 8'd0) ? 24'd0 : {1'b1, fa};
    assign mb = (eb == 8'd0) ? 24'd0 : {1'b1, fb};
    //calc new m (48 bits)
    logic [47:0] p;
    assign p = ma * mb;

    //calc new e (max 9 bits)
    localparam int BIAS = 127;
    logic signed [9:0] e_sum_signed;
    assign e_sum_signed = $signed({2'b00,ea}) + $signed({2'b00,eb}) - BIAS;

    //trans to IEEE
    logic        p47;
    assign p47 = p[47];

    //trans e
    logic signed [9:0] e_norm;
    assign e_norm = p47 ? (e_sum_signed + 1) : e_sum_signed;

    //overflow
    logic [7:0] exp_out;
    logic [22:0] frac_out;
    
    logic [47:0] p_shifted;
    assign p_shifted = p47 ? (p >> 1) : p;

    logic [22:0] frac_field;
    assign frac_field = p_shifted[45:23]; // truncation -> towards zero

    always_comb begin
        exp_out = 8'd0;
        frac_out = 23'd0;

        if ((ma == 24'd0) || (mb == 24'd0)) begin
            exp_out = 8'd0;
            frac_out = 23'd0;
        end
        else begin
            if (e_norm <= 0) begin
                exp_out = 8'd0;
                frac_out = 23'd0;
            end
            else if (e_norm >= 255) begin
                exp_out = 8'd255;
                frac_out = 23'd0;
            end
            else begin
                exp_out = e_norm[7:0];
                frac_out = frac_field;
            end
        end
    end

    logic s_out;
    assign s_out = sa ^ sb;

    assign y = { s_out, exp_out, frac_out };

endmodule
