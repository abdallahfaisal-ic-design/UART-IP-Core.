
`timescale 1ns / 1ps



module uart_top_tb;



    // Parameters

    parameter CLK_PERIOD = 100;       // 10MHz Clock (100ns period)

    parameter CLKS_PER_BIT = 87;      // 115200 Baud rate for 10MHz clock



    // Testbench Signals

    reg        clk;

    reg        tx_start;

    reg  [7:0] tx_byte;

    wire       tx_serial;

    wire       tx_done;

    wire [7:0] rx_byte;

    wire       rx_dv;



    // Instantiate UUT (Unit Under Test)

    uart_top #(

        .CLKS_PER_BIT(CLKS_PER_BIT)

    ) uut (

        .i_clock(clk),

        .i_Tx_start(tx_start),

        .i_Tx_Byte(tx_byte),

        .o_Tx_serial(tx_serial),

        .o_Tx_Done(tx_done),


        .i_Rx_serial(tx_serial), 

        .o_Rx_Byte(rx_byte),

        .o_Rx_DV(rx_dv)

    );



    // Clock Generation

    always begin

        #(CLK_PERIOD / 2) clk = ~clk;

    end



    // Main Test Stimulus

    initial begin

        clk      = 0;

        tx_start = 0;

        tx_byte  = 8'h00;





        #(CLK_PERIOD * CLKS_PER_BIT * 2);



        // --- Test Case 1: Send Byte 8'hA5 ---

        $display("[TB] Sending Byte: 8'hA5 at time %0t", $time);

        

        @(posedge clk);

        tx_byte  = 8'hA5;

        tx_start = 1'b1;          

        @(posedge clk);

        tx_start = 1'b0;   




        @(posedge rx_dv);

        if (rx_byte == 8'hA5) begin

            $display("[TB] SUCCESS: Received correct byte 8'hA5 at time %0t", $time);

        end else begin

            $display("[TB] ERROR: Expected 8'hA5 but got 8'h%h at time %0t", rx_byte, $time);

        end


        #(CLK_PERIOD * CLKS_PER_BIT * 2);



        // --- Test Case 2: Send Byte 8'h3F ---

        $display("[TB] Sending Byte: 8'h3F at time %0t", $time);

        

        @(posedge clk);

        tx_byte  = 8'h3F;

        tx_start = 1'b1;

        

        @(posedge clk);

        tx_start = 1'b0;



        @(posedge rx_dv);

        if (rx_byte == 8'h3F) begin

            $display("[TB] SUCCESS: Received correct byte 8'h3F at time %0t", $time);

        end else begin

            $display("[TB] ERROR: Expected 8'h3F but got 8'h%h at time %0t", rx_byte, $time);

        end




        #(CLK_PERIOD * CLKS_PER_BIT * 5);

        $display("[TB] All tests finished successfully!");

        $stop;

    end



endmodule

