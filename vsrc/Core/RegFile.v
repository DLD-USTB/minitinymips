module RegFile(  
    input  wire clk,  
    input  wire rst_n,
    // 写使能信号  
    input  wire rf_wen,  
    // 读地址  
    input  wire [  4 : 0 ] rf_addr_r1,  
    input  wire [  4 : 0 ] rf_addr_r2,  
    // 写入地址和写入数据  
    input  wire [  4 : 0 ] rf_addr_w,  
    input  wire [ 31 : 0 ] rf_data_w,  
    // 输出端口  
    output wire [ 31 : 0 ] rf_data_r1,  
    output wire [ 31 : 0 ] rf_data_r2  
);  
      
    reg[ 31 : 0 ] file [ 31 : 0 ];  
     
    assign rf_data_r1 = file[rf_addr_r1];  
    assign rf_data_r2 = file[rf_addr_r2];  
    
    integer idx;
    initial begin
        for (idx = 0; idx < 32; idx = idx + 1) file[idx] = 0;
    end 
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1)begin
            always@(posedge clk) begin                   
                //在此补充完成控制信号控制寄存器堆写操作
                if (rf_addr_w == i)begin
                    file[i] <= rf_data_w;
                end
                if (!rst_n) begin
                    file[i] <= 32'b0;
                end  
            end
        end  
    endgenerate
endmodule  
