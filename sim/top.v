`include "./IF.v"
`include "./ID.v"
`include "./gpr.v"
`include "./csr.v"
`include "./shifter.v"
`include "./backend.v"

module top (
    input           aclk,
    input           clk,
    input           rst,
    input           ei,
    input           ti
);
    
    wire    [31:0]  pc;
    wire    [31:0]  inst;
    wire            brh_flag;
    wire    [31:0]  brh_addr;
    wire            int_flag;
    wire    [31:0]  int_addr;
    wire    [31:0]  qa;
    wire    [31:0]  qb;
    wire            is_lt;
    wire            is_ltu;
    wire            is_zero;
    wire            alu_src_1;
    wire            alu_src_2;
    wire    [31:0]  alu_imm_1;
    wire    [31:0]  alu_imm_2;
    wire    [ 7:0]  alu_op;
    wire    [ 7:0]  mem_op;
    wire    [ 8:0]  csr_op;
    wire            gpr_we;
    wire    [31:0]  gpr_di;
    wire            load;
    wire            store;
    wire    [11:0]  csr_addr;
    wire    [ 4:0]  csr_zimm;
    wire    [31:0]  csr_wdata;
    wire    [31:0]  csr_rdata;

    IF u_IF (clk, rst, 32'h0, brh_flag, brh_addr, int_flag, int_addr, pc, inst);

    ID u_ID (clk, rst, pc, inst, qa, is_lt, is_ltu, is_zero, brh_flag, brh_addr, alu_src_1, alu_src_2, alu_imm_1, alu_imm_2, alu_op, mem_op, csr_op, csr_addr, csr_zimm, gpr_we, load, store);

    gpr u_gpr (aclk, clk, gpr_we, inst[19:15], inst[24:20], inst[11:7], gpr_di, qa, qb);

    csr u_csr (aclk, clk, pc, ei, ti, csr_op, csr_addr, csr_wdata, csr_rdata, int_flag, int_addr);

    backend u_backend (clk, alu_op, mem_op, csr_op, load, store, qa, qb, gpr_di, alu_imm_1, alu_imm_2, alu_src_1, alu_src_2, csr_zimm, csr_rdata, csr_wdata, is_lt, is_ltu, is_zero);

endmodule