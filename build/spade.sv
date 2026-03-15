`ifdef COCOTB_SIM
    `define COCOTB_CODE(name) \
        string __top_module; \
        string __vcd_file; \
        initial begin \
            if ($value$plusargs("TOP_MODULE=%s", __top_module) && __top_module == `"name`" && $value$plusargs("VCD_FILENAME=%s", __vcd_file)) begin \
                $dumpfile (__vcd_file); \
                $dumpvars (0, \name ); \
            end \
        end
`else
    `define COCOTB_CODE(name)
`endif


module \std::cdc::sync2[954]  (
        input clk_i,
        input input_i,
        output output__
    );
    `COCOTB_CODE( std::cdc::sync2[954] )
    logic \clk ;
    assign \clk  = clk_i;
    logic \input ;
    assign \input  = input_i;
    (* src = "<compiler dir>/stdlib/cdc.spade:16,14" *)
    reg \sync1 ;
    (* src = "<compiler dir>/stdlib/cdc.spade:17,14" *)
    reg \sync2 ;
    always @(posedge \clk ) begin
        \sync1  <= \input ;
    end
    always @(posedge \clk ) begin
        \sync2  <= \sync1 ;
    end
    assign output__ = \sync2 ;
endmodule


module \std::cdc::sync2_bool  (
        input clk_i,
        input input_i,
        output output__
    );
    `COCOTB_CODE( std::cdc::sync2_bool )
    logic \clk ;
    assign \clk  = clk_i;
    logic \input ;
    assign \input  = input_i;
    (* src = "<compiler dir>/stdlib/cdc.spade:34,9" *)
    logic _e_137;
    (* src = "<compiler dir>/stdlib/cdc.spade:34,9" *)
    
    \std::cdc::sync2[954]  \sync2_0 (.clk_i(\clk ), .input_i(\input ), .output__(_e_137));
    assign output__ = _e_137;
endmodule


module \std::conv::concat_arrays[969]  (
        input[7:0] l_i,
        output[7:0] output__
    );
    `COCOTB_CODE( std::conv::concat_arrays[969] )
    logic[7:0] \l ;
    assign \l  = l_i;
    (* src = "<compiler dir>/stdlib/conv.spade:26,30" *)
    logic[7:0] _e_428;
    logic[7:0] _e_427;
    assign _e_428 = {\l };
    assign _e_427 = _e_428;
    assign output__ = _e_427;
endmodule


module \std::conv::concat_arrays[966]  (
        input[7:0] l_i,
        input[7:0] r_i,
        output[15:0] output__
    );
    `COCOTB_CODE( std::conv::concat_arrays[966] )
    logic[7:0] \l ;
    assign \l  = l_i;
    logic[7:0] \r ;
    assign \r  = r_i;
    (* src = "<compiler dir>/stdlib/conv.spade:26,30" *)
    logic[15:0] _e_428;
    logic[15:0] _e_427;
    assign _e_428 = {\r , \l };
    assign _e_427 = _e_428;
    assign output__ = _e_427;
endmodule


module \std::conv::concat_arrays[963]  (
        input[7:0] l_i,
        input[15:0] r_i,
        output[23:0] output__
    );
    `COCOTB_CODE( std::conv::concat_arrays[963] )
    logic[7:0] \l ;
    assign \l  = l_i;
    logic[15:0] \r ;
    assign \r  = r_i;
    (* src = "<compiler dir>/stdlib/conv.spade:26,30" *)
    logic[23:0] _e_428;
    logic[23:0] _e_427;
    assign _e_428 = {\r , \l };
    assign _e_427 = _e_428;
    assign output__ = _e_427;
endmodule


module \std::conv::concat_arrays[965]  (
        input[7:0] l_i,
        input[23:0] r_i,
        output[31:0] output__
    );
    `COCOTB_CODE( std::conv::concat_arrays[965] )
    logic[7:0] \l ;
    assign \l  = l_i;
    logic[23:0] \r ;
    assign \r  = r_i;
    (* src = "<compiler dir>/stdlib/conv.spade:26,30" *)
    logic[31:0] _e_428;
    logic[31:0] _e_427;
    assign _e_428 = {\r , \l };
    assign _e_427 = _e_428;
    assign output__ = _e_427;
endmodule


module \std::conv::tri_to_bool  (
        input b_i,
        output output__
    );
    `COCOTB_CODE( std::conv::tri_to_bool )
    logic \b ;
    assign \b  = b_i;
    logic _e_433;
    assign _e_433 = \b ;
    assign output__ = _e_433;
endmodule


module \std::conv::uint_to_bits[959]  (
        input[7:0] input_i,
        output[7:0] output__
    );
    `COCOTB_CODE( std::conv::uint_to_bits[959] )
    logic[7:0] \input ;
    assign \input  = input_i;
    logic[7:0] _e_471;
    assign _e_471 = \input ;
    assign output__ = _e_471;
endmodule


module \std::conv::clock_to_bool  (
        input c_i,
        output output__
    );
    `COCOTB_CODE( std::conv::clock_to_bool )
    logic \c ;
    assign \c  = c_i;
    logic _e_487;
    assign _e_487 = \c ;
    assign output__ = _e_487;
endmodule


module \std::conv::bool_to_clock  (
        input c_i,
        output output__
    );
    `COCOTB_CODE( std::conv::bool_to_clock )
    logic \c ;
    assign \c  = c_i;
    logic _e_491;
    assign _e_491 = \c ;
    assign output__ = _e_491;
endmodule


module \std::io::rising_edge  (
        input clk_i,
        input sync1_i,
        output output__
    );
    `COCOTB_CODE( std::io::rising_edge )
    logic \clk ;
    assign \clk  = clk_i;
    logic \sync1 ;
    assign \sync1  = sync1_i;
    (* src = "<compiler dir>/stdlib/io.spade:3,14" *)
    reg \sync2 ;
    (* src = "<compiler dir>/core/ops.spade:192,29" *)
    logic _e_1505;
    (* src = "<compiler dir>/core/ops.spade:192,9" *)
    logic _e_1504;
    (* src = "<compiler dir>/core/ops.spade:192,9" *)
    logic _e_1503;
    (* src = "<compiler dir>/core/ops.spade:234,29" *)
    logic _e_1513;
    (* src = "<compiler dir>/core/ops.spade:234,37" *)
    logic _e_1514;
    (* src = "<compiler dir>/core/ops.spade:234,9" *)
    logic _e_1512;
    (* src = "<compiler dir>/core/ops.spade:234,9" *)
    logic _e_1511;
    always @(posedge \clk ) begin
        \sync2  <= \sync1 ;
    end
    assign _e_1505 = {\sync2 };
    assign _e_1504 = ~_e_1505;
    assign _e_1503 = _e_1504;
    assign _e_1513 = {\sync1 };
    assign _e_1514 = {_e_1503};
    assign _e_1512 = _e_1513 & _e_1514;
    assign _e_1511 = _e_1512;
    assign output__ = _e_1511;
endmodule


module \std::io::falling_edge  (
        input clk_i,
        input sync1_i,
        output output__
    );
    `COCOTB_CODE( std::io::falling_edge )
    logic \clk ;
    assign \clk  = clk_i;
    logic \sync1 ;
    assign \sync1  = sync1_i;
    (* src = "<compiler dir>/stdlib/io.spade:9,14" *)
    reg \sync2 ;
    (* src = "<compiler dir>/core/ops.spade:192,29" *)
    logic _e_1523;
    (* src = "<compiler dir>/core/ops.spade:192,9" *)
    logic _e_1522;
    (* src = "<compiler dir>/core/ops.spade:192,9" *)
    logic _e_1521;
    (* src = "<compiler dir>/core/ops.spade:234,29" *)
    logic _e_1531;
    (* src = "<compiler dir>/core/ops.spade:234,37" *)
    logic _e_1532;
    (* src = "<compiler dir>/core/ops.spade:234,9" *)
    logic _e_1530;
    (* src = "<compiler dir>/core/ops.spade:234,9" *)
    logic _e_1529;
    always @(posedge \clk ) begin
        \sync2  <= \sync1 ;
    end
    assign _e_1523 = {\sync1 };
    assign _e_1522 = ~_e_1523;
    assign _e_1521 = _e_1522;
    assign _e_1531 = {\sync2 };
    assign _e_1532 = {_e_1521};
    assign _e_1530 = _e_1531 & _e_1532;
    assign _e_1529 = _e_1530;
    assign output__ = _e_1529;
endmodule


module \ttsky_verilog_template::design  (
        input clk_i,
        input rst_i,
        input[7:0] ui_in_i,
        output[7:0] output__
    );
    `COCOTB_CODE( ttsky_verilog_template::design )
    logic \clk ;
    assign \clk  = clk_i;
    logic \rst ;
    assign \rst  = rst_i;
    logic[7:0] \ui_in ;
    assign \ui_in  = ui_in_i;
    localparam[7:0] _e_1137 = 0;
    localparam[7:0] _e_1140 = 1;
    (* src = "src/main.spade:2,38" *)
    logic[7:0] _e_1138;
    (* src = "src/main.spade:2,14" *)
    reg[7:0] \counter ;
    (* src = "src/main.spade:2,38" *)
    
    \core::ops::impl#23::wrapping_add[953]  \wrapping_add_0 (.self_i(\counter ), .rhs_i(_e_1140), .output__(_e_1138));
    always @(posedge \clk ) begin
        if (\rst ) begin
            \counter  <= _e_1137;
        end
        else begin
            \counter  <= _e_1138;
        end
    end
    assign output__ = \counter ;
endmodule


module tt_um_your_design (
        input clk,
        input rst_n,
        input[7:0] ui_in,
        output[7:0] uo_out,
        input[7:0] uio_in,
        output[7:0] uio_out,
        output[7:0] uio_oe,
        input ena
    );
    `COCOTB_CODE( tt_um_your_design )
    logic[7:0] \uo_out_mut ;
    assign uo_out = \uo_out_mut ;
    logic[7:0] \uio_out_mut ;
    assign uio_out = \uio_out_mut ;
    logic[7:0] \uio_oe_mut ;
    assign uio_oe = \uio_oe_mut ;
    (* src = "<compiler dir>/core/ops.spade:192,29" *)
    logic _e_1541;
    (* src = "<compiler dir>/core/ops.spade:192,9" *)
    logic _e_1540;
    (* src = "<compiler dir>/core/ops.spade:192,9" *)
    logic \rst ;
    localparam[7:0] _e_1147 = 0;
    localparam[7:0] _e_1150 = 0;
    (* src = "src/main.spade:32,18" *)
    logic[7:0] \output ;
    (* src = "src/main.spade:34,19" *)
    logic[7:0] _e_1158;
    assign _e_1541 = {\rst_n };
    assign _e_1540 = ~_e_1541;
    assign \rst  = _e_1540;
    assign \uio_out_mut  = _e_1147;
    assign \uio_oe_mut  = _e_1150;
    (* src = "src/main.spade:32,18" *)
    
    \ttsky_verilog_template::design  \design_0 (.clk_i(\clk ), .rst_i(\rst ), .ui_in_i(\ui_in ), .output__(\output ));
    (* src = "src/main.spade:34,19" *)
    
    \std::conv::impl#4::to_bits[957]  \to_bits_0 (.self_i(\output ), .output__(_e_1158));
    assign \uo_out_mut  = _e_1158;
    
endmodule


module \std::conv::impl#2::to_uint  (
        input self_i,
        output output__
    );
    `COCOTB_CODE( std::conv::impl#2::to_uint )
    logic \self ;
    assign \self  = self_i;
    logic _e_501;
    assign _e_501 = \self ;
    assign output__ = _e_501;
endmodule


module \std::conv::impl#2::to_int  (
        input self_i,
        output output__
    );
    `COCOTB_CODE( std::conv::impl#2::to_int )
    logic \self ;
    assign \self  = self_i;
    logic _e_505;
    assign _e_505 = \self ;
    assign output__ = _e_505;
endmodule


module \std::conv::impl#4::to_bits[957]  (
        input[7:0] self_i,
        output[7:0] output__
    );
    `COCOTB_CODE( std::conv::impl#4::to_bits[957] )
    logic[7:0] \self ;
    assign \self  = self_i;
    (* src = "<compiler dir>/stdlib/conv.spade:167,9" *)
    logic[7:0] _e_517;
    (* src = "<compiler dir>/stdlib/conv.spade:167,9" *)
    
    \std::conv::uint_to_bits[959]  \uint_to_bits_0 (.input_i(\self ), .output__(_e_517));
    assign output__ = _e_517;
endmodule


module \std::conv::impl#5::to_be_bytes  (
        input[15:0] self_i,
        output[15:0] output__
    );
    `COCOTB_CODE( std::conv::impl#5::to_be_bytes )
    logic[15:0] \self ;
    assign \self  = self_i;
    localparam[15:0] _e_524 = 8;
    (* src = "<compiler dir>/stdlib/conv.spade:176,16" *)
    logic[15:0] _e_522;
    (* src = "<compiler dir>/stdlib/conv.spade:176,10" *)
    logic[7:0] _e_521;
    (* src = "<compiler dir>/stdlib/conv.spade:176,28" *)
    logic[7:0] _e_525;
    (* src = "<compiler dir>/stdlib/conv.spade:176,9" *)
    logic[15:0] _e_520;
    assign _e_522 = \self  >> _e_524;
    assign _e_521 = _e_522[7:0];
    assign _e_525 = \self [7:0];
    assign _e_520 = {_e_525, _e_521};
    assign output__ = _e_520;
endmodule


module \std::conv::impl#5::to_le_bytes  (
        input[15:0] self_i,
        output[15:0] output__
    );
    `COCOTB_CODE( std::conv::impl#5::to_le_bytes )
    logic[15:0] \self ;
    assign \self  = self_i;
    (* src = "<compiler dir>/stdlib/conv.spade:182,31" *)
    logic[15:0] _e_529;
    (* src = "<compiler dir>/stdlib/conv.spade:44,9" *)
    logic[7:0] _e_1550;
    (* src = "<compiler dir>/stdlib/conv.spade:44,50" *)
    logic[7:0] _e_1552;
    (* src = "<compiler dir>/stdlib/conv.spade:44,9" *)
    logic[7:0] _e_1576;
    (* src = "<compiler dir>/stdlib/conv.spade:44,9" *)
    logic[7:0] result_n1;
    (* src = "<compiler dir>/stdlib/conv.spade:44,9" *)
    logic[15:0] result_n2;
    (* src = "<compiler dir>/stdlib/conv.spade:182,31" *)
    
    \std::conv::impl#5::to_be_bytes  \to_be_bytes_0 (.self_i(\self ), .output__(_e_529));
    assign _e_1550 = _e_529[15-:8];
    assign _e_1552 = _e_529[7-:8];
    assign _e_1576 = _e_1552;
    
    
    (* src = "<compiler dir>/stdlib/conv.spade:44,9" *)
    
    \std::conv::concat_arrays[969]  \concat_arrays_0 (.l_i(_e_1576), .output__(result_n1));
    (* src = "<compiler dir>/stdlib/conv.spade:44,9" *)
    
    \std::conv::concat_arrays[966]  \concat_arrays_1 (.l_i(_e_1550), .r_i(result_n1), .output__(result_n2));
    assign output__ = result_n2;
endmodule


module \std::conv::impl#6::to_be_bytes  (
        input[23:0] self_i,
        output[23:0] output__
    );
    `COCOTB_CODE( std::conv::impl#6::to_be_bytes )
    logic[23:0] \self ;
    assign \self  = self_i;
    localparam[23:0] _e_536 = 16;
    (* src = "<compiler dir>/stdlib/conv.spade:190,16" *)
    logic[23:0] _e_534;
    (* src = "<compiler dir>/stdlib/conv.spade:190,10" *)
    logic[7:0] _e_533;
    localparam[23:0] _e_540 = 8;
    (* src = "<compiler dir>/stdlib/conv.spade:190,35" *)
    logic[23:0] _e_538;
    (* src = "<compiler dir>/stdlib/conv.spade:190,29" *)
    logic[7:0] _e_537;
    (* src = "<compiler dir>/stdlib/conv.spade:190,47" *)
    logic[7:0] _e_541;
    (* src = "<compiler dir>/stdlib/conv.spade:190,9" *)
    logic[23:0] _e_532;
    assign _e_534 = \self  >> _e_536;
    assign _e_533 = _e_534[7:0];
    assign _e_538 = \self  >> _e_540;
    assign _e_537 = _e_538[7:0];
    assign _e_541 = \self [7:0];
    assign _e_532 = {_e_541, _e_537, _e_533};
    assign output__ = _e_532;
endmodule


module \std::conv::impl#6::to_le_bytes  (
        input[23:0] self_i,
        output[23:0] output__
    );
    `COCOTB_CODE( std::conv::impl#6::to_le_bytes )
    logic[23:0] \self ;
    assign \self  = self_i;
    (* src = "<compiler dir>/stdlib/conv.spade:196,31" *)
    logic[23:0] _e_545;
    (* src = "<compiler dir>/stdlib/conv.spade:44,9" *)
    logic[7:0] _e_1629;
    (* src = "<compiler dir>/stdlib/conv.spade:44,50" *)
    logic[15:0] _e_1631;
    (* src = "<compiler dir>/stdlib/conv.spade:44,9" *)
    logic[7:0] _e_1655;
    (* src = "<compiler dir>/stdlib/conv.spade:44,50" *)
    logic[7:0] _e_1657;
    (* src = "<compiler dir>/stdlib/conv.spade:44,9" *)
    logic[7:0] _e_1691;
    (* src = "<compiler dir>/stdlib/conv.spade:44,9" *)
    logic[7:0] result_n1;
    (* src = "<compiler dir>/stdlib/conv.spade:44,9" *)
    logic[15:0] result_n2;
    (* src = "<compiler dir>/stdlib/conv.spade:44,9" *)
    logic[23:0] result_n3;
    (* src = "<compiler dir>/stdlib/conv.spade:196,31" *)
    
    \std::conv::impl#6::to_be_bytes  \to_be_bytes_0 (.self_i(\self ), .output__(_e_545));
    assign _e_1629 = _e_545[23-:8];
    assign _e_1631 = _e_545[15-:16];
    assign _e_1655 = _e_1631[15-:8];
    assign _e_1657 = _e_1631[7-:8];
    assign _e_1691 = _e_1657;
    
    
    (* src = "<compiler dir>/stdlib/conv.spade:44,9" *)
    
    \std::conv::concat_arrays[969]  \concat_arrays_0 (.l_i(_e_1691), .output__(result_n1));
    (* src = "<compiler dir>/stdlib/conv.spade:44,9" *)
    
    \std::conv::concat_arrays[966]  \concat_arrays_1 (.l_i(_e_1655), .r_i(result_n1), .output__(result_n2));
    (* src = "<compiler dir>/stdlib/conv.spade:44,9" *)
    
    \std::conv::concat_arrays[963]  \concat_arrays_2 (.l_i(_e_1629), .r_i(result_n2), .output__(result_n3));
    assign output__ = result_n3;
endmodule


module \std::conv::impl#7::to_be_bytes  (
        input[31:0] self_i,
        output[31:0] output__
    );
    `COCOTB_CODE( std::conv::impl#7::to_be_bytes )
    logic[31:0] \self ;
    assign \self  = self_i;
    localparam[31:0] _e_552 = 32'd24;
    (* src = "<compiler dir>/stdlib/conv.spade:204,16" *)
    logic[31:0] _e_550;
    (* src = "<compiler dir>/stdlib/conv.spade:204,10" *)
    logic[7:0] _e_549;
    localparam[31:0] _e_556 = 32'd16;
    (* src = "<compiler dir>/stdlib/conv.spade:204,35" *)
    logic[31:0] _e_554;
    (* src = "<compiler dir>/stdlib/conv.spade:204,29" *)
    logic[7:0] _e_553;
    localparam[31:0] _e_560 = 32'd8;
    (* src = "<compiler dir>/stdlib/conv.spade:204,54" *)
    logic[31:0] _e_558;
    (* src = "<compiler dir>/stdlib/conv.spade:204,48" *)
    logic[7:0] _e_557;
    (* src = "<compiler dir>/stdlib/conv.spade:204,66" *)
    logic[7:0] _e_561;
    (* src = "<compiler dir>/stdlib/conv.spade:204,9" *)
    logic[31:0] _e_548;
    assign _e_550 = \self  >> _e_552;
    assign _e_549 = _e_550[7:0];
    assign _e_554 = \self  >> _e_556;
    assign _e_553 = _e_554[7:0];
    assign _e_558 = \self  >> _e_560;
    assign _e_557 = _e_558[7:0];
    assign _e_561 = \self [7:0];
    assign _e_548 = {_e_561, _e_557, _e_553, _e_549};
    assign output__ = _e_548;
endmodule


module \std::conv::impl#7::to_le_bytes  (
        input[31:0] self_i,
        output[31:0] output__
    );
    `COCOTB_CODE( std::conv::impl#7::to_le_bytes )
    logic[31:0] \self ;
    assign \self  = self_i;
    (* src = "<compiler dir>/stdlib/conv.spade:210,31" *)
    logic[31:0] _e_565;
    (* src = "<compiler dir>/stdlib/conv.spade:44,9" *)
    logic[7:0] _e_1759;
    (* src = "<compiler dir>/stdlib/conv.spade:44,50" *)
    logic[23:0] _e_1761;
    (* src = "<compiler dir>/stdlib/conv.spade:44,9" *)
    logic[7:0] _e_1785;
    (* src = "<compiler dir>/stdlib/conv.spade:44,50" *)
    logic[15:0] _e_1787;
    (* src = "<compiler dir>/stdlib/conv.spade:44,9" *)
    logic[7:0] _e_1821;
    (* src = "<compiler dir>/stdlib/conv.spade:44,50" *)
    logic[7:0] _e_1823;
    (* src = "<compiler dir>/stdlib/conv.spade:44,9" *)
    logic[7:0] _e_1867;
    (* src = "<compiler dir>/stdlib/conv.spade:44,9" *)
    logic[7:0] result_n1;
    (* src = "<compiler dir>/stdlib/conv.spade:44,9" *)
    logic[15:0] result_n2;
    (* src = "<compiler dir>/stdlib/conv.spade:44,9" *)
    logic[23:0] result_n3;
    (* src = "<compiler dir>/stdlib/conv.spade:44,9" *)
    logic[31:0] result_n4;
    (* src = "<compiler dir>/stdlib/conv.spade:210,31" *)
    
    \std::conv::impl#7::to_be_bytes  \to_be_bytes_0 (.self_i(\self ), .output__(_e_565));
    assign _e_1759 = _e_565[31-:8];
    assign _e_1761 = _e_565[23-:24];
    assign _e_1785 = _e_1761[23-:8];
    assign _e_1787 = _e_1761[15-:16];
    assign _e_1821 = _e_1787[15-:8];
    assign _e_1823 = _e_1787[7-:8];
    assign _e_1867 = _e_1823;
    
    
    (* src = "<compiler dir>/stdlib/conv.spade:44,9" *)
    
    \std::conv::concat_arrays[969]  \concat_arrays_0 (.l_i(_e_1867), .output__(result_n1));
    (* src = "<compiler dir>/stdlib/conv.spade:44,9" *)
    
    \std::conv::concat_arrays[966]  \concat_arrays_1 (.l_i(_e_1821), .r_i(result_n1), .output__(result_n2));
    (* src = "<compiler dir>/stdlib/conv.spade:44,9" *)
    
    \std::conv::concat_arrays[963]  \concat_arrays_2 (.l_i(_e_1785), .r_i(result_n2), .output__(result_n3));
    (* src = "<compiler dir>/stdlib/conv.spade:44,9" *)
    
    \std::conv::concat_arrays[965]  \concat_arrays_3 (.l_i(_e_1759), .r_i(result_n3), .output__(result_n4));
    assign output__ = result_n4;
endmodule


module \core::ops::impl#23::wrapping_add[953]  (
        input[7:0] self_i,
        input[7:0] rhs_i,
        output[7:0] output__
    );
    `COCOTB_CODE( core::ops::impl#23::wrapping_add[953] )
    logic[7:0] \self ;
    assign \self  = self_i;
    logic[7:0] \rhs ;
    assign \rhs  = rhs_i;
    (* src = "<compiler dir>/core/ops.spade:103,62" *)
    logic[8:0] _e_1219;
    logic[8:0] \bits ;
    (* src = "<compiler dir>/core/ops.spade:104,34" *)
    logic[7:0] _e_1224;
    logic[7:0] _e_1223;
    assign _e_1219 = \self  + \rhs ;
    assign \bits  = _e_1219;
    assign _e_1224 = \bits [7-:8];
    assign _e_1223 = _e_1224;
    assign output__ = _e_1223;
endmodule

`default_nettype none