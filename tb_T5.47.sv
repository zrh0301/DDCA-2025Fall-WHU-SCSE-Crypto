`timescale 10ps/1ps

module tb_f_add;

    logic [31:0] a, b, res;

    f_add dut(.a(a), .b(b), .res(res));

    initial begin
        // 例如 3.5 + 2.25
        a = 32'h40600000; // 3.5
        b = 32'h40120000; // 2.25
        #1;
        $display("a=%h b=%h res=%h", a, b, res);
        // 期望结果 5.75 -> 0x40b80000

        // 测试 1.0 + 1.0
        a = 32'h3f800000; // 1.0
        b = 32'h3f800000; // 1.0
        #1;
        $display("a=%h b=%h res=%h", a, b, res);
        // 期望结果 2.0 -> 0x40000000

        $finish;
    end

endmodule
