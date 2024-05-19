(* DONT_TOUCH = "yes" *)
module input1to4
    import router_pkg::*;
#(

   // parameter router_type rtype = CORNER,
    parameter integer n = 8,
    parameter integer srcx = 0,
    parameter integer srcy = 0,
    parameter integer maxx = 1,
    parameter integer maxy = 1
)
(
    //Global
    input logic rst,
    //Interfaces
    RTPort.Input in,
    RTPort.Output outs[4]
);


logic req_click_fork;
logic ack_click_fork;
logic[n-1:0] data_click_fork;

logic req_fork_demux;
logic ack_fork_demux;

logic req_fork_selector;
logic ack_fork_selector;


logic [maxx-1:0] dst_x;
logic [maxy-1:0] dst_y;
logic [1:0] toDemux;

assign dst_y = data_click_fork[n-maxx-1:n-maxx-maxy];
assign dst_x = data_click_fork[n-1:n-maxx];



logic delay_req_select;

logic test = 1'b0;


click_element #(
    .DATA_WIDTH     (n)
) click
    (
    .rst            (rst),
    .in_ack         (in.ack), //OK
    .in_req         (in.req), //OK
    .in_data        (in.data), //OK

    .out_req        (req_click_fork), //OK
    .out_ack        (ack_click_fork), //OK
    .out_data       (data_click_fork) //OK
);


fork_component #() click_fork
(
    .rst        (rst),
    .inA_ack    (ack_click_fork),
    .inA_req    (req_click_fork),

    .outB_ack   (ack_fork_demux),
    .outB_req   (req_fork_demux),

    .outC_ack   (ack_fork_selector),
    .outC_req   (req_fork_selector)

);

router_block4 #(

   // .rtype      (rtype),
    .maxx      (maxx),
    .maxy      (maxy),
    .selfy      (srcy),
    .selfx      (srcx)

)router_self
(


    .dst_x      (dst_x),
    .dst_y      (dst_y),
    .toDemux    (toDemux)

    
);

delay_element #(
    .size   (1)
) delayReqLocaltoOther(
    .d      (req_fork_selector),
    .z      (delay_req_select)
);


demux4 #() demuxLocaltoOther
(
    .rst        (rst),
    .inA_req    (req_fork_demux),
    .inA_ack    (ack_fork_demux),
    .inA_data   (data_click_fork),

    .inSel_req   (delay_req_select),
    .inSel_ack   (ack_fork_selector),
    .selector    (toDemux),

    .outC_req    (outs[0].req),
    .outC_ack    (outs[0].ack),
    .outC_data   (outs[0].data),

    .outD_req    (outs[1].req),
    .outD_ack    (outs[1].ack),
    .outD_data   (outs[1].data),

    .outB_req    (outs[2].req),
    .outB_ack    (outs[2].ack),
    .outB_data   (outs[2].data),

    .outE_req    (outs[3].req),
    .outE_ack    (outs[3].ack),
    .outE_data   (outs[3].data)    

);


endmodule