`timescale 1ns / 1ps

module hand_60dir #(
    parameter LEN   = 100,
    parameter WIDTH = 3
)(
    input  wire signed [10:0] x,
    input  wire signed [10:0] y,
    input  wire [5:0]         pos,
    output wire               hand
);

    reg signed [9:0] dx;
    reg signed [9:0] dy;

    always @(*) begin
        case (pos)
            6'd0:  begin dx = 10'sd0;    dy = -10'sd128; end
            6'd1:  begin dx = 10'sd13;   dy = -10'sd127; end
            6'd2:  begin dx = 10'sd27;   dy = -10'sd125; end
            6'd3:  begin dx = 10'sd40;   dy = -10'sd122; end
            6'd4:  begin dx = 10'sd52;   dy = -10'sd117; end
            6'd5:  begin dx = 10'sd64;   dy = -10'sd111; end
            6'd6:  begin dx = 10'sd75;   dy = -10'sd104; end
            6'd7:  begin dx = 10'sd86;   dy = -10'sd95;  end
            6'd8:  begin dx = 10'sd95;   dy = -10'sd86;  end
            6'd9:  begin dx = 10'sd104;  dy = -10'sd75;  end
            6'd10: begin dx = 10'sd111;  dy = -10'sd64;  end
            6'd11: begin dx = 10'sd117;  dy = -10'sd52;  end
            6'd12: begin dx = 10'sd122;  dy = -10'sd40;  end
            6'd13: begin dx = 10'sd125;  dy = -10'sd27;  end
            6'd14: begin dx = 10'sd127;  dy = -10'sd13;  end
            6'd15: begin dx = 10'sd128;  dy = 10'sd0;    end
            6'd16: begin dx = 10'sd127;  dy = 10'sd13;   end
            6'd17: begin dx = 10'sd125;  dy = 10'sd27;   end
            6'd18: begin dx = 10'sd122;  dy = 10'sd40;   end
            6'd19: begin dx = 10'sd117;  dy = 10'sd52;   end
            6'd20: begin dx = 10'sd111;  dy = 10'sd64;   end
            6'd21: begin dx = 10'sd104;  dy = 10'sd75;   end
            6'd22: begin dx = 10'sd95;   dy = 10'sd86;   end
            6'd23: begin dx = 10'sd86;   dy = 10'sd95;   end
            6'd24: begin dx = 10'sd75;   dy = 10'sd104;  end
            6'd25: begin dx = 10'sd64;   dy = 10'sd111;  end
            6'd26: begin dx = 10'sd52;   dy = 10'sd117;  end
            6'd27: begin dx = 10'sd40;   dy = 10'sd122;  end
            6'd28: begin dx = 10'sd27;   dy = 10'sd125;  end
            6'd29: begin dx = 10'sd13;   dy = 10'sd127;  end
            6'd30: begin dx = 10'sd0;    dy = 10'sd128;  end
            6'd31: begin dx = -10'sd13;  dy = 10'sd127;  end
            6'd32: begin dx = -10'sd27;  dy = 10'sd125;  end
            6'd33: begin dx = -10'sd40;  dy = 10'sd122;  end
            6'd34: begin dx = -10'sd52;  dy = 10'sd117;  end
            6'd35: begin dx = -10'sd64;  dy = 10'sd111;  end
            6'd36: begin dx = -10'sd75;  dy = 10'sd104;  end
            6'd37: begin dx = -10'sd86;  dy = 10'sd95;   end
            6'd38: begin dx = -10'sd95;  dy = 10'sd86;   end
            6'd39: begin dx = -10'sd104; dy = 10'sd75;   end
            6'd40: begin dx = -10'sd111; dy = 10'sd64;   end
            6'd41: begin dx = -10'sd117; dy = 10'sd52;   end
            6'd42: begin dx = -10'sd122; dy = 10'sd40;   end
            6'd43: begin dx = -10'sd125; dy = 10'sd27;   end
            6'd44: begin dx = -10'sd127; dy = 10'sd13;   end
            6'd45: begin dx = -10'sd128; dy = 10'sd0;    end
            6'd46: begin dx = -10'sd127; dy = -10'sd13;  end
            6'd47: begin dx = -10'sd125; dy = -10'sd27;  end
            6'd48: begin dx = -10'sd122; dy = -10'sd40;  end
            6'd49: begin dx = -10'sd117; dy = -10'sd52;  end
            6'd50: begin dx = -10'sd111; dy = -10'sd64;  end
            6'd51: begin dx = -10'sd104; dy = -10'sd75;  end
            6'd52: begin dx = -10'sd95;  dy = -10'sd86;  end
            6'd53: begin dx = -10'sd86;  dy = -10'sd95;  end
            6'd54: begin dx = -10'sd75;  dy = -10'sd104; end
            6'd55: begin dx = -10'sd64;  dy = -10'sd111; end
            6'd56: begin dx = -10'sd52;  dy = -10'sd117; end
            6'd57: begin dx = -10'sd40;  dy = -10'sd122; end
            6'd58: begin dx = -10'sd27;  dy = -10'sd125; end
            6'd59: begin dx = -10'sd13;  dy = -10'sd127; end
            default: begin dx = 10'sd0; dy = -10'sd128; end
        endcase
    end

    wire signed [23:0] dot_tmp   = x * dx + y * dy;
    wire signed [23:0] cross_tmp = x * dy - y * dx;

    wire [23:0] cross_abs = cross_tmp[23] ? -cross_tmp : cross_tmp;

    wire in_front = (dot_tmp >= 0);
    wire in_len   = (dot_tmp <= (LEN * 128));
    wire in_width = (cross_abs <= (WIDTH * 128));

    assign hand = in_front && in_len && in_width;

endmodule
