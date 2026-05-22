module rom_w3 (input [3:0] addr, output reg signed [15:0] q);
    reg signed [15:0] mem [0:11]; 
    initial $readmemh("w3_hex.txt", mem);
    always @(*) q = mem[addr];
endmodule