`timescale 10ps/1ps

module tb_unsigned_cmp;

    logic C;
    logic Z;
    logic HS;
    logic LS;
    logic HI;
    logic LO;

    unsigned_cmp dut (
        .C(C),
        .Z(Z),
        .HS(HS),
        .LS(LS),
        .HI(HI),
        .LO(LO)
    );

    initial begin
        $display("C Z | HS LS HI LO");
        $display("---------------");

        for (int i = 0; i < 4; i++) begin
            C = i[1];  
            Z = i[0];  
            #1;        
            $display("%b %b |  %b  %b  %b  %b", C, Z, HS, LS, HI, LO);
        end

        $finish;
    end

endmodule
