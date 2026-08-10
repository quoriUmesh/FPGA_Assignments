`timescale 1ns/1ps

module fft_tb;

    localparam DATA_WIDTH = 16;
    localparam FRAC_BITS  = 15;
    localparam ACC_WIDTH  = 20;

    reg  signed [DATA_WIDTH-1:0] x0_re, x0_im, x1_re, x1_im;
    reg  signed [DATA_WIDTH-1:0] x2_re, x2_im, x3_re, x3_im;
    reg  signed [DATA_WIDTH-1:0] x4_re, x4_im, x5_re, x5_im;
    reg  signed [DATA_WIDTH-1:0] x6_re, x6_im, x7_re, x7_im;

    wire signed [ACC_WIDTH-1:0] X0_re, X0_im, X1_re, X1_im;
    wire signed [ACC_WIDTH-1:0] X2_re, X2_im, X3_re, X3_im;
    wire signed [ACC_WIDTH-1:0] X4_re, X4_im, X5_re, X5_im;
    wire signed [ACC_WIDTH-1:0] X6_re, X6_im, X7_re, X7_im;

    integer k;
    real pi = 3.14159265358979;
    real xin [0:7];
    real scale;

    fft8 #(
        .DATA_WIDTH(DATA_WIDTH),
        .FRAC_BITS(FRAC_BITS),
        .ACC_WIDTH(ACC_WIDTH)
    ) uut (
        .x0_re(x0_re), .x0_im(x0_im),
        .x1_re(x1_re), .x1_im(x1_im),
        .x2_re(x2_re), .x2_im(x2_im),
        .x3_re(x3_re), .x3_im(x3_im),
        .x4_re(x4_re), .x4_im(x4_im),
        .x5_re(x5_re), .x5_im(x5_im),
        .x6_re(x6_re), .x6_im(x6_im),
        .x7_re(x7_re), .x7_im(x7_im),

        .X0_re(X0_re), .X0_im(X0_im),
        .X1_re(X1_re), .X1_im(X1_im),
        .X2_re(X2_re), .X2_im(X2_im),
        .X3_re(X3_re), .X3_im(X3_im),
        .X4_re(X4_re), .X4_im(X4_im),
        .X5_re(X5_re), .X5_im(X5_im),
        .X6_re(X6_re), .X6_im(X6_im),
        .X7_re(X7_re), .X7_im(X7_im)
    );

    initial begin
        // VCD dump - open fft8_fixed.vcd in gtkwave after the run.
        $dumpfile("fft.vcd");
        $dumpvars(0, fft_tb);

        scale = 2.0 ** FRAC_BITS;

        // ---- Vector 1 (t=0..10ns): cosine at bin 1 ----
        for (k = 0; k < 8; k = k + 1)
            xin[k] = $cos(2.0*pi*k*1.0/8.0);
        x0_re = $rtoi(xin[0]*scale); x0_im = 0;
        x1_re = $rtoi(xin[1]*scale); x1_im = 0;
        x2_re = $rtoi(xin[2]*scale); x2_im = 0;
        x3_re = $rtoi(xin[3]*scale); x3_im = 0;
        x4_re = $rtoi(xin[4]*scale); x4_im = 0;
        x5_re = $rtoi(xin[5]*scale); x5_im = 0;
        x6_re = $rtoi(xin[6]*scale); x6_im = 0;
        x7_re = $rtoi(xin[7]*scale); x7_im = 0;
        #10;

        // ---- Vector 2 (t=10..20ns): unit impulse ----
        x0_re = $rtoi(1.0*scale); x0_im = 0;
        x1_re = 0; x1_im = 0;
        x2_re = 0; x2_im = 0;
        x3_re = 0; x3_im = 0;
        x4_re = 0; x4_im = 0;
        x5_re = 0; x5_im = 0;
        x6_re = 0; x6_im = 0;
        x7_re = 0; x7_im = 0;
        #10;

        // ---- Vector 3 (t=20..30ns): cosine at bin 2 ----
        for (k = 0; k < 8; k = k + 1)
            xin[k] = $cos(2.0*pi*k*2.0/8.0);
        x0_re = $rtoi(xin[0]*scale); x0_im = 0;
        x1_re = $rtoi(xin[1]*scale); x1_im = 0;
        x2_re = $rtoi(xin[2]*scale); x2_im = 0;
        x3_re = $rtoi(xin[3]*scale); x3_im = 0;
        x4_re = $rtoi(xin[4]*scale); x4_im = 0;
        x5_re = $rtoi(xin[5]*scale); x5_im = 0;
        x6_re = $rtoi(xin[6]*scale); x6_im = 0;
        x7_re = $rtoi(xin[7]*scale); x7_im = 0;
        #10;

        $finish;
    end

endmodule