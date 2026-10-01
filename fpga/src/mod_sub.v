// c = (a-b) mod q, q = 3329
//add q first so the intermediate never underflows (stays unsigned) 

// conditional sub: a,q < q --> a + q - b is in [1, 2q]

// combinational 

module mod_sub(
    input wire [11:0] a, 
    input wire [11:0] b,
    output wire [11:0] c
); 

    localparam [12:0] Q = 13'd3329; 

    wire [12:0] diff = (a + Q) - b;     //13-bit: in [1,2q] = [1, 6658], never negative 
    wire [12:0] sub = diff - Q;         //diff - Q

    // if diff >= q, result is diff - q; else diff. 
    assign c = (diff >= Q) ? sub[11:0] : diff[11:0]; 

endmodule