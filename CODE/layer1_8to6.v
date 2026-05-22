module layer1_8to6 (
    input clk,
    input rst_n,
    input en,
    input clr,
    input [3:0] count,
    input signed [127:0] in_x,
    output signed [95:0] out_h1
);
    wire signed [15:0] in_x_arr [0:7];
    assign in_x_arr[0] = in_x[15:0];
    assign in_x_arr[1] = in_x[31:16];
    assign in_x_arr[2] = in_x[47:32];
    assign in_x_arr[3] = in_x[63:48];
    assign in_x_arr[4] = in_x[79:64];
    assign in_x_arr[5] = in_x[95:80];
    assign in_x_arr[6] = in_x[111:96];
    assign in_x_arr[7] = in_x[127:112];

    wire signed [15:0] q_w1 [0:5];
    wire signed [15:0] q_b1 [0:5];

    rom_w1 r_w1_0 (.addr(count + 6'd0),  .q(q_w1[0]));
    rom_w1 r_w1_1 (.addr(count + 6'd8),  .q(q_w1[1]));
    rom_w1 r_w1_2 (.addr(count + 6'd16), .q(q_w1[2]));
    rom_w1 r_w1_3 (.addr(count + 6'd24), .q(q_w1[3]));
    rom_w1 r_w1_4 (.addr(count + 6'd32), .q(q_w1[4]));
    rom_w1 r_w1_5 (.addr(count + 6'd40), .q(q_w1[5]));

    rom_b1 r_b1_0 (.addr(3'd0), .q(q_b1[0]));
    rom_b1 r_b1_1 (.addr(3'd1), .q(q_b1[1]));
    rom_b1 r_b1_2 (.addr(3'd2), .q(q_b1[2]));
    rom_b1 r_b1_3 (.addr(3'd3), .q(q_b1[3]));
    rom_b1 r_b1_4 (.addr(3'd4), .q(q_b1[4]));
    rom_b1 r_b1_5 (.addr(3'd5), .q(q_b1[5]));

    wire signed [15:0] h1 [0:5];
    neuron_unit u_l1_0 (.clk(clk), .rst_n(rst_n), .en(en), .clr(clr), .x(in_x_arr[count]), .w(q_w1[0]), .b(q_b1[0]), .y(h1[0]));
    neuron_unit u_l1_1 (.clk(clk), .rst_n(rst_n), .en(en), .clr(clr), .x(in_x_arr[count]), .w(q_w1[1]), .b(q_b1[1]), .y(h1[1]));
    neuron_unit u_l1_2 (.clk(clk), .rst_n(rst_n), .en(en), .clr(clr), .x(in_x_arr[count]), .w(q_w1[2]), .b(q_b1[2]), .y(h1[2]));
    neuron_unit u_l1_3 (.clk(clk), .rst_n(rst_n), .en(en), .clr(clr), .x(in_x_arr[count]), .w(q_w1[3]), .b(q_b1[3]), .y(h1[3]));
    neuron_unit u_l1_4 (.clk(clk), .rst_n(rst_n), .en(en), .clr(clr), .x(in_x_arr[count]), .w(q_w1[4]), .b(q_b1[4]), .y(h1[4]));
    neuron_unit u_l1_5 (.clk(clk), .rst_n(rst_n), .en(en), .clr(clr), .x(in_x_arr[count]), .w(q_w1[5]), .b(q_b1[5]), .y(h1[5]));

    assign out_h1[15:0]  = h1[0];
    assign out_h1[31:16] = h1[1];
    assign out_h1[47:32] = h1[2];
    assign out_h1[63:48] = h1[3];
    assign out_h1[79:64] = h1[4];
    assign out_h1[95:80] = h1[5];
endmodule