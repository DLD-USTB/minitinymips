module IFU(
    input wire clk, rst_n,
    input wire alu_zero, ct_branch, ct_jump,
    output reg [ 31 : 0 ] pc,
    input wire [ 31 : 0 ] inst
);
	
    reg  [ 31 : 0 ] npc;

    wire [ 31 : 0 ] jump_addr, branch_addr, linear_addr;
    assign linear_addr = pc + 4;
    assign jump_addr = 0;
    assign branch_addr = 0;

    always @(*) begin
        if(ct_jump)begin                
            npc = jump_addr;
        end else if(ct_branch && alu_zero) begin
            npc = branch_addr;
        end else begin 
            npc = pc + 4;
        end
    end
    always @ (posedge clk)begin
        pc <= npc;
        if(!rst_n)begin
            pc <= 0;
        end
    end
endmodule
