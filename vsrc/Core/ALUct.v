module ALUCt(
    input  wire [ 5 : 0 ] funct,
    input  wire [ 1 : 0 ] alu_ct_op,
    output reg  [ 3 : 0 ] alu_ct
);
    always@(*) begin
        case(alu_ct_op)
            2'b00:
                alu_ct= 4'b0010;
            2'b01:
                alu_ct= 4'b0110;
            2'b10:
                case(funct) 
                    //在此补充代码：当指令中funct段为100001时，alu_ct输出4’b0010（执行加法操作）。

                    default:begin 
                        alu_ct = 4'b0010;
                    end
                endcase
            default:begin end
        endcase 
    end
endmodule
