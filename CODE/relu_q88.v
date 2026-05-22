module relu_q88 (
    input signed [15:0] in_data,
    output signed [15:0] out_data
);
    assign out_data = (in_data[15] == 1'b1) ? 16'sd0 : in_data;
endmodule