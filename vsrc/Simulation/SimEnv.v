module SimEnv();
    reg clk;
    reg rst_n;

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
    SimTop u_top(
        .clk(clk), 
        .rst_n(rst_n) 
    );

    //monitor
    parameter SIM_CYCLE = 100;
    parameter TRACE = 0;
    integer cycles;
    wire [ 31 : 0 ] inst;
    wire [ 31 : 0 ] pc;
    assign inst = u_top.inst_rdata;
    assign pc   = u_top.inst_addr;
    initial begin
        cycles = 0;
        while(cycles != SIM_CYCLE)begin
            @(posedge clk);
            cycles = cycles + 1'b1;
            if (inst == 32'h7000_003f)begin
                $display("[SIM ENV] meet the sdbbp, Simulation finish, cycles=%d", cycles);
                $finish;
            end
            if (rst_n == 1'b1 && TRACE == 1)begin
                $display("[SIM ENV] pc = %h, inst = %h", pc, inst);
            end
        end
        $display("[SIM ENV] Simulation finish, cycles = ", cycles);
        $finish;
    end

    initial begin            
        $dumpfile("wave.vcd");       
        $dumpvars(0, SimEnv);    
    end
endmodule