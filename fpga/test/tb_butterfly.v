`timescale 1ns/1ps
module tb_butterfly;
    reg  [11:0] a, b, zeta;
    wire [11:0] a_out, b_out;

    butterfly dut (.a(a), .b(b), .zeta(zeta), .a_out(a_out), .b_out(b_out));

    // golden: t=zeta*b%q; a_out=(a+t)%q; b_out=(a-t+q)%q
    task check;
        input [11:0] ta, tb, tz;
        integer t, exp_a, exp_b;
        begin
            a=ta; b=tb; zeta=tz; #1;
            t = (tz*tb) % 3329;
            exp_a = (ta + t) % 3329;
            exp_b = (ta - t + 3329) % 3329;
            if (a_out!==exp_a || b_out!==exp_b)
                $display("FAIL a=%0d b=%0d z=%0d : got(%0d,%0d) exp(%0d,%0d)",
                          ta,tb,tz,a_out,b_out,exp_a,exp_b);
            else
                $display("ok   a=%0d b=%0d z=%0d -> (%0d,%0d)",
                          ta,tb,tz,a_out,b_out);
        end
    endtask

    integer i;
    initial begin
        check(0,0,1);
        check(1,1,1);
        check(3328,3328,1729);
        check(100,200,17);
        for (i=0;i<20;i=i+1)
            check($random%3329, $random%3329, $random%3329);
        $finish;
    end
endmodule