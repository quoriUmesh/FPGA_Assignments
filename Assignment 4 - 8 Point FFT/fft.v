module fft8 #(
    parameter DATA_WIDTH = 16,   // input word width (Q1.15)
    parameter FRAC_BITS  = 15,   // fractional bits (same for input & acc)
    parameter ACC_WIDTH  = 20    // internal/output width (Q5.15), growth headroom
)(
    input  signed [DATA_WIDTH-1:0] x0_re, x0_im,
    input  signed [DATA_WIDTH-1:0] x1_re, x1_im,
    input  signed [DATA_WIDTH-1:0] x2_re, x2_im,
    input  signed [DATA_WIDTH-1:0] x3_re, x3_im,
    input  signed [DATA_WIDTH-1:0] x4_re, x4_im,
    input  signed [DATA_WIDTH-1:0] x5_re, x5_im,
    input  signed [DATA_WIDTH-1:0] x6_re, x6_im,
    input  signed [DATA_WIDTH-1:0] x7_re, x7_im,

    output reg signed [ACC_WIDTH-1:0] X0_re, X0_im,
    output reg signed [ACC_WIDTH-1:0] X1_re, X1_im,
    output reg signed [ACC_WIDTH-1:0] X2_re, X2_im,
    output reg signed [ACC_WIDTH-1:0] X3_re, X3_im,
    output reg signed [ACC_WIDTH-1:0] X4_re, X4_im,
    output reg signed [ACC_WIDTH-1:0] X5_re, X5_im,
    output reg signed [ACC_WIDTH-1:0] X6_re, X6_im,
    output reg signed [ACC_WIDTH-1:0] X7_re, X7_im
);

    localparam PROD_WIDTH = ACC_WIDTH + DATA_WIDTH;

    // 0.70710678118654752440 * 2^15, rounded  (Q1.15)
    localparam signed [DATA_WIDTH-1:0] COS45 = 16'sd23170;

    // ---- sign-extend a DATA_WIDTH input up to ACC_WIDTH ----
    function signed [ACC_WIDTH-1:0] sext(input signed [DATA_WIDTH-1:0] d);
        sext = {{(ACC_WIDTH-DATA_WIDTH){d[DATA_WIDTH-1]}}, d};
    endfunction

    // ---- multiply an ACC_WIDTH value by the constant 0.7071, ----
    // ---- with rounding, rescaled back to ACC_WIDTH/Q5.15     ----
    function signed [ACC_WIDTH-1:0] mulW(input signed [ACC_WIDTH-1:0] d);
        reg signed [PROD_WIDTH-1:0] prod;
        reg signed [PROD_WIDTH-1:0] rounded;
        begin
            prod    = d * COS45;
            rounded = prod + (1 <<< (FRAC_BITS-1));   // round-to-nearest
            mulW    = rounded >>> FRAC_BITS;           // arithmetic shift back to Q5.15
        end
    endfunction

    // Stage 1 outputs (size-2 butterflies, twiddle = W8^0 = 1)
    reg signed [ACC_WIDTH-1:0] a0_re, a0_im, a1_re, a1_im;
    reg signed [ACC_WIDTH-1:0] a2_re, a2_im, a3_re, a3_im;
    reg signed [ACC_WIDTH-1:0] a4_re, a4_im, a5_re, a5_im;
    reg signed [ACC_WIDTH-1:0] a6_re, a6_im, a7_re, a7_im;

    // Stage 2 outputs (size-4 butterflies, twiddles W8^0, W8^2=-j)
    reg signed [ACC_WIDTH-1:0] b0_re, b0_im, b1_re, b1_im, b2_re, b2_im, b3_re, b3_im;
    reg signed [ACC_WIDTH-1:0] b4_re, b4_im, b5_re, b5_im, b6_re, b6_im, b7_re, b7_im;

    always @* begin
        // -----------------------------------------------------
        // Stage 1: pairs (x0,x4) (x2,x6) (x1,x5) (x3,x7)
        // (this pairing IS the N=8 bit-reversal, applied
        //  directly to natural-order inputs). Twiddle = 1.
        // -----------------------------------------------------
        a0_re = sext(x0_re) + sext(x4_re);  a0_im = sext(x0_im) + sext(x4_im);
        a1_re = sext(x0_re) - sext(x4_re);  a1_im = sext(x0_im) - sext(x4_im);

        a2_re = sext(x2_re) + sext(x6_re);  a2_im = sext(x2_im) + sext(x6_im);
        a3_re = sext(x2_re) - sext(x6_re);  a3_im = sext(x2_im) - sext(x6_im);

        a4_re = sext(x1_re) + sext(x5_re);  a4_im = sext(x1_im) + sext(x5_im);
        a5_re = sext(x1_re) - sext(x5_re);  a5_im = sext(x1_im) - sext(x5_im);

        a6_re = sext(x3_re) + sext(x7_re);  a6_im = sext(x3_im) + sext(x7_im);
        a7_re = sext(x3_re) - sext(x7_re);  a7_im = sext(x3_im) - sext(x7_im);

        // -----------------------------------------------------
        // Stage 2: combine 2-pt results into two 4-pt results.
        // Twiddles: W8^0 = 1, W8^2 = -j
        // (re + j*im) * (-j) = im - j*re  -> swap + negate, no multiplier
        // -----------------------------------------------------
        b0_re = a0_re + a2_re;   b0_im = a0_im + a2_im;
        b2_re = a0_re - a2_re;   b2_im = a0_im - a2_im;

        b1_re = a1_re + a3_im;   b1_im = a1_im - a3_re;   // a1 + (-j*a3)
        b3_re = a1_re - a3_im;   b3_im = a1_im + a3_re;   // a1 - (-j*a3)

        b4_re = a4_re + a6_re;   b4_im = a4_im + a6_im;
        b6_re = a4_re - a6_re;   b6_im = a4_im - a6_im;

        b5_re = a5_re + a7_im;   b5_im = a5_im - a7_re;
        b7_re = a5_re - a7_im;   b7_im = a5_im + a7_re;

        // -----------------------------------------------------
        // Stage 3: combine two 4-pt results into the final 8-pt
        // result. Twiddles: W8^0=1, W8^1, W8^2=-j, W8^3
        //   W8^1*b5 = W*(b5_re+b5_im) + j*W*(b5_im-b5_re)
        //   W8^3*b7 = W*(b7_im-b7_re) - j*W*(b7_re+b7_im)
        // -----------------------------------------------------
        X0_re = b0_re + b4_re;   X0_im = b0_im + b4_im;
        X4_re = b0_re - b4_re;   X4_im = b0_im - b4_im;

        X1_re = b1_re + mulW(b5_re + b5_im);
        X1_im = b1_im + mulW(b5_im - b5_re);
        X5_re = b1_re - mulW(b5_re + b5_im);
        X5_im = b1_im - mulW(b5_im - b5_re);

        X2_re = b2_re + b6_im;   X2_im = b2_im - b6_re;
        X6_re = b2_re - b6_im;   X6_im = b2_im + b6_re;

        X3_re = b3_re + mulW(b7_im - b7_re);
        X3_im = b3_im - mulW(b7_re + b7_im);
        X7_re = b3_re - mulW(b7_im - b7_re);
        X7_im = b3_im + mulW(b7_re + b7_im);
    end

endmodule