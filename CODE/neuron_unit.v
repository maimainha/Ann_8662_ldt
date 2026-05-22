module neuron_unit (
    input clk,
    input rst_n,
    input en,
    input clr,
    input signed [15:0] x,
    input signed [15:0] w,
    input signed [15:0] b, 
    output signed [15:0] y 
);
    wire signed [15:0] sum_accumulated;

    mac_q88 mac_inst (
        .clk(clk), .rst_n(rst_n), .en(en), .clr(clr),
        .x(x), .w(w), .out_mac(sum_accumulated)
    );

    wire signed [15:0] pre_relu = sum_accumulated + b;

    relu_q88 relu_inst (
        .in_data(pre_relu),
        .out_data(y)
    );
endmodule