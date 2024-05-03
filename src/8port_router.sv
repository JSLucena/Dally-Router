module full_router
    import router_pkg::*;
#(

    parameter router_type rtype = CORNERNE,
    parameter integer n = 32,
    parameter integer srcx = 2,
    parameter integer srcy = 2,
    parameter integer maxx = 3,
    parameter integer maxy = 3
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
    RTPort.Output portSE_output

);

logic [2:0] toDemux;

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
//logic deltax1;
//logic deltay1;

assign dst_y = data_self[n-maxx-1:n-maxx-maxy];
assign dst_x = data_self[n-1:n-maxx];
////assign deltax = data_self[n-maxx-2-maxy-2]; //1 if bigger, 0 if smaller
////assign deltay = data_self[n-maxx-2-maxy-3]; //1 if bigger, 0 if smaller
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
//logic deltaxN;
//logic deltayN;

logic to_demux_N;
assign dst_yN = data_N[n-maxx-2:n-maxx-2-maxy-1];
assign dst_xN = data_N[n-1:n-maxx-1];
//assign deltaxN = data_N[n-maxx-2-maxy-2]; //1 if bigger, 0 if smaller
//assign deltayN = data_N[n-maxx-2-maxy-3]; //1 if bigger, 0 if smaller

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
    .size   (20)
) delayReqNtoOther(
    .d      (forkN_to_sel_req),
    .z      (selectN_req_delay)
);

router_block2 #(

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

    .outB_req    (req_N_local),
    .outB_ack    (ack_N_local),
    .outB_data   (data_N_local),

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
//logic deltaxS;
//logic deltayS;

logic to_demux_S;
assign dst_yS = data_S[n-maxx-2:n-maxx-2-maxy-1];
assign dst_xS = data_S[n-1:n-maxx-1];
//assign deltaxS = data_S[n-maxx-2-maxy-2]; //1 if bigger, 0 if smaller
//assign deltayS = data_S[n-maxx-2-maxy-3]; //1 if bigger, 0 if smaller

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
    .size   (20)
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

    .outB_req    (req_S_local),
    .outB_ack    (ack_S_local),
    .outB_data   (data_S_local),

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
//logic deltaxW;
//logic deltayW;

logic to_demux_W;

assign dst_yW = data_W[n-maxx-2:n-maxx-2-maxy-1];
assign dst_xW = data_W[n-1:n-maxx-1];
//assign deltaxW = data_W[n-maxx-2-maxy-2]; //1 if bigger, 0 if smaller
//assign deltayW = data_W[n-maxx-2-maxy-3]; //1 if bigger, 0 if smaller

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
    .size   (20)
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

    .outB_req    (req_W_local),
    .outB_ack    (ack_W_local),
    .outB_data   (data_W_local),

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
//logic deltaxE;
//logic deltayE;

logic to_demux_E;

assign dst_yE = data_E[n-maxx-2:n-maxx-2-maxy-1];
assign dst_xE = data_E[n-1:n-maxx-1];
//assign deltaxE = data_E[n-maxx-2-maxy-2]; //1 if bigger, 0 if smaller
//assign deltayE = data_E[n-maxx-2-maxy-3]; //1 if bigger, 0 if smaller

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
    .size   (20)
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

    .outB_req    (req_E_local),
    .outB_ack    (ack_E_local),
    .outB_data   (data_E_local),

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
//logic deltaxNW;
//logic deltayNW;

logic [1:0] to_demux_NW;

assign dst_yNW = data_NW[n-maxx-2:n-maxx-2-maxy-1];
assign dst_xNW = data_NW[n-1:n-maxx-1];
//assign deltaxNW = data_NW[n-maxx-2-maxy-2]; //1 if bigger, 0 if smaller
//assign deltayNW = data_NW[n-maxx-2-maxy-3]; //1 if bigger, 0 if smaller

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
    .size   (20)
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

    .outB_req    (req_NW_local),
    .outB_ack    (ack_NW_local),
    .outB_data   (data_NW_local),

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

logic [maxx-1:0] dst_xNE;
logic [maxy-1:0] dst_yNE;
//logic deltaxNE;
//logic deltayNE;

logic [1:0] to_demux_NE;

assign dst_yNE = data_NE[n-maxx-2:n-maxx-2-maxy-1];
assign dst_xNE = data_NE[n-1:n-maxx-1];
//assign deltaxNE = data_NE[n-maxx-2-maxy-2]; //1 if bigger, 0 if smaller
//assign deltayNE = data_NE[n-maxx-2-maxy-3]; //1 if bigger, 0 if smaller

logic forkNE_to_a_req;
logic forkNE_to_a_ack;
logic forkNE_to_sel_req;
logic forkNE_to_sel_ack;
logic selectNE_req_delay;

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

fork_component #() clickNE_fork
(
    .rst        (rst),
    .inA_ack    (ack_NE),
    .inA_req    (req_NE),

    .outB_ack   (forkNE_to_a_ack),
    .outB_req   (forkNE_to_a_req),
    .outC_ack   (forkNE_to_sel_ack),
    .outC_req   (forkNE_to_sel_req)

);
delay_element #(
    .size   (20)
) delayReqNEtoOther(
    .d      (forkNE_to_sel_req),
    .z      (selectNE_req_delay)
);

router_block4 #(

    .rtype      (rtype),
    .maxx      (maxx),
    .maxy      (maxy),
    .selfy      (srcy),
    .selfx      (srcx)

)router_northeast
(


    .dst_x      (dst_xNE),
    .dst_y      (dst_yNE),
    .dx         (delta_xNE),
    .dy         (delta_yNE),
    .toDemux    (to_demux_NE)

    
);

demux4 #() demux_northeast_input
(
    .rst        (rst),
    .inA_req    (forkNE_to_a_req),
    .inA_ack    (forkNE_to_a_ack),

    .inSel_req   (selectNE_req_delay),
    .inSel_ack   (forkNE_to_sel_ack),
    .selector    (to_demux_NE),

    .outB_req    (req_NE_local),
    .outB_ack    (ack_NE_local),
    .outB_data   (data_NE_local),

    .outC_req    (req_northeast_south),
    .outC_ack    (ack_northeast_south),
    .outC_data   (data_northeast_south),

    .outD_req    (req_northeast_west),
    .outD_ack    (ack_northeast_west),
    .outD_data   (data_northeast_west),

    .outE_req    (req_northeast_southwest),
    .outE_ack    (ack_northeast_southwest),
    .outE_data   (data_northeast_southwest)

);
//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------

//Signals from Southwest input
logic reqSW;
logic ackSW;
logic [n-1:0] data_SW;

logic [maxx-1:0] dst_xSW;
logic [maxy-1:0] dst_ySW;
//logic deltaxSW;
//logic deltaySW;

logic [1:0] to_demux_SW;

assign dst_ySW = data_SW[n-maxx-2:n-maxx-2-maxy-1];
assign dst_xSW = data_SW[n-1:n-maxx-1];
//assign deltaxSW = data_SW[n-maxx-2-maxy-2]; //1 if bigger, 0 if smaller
//assign deltaySW = data_SW[n-maxx-2-maxy-3]; //1 if bigger, 0 if smaller

logic forkSW_to_a_req;
logic forkSW_to_a_ack;
logic forkSW_to_sel_req;
logic forkSW_to_sel_ack;
logic selectSW_req_delay;

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

fork_component #() clickSW_fork
(
    .rst        (rst),
    .inA_ack    (ack_SW),
    .inA_req    (req_SW),

    .outB_ack   (forkSW_to_a_ack),
    .outB_req   (forkSW_to_a_req),
    .outC_ack   (forkSW_to_sel_ack),
    .outC_req   (forkSW_to_sel_req)

);
delay_element #(
    .size   (20)
) delayReqSWtoOther(
    .d      (forkSW_to_sel_req),
    .z      (selectSW_req_delay)
);

router_block4 #(

    .rtype      (rtype),
    .maxx      (maxx),
    .maxy      (maxy),
    .selfy      (srcy),
    .selfx      (srcx)

)router_southwest
(


    .dst_x      (dst_xSW),
    .dst_y      (dst_ySW),
    .dx         (delta_xSW),
    .dy         (delta_ySW),
    .toDemux    (to_demux_SW)

    
);

demux4 #() demux_southwest_input
(
    .rst        (rst),
    .inA_req    (forkSW_to_a_req),
    .inA_ack    (forkSW_to_a_ack),

    .inSel_req   (selectSW_req_delay),
    .inSel_ack   (forkSW_to_sel_ack),
    .selector    (to_demux_SW),

    .outB_req    (req_SW_local),
    .outB_ack    (ack_SW_local),
    .outB_data   (data_SW_local),

    .outC_req    (req_southwest_north),
    .outC_ack    (ack_southwest_north),
    .outC_data   (data_southwest_north),

    .outD_req    (req_southwest_east),
    .outD_ack    (ack_southwest_east),
    .outD_data   (data_southwest_east),

    .outE_req    (req_southwest_northeast),
    .outE_ack    (ack_southwest_northeast),
    .outE_data   (data_southwest_northeast)

);
//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------

//Signals from Southeast input
logic reqSE;
logic ackSE;
logic [n-1:0] data_SE;

logic [maxx-1:0] dst_xSE;
logic [maxy-1:0] dst_ySE;
//logic deltaxSE;
//logic deltaySE;

logic [1:0] to_demux_SE;

assign dst_ySE = data_SE[n-maxx-2:n-maxx-2-maxy-1];
assign dst_xSE = data_SE[n-1:n-maxx-1];
//assign deltaxSE = data_SE[n-maxx-2-maxy-2]; //1 if bigger, 0 if smaller
//assign deltaySE = data_SE[n-maxx-2-maxy-3]; //1 if bigger, 0 if smaller

logic forkSE_to_a_req;
logic forkSE_to_a_ack;
logic forkSE_to_sel_req;
logic forkSE_to_sel_ack;
logic selectSE_req_delay;

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

fork_component #() clickSE_fork
(
    .rst        (rst),
    .inA_ack    (ack_SE),
    .inA_req    (req_SE),

    .outB_ack   (forkSE_to_a_ack),
    .outB_req   (forkSE_to_a_req),
    .outC_ack   (forkSE_to_sel_ack),
    .outC_req   (forkSE_to_sel_req)

);
delay_element #(
    .size   (20)
) delayReqSEtoOther(
    .d      (forkSE_to_sel_req),
    .z      (selectSE_req_delay)
);

router_block4 #(

    .rtype      (rtype),
    .maxx      (maxx),
    .maxy      (maxy),
    .selfy      (srcy),
    .selfx      (srcx)

)router_southeast
(


    .dst_x      (dst_xSE),
    .dst_y      (dst_ySE),
    .dx         (delta_xSE),
    .dy         (delta_ySE),
    .toDemux    (to_demux_SE)

    
);

demux4 #() demux_southeast_input
(
    .rst        (rst),
    .inA_req    (forkSE_to_a_req),
    .inA_ack    (forkSE_to_a_ack),

    .inSel_req   (selectSE_req_delay),
    .inSel_ack   (forkSE_to_sel_ack),
    .selector    (to_demux_SE),

    .outB_req    (req_SE_local),
    .outB_ack    (ack_SE_local),
    .outB_data   (data_SE_local),

    .outC_req    (req_southeast_north),
    .outC_ack    (ack_southeast_north),
    .outC_data   (data_southeast_north),

    .outD_req    (req_southeast_west),
    .outD_ack    (ack_southeast_west),
    .outD_data   (data_southeast_west),

    .outE_req    (req_southeast_northwest),
    .outE_ack    (ack_southeast_northwest),
    .outE_data   (data_southeast_northwest)

);
//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------



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

arbiter4 #(n) north_arbiter
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

arbiter4 #(n) south_arbiter
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
    .inD_data   (data_local_S),
    .inD_ack    (ack_local_S),
    
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

arbiter4 #(n) west_arbiter
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
    .inD_data   (data_local_W),
    .inD_ack    (ack_local_W),
    
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

arbiter4 #(n) east_arbiter
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

arbiter #(n) northwest_arbiter
(
    .rst    (rst),
    
    .inA_req    (req_southeast_northwest),
    .inA_data   (data_southeast_northwest),
    .inA_ack    (ack_southeast_northwest),
    
    .inB_req    (req_local_NW),
    .inB_data   (data_local_NW),
    .inB_ack    (ack_local_NW),
    
    
    .out_req    (portNW_output.req),
    .out_data   (portNW_output.data),
    .out_ack    (portNW_output.ack)
);

//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------

//Signals from Northeast output
logic req_southwest_northeast;
logic ack_southwest_northeast;
logic [n-1:0] data_southwest_northeast;


logic req_local_NE;
logic ack_local_NE;
logic [n-1:0] data_local_NE;

arbiter #(n) northeast_arbiter
(
    .rst    (rst),
    
    .inA_req    (req_southwest_northeast),
    .inA_data   (data_southwest_northeast),
    .inA_ack    (ack_southwest_northeast),
    
    .inB_req    (req_local_NE),
    .inB_data   (data_local_NE),
    .inB_ack    (ack_local_NE),
    
    
    .out_req    (portNE_output.req),
    .out_data   (portNE_output.data),
    .out_ack    (portNE_output.ack)
);

//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
//Signals from Soutwest output
logic req_northeast_southwest;
logic ack_northeast_southwest;
logic [n-1:0] data_northeast_southwest;


logic req_local_SW;
logic ack_local_SW;
logic [n-1:0] data_local_SW;

arbiter #(n) southwest_arbiter
(
    .rst    (rst),
    
    .inA_req    (req_northeast_southwest),
    .inA_data   (data_northeast_southwest),
    .inA_ack    (ack_northeast_southwest),
    
    .inB_req    (req_local_SW),
    .inB_data   (data_local_SW),
    .inB_ack    (ack_local_SW),
    
    
    .out_req    (portSW_output.req),
    .out_data   (portSW_output.data),
    .out_ack    (portSW_output.ack)
);

//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------

//Signals from Southeast output
logic req_northwest_southeast;
logic ack_northwest_southeast;
logic [n-1:0] data_northwest_southeast;


logic req_local_SE;
logic ack_local_SE;
logic [n-1:0] data_local_SE;

arbiter #(n) southeast_arbiter
(
    .rst    (rst),
    
    .inA_req    (req_northwest_southeast),
    .inA_data   (data_northwest_southeast),
    .inA_ack    (ack_northwest_southeast),
    
    .inB_req    (req_local_SE),
    .inB_data   (data_local_SE),
    .inB_ack    (ack_local_SE),
    
    
    .out_req    (portSE_output.req),
    .out_data   (portSE_output.data),
    .out_ack    (portSE_output.ack)
);

//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
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



router_block8 #(

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
    
);

delay_element #(
    .size   (20)
) delayReqLocaltoOther(
    .d      (fork_to_sel_req),
    .z      (sel_req_delay_o)
);

demux8 #() demuxLocaltoOther
(
    .rst        (rst),
    .inA_req    (fork_to_a_req),
    .inA_ack    (fork_to_a_ack),

    .inSel_req   (sel_req_delay_o),
    .inSel_ack   (fork_to_sel_ack),
    .selector    (toDemux),

    .outB_req    (req_local_NE),
    .outB_ack    (ack_local_NE),
    .outB_data   (data_local_NE),

    .outC_req    (req_local_NW),
    .outC_ack    (ack_local_NW),
    .outC_data   (data_local_NW),

    .outD_req    (req_local_SE),
    .outD_ack    (ack_local_SE),
    .outD_data   (data_local_SE),

    .outE_req    (req_local_SW),
    .outE_ack    (ack_local_SW),
    .outE_data   (data_local_SW),

    .outF_req    (req_local_N),
    .outF_ack    (ack_local_N),
    .outF_data   (data_local_N), 

    .outG_req    (req_local_S),
    .outG_ack    (ack_local_S),
    .outG_data   (data_local_S), 

    .outH_req    (req_local_E),
    .outH_ack    (ack_local_E),
    .outH_data   (data_local_E), 

    .outI_req    (req_local_W),
    .outI_ack    (ack_local_W),
    .outI_data   (data_local_W)   

);


// Ports to Proc

logic req_N_local;
logic ack_N_local;
logic [n-1:0] data_N_local;

logic req_S_local;
logic ack_S_local;
logic [n-1:0] data_S_local;

logic req_E_local;
logic ack_E_local;
logic [n-1:0] data_E_local;

logic req_W_local;
logic ack_W_local;
logic [n-1:0] data_W_local;

logic req_NW_local;
logic ack_NW_local;
logic [n-1:0] data_NW_local;

logic req_SE_local;
logic ack_SE_local;
logic [n-1:0] data_SE_local;

logic req_NE_local;
logic ack_NE_local;
logic [n-1:0] data_NE_local;

logic req_SW_local;
logic ack_SW_local;
logic [n-1:0] data_SW_local;

arbiter8 #(n) proc_arbiter
(
    .rst    (rst),
    
    .inA_req    (req_N_local),
    .inA_data   (data_N_local),
    .inA_ack    (ack_N_local),
    
    .inB_req    (req_S_local),
    .inB_data   (data_S_local),
    .inB_ack    (ack_S_local),
    
    .inC_req    (req_E_local),
    .inC_data   (data_E_local),
    .inC_ack    (ack_E_local),
    
    .inD_req    (req_W_local),
    .inD_data   (data_W_local),
    .inD_ack    (ack_W_local),

    .inE_req    (req_NW_local),
    .inE_data   (data_NW_local),
    .inE_ack    (ack_NW_local),

    .inF_req    (req_NE_local),
    .inF_data   (data_NE_local),
    .inF_ack    (ack_NE_local),

    .inG_req    (req_SW_local),
    .inG_data   (data_SW_local),
    .inG_ack    (ack_SW_local),

    .inH_req    (req_SE_local),
    .inH_data   (data_SE_local),
    .inH_ack    (ack_SE_local),
    
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