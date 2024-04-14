module noc_top
    import router_pkg::*;
#(
    parameter integer n = 32,
    parameter integer maxx = 2,
    parameter integer maxy = 2
)
(

    //Global
    input logic rst,
    
    /// Signals between router and cpu
    input logic [n-1:0] io_data, //OK
    input logic io_req, //OK
    output logic io_ack, //OK
    
    input logic ack_proc_self, //TODO
    output logic [n-1:0] proc_data_o, //TODO
    output logic req_self_proc, //TODO
)

logic ack0001;
logic ack0010;
logic ack0011;
logic ack0110;
logic ack0111;
logic ack1011;

logic req0001;
logic req0010;
logic req0011;
logic req0110;
logic req0111;
logic req1011;

logic [n-1:0] data0001;
logic [n-1:0] data0010;
logic [n-1:0] data0011;
logic [n-1:0] data0110;
logic [n-1:0] data0111;
logic [n-1:0] data1011;


Corner_Router #(
    .router_type    (CORNERSW),
    .n              (n),
    .srcx           (0),
    .srcy           (0),
    .maxx           (maxx),
    .maxy           (maxy)
) SW

(
    .rst            (rst),
    .proc_data_i    (io_data),
    .req_proc_self  (io_req),
    .ack_self_proc  (io_ack),



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
)






endmodule