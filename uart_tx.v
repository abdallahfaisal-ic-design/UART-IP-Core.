
module uart_tx #(

    parameter CLKS_PER_BIT = 87

)(

    input  wire       i_clock,

    input  wire       i_Tx_start,

    input  wire [7:0] i_Tx_Byte,

    output reg        o_Tx_serial,

    output reg        o_Tx_Done

);



    // States definition

    parameter IDLE  = 2'b00;

    parameter START = 2'b01;

    parameter DATA  = 2'b10;

    parameter STOP  = 2'b11;



    reg [1:0]  r_state = IDLE;

    reg [15:0] r_clock_count = 0;

    reg [2:0]  r_Bit_Index = 0;

    reg [7:0]  r_Tx_Data = 0;



    always @(posedge i_clock) begin

        case (r_state)

            IDLE: begin

                o_Tx_serial   <= 1'b1; // Drive Line High in IDLE

                o_Tx_Done     <= 1'b0;

                r_Bit_Index   <= 0;

                r_clock_count <= 0;



                if (i_Tx_start == 1'b1) begin

                    r_Tx_Data <= i_Tx_Byte;

                    r_state   <= START;

                end

            end



            START: begin

                o_Tx_serial <= 1'b0; // Start Bit (Low)



                if (r_clock_count < CLKS_PER_BIT - 1) begin

                    r_clock_count <= r_clock_count + 1;

                end else begin

                    r_clock_count <= 0;

                    r_state       <= DATA;

                end

            end



            DATA: begin

                o_Tx_serial <= r_Tx_Data[r_Bit_Index];



                if (r_clock_count < CLKS_PER_BIT - 1) begin

                    r_clock_count <= r_clock_count + 1;

                end else begin

                    r_clock_count <= 0;

                    

                    if (r_Bit_Index < 7) begin

                        r_Bit_Index <= r_Bit_Index + 1;

                    end else begin

                        r_Bit_Index <= 0;

                        r_state     <= STOP;

                    end

                end

            end



            STOP: begin

                o_Tx_serial <= 1'b1; // Stop Bit (High)



                if (r_clock_count < CLKS_PER_BIT - 1) begin

                    r_clock_count <= r_clock_count + 1;

                end else begin

                    o_Tx_Done     <= 1'b1;

                    r_clock_count <= 0;

                    r_state       <= IDLE;

                end

            end



            default: r_state <= IDLE;

        endcase

    end



endmodule

