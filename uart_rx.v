
module uart_rx #(

    parameter CLKS_PER_BIT = 87

)(

    input  wire       i_clock,

    input  wire       i_Rx_serial,

    output wire       o_Rx_DV,

    output wire [7:0] o_Rx_Byte

);



    // States definition

    parameter IDLE  = 3'b000;

    parameter START = 3'b001;

    parameter DATA  = 3'b010;

    parameter STOP  = 3'b011;

    parameter CLEAN = 3'b100;



    reg [2:0]  r_state = IDLE;

    reg [15:0] r_clock_count = 0;

    reg [2:0]  r_Bit_Index = 0;

    reg [7:0]  r_Rx_Byte = 0;

    reg        r_Rx_DV = 0;



    always @(posedge i_clock) begin

        case (r_state)

            IDLE: begin

                r_Rx_DV       <= 1'b0;

                r_clock_count <= 0;

                r_Bit_Index   <= 0;



                if (i_Rx_serial == 1'b0) begin // Detect Start Bit

                    r_state <= START;

                end

            end



            START: begin

                // Sample at the middle of the start bit

                if (r_clock_count == (CLKS_PER_BIT - 1) / 2) begin

                    if (i_Rx_serial == 1'b0) begin

                        r_clock_count <= 0;

                        r_state       <= DATA;

                    end else begin

                        r_state       <= IDLE;

                    end

                end else begin

                    r_clock_count <= r_clock_count + 1;

                end

            end



            DATA: begin

                if (r_clock_count < CLKS_PER_BIT - 1) begin

                    r_clock_count <= r_clock_count + 1;

                end else begin

                    r_clock_count          <= 0;

                    r_Rx_Byte[r_Bit_Index] <= i_Rx_serial;



                    if (r_Bit_Index < 7) begin

                        r_Bit_Index <= r_Bit_Index + 1;

                    end else begin

                        r_Bit_Index <= 0;

                        r_state     <= STOP;

                    end

                end

            end



            STOP: begin

                if (r_clock_count < CLKS_PER_BIT - 1) begin

                    r_clock_count <= r_clock_count + 1;

                end else begin

                    r_Rx_DV       <= 1'b1;

                    r_clock_count <= 0;

                    r_state       <= CLEAN;

                end

            end



            CLEAN: begin

                r_state   <= IDLE;

                r_Rx_DV   <= 1'b0;

            end



            default: r_state <= IDLE;

        endcase

    end



    // Continuous assignments (Correct Left-hand side as wire)

    assign o_Rx_DV   = r_Rx_DV;

    assign o_Rx_Byte = r_Rx_Byte;



endmodule

