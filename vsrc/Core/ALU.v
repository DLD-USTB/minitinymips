module ALU(
    input  wire [  3 : 0 ] alu_ct,
    input  wire [ 31 : 0 ] alu_src1,alu_src2,
    output wire            alu_zero,
    output reg  [ 31 : 0 ] alu_res
);
    assign alu_zero= (alu_res==0)?1:0;
    always@(*)
        case(alu_ct)
            //在此补充代码：当alu_ct为4'b0010，执行加法运算；为4'b0110时，执行减法运算。
            default:begin end
        endcase
endmodule
