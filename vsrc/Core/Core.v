`timescale 1ns / 1ps
module CPU(
    input  wire             clk,
    input  wire             rst_n,
    output wire  [ 31 : 0 ] inst_addr,
    output wire             inst_ren,
    input  wire  [ 31 : 0 ] inst,
    output wire  [ 31 : 0 ] data_addr,
    output wire             data_ren,
    input  wire  [ 31 : 0 ] data_rd,
    output wire             data_wen,
    output wire  [ 31 : 0 ] data_wr,
    output wire  [  3 : 0 ] data_wstrb
);  
    wire [31:0] pc;
    //Contol模块输出的控制信号
    wire        ct_rf_dst,ct_rf_wen,ct_alu_src,ct_data_rf,ct_branch,ct_jump;
    wire        ct_mem_wen,ct_mem_ren;
    wire [ 3:0] ct_mem_wstrb;
    wire [ 3:0] ct_alu;
    //RegFile模块的输入输出
    wire [ 4:0] rf_addr_w;
    wire [31:0] rf_data_r1,rf_data_r2,rf_data_w;
    //ALU模块的输入输出
    wire        alu_zero;
    wire [31:0] alu_src2;
    wire [31:0] alu_res;
    //符号扩展的结果
    wire [31:0] ext_data;
    //DataMem的输出
    wire [31:0] mem_data_o;
    //选择要写的寄存器地址  
    assign rf_addr_w = ct_rf_dst ? inst[15:11] : inst[20:16];
    //选择要写入寄存器堆的数据
    assign rf_data_w = ct_data_rf ? mem_data_o : alu_res;
    //alu_src2是指令后16位符号扩展的结果或者寄存器堆读的第二寄存器的值
    assign ext_data = {{16{inst[15]}}, inst[15:0]};
    assign alu_src2 = ct_alu_src ? ext_data : rf_data_r2;
    
    IFU ifu0(
        .clk(clk),
        .rst_n(rst_n),
        .alu_zero(alu_zero),
        .ct_branch(ct_branch),
        .ct_jump(ct_jump),
        .pc(pc),
        .inst(inst)
    );
    Control ct0(
        .ct_inst(inst[31:26]),
        .aluct_inst(inst[5:0]),
        .ct_rf_dst(ct_rf_dst),
        .ct_rf_wen(ct_rf_wen),
        .ct_alu_src(ct_alu_src),
        .ct_alu(ct_alu),
        .ct_mem_wen(ct_mem_wen),
        .ct_mem_ren(ct_mem_ren),
        .ct_data_rf(ct_data_rf),
        .ct_branch(ct_branch),
        .ct_jump(ct_jump),
        .ct_mem_wstrb(ct_mem_wstrb)
    );
    RegFile rf0(
        .clk(clk),
        .rst_n(rst_n),
        .rf_wen(ct_rf_wen),
        .rf_addr_r1(inst[25:21]),
        .rf_addr_r2(inst[20:16]),
        .rf_addr_w(rf_addr_w),
        .rf_data_w(rf_data_w),
        .rf_data_r1(rf_data_r1),
        .rf_data_r2(rf_data_r2)
    );
    ALU alu0(
        .alu_ct(ct_alu),
        .alu_src1(rf_data_r1),
        .alu_src2(alu_src2),
        .alu_zero(alu_zero),
        .alu_res(alu_res)
    );

    assign data_wen = ct_mem_wen;
    assign data_ren = ct_mem_ren;
    assign data_wr  = rf_data_r2;
    assign data_wstrb = ct_mem_wstrb;
    assign data_addr = alu_res;
    assign inst_ren   = 1'b1;
    assign inst_addr  = pc;

endmodule
