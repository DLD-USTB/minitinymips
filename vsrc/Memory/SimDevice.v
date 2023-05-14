module SimDevice(
    input  wire clk,
    input  wire rst_n,
    input  wire [ 31 : 0 ]  addr,
    input  wire             ren,
    output wire [ 31 : 0 ]  rdata,
    input  wire [ 31 : 0 ]  wdata,
    input  wire             wen,
    input  wire [  3 : 0 ]  wstrb 
);
    //write to uart
    parameter STDOUT = 32'h8000_0001;
    parameter UART_ADDR = 16'b0000;
    always @(posedge clk)begin
        if (wen && addr[15:0] == UART_ADDR)begin
            $fwrite(STDOUT,"\033[1;34m%c\033[0m", wdata);
        end
    end

endmodule
module SimDevice_tb();
    reg clk;
    reg rst_n;
    reg wen;
    reg [ 31 : 0 ]  wdata;

    SimDevice u_simdevice(
        .clk(clk),
        .rst_n(rst_n),
        .addr(32'ha000_0000),
        .ren(1'b1),
        .rdata(),
        .wdata(wdata),
        .wen(wen),
        .wstrb(4'b1111) 
    );

    task wait_cycles(input integer n);
        integer idx;
        for (idx = 0; idx < n; idx = idx + 1)begin
            @(posedge clk);
        end
    endtask
    initial begin
        clk = 0;
        forever begin
            #5 clk = ~clk;
        end        
    end
    initial begin
        rst_n = 0;
        wait_cycles(10);
        rst_n = 1;
    end

    initial begin
        wen = 0;
        wdata = 0;
        wait_cycles(20);
        wen = 1;
        wdata = "H";
        wait_cycles(1);
        wdata = "e";
        wait_cycles(1);
        wdata = "l";
        wait_cycles(1);
        wdata = "l";
        wait_cycles(1);
        wdata = "o";
        wait_cycles(1);
        wdata = "\n";
        wait_cycles(1);
        $display("[sim_env] done");
        $finish;
    end

    
endmodule