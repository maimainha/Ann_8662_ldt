module rom_w2 (input [5:0] addr, output reg signed [15:0] q);
    reg signed [15:0] mem [0:35]; 
    initial $readmemh("w2_hex.txt", mem);
    always @(*) q = mem[addr];
endmodule