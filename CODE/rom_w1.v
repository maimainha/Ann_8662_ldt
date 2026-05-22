module rom_w1 (input [5:0] addr, output reg signed [15:0] q);
    reg signed [15:0] mem [0:47]; 
    initial $readmemh("w1_hex.txt", mem);
    always @(*) q = mem[addr];
endmodule