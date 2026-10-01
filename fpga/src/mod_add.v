// c = (a + b) mod q, q = 3329
// both inputs are field elements  q, so a + b < 2q --> at most one subtraction

// Combinational only 

module mod_add(
    input wire [11:0] a,
    input wire [11:0] b,
    output wire [11:0] c 
);

    localparam [12:0] Q = 13'd3329; 

    wire [12:0] sum = a + b;    // 13-bit: max 3328+3328 = 6656 < 2^13
    wire [12:0] sub = sum - Q; // sum - q

    //if sum >= q, result is sum - q; else sum. 
    assign c = (sum >= Q) ? sub[11:0] : sum[11:0];
endmodule