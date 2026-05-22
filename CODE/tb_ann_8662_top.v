// =============================================================================
// MODULE KIỂM THỬ: TESTBENCH MÔ PHỎNG KIỂM CHỨNG TOÀN DIỆN VỚI 20 MẪU THỬ
// ĐỒNG BỘ HOÀN TOÀN VỚI CẤU TRÚC PHÂN CẤP MỚI TRÊN QUESTASIM
// =============================================================================
`timescale 1ns/1ps

module tb_ann_top();
    reg clk;
    reg rst_n;
    reg start;
    reg signed [127:0] tb_in_x; // Bus phẳng chứa 8 ngõ vào đóng gói
    
    wire signed [15:0] y1_score;
    wire signed [15:0] y2_class;
    wire done;

    // Gọi đúng Module Top phân cấp mới
    ann_8662_top dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .in_x(tb_in_x),
        .y1_score(y1_score),
        .y2_class(y2_class),
        .done(done)
    );

    // Tạo xung Clock hệ thống 50MHz (Chu kỳ 20ns)
    initial clk = 0;
    always #10 clk = ~clk;

    // Task tiện ích nạp dữ liệu nhanh và chốt mẫu
    task send_sample(
        input signed [15:0] x0, input signed [15:0] x1,
        input signed [15:0] x2, input signed [15:0] x3,
        input signed [15:0] x4, input signed [15:0] x5,
        input signed [15:0] x6, input signed [15:0] x7
    );
        begin
            tb_in_x = {x7, x6, x5, x4, x3, x2, x1, x0}; // Đóng gói 128-bit
            start = 1;
            #20; // Giữ start đúng 1 chu kỳ clock
            start = 0;
            @(posedge done); // Chờ bộ FSM tính toán xong
            #40; // Nghỉ nhẹ trước khi nạp mẫu kế tiếp
        end
    endtask

    // Vận hành quá trình quét tự động 20 mẫu thử nghiệm khác nhau
    initial begin
        // --- KHỞI TẠO BAN ĐẦU ---
        rst_n = 0;
        start = 0;
        tb_in_x = 0;
        #85;
        rst_n = 1;
        #40;

        $display("========================================================================");
        $display("        BAT DAU MO PHONG QUET TU DONG 20 MAU THU NGHIEM (GD2)          ");
        $display("========================================================================");

        // --- NHÓM MẪU CHẤT LƯỢNG CAO (Y1 > 4.0đ -> MONG ĐỢI Y2 >= 128 -> ĐẠT) ---
        $display("\n>>> [NHOM 1]: KIEM THU MAU CHAT LUONG TOT");
        
        // Mẫu 1: X = [1.5, 2.0, 1.0, 3.0, 0.5, 2.5, 1.0, 1.5]
        send_sample(16'sd384, 16'sd512, 16'sd256, 16'sd768, 16'sd128, 16'sd640, 16'sd256, 16'sd384);
        $display("Mau 01 | Y1 (Diem): %4d (~%0.2f d) | Y2 (Dat): %4d -> KET LUAN: %s", 
                 y1_score, $itor(y1_score)/256.0, y2_class, (y2_class >= 128) ? "DAT (PASS)" : "KHONG DAT (FAIL)");

        // Mẫu 2: Toàn bộ đầu vào dương cực lớn
        send_sample(16'sd1280, 16'sd1536, 16'sd1024, 16'sd1280, 16'sd768, 16'sd1024, 16'sd512, 16'sd1280);
        $display("Mau 02 | Y1 (Diem): %4d (~%0.2f d) | Y2 (Dat): %4d -> KET LUAN: %s", 
                 y1_score, $itor(y1_score)/256.0, y2_class, (y2_class >= 128) ? "DAT (PASS)" : "KHONG DAT (FAIL)");

        // Mẫu 3: Giá trị đồng đều tốt
        send_sample(16'sd512, 16'sd512, 16'sd512, 16'sd512, 16'sd512, 16'sd512, 16'sd512, 16'sd512);
        $display("Mau 03 | Y1 (Diem): %4d (~%0.2f d) | Y2 (Dat): %4d -> KET LUAN: %s", 
                 y1_score, $itor(y1_score)/256.0, y2_class, (y2_class >= 128) ? "DAT (PASS)" : "KHONG DAT (FAIL)");

        // Mẫu 4: Cận trên tối đa
        send_sample(16'sd2048, 16'sd2048, 16'sd2048, 16'sd2048, 16'sd2048, 16'sd2048, 16'sd2048, 16'sd2048);
        $display("Mau 04 | Y1 (Diem): %4d (~%0.2f d) | Y2 (Dat): %4d -> KET LUAN: %s", 
                 y1_score, $itor(y1_score)/256.0, y2_class, (y2_class >= 128) ? "DAT (PASS)" : "KHONG DAT (FAIL)");

        // Mẫu 5: Có chút dao động nhẹ nhưng vẫn tốt
        send_sample(16'sd256, 16'sd768, 16'sd512, 16'sd1024, 16'sd384, 16'sd768, 16'sd512, 16'sd512);
        $display("Mau 05 | Y1 (Diem): %4d (~%0.2f d) | Y2 (Dat): %4d -> KET LUAN: %s", 
                 y1_score, $itor(y1_score)/256.0, y2_class, (y2_class >= 128) ? "DAT (PASS)" : "KHONG DAT (FAIL)");


        // --- NHÓM MẪU TRUNG BÌNH CẬN BIÊN (Y2 DAO ĐỘNG QUANH NGƯỠNG 128) ---
        $display("\n>>> [NHOM 2]: KIEM THU MAU CAN BIEN Q9.8 (Y2 ~ 128)");
        
        // Mẫu 6: Đầu vào nhỏ, điểm rơi tầm trung
        send_sample(16'sd128, 16'sd256, 16'sd128, 16'sd256, 16'sd128, 16'sd256, 16'sd128, 16'sd128);
        $display("Mau 06 | Y1 (Diem): %4d (~%0.2f d) | Y2 (Dat): %4d -> KET LUAN: %s", 
                 y1_score, $itor(y1_score)/256.0, y2_class, (y2_class >= 128) ? "DAT (PASS)" : "KHONG DAT (FAIL)");

        // Mẫu 7: Giá trị lùi dần
        send_sample(16'sd256, 16'sd128, 16'sd64, 16'sd32, 16'sd16, 16'sd8, 16'sd0, 16'sd0);
        $display("Mau 07 | Y1 (Diem): %4d (~%0.2f d) | Y2 (Dat): %4d -> KET LUAN: %s", 
                 y1_score, $itor(y1_score)/256.0, y2_class, (y2_class >= 128) ? "DAT (PASS)" : "KHONG DAT (FAIL)");

        // Mẫu 8: Cận biên đạt (y2 vừa lớn hơn 128)
        send_sample(16'sd300, 16'sd300, 16'sd300, 16'sd100, 16'sd100, 16'sd100, 16'sd50, 16'sd50);
        $display("Mau 08 | Y1 (Diem): %4d (~%0.2f d) | Y2 (Dat): %4d -> KET LUAN: %s", 
                 y1_score, $itor(y1_score)/256.0, y2_class, (y2_class >= 128) ? "DAT (PASS)" : "KHONG DAT (FAIL)");

        // Mẫu 9: Cận biên không đạt (y2 vừa nhỏ hơn 128 một chút)
        send_sample(16'sd150, 16'sd150, 16'sd100, 16'sd50, 16'sd50, 16'sd0, 16'sd0, 16'sd0);
        $display("Mau 09 | Y1 (Diem): %4d (~%0.2f d) | Y2 (Dat): %4d -> KET LUAN: %s", 
                 y1_score, $itor(y1_score)/256.0, y2_class, (y2_class >= 128) ? "DAT (PASS)" : "KHONG DAT (FAIL)");

        // Mẫu 10: Xoay quanh giá trị 0
        send_sample(16'sd0, 16'sd50, -16'sd50, 16'sd100, -16'sd100, 16'sd150, -16'sd150, 16'sd0);
        $display("Mau 10 | Y1 (Diem): %4d (~%0.2f d) | Y2 (Dat): %4d -> KET LUAN: %s", 
                 y1_score, $itor(y1_score)/256.0, y2_class, (y2_class >= 128) ? "DAT (PASS)" : "KHONG DAT (FAIL)");


        // --- NHÓM MẪU CHẤT LƯỢNG KÉM (TRỊ SỐ ÂM, RELU CHẶN, Y1, Y2 VỀ SẠCH 0) ---
        $display("\n>>> [NHOM 3]: KIEM THU MAU KEM (Y1 & Y2 -> KHONG DAT)");
        
        // Mẫu 11: Số âm cực lớn
        send_sample(-16'sd1024, -16'sd1536, -16'sd1024, -16'sd1280, -16'sd768, -16'sd1024, -16'sd512, -16'sd1280);
        $display("Mau 11 | Y1 (Diem): %4d (~%0.2f d) | Y2 (Dat): %4d -> KET LUAN: %s", 
                 y1_score, $itor(y1_score)/256.0, y2_class, (y2_class >= 128) ? "DAT (PASS)" : "KHONG DAT (FAIL)");

        // Mẫu 12: Nhiễu âm lớn xen kẽ số dương bé
        send_sample(16'sd128, -16'sd1024, 16'sd128, -16'sd512, 16'sd64, -16'sd256, 16'sd0, -16'sd128);
        $display("Mau 12 | Y1 (Diem): %4d (~%0.2f d) | Y2 (Dat): %4d -> KET LUAN: %s", 
                 y1_score, $itor(y1_score)/256.0, y2_class, (y2_class >= 128) ? "DAT (PASS)" : "KHONG DAT (FAIL)");

        // Mẫu 13: Toàn bộ ngõ vào triệt tiêu về 0
        send_sample(16'sd0, 16'sd0, 16'sd0, 16'sd0, 16'sd0, 16'sd0, 16'sd0, 16'sd0);
        $display("Mau 13 | Y1 (Diem): %4d (~%0.2f d) | Y2 (Dat): %4d -> KET LUAN: %s", 
                 y1_score, $itor(y1_score)/256.0, y2_class, (y2_class >= 128) ? "DAT (PASS)" : "KHONG DAT (FAIL)");

        // Mẫu 14: Một vài nơ-ron âm kéo sập cả lớp
        send_sample(16'sd1024, 16'sd1024, 16'sd1024, 16'sd1024, -16'sd2048, -16'sd2048, -16'sd2048, -16'sd2048);
        $display("Mau 14 | Y1 (Diem): %4d (~%0.2f d) | Y2 (Dat): %4d -> KET LUAN: %s", 
                 y1_score, $itor(y1_score)/256.0, y2_class, (y2_class >= 128) ? "DAT (PASS)" : "KHONG DAT (FAIL)");

        // Mẫu 15: Giảm biên sâu
        send_sample(-16'sd256, -16'sd128, -16'sd64, -16'sd32, -16'sd16, -16'sd8, -16'sd4, -16'sd2);
        $display("Mau 15 | Y1 (Diem): %4d (~%0.2f d) | Y2 (Dat): %4d -> KET LUAN: %s", 
                 y1_score, $itor(y1_score)/256.0, y2_class, (y2_class >= 128) ? "DAT (PASS)" : "KHONG DAT (FAIL)");


        // --- NHÓM MẪU STRESS TEST (KIỂM TRA ĐỘ BỀN GIỚI HẠN) ---
        $display("\n>>> [NHOM 4]: KIEM THU STRESS TEST (STRESS TEST)");
        
        // Mẫu 16: Trọng số phân tách xen kẽ biên
        send_sample(16'sd2048, -16'sd2048, 16'sd2048, -16'sd2048, 16'sd1024, -16'sd1024, 16'sd512, -16'sd512);
        $display("Mau 16 | Y1 (Diem): %4d (~%0.2f d) | Y2 (Dat): %4d -> KET LUAN: %s", 
                 y1_score, $itor(y1_score)/256.0, y2_class, (y2_class >= 128) ? "DAT (PASS)" : "KHONG DAT (FAIL)");

        // Mẫu 17: Đầu vào cực nhỏ nhưng dương (kiểm tra độ nhạy thập phân)
        send_sample(16'sd4, 16'sd8, 16'sd12, 16'sd16, 16'sd4, 16'sd8, 16'sd12, 16'sd16);
        $display("Mau 17 | Y1 (Diem): %4d (~%0.2f d) | Y2 (Dat): %4d -> KET LUAN: %s", 
                 y1_score, $itor(y1_score)/256.0, y2_class, (y2_class >= 128) ? "DAT (PASS)" : "KHONG DAT (FAIL)");

        // Mẫu 18: Đầu vào bão hòa dương cực đại (9.0 * 256 = 2304)
        send_sample(16'sd2304, 16'sd2304, 16'sd2304, 16'sd2304, 16'sd2304, 16'sd2304, 16'sd2304, 16'sd2304);
        $display("Mau 18 | Y1 (Diem): %4d (~%0.2f d) | Y2 (Dat): %4d -> KET LUAN: %s", 
                 y1_score, $itor(y1_score)/256.0, y2_class, (y2_class >= 128) ? "DAT (PASS)" : "KHONG DAT (FAIL)");

        // Mẫu 19: Đầu vào bão hòa âm cực tiểu (-9.0 * 256 = -2304)
        send_sample(-16'sd2304, -16'sd2304, -16'sd2304, -16'sd2304, -16'sd2304, -16'sd2304, -16'sd2304, -16'sd2304);
        $display("Mau 19 | Y1 (Diem): %4d (~%0.2f d) | Y2 (Dat): %4d -> KET LUAN: %s", 
                 y1_score, $itor(y1_score)/256.0, y2_class, (y2_class >= 128) ? "DAT (PASS)" : "KHONG DAT (FAIL)");

        // Mẫu 20: Trường hợp ngẫu nhiên biến thiên mạnh
        send_sample(16'sd1280, -16'sd512, 16'sd768, -16'sd1024, 16'sd512, -16'sd256, 16'sd1536, -16'sd1536);
        $display("Mau 20 | Y1 (Diem): %4d (~%0.2f d) | Y2 (Dat): %4d -> KET LUAN: %s", 
                 y1_score, $itor(y1_score)/256.0, y2_class, (y2_class >= 128) ? "DAT (PASS)" : "KHONG DAT (FAIL)");

        $display("\n========================================================================");
        $display("               DA QUET XONG TOAN BO 20 MAU KIEM THU (GD2)               ");
        $display("========================================================================");
        $stop;
    end
endmodule