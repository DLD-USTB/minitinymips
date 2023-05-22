module SimTop(
    input wire clk,
    input wire rst_n
);
    // CPU to rounter and inst mem connection
    wire [ 31 : 0 ] inst_addr, data_addr;
    wire [ 31 : 0 ] inst_rdata, data_rd, data_wr;
    wire            inst_ren, data_ren, data_wen;
    wire [  3 : 0 ] data_wstrb;

    // rounter to data mem and  device
    wire [  3 : 0 ] common_wstrb;
    wire [ 31 : 0 ] common_wdata;
    wire [ 31 : 0 ] common_addr;
    
    wire [ 31 : 0 ] datamem_rdata, device_rdata;
    wire            device_ren,device_wen, datamem_ren, datamem_wen;

    CPU u_cpu(
        .clk(clk), 
        .rst_n(rst_n), 
        .inst_addr(inst_addr), 
        .inst_ren(inst_ren), 
        .inst(inst_rdata), 
        .data_addr(data_addr), 
        .data_ren(data_ren), 
        .data_rd(data_rd), 
        .data_wen(data_wen), 
        .data_wr(data_wr), 
        .data_wstrb(data_wstrb) 
    );
    SimDevice u_dev(
        .clk(clk), 
        .rst_n(rst_n), 
        .addr(common_addr), 
        .ren(device_ren), 
        .rdata(device_rdata), 
        .wdata(common_wdata), 
        .wen(device_wen), 
        .wstrb(common_wstrb)  
    );
    Memory u_mem(
        .clk(clk), 
        .rst_n(rst_n), 
        .port0_addr(inst_addr), 
        .port0_ren(inst_ren), 
        .port0_rdata(inst_rdata), 
        .port1_ren(datamem_ren), 
        .port1_rdata(device_rdata), 
        .port1_addr(common_addr), 
        .port1_wen(datamem_wen), 
        .port1_wstrb(common_wstrb), 
        .port1_wdata(common_wdata) 
    );
    Router u_router(
        // from cpu
        .data_addr(data_addr), 
        .data_ren(data_ren), 
        .data_rd(data_rd), 
        .data_wen(data_wen), 
        .data_wr(data_wr), 
        .data_wstrb(data_wstrb), 
        // to memory
        // data, data use the common data bus, these are control signals
        .datamem_ren(datamem_ren), 
        .datamem_wen(datamem_wen),
        .datamem_rdata(datamem_rdata), 
        // to device
        .device_ren(device_ren), 
        .device_wen(device_wen),
        .device_rdata(device_rdata),
        // common databus
        .common_addr(common_addr), 
        .common_wdata(common_wdata), 
        .common_wstrb(common_wstrb)
    );
endmodule