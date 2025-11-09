`timescale 10ps/1ps

module tb_signed_cmp;
    logic N, Z, V;
    logic GE, LE, GT, LT;

    
    signed_cmp uut (
        .N(N), .Z(Z), .V(V),
        .GE(GE), .LE(LE), .GT(GT), .LT(LT)
    );

    initial begin
        $display("N Z V | GE LE GT LT");
        $display("-------------------");

        
        for (int i=0; i<8; i++) begin
            {N,Z,V} = i;
            #1;
            $display("%b %b %b | %b  %b  %b  %b", N, Z, V, GE, LE, GT, LT);
        end

        $finish;
    end
endmodule
