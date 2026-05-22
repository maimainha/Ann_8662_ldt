module layer2_6to6 (
    input clk,
    input rst_n,
    input en,
    input clr,
    input [3:0] count,
    input signed [95:0] in_h1,
    output signed [95:0] out_h2
);
    wire signed [15:0] in_h1_arr [0:5];
    assign in_h1_arr[0] = in_h1[15:0];
    assign in_h1_arr[1] = in_h1[31:16];
    assign in_h1_arr[2] = in_h1[47:32];
    assign in_h1_arr[3] = in_h1[63:48];
    assign in_h1_arr[4] = in_h1[79:64];
    assign in_h1_arr[5] = in_h1[95:80];

    wire signed [15:0] q_w2 [0:5];
    wire signed [15:0] q_b2 [0:5];

    rom_w2 r_w2_0 (.addr(count + 6'd0),  .q(q_w2[0]));
    rom_w2 r_w2_1 (.addr(count + 6'd6),  .q(q_w2[1]));
    rom_w2 r_w2_2 (.addr(count + 6'd12), .q(q_w2[2]));
    rom_w2 r_w2_3 (.addr(count + 6'd18), .q(q_w2[3]));
    rom_w2 r_w2_4 (.addr(count + 6'd24), .q(q_w2[4]));
    rom_w2 r_w2_5 (.addr(count + 6'd30), .q(q_w2[5]));

    rom_b2 r_b2_0 (.addr(3'd0), .q(q_b2[0]));
    rom_b2 r_b2_1 (.addr(3'd1), .q(q_b2[1]));
    rom_b2 r_b2_2 (.addr(3'd2), .q(q_b2[2]));
    rom_b2 r_b2_3 (.addr(3'd3), .q(q_b2[3]));
    rom_b2 r_b2_4 (.addr(3'd4), .q(q_b2[4]));
    rom_b2 r_b2_5 (.addr(3'd5), .q(q_b2[5]));

    wire signed [15:0] h2 [0:5];
    neuron_unit u_l2_0 (.clk(clk), .rst_n(rst_n), .en(en), .clr(clr), .x(in_h1_arr[count]), .w(q_w2[0]), .b(q_b2[0]), .y(h2[0]));
    neuron_unit u_l2_1 (.clk(clk), .rst_n(rst_n), .en(en), .clr(clr), .x(in_h1_arr[count]), .w(q_w2[1]), .b(q_b2[1]), .y(h2[1]));
    neuron_unit u_l2_2 (.clk(clk), .rst_n(rst_n), .en(en), .clr(clr), .x(in_h1_arr[count]), .w(q_w2[2]), .b(q_b2[2]), .y(h2[2]));
    neuron_unit u_l2_3 (.clk(clk), .rst_n(rst_n), .en(en), .clr(clr), .x(in_h1_arr[count]), .w(q_w2[3]), .b(q_b2[3]), .y(h2[3]));
    neuron_unit u_l2_4 (.clk(clk), .rst_n(rst_n), .en(en), .clr(clr), .x(in_h1_arr[count]), .w(q_w2[4]), .b(q_b2[4]), .y(h2[4]));
    neuron_unit u_l2_5 (.clk(clk), .rst_n(rst_n), .en(en), .clr(clr), .x(in_h1_arr[count]), .w(q_w2[5]), .b(q_b2[5]), .y(h2[5]));

    assign out_h2[15:0]  = h2[0];
    assign out_h2[31:16] = h2[1];
    assign out_h2[47:32] = h2[2];
    assign out_h2[63:48] = h2[3];
    assign out_h2[79:64] = h2[4];
    assign out_h2[95:80] = h2[5];
endmodule