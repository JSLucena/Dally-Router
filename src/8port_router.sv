module full_router
    import router_pkg::*;
#(

    parameter router_type rtype = CORNERNE,
    parameter integer n = 32,
    parameter integer srcx = 2,
    parameter integer srcy = 2,
    parameter integer maxx = 1,
    parameter integer maxy = 1
)
(
    //Global
    input logic rst,
    //Interfaces
    RTPort.Input proc_input,
    RTPort.Output proc_output,
    RTPort.Input portE_input,
    RTPort.Output portE_output,
    RTPort.Input portW_input,
    RTPort.Output portW_output,
    RTPort.Input portN_input,
    RTPort.Output portN_output,
    RTPort.Input portS_input,
    RTPort.Output portS_output,

    RTPort.Input portNW_input,
    RTPort.Output portNW_output,
    RTPort.Input portNE_input,
    RTPort.Output portNE_output,

    RTPort.Input portSW_input,
    RTPort.Output porSW_output,
    RTPort.Input portSE_input,
    RTPort.Output portSE_output,

);

logic [1:0] toDemux;

// Requests between click and routers
logic req_click_router_self;
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

assign dst_y = data_self[n-maxx-2:n-maxx-2-maxy-1];
assign dst_x = data_self[n-1:n-maxx-1];
assign deltax = data_self[n-maxx-2-maxy-2]; //1 if bigger, 0 if smaller
assign deltay = data_self[n-maxx-2-maxy-3]; //1 if bigger, 0 if smaller
///////////////////////////


//logic grant1;
//logic grant2;
//logic grant3;
//logic grant_self;
//
//logic [n-1:0] grant_and1;
//logic [n-1:0] grant_and2;
//logic [n-1:0] grant_and3;


//Data from click to router/muxes
logic [n-1:0] data_self ;




//Acks from output to clicks
logic ack_proc_click;
//logic ack_port1_click;
//logic ack_port2_click;
//logic ack_port3_click;

//Signals from North input
logic reqN;
logic ackN;
logic [n-1:0] data_N;

logic [maxx-1:0] dst_xN;
logic [maxy-1:0] dst_yN;
logic deltaxN;
logic deltayN;

logic to_demux_N;
assign dst_yN = data_N[n-maxx-2:n-maxx-2-maxy-1];
assign dst_xN = data_N[n-1:n-maxx-1];
assign deltaxN = data_N[n-maxx-2-maxy-2]; //1 if bigger, 0 if smaller
assign deltayN = data_N[n-maxx-2-maxy-3]; //1 if bigger, 0 if smaller

logic forkN_to_a_req;
logic forkN_to_a_ack;
logic forkN_to_sel_req;
logic forkN_to_sel_ack;
logic selectN_req_delay;
click_element #(
    .DATA_WIDTH     (n),
    .VALUE          (0),
    .PHASE_INIT     (1'b0)) clickN
    (
    .in_ack         (portN_input.ack),
    .in_req         (portN_input.req),
    .in_data        (portN_input.data),

    .out_req        (req_N),
    .out_ack        (ack_N),
    .out_data       (data_N)

);

fork_component #() clickN_fork
(
    .rst        (rst),
    .inA_ack    (ack_N),
    .inA_req    (req_N),

    .outB_ack   (forkN_to_a_ack),
    .outB_req   (forkN_to_a_req),

    .outC_ack   (forkN_to_sel_ack),
    .outC_req   (forkN_to_sel_req)

);
delay_element #(
    .size   (10)
) delayReqNtoOther(
    .d      (forkN_to_sel_req),
    .z      (selectN_req_delay)
);

router_block4 #(

    .rtype      (rtype),
    .maxx      (maxx),
    .maxy      (maxy),
    .selfy      (srcy),
    .selfx      (srcx)

)router_north
(


    .dst_x      (dst_xN),
    .dst_y      (dst_yN),
    .dx         (delta_xN),
    .dy         (delta_yN),
    .toDemux    (to_demux_N)

    
);

demux #() demux_north_input
(
    .rst        (rst),
    .inA_req    (forkN_to_a_req),
    .inA_ack    (forkN_to_a_ack),

    .inSel_req   (selectN_req_delay),
    .inSel_ack   (forkN_to_sel_ack),
    .selector    (to_demux_N),

    .outB_req    (proc_output.req),
    .outB_ack    (proc_output.ack),
    .outB_data   (proc_output.data),

    .outC_req    (req_north_south),
    .outC_ack    (ack_north_south),
    .outC_data   (data_north_south) 

);



//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------

//Signals from South input
logic reqS;
logic ackS;
logic [n-1:0] data_S;

logic [maxx-1:0] dst_xS;
logic [maxy-1:0] dst_yS;
logic deltaxS;
logic deltayS;

logic to_demux_S;
assign dst_yS = data_S[n-maxx-2:n-maxx-2-maxy-1];
assign dst_xS = data_S[n-1:n-maxx-1];
assign deltaxS = data_S[n-maxx-2-maxy-2]; //1 if bigger, 0 if smaller
assign deltayS = data_S[n-maxx-2-maxy-3]; //1 if bigger, 0 if smaller

logic forkS_to_a_req;
logic forkS_to_a_ack;
logic forkS_to_sel_req;
logic forkS_to_sel_ack;
logic selectS_req_delay;

click_element #(
    .DATA_WIDTH     (n),
    .VALUE          (0),
    .PHASE_INIT     (1'b0)) clickS
    (
    .in_ack         (portS_input.ack),
    .in_req         (portS_input.req),
    .in_data        (portS_input.data),

    .out_req        (req_S),
    .out_ack        (ack_S),
    .out_data       (data_S)

);

fork_component #() clickS_fork
(
    .rst        (rst),
    .inA_ack    (ack_S),
    .inA_req    (req_S),

    .outB_ack   (forkS_to_a_ack),
    .outB_req   (forkS_to_a_req),

    .outC_ack   (forkS_to_sel_ack),
    .outC_req   (forkS_to_sel_req)

);
delay_element #(
    .size   (10)
) delayReqStoOther(
    .d      (forkS_to_sel_req),
    .z      (selectS_req_delay)
);

router_block2 #(

    .rtype      (rtype),
    .maxx      (maxx),
    .maxy      (maxy),
    .selfy      (srcy),
    .selfx      (srcx)

)router_south
(


    .dst_x      (dst_xS),
    .dst_y      (dst_yS),
    .dx         (delta_xS),
    .dy         (delta_yS),
    .toDemux    (to_demux_S)

    
);

demux #() demux_south_input
(
    .rst        (rst),
    .inA_req    (forkS_to_a_req),
    .inA_ack    (forkS_to_a_ack),

    .inSel_req   (selectS_req_delay),
    .inSel_ack   (forkS_to_sel_ack),
    .selector    (to_demux_S),

    .outB_req    (proc_output.req),
    .outB_ack    (proc_output.ack),
    .outB_data   (proc_output.data),

    .outC_req    (req_south_north),
    .outC_ack    (ack_south_north),
    .outC_data   (data_south_north) 

);
//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
//Signals from West input
logic reqW;
logic ackW;
logic [n-1:0] data_W;

logic [maxx-1:0] dst_xW;
logic [maxy-1:0] dst_yW;
logic deltaxW;
logic deltayW;

logic to_demux_W;

assign dst_yW = data_W[n-maxx-2:n-maxx-2-maxy-1];
assign dst_xW = data_W[n-1:n-maxx-1];
assign deltaxW = data_W[n-maxx-2-maxy-2]; //1 if bigger, 0 if smaller
assign deltayW = data_W[n-maxx-2-maxy-3]; //1 if bigger, 0 if smaller

logic forkW_to_a_req;
logic forkW_to_a_ack;
logic forkW_to_sel_req;
logic forkW_to_sel_ack;
logic selectW_req_delay;

click_element #(
    .DATA_WIDTH     (n),
    .VALUE          (0),
    .PHASE_INIT     (1'b0)) clickW
    (
    .in_ack         (portW_input.ack),
    .in_req         (portW_input.req),
    .in_data        (portW_input.data),

    .out_req        (req_W),
    .out_ack        (ack_W),
    .out_data       (data_W)

);

fork_component #() clickW_fork
(
    .rst        (rst),
    .inA_ack    (ack_W),
    .inA_req    (req_W),

    .outB_ack   (forkW_to_a_ack),
    .outB_req   (forkW_to_a_req),
    .outC_ack   (forkW_to_sel_ack),
    .outC_req   (forkW_to_sel_req)

);
delay_element #(
    .size   (10)
) delayReqWtoOther(
    .d      (forkW_to_sel_req),
    .z      (selectW_req_delay)
);

router_block2 #(

    .rtype      (rtype),
    .maxx      (maxx),
    .maxy      (maxy),
    .selfy      (srcy),
    .selfx      (srcx)

)router_west
(


    .dst_x      (dst_xW),
    .dst_y      (dst_yW),
    .dx         (delta_xW),
    .dy         (delta_yW),
    .toDemux    (to_demux_W)

    
);

demux #() demux_west_input
(
    .rst        (rst),
    .inA_req    (forkW_to_a_req),
    .inA_ack    (forkW_to_a_ack),

    .inSel_req   (selectW_req_delay),
    .inSel_ack   (forkW_to_sel_ack),
    .selector    (to_demux_W),

    .outB_req    (proc_output.req),
    .outB_ack    (proc_output.ack),
    .outB_data   (proc_output.data),

    .outC_req    (req_west_east),
    .outC_ack    (ack_west_east),
    .outC_data   (data_west_east) 

);
//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
//Signals from East input
logic reqE;
logic ackE;
logic [n-1:0] data_E;

logic [maxx-1:0] dst_xE;
logic [maxy-1:0] dst_yE;
logic deltaxE;
logic deltayE;

logic to_demux_E;

assign dst_yE = data_E[n-maxx-2:n-maxx-2-maxy-1];
assign dst_xE = data_E[n-1:n-maxx-1];
assign deltaxE = data_E[n-maxx-2-maxy-2]; //1 if bigger, 0 if smaller
assign deltayE = data_E[n-maxx-2-maxy-3]; //1 if bigger, 0 if smaller

logic forkE_to_a_req;
logic forkE_to_a_ack;
logic forkE_to_sel_req;
logic forkE_to_sel_ack;
logic selectE_req_delay;




click_element #(
    .DATA_WIDTH     (n),
    .VALUE          (0),
    .PHASE_INIT     (1'b0)) clickE
    (
    .in_ack         (portE_input.ack),
    .in_req         (portE_input.req),
    .in_data        (portE_input.data),

    .out_req        (req_E),
    .out_ack        (ack_E),
    .out_data       (data_E)

);
fork_component #() clickE_fork
(
    .rst        (rst),
    .inA_ack    (ack_E),
    .inA_req    (req_E),

    .outB_ack   (forkE_to_a_ack),
    .outB_req   (forkE_to_a_req),
    .outC_ack   (forkE_to_sel_ack),
    .outC_req   (forkE_to_sel_req)

);
delay_element #(
    .size   (10)
) delayReqEtoOther(
    .d      (forkE_to_sel_req),
    .z      (selectE_req_delay)
);

router_block2 #(

    .rtype      (rtype),
    .maxx      (maxx),
    .maxy      (maxy),
    .selfy      (srcy),
    .selfx      (srcx)

)router_east
(


    .dst_x      (dst_xE),
    .dst_y      (dst_yE),
    .dx         (delta_xE),
    .dy         (delta_yE),
    .toDemux    (to_demux_E)

    
);

demux #() demux_east_input
(
    .rst        (rst),
    .inA_req    (forkE_to_a_req),
    .inA_ack    (forkE_to_a_ack),

    .inSel_req   (selectE_req_delay),
    .inSel_ack   (forkE_to_sel_ack),
    .selector    (to_demux_E),

    .outB_req    (proc_output.req),
    .outB_ack    (proc_output.ack),
    .outB_data   (proc_output.data),

    .outC_req    (req_east_west),
    .outC_ack    (ack_east_west),
    .outC_data   (data_east_west) 

);
//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------

//Signals from Northwest input
logic reqNW;
logic ackNW;
logic [n-1:0] data_NW;

logic [maxx-1:0] dst_xNW;
logic [maxy-1:0] dst_yNW;
logic deltaxNW;
logic deltayNW;

logic [1:0] to_demux_NW;

assign dst_yNW = data_NW[n-maxx-2:n-maxx-2-maxy-1];
assign dst_xNW = data_NW[n-1:n-maxx-1];
assign deltaxNW = data_NW[n-maxx-2-maxy-2]; //1 if bigger, 0 if smaller
assign deltayNW = data_NW[n-maxx-2-maxy-3]; //1 if bigger, 0 if smaller

logic forkNW_to_a_req;
logic forkNW_to_a_ack;
logic forkNW_to_sel_req;
logic forkNW_to_sel_ack;
logic selectNW_req_delay;

click_element #(
    .DATA_WIDTH     (n),
    .VALUE          (0),
    .PHASE_INIT     (1'b0)) clickNW
    (
    .in_ack         (portNW_input.ack),
    .in_req         (portNW_input.req),
    .in_data        (portNW_input.data),

    .out_req        (req_NW),
    .out_ack        (ack_NW),
    .out_data       (data_NW)

);

fork_component #() clickNW_fork
(
    .rst        (rst),
    .inA_ack    (ack_NW),
    .inA_req    (req_NW),

    .outB_ack   (forkNW_to_a_ack),
    .outB_req   (forkNW_to_a_req),
    .outC_ack   (forkNW_to_sel_ack),
    .outC_req   (forkNW_to_sel_req)

);
delay_element #(
    .size   (10)
) delayReqNWtoOther(
    .d      (forkNW_to_sel_req),
    .z      (selectNW_req_delay)
);

router_block4 #(

    .rtype      (rtype),
    .maxx      (maxx),
    .maxy      (maxy),
    .selfy      (srcy),
    .selfx      (srcx)

)router_northwest
(


    .dst_x      (dst_xNW),
    .dst_y      (dst_yNW),
    .dx         (delta_xNW),
    .dy         (delta_yNW),
    .toDemux    (to_demux_NW)

    
);

demux4 #() demux_northwest_input
(
    .rst        (rst),
    .inA_req    (forkNW_to_a_req),
    .inA_ack    (forkNW_to_a_ack),

    .inSel_req   (selectNW_req_delay),
    .inSel_ack   (forkNW_to_sel_ack),
    .selector    (to_demux_NW),

    .outB_req    (proc_output.req),
    .outB_ack    (proc_output.ack),
    .outB_data   (proc_output.data),

    .outC_req    (req_northwest_south),
    .outC_ack    (ack_northwest_south),
    .outC_data   (data_northwest_south),

    .outD_req    (req_northwest_east),
    .outD_ack    (ack_northwest_east),
    .outD_data   (data_northwest_east),

    .outE_req    (req_northwest_southeast),
    .outE_ack    (ack_northwest_southeast),
    .outE_data   (data_northwest_southeast)

);
//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------


//Signals from Northeast input
logic reqNE;
logic ackNE;
logic [n-1:0] data_NE;

//Signals from Southwest input
logic reqSW;
logic ackSW;
logic [n-1:0] data_SW;

//Signals from Southeast input
logic reqSE;
logic ackSE;
logic [n-1:0] data_SE;

//logic unused_req = 1'b0;
//logic unused_ack = 1'b0;
//logic [n-1:0] unused_databus =  {(n){1'b0}};
//logic unused_req2 = 1'b0;
//logic unused_ack2 = 1'b0;
//logic [n-1:0] unused_databus2 =  {(n){1'b0}};

//logic out_req;
//logic out_ack;
//logic [n-1:0] out_data;

///Outputs



//Signals from North output
logic req_south_north;
logic ack_south_north;
logic [n-1:0] data_south_north;

logic req_southwest_north;
logic ack_southwest_north;
logic [n-1:0] data_southwest_north;

logic req_southeast_north;
logic ack_southeast_north;
logic [n-1:0] data_southeast_north;

logic req_local_N;
logic ack_local_N;
logic [n-1:0] data_local_N;

arbiter4 #() north_arbiter
(
    .rst    (rst),
    
    .inA_req    (req_south_north),
    .inA_data   (data_south_north),
    .inA_ack    (ack_south_north),
    
    .inB_req    (req_southwest_north),
    .inB_data   (data_southwest_north),
    .inB_ack    (ack_southwest_north),
    
    .inC_req    (req_southeast_north),
    .inC_data   (data_southeast_north),
    .inC_ack    (ack_southeast_north),
    
    .inD_req    (req_local_N),
    .inD_data   (data_local_N),
    .inD_ack    (ack_local_N),
    
    .out_req    (portN_output.req),
    .out_data   (portN_output.data),
    .out_ack    (portN_output.ack)
);

//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
//Signals from South output
logic req_north_south;
logic ack_north_south;
logic [n-1:0] data_north_south;

logic req_northwest_south;
logic ack_northwest_south;
logic [n-1:0] data_northwest_south;

logic req_northeast_south;
logic ack_northeast_south;
logic [n-1:0] data_northeast_south;

logic req_local_S;
logic ack_local_S;
logic [n-1:0] data_local_S;

arbiter4 #() south_arbiter
(
    .rst    (rst),
    
    .inA_req    (req_north_south),
    .inA_data   (data_north_south),
    .inA_ack    (ack_north_south),
    
    .inB_req    (req_northwest_south),
    .inB_data   (data_northwest_south),
    .inB_ack    (ack_northwest_south),
    
    .inC_req    (req_northeast_south),
    .inC_data   (data_northeast_south),
    .inC_ack    (ack_northeast_south),
    
    .inD_req    (req_local_S),
    .inD_data   (ack_local_S),
    .inD_ack    (data_local_S),
    
    .out_req    (portS_output.req),
    .out_data   (portS_output.data),
    .out_ack    (portS_output.ack)
);

//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
//Signals from West output
logic req_east_west;
logic ack_east_west;
logic [n-1:0] data_east_west;

logic req_northeast_west;
logic ack_northeast_west;
logic [n-1:0] data_northeast_west;

logic req_southeast_west;
logic ack_southeast_west;
logic [n-1:0] data_southeast_west;

logic req_local_W;
logic ack_local_W;
logic [n-1:0] data_local_W;

arbiter4 #() west_arbiter
(
    .rst    (rst),
    
    .inA_req    (req_east_west),
    .inA_data   (data_east_west),
    .inA_ack    (ack_east_west),
    
    .inB_req    (req_southeast_west),
    .inB_data   (data_southeast_west),
    .inB_ack    (ack_southeast_west),
    
    .inC_req    (req_northeast_west),
    .inC_data   (data_northeast_west),
    .inC_ack    (ack_northeast_west),
    
    .inD_req    (req_local_W),
    .inD_data   (ack_local_W),
    .inD_ack    (data_local_W),
    
    .out_req    (portW_output.req),
    .out_data   (portW_output.data),
    .out_ack    (portW_output.ack)
);

//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
//Signals from East output
logic req_west_east;
logic ack_west_east;
logic [n-1:0] data_west_east;

logic req_northwest_east;
logic ack_northwest_east;
logic [n-1:0] data_northwest_east;

logic req_southwest_east;
logic ack_southwest_east;
logic [n-1:0] data_southwest_east;

logic req_local_E;
logic ack_local_E;
logic [n-1:0] data_local_E;

arbiter4 #() east_arbiter
(
    .rst    (rst),
    
    .inA_req    (req_west_east),
    .inA_data   (data_west_east),
    .inA_ack    (ack_west_east),
    
    .inB_req    (req_southwest_east),
    .inB_data   (data_southwest_east),
    .inB_ack    (ack_southwest_east),
    
    .inC_req    (req_northwest_east),
    .inC_data   (data_northwest_east),
    .inC_ack    (ack_northwest_east),
    
    .inD_req    (req_local_E),
    .inD_data   (ack_local_E),
    .inD_ack    (data_local_E),
    
    .out_req    (portE_output.req),
    .out_data   (portE_output.data),
    .out_ack    (portE_output.ack)
);

//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
//Signals from Northwest output
logic req_southeast_northwest;
logic ack_southeast_northwest;
logic [n-1:0] data_southeast_northwest;


logic req_local_NW;
logic ack_local_NW;
logic [n-1:0] data_local_NW;

arbiter #() northwest_arbiter
(
    .rst    (rst),
    
    .inA_req    (req_southeast_northwest),
    .inA_data   (data_southeast_northwest),
    .inA_ack    (ack_southeast_northwest),
    
    .inB_req    (req_local_NW),
    .inB_data   (data_local_NW),
    .inB_ack    (ack_local_NW),
    ,
    
    .out_req    (portNW_output.req),
    .out_data   (portNW_output.data),
    .out_ack    (portNW_output.ack)
);

//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------

click_element #(
    .DATA_WIDTH     (n),
    .VALUE          (0),
    .PHASE_INIT     (1'b0)) clickNE
    (
    .in_ack         (portNE_input.ack),
    .in_req         (portNE_input.req),
    .in_data        (portNE_input.data),

    .out_req        (req_NE),
    .out_ack        (ack_NE),
    .out_data       (data_NE)

);
click_element #(
    .DATA_WIDTH     (n),
    .VALUE          (0),
    .PHASE_INIT     (1'b0)) clickSW
    (
    .in_ack         (portSW_input.ack),
    .in_req         (portSW_input.req),
    .in_data        (portSW_input.data),

    .out_req        (req_SW),
    .out_ack        (ack_SW),
    .out_data       (data_SW)

);
click_element #(
    .DATA_WIDTH     (n),
    .VALUE          (0),
    .PHASE_INIT     (1'b0)) clickSE
    (
    .in_ack         (portSE_input.ack),
    .in_req         (portSE_input.req),
    .in_data        (portSE_input.data),

    .out_req        (req_SE),
    .out_ack        (ack_SE),
    .out_data       (data_SE)

);

click_element #(
    .DATA_WIDTH     (n),
    .VALUE          (0),
    .PHASE_INIT     (1'b0)) clickself
    (
    .in_ack         (proc_input.ack), //OK
    .in_req         (proc_input.req), //OK
    .in_data        (proc_input.data), //OK

    .out_req        (req_click_router_self), //OK
    .out_ack        (ack_proc_click), //OK
    .out_data       (data_self) //OK
    );



router_block4 #(

    .rtype      (rtype),
    .maxx      (maxx),
    .maxy      (maxy),
    .selfy      (srcy),
    .selfx      (srcx)

)router_self
(


    .dst_x      (dst_x),
    .dst_y      (dst_y),
    .dx         (delta_x),
    .dy         (delta_y),
    .toDemux    (toDemux)

   // .outputWE        (req_self1),
   // .outputNS       (req_self2),
   // .outputDiag        (req_self3),
   // .outputSelf        (req_selfself)
    
);

delay_element #(
    .size   (10)
) delayReqLocaltoOther(
    .d      (fork_to_sel_req),
    .z      (sel_req_delay_o)
);

demux4 #() demuxLocaltoOther
(
    .rst        (rst),
    .inA_req    (fork_to_a_req),
    .inA_ack    (fork_to_a_ack),

    .inSel_req   (sel_req_delay_o),
    .inSel_ack   (fork_to_sel_ack),
    .selector    (toDemux),

    .outB_req    (port1_output.req),
    .outB_ack    (port1_output.ack),
    .outB_data   (port1_output.data),

    .outC_req    (port2_output.req),
    .outC_ack    (port2_output.ack),
    .outC_data   (port2_output.data),

    .outD_req    (port3_output.req),
    .outD_ack    (port3_output.ack),
    .outD_data   (port3_output.data),

    .outE_req    (unused_req),
    .outE_ack    (unused_ack),
    .outE_data   (unused_databus)    

);

//assign grant1 = req_self1;
//assign grant2 = req_self2;
//assign grant3 = req_self3;

//assign grant_and1 = {(n){grant1}};
//assign grant_and2 = {(n){grant2}};
//assign grant_and3 = {(n){grant2}};

//assign port1_output.data = data_self & grant_and1;
//assign port1_output.req = grant1;

//assign port2_output.data = data_self & grant_and2;
//assign port2_output.req = grant2;

//assign port3_output.data = data_self & grant_and3;
//assign port3_output.req = grant3;


//assign ack_proc_click = (grant1 & port1_output.ack) | (grant2 & port2_output.ack) | (grant3 & port3_output.ack);

// Ports to Proc
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


// Routers



fork_component #() click_fork
(
    .rst        (rst),
    .inA_ack    (ack_proc_click),
    .inA_req    (req_click_router_self),

    .outB_ack   (fork_to_a_ack),
    .outB_req   (fork_to_a_req),

    .outC_ack   (fork_to_sel_ack),
    .outC_req   (fork_to_sel_req)

);

endmodule