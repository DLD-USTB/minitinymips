module Memory(
    input  wire clk,
    input  wire rst_n,
    input  wire [ 31 : 0 ]  port0_addr,
    input  wire             port0_ren,
    output wire [ 31 : 0 ]  port0_rdata,
    input  wire             port1_ren,
    output wire [ 31 : 0 ]  port1_rdata,
    input  wire [ 31 : 0 ]  port1_addr,
    input  wire             port1_wen,
    input  wire [  3 : 0 ]  port1_wstrb,
    input  wire [ 31 : 0 ]  port1_wdata
);
    (* ram_style = "distributed" *)
    reg [31 : 0 ] mem_file [0 : 65536];

    initial begin
        $readmemh("build/mem.data", mem_file);
    end
    // read the memory 
    assign port0_rdata = mem_file[port0_addr[17:2]];
    assign port1_rdata = mem_file[port1_addr[17:2]];

    // write the memory 
    wire [ 31 : 0 ] write_mask;
    genvar i;
    generate
        for (i = 0; i < 4 ; i = i + 1)begin
            // what is the usage of +: ? search the friendly web if you want to know
            assign write_mask[ i*8 +: 8] = port1_wstrb[i] ? 8'hff : 0;
        end
    endgenerate

    always @(posedge clk)begin
        if (port1_wen)begin
            mem_file[port1_addr[17:2]] <= port1_wdata;
        end
    end


endmodule