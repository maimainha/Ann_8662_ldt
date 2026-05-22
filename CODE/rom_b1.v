module rom_b1 (input [2:0] addr, output reg signed [15:0] q);
    reg signed [15:0] mem [0:5];  
    initial $readmemh("b1_hex.txt", mem);
    always @(*) q = mem[addr];
endmodule