module Device(
    input  wire clk,
    input  wire rst_n,
    input  wire [ 31 : 0 ]  addr,
    input  wire             ren,
    output wire [ 31 : 0 ]  rdata,
    input  wire [ 31 : 0 ]  wdata,
    input  wire             wen,
    input  wire [  3 : 0 ]  wstrb,

    output wire [ 15 : 0 ]  led,
    input  wire [ 15 : 0 ]  sw,
    output wire [  7 : 0 ]  seg0,
    output wire [  7 : 0 ]  seg1,
    output wire [  3 : 0 ]  sel0,
    output wire [  3 : 0 ]  sel1
);
    reg [ 16 : 0 ] config_led;// led configure register
    reg [ 31 : 0 ] config_num;// the configure register of seven-segment display
    // read logic 
    reg [ 31 : 0 ] read_data;
    always @(*)begin
        case(addr[ 3 : 2 ])
            2'b00:read_data = {16'b0, config_led};
            2'b01:read_data = {16'b0, sw};
            2'b10:read_data = config_num;
            default: read_data = 0;
        endcase
    end
    assign rdata = read_data;
    // write logic
    wire [ 31 : 0 ] write_mask;
    genvar i;
    generate
        for (i = 0; i < 4 ; i = i + 1)begin
            assign write_mask[ i*8 +: 8] = wstrb[i] ? 8'hff : 0;
        end
    endgenerate
    wire [31 : 0] real_wdata;
    assign real_wdata = (write_mask & wdata) | (~write_mask & rdata);
    always @(posedge clk)begin
        if (wen)begin
            case(addr[ 3 : 2]) 
                2'b00:
                    config_led <= real_wdata[ 15 : 0 ];
                2'b10:
                    config_num <= real_wdata[ 31 : 0 ];
            endcase
        end
    end

    assign led = config_led;
    assign {seg1, seg0} = config_num[ 15 : 0 ];
    assign sel0 = config_num[ 19 : 16 ];
    assign sel1 = config_num[ 27 : 24 ];
endmodule