`timescale 10ps/1ps

module tb_ALU();

parameter N = 32;

logic [N-1:0] A,B,res;
logic [2:0] ctrl;
logic zero,overflow;

ALU #(N) dut(
	.a(A),
	.b(B),
	.res(res),
	.ctrl(ctrl),
	.zero(zero),
	.overflow(overflow)
);
task print_result(string op);
       $display("[%0t] %s: A=%0d, B=%0d -> Result=%0d, Zero=%b, Overflow=%b",
                 $time, op, A, B, res, zero, overflow);
endtask

initial begin
        $display("==== ALU test ====");

        // AND
        A = 32'd15; B = 32'd9; ctrl = 3'b000;
        #5; print_result("AND");

        // OR
        A = 32'd15; B = 32'd9; ctrl = 3'b001;
        #5; print_result("OR");

        // ADD
        A = 32'd100; B = 32'd23; ctrl = 3'b010;
        #5; print_result("ADD");

        // SUB
        A = 32'd100; B = 32'd23; ctrl = 3'b110;
        #5; print_result("SUB");

        // SUB negative
        A = 32'd23; B = 32'd100; ctrl = 3'b110;
        #5; print_result("SUB (负数)");

        // SLT (A<B)
        A = 32'd10; B = 32'd20; ctrl = 3'b111;
        #5; print_result("SLT");

        // SLT (A>B)
        A = 32'd20; B = 32'd10; ctrl = 3'b111;
        #5; print_result("SLT");

        // NOR
        A = 32'h0F0F; B = 32'h00FF; ctrl = 3'b011;
        #5; print_result("NOR");

        // test Zero
        A = 32'd0; B = 32'd0; ctrl = 3'b101;
        #5; print_result("ZeroExtend");

        $display("==== test end ====");
        $finish;
    end

endmodule