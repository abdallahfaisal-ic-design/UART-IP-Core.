
module uart_top #(

    parameter CLKS_PER_BIT = 87

)(

    input  wire       i_clock,

    // Tx Ports

    input  wire       i_Tx_start,

    input  wire [7:0] i_Tx_Byte,

    output wire       o_Tx_serial,

    output wire       o_Tx_Done,

    // Rx Ports

    input  wire       i_Rx_serial,

    output wire [7:0] o_Rx_Byte,

    output wire       o_Rx_DV

);



    // Instantiate Transmitter (Tx)

    uart_tx #(

        .CLKS_PER_BIT(CLKS_PER_BIT)

    ) uart_tx_inst (

        .i_clock(i_clock),

        .i_Tx_start(i_Tx_start),

        .i_Tx_Byte(i_Tx_Byte),

        .o_Tx_serial(o_Tx_serial),

        .o_Tx_Done(o_Tx_Done)

    );



    // Instantiate Receiver (Rx)

    uart_rx #(

        .CLKS_PER_BIT(CLKS_PER_BIT)

    ) uart_rx_inst (

        .i_clock(i_clock),

        .i_Rx_serial(i_Rx_serial),

        .o_Rx_DV(o_Rx_DV),

        .o_Rx_Byte(o_Rx_Byte)

    );



endmodule

