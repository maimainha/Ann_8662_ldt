`timescale 1ns/1ps

module tb_neuron;

    reg clk;
    reg rst_n;
    reg en;
    reg clr;

    reg signed [15:0] x;
    reg signed [15:0] w;
    reg signed [15:0] b;

    wire signed [15:0] y;

    neuron_unit dut (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .clr(clr),
        .x(x),
        .w(w),
        .b(b),
        .y(y)
    );

    // Clock 20ns
    always #10 clk = ~clk;

    initial begin

        clk = 0;
        rst_n = 0;
        en = 0;
        clr = 0;

        x = 16'd256;   // 1.0 Q8.8
        w = 16'd512;   // 2.0 Q8.8
        b = 16'd128;   // 0.5 Q8.8

        #20;
        rst_n = 1;

        #20;
        en = 1;

        #200;

        $stop;

    end

endmodule