module Corner_Router
    import router_pkg::*;
#(
    parameter router_type rtype = CORNERNE,
    parameter integer n = 32,
    parameter integer srcx = 0,
    parameter integer srcy = 0,
    parameter integer maxx = 1,
    parameter integer maxy = 1
)
(
    //Global
    input logic rst,
    //Interfaces
    RTPort.Input proc_input ,
    RTPort.Output proc_output ,
    RTPort.Input port1_input,
    RTPort.Output port1_output,
    RTPort.Input port2_input,
    RTPort.Output port2_output,
    RTPort.Input port3_input,
    RTPort.Output port3_output



);


//Data from click to router/muxes
logic [n-1:0] data_1 ;
logic [n-1:0] data_2 ;
logic [n-1:0] data_3 ;




//Signals from ports to proc output
logic req_1;
logic ack_1;
logic req_2;
logic ack_2;
logic req_3;
logic ack_3;

RTPort#(.WIDTH (n)) self_loopback ();

logic self_loopback_req;
logic self_loopback_ack;
logic [n-1:0] self_loopback_data;

assign self_loopback_req = self_loopback.req;
assign self_loopback_ack = self_loopback.ack;
assign self_loopback_data = self_loopback.data;



input1to4 #(
        .rtype      (rtype),
        .n          (n),
        .maxx      (maxx),
        .maxy      (maxy),
        .srcy     (srcy),
        .srcx      (srcx)
) proc_input_port
(
    .rst    (rst),
    .in     (proc_input),
    .outs   ({port1_output,port2_output,port3_output, self_loopback.Output})
    
);


arbiter4 #(n) proc_arbiter
(
    .rst    (rst),
    
    .inA_req    (req_1),
    .inA_data   (data_1),
    .inA_ack    (ack_1),
    
    .inB_req    (req_2),
    .inB_data   (data_2),
    .inB_ack    (ack_2),
    
    .inC_req    (req_3),
    .inC_data   (data_3),
    .inC_ack    (ack_3),
    
    .inD_req    (self_loopback.req),
    .inD_data   (self_loopback.data),
    .inD_ack    (self_loopback.ack),
    
    .out_req    (proc_output.req),
    .out_data   (proc_output.data),
    .out_ack    (proc_output.ack)
);

// Input latches
click_element #(
    .DATA_WIDTH     (n)
   // .VALUE          (0),
  //  .PHASE_INIT     (1'b0)
    ) click1
    (
    .rst            (rst),
    .in_ack         (port1_input.ack),
    .in_req         (port1_input.req),
    .in_data        (port1_input.data),

    .out_req        (req_1),
    .out_ack        (ack_1),
    .out_data       (data_1)

);



click_element #(
    .DATA_WIDTH     (n)
  //  .VALUE          (0),
  //  .PHASE_INIT     (1'b0)
    ) click2
    (
    .rst            (rst),
    .in_ack         (port2_input.ack),
    .in_req         (port2_input.req),
    .in_data        (port2_input.data),

    .out_req        (req_2),
    .out_ack        (ack_2),
    .out_data       (data_2)

);
click_element #(
    .DATA_WIDTH     (n)
 //   .VALUE          (0),
 //   .PHASE_INIT     (1'b0)
    ) click3
    (
    .rst            (rst),
    .in_ack         (port3_input.ack),
    .in_req         (port3_input.req),
    .in_data        (port3_input.data),

    .out_req        (req_3),
    .out_ack        (ack_3),
    .out_data       (data_3)

);









endmodule