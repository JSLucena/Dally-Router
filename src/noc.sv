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
    parameter integer n = 32,
    parameter integer srcx = 0,
    parameter integer srcy = 0,
    parameter integer maxx = 2,
    parameter integer maxy = 2
)




endmodule