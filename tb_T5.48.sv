`timescale 10ps / 1ps

module tb_fmul();

  // === 信号声明 ===
  logic [31:0] a, b;
  logic [31:0] result;
  logic clk;

  // === 实例化被测模块 ===
  fmul dut (
    .a(a),
    .b(b),
    .y(result)
  );

  // === 时钟生成 ===
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // === 测试输入 ===
  initial begin
    // 声明必须写在语句前面
    a = 32'h3F800000;  // 1.0
    b = 32'h40000000;  // 2.0
    #10;
    $display("1.0 * 2.0 = %h (expected 0x40000000)", result);

    a = 32'h40400000;  // 3.0
    b = 32'h40800000;  // 4.0
    #10;
    $display("3.0 * 4.0 = %h (expected 0x41400000)", result);

    #10;
    $finish;
  end

endmodule
