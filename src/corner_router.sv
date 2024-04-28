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


logic [1:0] toDemux;

// Requests between click and routers
bit req_click_router_self;
logic fork_to_a_req;
logic fork_to_a_ack;
logic fork_to_sel_req;
logic fork_to_sel_ack;
logic sel_req_delay_o;


// Signals for input 1
logic [maxx-1:0] dst_x1;
logic [maxy-1:0] dst_y1;
logic deltax1;
logic deltay1;


//assign deltax = data_self[n-maxx-2-maxy-2]; //1 if bigger, 0 if smaller
//assign deltay = data_self[n-maxx-2-maxy-3]; //1 if bigger, 0 if smaller
///////////////////////////

///Outputs



//Data from click to router/muxes
logic [n-1:0] data_self ;
logic [n-1:0] data_1 ;
logic [n-1:0] data_2 ;
logic [n-1:0] data_3 ;

//Acks from output to clicks
logic ack_proc_click;


//Signals from ports to proc output
logic req1;
logic ack1;
logic req2;
logic ack2;
logic req3;
logic ack3;
logic unused_req; 
logic unused_ack;
logic [n-1:0] unused_databus;
logic unused_req2 = 1'b0;
logic unused_ack2 = 1'b0;
logic [n-1:0] unused_databus2 =  {(n){1'b0}};
RTPort unused ();
assign unused.ack = 1'b0;
//assign port1_output = outs[0].Output;
//assign port2_output = outs[1].Output;
//assign port3_output = outs[2].Output;

assign dst_y = data_self[n-maxx-1:n-maxx-maxy];
assign dst_x = data_self[n-1:n-maxx];

input1to4 #(
        .rtype      (rtype),
        .maxx      (maxx),
        .maxy      (maxy),
        .srcy     (srcy),
        .srcx      (srcx)
) proc_input_port
(
    .rst    (rst),
    .in     (proc_input),
    .outs   ({port1_output,port2_output,port3_output, unused.Output})
    
);


//router_block4 #(
//
//    .rtype      (rtype),
//    .maxx      (maxx),
//    .maxy      (maxy),
//    .selfy      (srcy),
//    .selfx      (srcx)
//
//)router_self
//(
//
//
//    .dst_x      (dst_x),
//    .dst_y      (dst_y),
//    .toDemux    (toDemux)
//
//    
//);
//
//delay_element #(
//    .size   (20)
//) delayReqLocaltoOther(
//    .d      (fork_to_sel_req),
//    .z      (sel_req_delay_o)
//);
//
//
//demux4 #() demuxLocaltoOther
//(
//    .rst        (rst),
//    .inA_req    (fork_to_a_req),
//    .inA_ack    (fork_to_a_ack),
//    .inA_data   (data_self),
//
//    .inSel_req   (sel_req_delay_o),
//    .inSel_ack   (fork_to_sel_ack),
//    .selector    (toDemux),
//
//    .outD_req    (port1_output.req),
//    .outD_ack    (port1_output.ack),
//    .outD_data   (port1_output.data),
//
//    .outC_req    (port2_output.req),
//    .outC_ack    (port2_output.ack),
//    .outC_data   (port2_output.data),
//
//    .outB_req    (port3_output.req),
//    .outB_ack    (port3_output.ack),
//    .outB_data   (port3_output.data),
//
//    .outE_req    (unused_req),
//    .outE_ack    (unused_ack),
//    .outE_data   (unused_databus)    
//
//);
//
//// Ports to Proc
arbiter4 #() proc_arbiter
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
    
    .inD_req    (unused_req2),
    .inD_data   (unused_databus2),
    .inD_ack    (unused_ack2),
    
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



//click_element #(
//    .DATA_WIDTH     (n)
//  //  .VALUE          (0),
//   // .PHASE_INIT     (0)
//    ) clickself
//    (
//    .rst            (rst),
//    .in_ack         (proc_input.ack), //OK
//    .in_req         (proc_input.req), //OK
//    .in_data        (proc_input.data), //OK
//
//    .out_req        (req_click_router_self), //OK
//    .out_ack        (ack_proc_click), //OK
//    .out_data       (data_self) //OK
//);
//
//
//
//
//
//fork_component #() click_fork
//(
//    .rst        (rst),
//    .inA_ack    (ack_proc_click),
//    .inA_req    (req_click_router_self),
//
//    .outB_ack   (fork_to_a_ack),
//    .outB_req   (fork_to_a_req),
//
//    .outC_ack   (fork_to_sel_ack),
//    .outC_req   (fork_to_sel_req)
//
//);






endmodule