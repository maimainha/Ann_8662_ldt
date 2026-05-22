module rom_b3 (input [0:0] addr, output reg signed [15:0] q);
    reg signed [15:0] mem [0:1];  
    initial $readmemh("b3_hex.txt", mem);
    always @(*) q = mem[addr];
endmodule