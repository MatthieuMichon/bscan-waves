`timescale 1ns/1ps
`default_nettype none

module shell;

localparam int JTAG_USER_ID = 4;
localparam int AXSS_WIDTH = 32;

typedef logic[AXSS_WIDTH-1:0] axss_t;

logic tck, tms, tdi, tdo;
logic drck, test_logic_reset, run_test_idle, ir_is_user, capture_dr, shift_dr, update_dr;

BSCANE2 #(.JTAG_CHAIN(JTAG_USER_ID)) bscan_i (
    // raw JTAG signals
        .TCK(tck),
        .TMS(tms),
        .TDI(tdi),
        .TDO(tdo), // muxed by TAP if IR matches USER(JTAG_CHAIN)
    // TAP controller states
        .DRCK(drck),
        .RESET(test_logic_reset),
        .RUNTEST(run_test_idle),
        .SEL(ir_is_user),
        .CAPTURE(capture_dr),
        .SHIFT(shift_dr),
        .UPDATE(update_dr));

logic conf_clk, axss_valid;
axss_t axss_data;

USR_ACCESSE2 (
    .CFGCLK(conf_clk),
    .DATAVALID(axss_valid),
    .DATA(axss_data)
);

logic [11-1:0] ila_signals;

assign ila_signals = {
    tck, tms, tdi, tdo,
    drck, test_logic_reset, run_test_idle,
    ir_is_user, capture_dr, shift_dr, update_dr};

bscan_ila bscan_ila_i (
    .clk(conf_clk),
    .probe0(ila_signals)
);

endmodule
`default_nettype wire
