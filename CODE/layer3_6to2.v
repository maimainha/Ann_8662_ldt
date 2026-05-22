module layer3_6to2 (
    input clk,
    input rst_n,
    input en,
    input clr,
    input [3:0] count,
    input signed [95:0] in_h2,
    output signed [31:0] out_y
);
    wire signed [15:0] in_h2_arr [0:5];
    assign in_h2_arr[0] = in_h2[15:0];
    assign in_h2_arr[1] = in_h2[31:16];
    assign in_h2_arr[2] = in_h2[47:32];
    assign in_h2_arr[3] = in_h2[63:48];
    assign in_h2_arr[4] = in_h2[79:64];
    assign in_h2_arr[5] = in_h2[95:80];

    wire signed [15:0] q_w3 [0:1];
    wire signed [15:0] q_b3 [0:1];

    rom_w3 r_w3_0 (.addr(count + 4'd0), .q(q_w3[0]));
    rom_w3 r_w3_1 (.addr(count + 4'd6), .q(q_w3[1]));

    rom_b3 r_b3_0 (.addr(1'd0), .q(q_b3[0]));
    rom_b3 r_b3_1 (.addr(1'd1), .q(q_b3[1]));

    wire signed [15:0] final_y [0:1];
    neuron_unit u_l3_0 (.clk(clk), .rst_n(rst_n), .en(en), .clr(clr), .x(in_h2_arr[count]), .w(q_w3[0]), .b(q_b3[0]), .y(final_y[0]));
    neuron_unit u_l3_1 (.clk(clk), .rst_n(rst_n), .en(en), .clr(clr), .x(in_h2_arr[count]), .w(q_w3[1]), .b(q_b3[1]), .y(final_y[1]));

    assign out_y[15:0]  = final_y[0];
    assign out_y[31:16] = final_y[1];
endmodule