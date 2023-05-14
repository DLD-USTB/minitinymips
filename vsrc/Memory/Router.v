module Router(
    // from cpu
    input  wire  [ 31 : 0 ] data_addr,
    input  wire             data_ren,
    output wire  [ 31 : 0 ] data_rd,
    input  wire             data_wen,
    input  wire  [ 31 : 0 ] data_wr,
    input  wire  [  3 : 0 ] data_wstrb,
    // to memory
    // data, data use the common data bus, these are control signals
    output wire             datamem_ren,
    output wire             datamem_wen,
    // to device
    output wire             device_ren,
    output wire             device_wen,
    // common databus
    output wire [ 31 : 0 ]  common_addr,
    input  wire [ 31 : 0 ]  common_rdata,
    output wire [ 31 : 0 ]  common_wdata,
    output wire [  3 : 0 ]  common_wstrb 
);
    assign common_addr  = data_addr;
    assign common_wdata = data_wr;
    assign common_wstrb = data_wstrb;
    assign data_rd = common_rdata;

    assign datamem_ren = data_ren;
    assign datamem_wen = data_wen;
    assign device_ren  = 0;
    assign device_wen  = 0;

endmodule