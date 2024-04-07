module Corner_Router
    import router_pkg::*;
#(

    parameter router_type rtype = CORNERNE,
    parameter integer n = 32,
    parameter integer srcx = 0,
    parameter integer srcy = 0,
    parameter integer maxx = 2,
    parameter integer maxy = 2
)
(
    //Global
    input logic rst,
    
    /// Signals between router and cpu
    input logic [n-1:0] proc_data_i, //OK
    input logic req_proc_self, //OK
    output logic ack_self_proc, //OK
    
    input logic ack_proc_self, //TODO
    output logic [n-1:0] proc_data_o, //TODO
    output logic req_self_proc, //TODO
    //----------------------------------------
    
    input logic [n-1:0] port1_i,
    input logic port1_input_req, 
    output logic port1_input_ack, 
    
    input logic port1_output_ack, //OK
    output logic [n-1:0] port1_o,
    output logic port1_output_req,
//---------------------------------------------
    input logic [n-1:0] port2_i,     
    input logic port2_input_req, 
    output logic port2_input_ack, 
    
    output logic [n-1:0] port2_o, //OK
    input logic port2_output_ack,
    output logic port2_output_req, 
//----------------------------------------------
    input logic [n-1:0] port3_i, 
    input logic port3_input_req, 
    output logic port3_input_ack, 
    
    output logic [n-1:0] port3_o, //OK
    input logic port3_output_ack,
    output logic port3_output_req
     


);
//Signals for self router
logic req_self1;
logic req_self2;
logic req_self3;
logic req_selfself;

// Requests between click and routers
logic req_click_router_self;


// Signals for input 1
logic [maxx-1:0] src_x1;
logic [maxy-1:0] src_y1;
logic deltax1;
logic deltay1;

assign src_y1 = data_self[n-maxx-2:n-maxx-2-maxy-1];
assign src_x1 = data_self[n-1:n-maxx-1];
assign deltax1 = data_self[n-maxx-2-maxy-2]; //1 if bigger, 0 if smaller
assign deltay1 = data_self[n-maxx-2-maxy-3]; //1 if bigger, 0 if smaller
///////////////////////////

///Outputs
logic grant1;
logic grant2;
logic grant3;
logic grant_self;

logic [n-1:0] grant_and1;
logic [n-1:0] grant_and2;
logic [n-1:0] grant_and3;


//Data from click to router/muxes
logic [n-1:0] data_self ;
logic [n-1:0] data_1 ;
logic [n-1:0] data_2 ;
logic [n-1:0] data_3 ;

//Acks from output to clicks
logic ack_proc_click;
logic ack_port1_click;
logic ack_port2_click;
logic ack_port3_click;

//Signals from ports to proc output
logic req1;
logic ack1;
logic req2;
logic ack2;
logic req3;
logic ack3;
logic unused_req = 1'b0;
logic unused_ack = 1'b0;
logic [n-1:0] unused_databus =  {(n){1'b0}};

//logic out_req;
//logic out_ack;
//logic [n-1:0] out_data;


router_block4 #(

    .rtype      (rtype),
    .maxx      (maxx),
    .maxy      (maxy),
    .selfy      (srcy),
    .selfx      (srcx)

)router_self
(
    .req_i      (req_click_router_self),


    .src_x      (srcx),
    .src_y      (srcy),
    .dx         (delta_x1),
    .dy         (delta_y1),
    
    .outputWE        (req_self1),
    .outputNS       (req_self2),
    .outputDiag        (req_self3),
    .outputSelf        (req_selfself)
    
);

assign grant1 = req_self1;
assign grant2 = req_self2;
assign grant3 = req_self3;

assign grant_and1 = {(n){grant1}};
assign grant_and2 = {(n){grant2}};
assign grant_and3 = {(n){grant2}};

assign port1_o = data_self & grant_and1;
assign port1_output_req = grant1;

assign port2_o = data_self & grant_and2;
assign port2_output_req = grant2;

assign port3_o = data_self & grant_and3;
assign port3_output_req = grant3;


assign ack_proc_click = (grant1 & port1_output_ack) | (grant2 & port2_output_ack) | (grant3 & port3_output_ack);

// Ports to Proc
arbiter4 #()
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
    
    .inD_req    (unused_req),
    .inD_data   (unused_databus),
    .inD_ack    (unused_ack),
    
    .out_req    (req_self_proc),
    .out_data   (proc_data_o),
    .out_ack    (ack_proc_self)
);

// Input latches
click_element #(
    .DATA_WIDTH     (n),
    .VALUE          (0),
    .PHASE_INIT     (1'b0)) click1
    (
    .in_ack         (port1_input_ack),
    .in_req         (port1_input_req),
    .in_data        (port1_i),

    .out_req        (req_1),
    .out_ack        (ack_1),
    .out_data       (data_1)

);



click_element #(
    .DATA_WIDTH     (n),
    .VALUE          (0),
    .PHASE_INIT     (1'b0)) click2
    (
    .in_ack         (port2_input_ack),
    .in_req         (port2_input_req),
    .in_data        (port2_i),

    .out_req        (req_2),
    .out_ack        (ack_2),
    .out_data       (data_2)

);
click_element #(
    .DATA_WIDTH     (n),
    .VALUE          (0),
    .PHASE_INIT     (1'b0)) click3
    (
    .in_ack         (port3_input_ack),
    .in_req         (port3_input_req),
    .in_data        (port3_i),

    .out_req        (req_3),
    .out_ack        (ack_3),
    .out_data       (data_3)

);
click_element #(
    .DATA_WIDTH     (n),
    .VALUE          (0),
    .PHASE_INIT     (1'b0)) clickself
    (
    .in_ack         (ack_self_proc), //OK
    .in_req         (req_proc_self), //OK
    .in_data        (proc_data_i), //OK

    .out_req        (req_click_router_self), //OK
    .out_ack        (ack_proc_click), //OK
    .out_data       (data_self) //OK

// Routers

);


endmodule