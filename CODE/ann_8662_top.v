module ann_8662_top (
    input clk,
    input rst_n,
    input start,                        
    input signed [127:0] in_x,          
    output reg signed [15:0] y1_score,  
    output reg signed [15:0] y2_class,  
    output reg done                     
);

    parameter S_IDLE   = 3'd0;
    parameter S_LAYER1 = 3'd1;
    parameter S_LAYER2 = 3'd2;
    parameter S_OUTPUT = 3'd3;
    parameter S_FINISH = 3'd4;

    reg [2:0] state;
    reg [3:0] count; 

    // Các đường dây kết nối đa tầng
    wire signed [95:0] h1_out;
    wire signed [95:0] h2_out;
    wire signed [31:0] final_y;

    reg signed [95:0] reg_h1;
    reg signed [95:0] reg_h2;

    wire en_l1 = (state == S_LAYER1);
    wire en_l2 = (state == S_LAYER2);
    wire en_l3 = (state == S_OUTPUT);
    wire clr_all = (state == S_IDLE);

    // KẾT NỐI PHÂN CẤP LỚP (Mỗi lớp là một khối cực đẹp trong RTL)
    layer1_8to6 Layer_1 (
        .clk(clk), .rst_n(rst_n), .en(en_l1), .clr(clr_all), 
        .count(count), .in_x(in_x), .out_h1(h1_out)
    );

    layer2_6to6 Layer_2 (
        .clk(clk), .rst_n(rst_n), .en(en_l2), .clr(clr_all), 
        .count(count), .in_h1(reg_h1), .out_h2(h2_out)
    );

    layer3_6to2 Layer_3 (
        .clk(clk), .rst_n(rst_n), .en(en_l3), .clr(clr_all), 
        .count(count), .in_h2(reg_h2), .out_y(final_y)
    );

    // Khối điều khiển chuyển đổi trạng thái FSM tuần tự
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_IDLE;
            done <= 0;
            count <= 0;
            reg_h1 <= 96'd0;
            reg_h2 <= 96'd0;
            y1_score <= 16'd0;
            y2_class <= 16'd0;
        end else begin
            case (state)
                S_IDLE: begin
                    done <= 0;
                    count <= 0;
                    if (start) state <= S_LAYER1;
                end

                S_LAYER1: begin
                    if (count == 4'd8) begin
                        state <= S_LAYER2;
                        count <= 0;
                        reg_h1 <= h1_out; // Chốt kết quả Layer 1 vào Pipeline Register
                    end else count <= count + 1;
                end

                S_LAYER2: begin
                    if (count == 4'd6) begin
                        state <= S_OUTPUT;
                        count <= 0;
                        reg_h2 <= h2_out; // Chốt kết quả Layer 2 vào Pipeline Register
                    end else count <= count + 1;
                end

                S_OUTPUT: begin
                    if (count == 4'd6) begin
                        state <= S_FINISH;
                        count <= 0;
                    end else count <= count + 1;
                end

                S_FINISH: begin
                    y1_score <= final_y[15:0];
                    y2_class <= final_y[31:16];
                    done <= 1;
                    state <= S_IDLE;
                end
                default: state <= S_IDLE;
            endcase
        end
    end
endmodule