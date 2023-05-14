module Control(
    input  wire  [  5 : 0 ] ct_inst,
    input  wire  [  5 : 0 ] aluct_inst,
    output wire             ct_rf_dst,
    output wire             ct_rf_wen,
    output wire             ct_alu_src,
    output wire  [  3 : 0 ] ct_alu,
    output wire             ct_mem_wen,
    output wire             ct_mem_ren,
    output wire  [  3 : 0 ] ct_mem_wstrb,
    output wire             ct_data_rf,
    output wire             ct_branch,
    output wire             ct_jump
);
    wire inst_r, inst_lw, inst_sw, inst_beq, inst_j, inst_addiu;
    wire[1:0] ct_alu_op;
    ALUCt aluct0(
        .funct(aluct_inst),
        .alu_ct_op(ct_alu_op),
        .alu_ct(ct_alu)
    );
    //二级逻辑阵列
    //与阵
    assign inst_r  = (!ct_inst[5])&&(!ct_inst[4])&&(!ct_inst[3])&&(!ct_inst[2])&&(!ct_inst[1])&&(!ct_inst[0]);
    //在此补充完整其余5条指令inst_lw，inst_sw，inst_beq， inst_j，inst_addiu的表达式。
    
    //或阵
    assign ct_rf_dst = inst_r;
    assign ct_rf_wen = inst_r || inst_lw || inst_addiu;
    assign ct_alu_src = inst_lw || inst_sw || inst_addiu;
    assign ct_alu_op = {inst_r,inst_beq};
    assign ct_mem_wstrb = 4'b1111; // 由于当前只实现sw指令，wstrb各位均为1，那么，如果要增加sb，sh指令，又该如何处理呢
    //在此补充完整其余控制信号的表达式：ct_branch, ct_mem_ren, ct_mem_wen, ct_data_rf, ct_jump
endmodule
