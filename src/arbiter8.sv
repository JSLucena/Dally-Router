module arbiter8
  //  include "defs.vhd"
   // import defs::*;
 #(
    parameter data_width = 32
 )(
    input logic rst,

    // Channel A
    input logic inA_req,
    input logic [data_width-1:0] inA_data,
    output logic inA_ack,
    // Channel B
    input logic inB_req,
    input logic [data_width-1:0] inB_data,
    output logic inB_ack,
    // Channel C
    input logic inC_req,
    input logic [data_width-1:0] inC_data,
    output logic inC_ack,
    // Channel D
    input logic inD_req,
    input logic [data_width-1:0] inD_data,
    output logic inD_ack,
    // Channel E
    input logic inE_req,
    input logic [data_width-1:0] inE_data,
    output logic inE_ack,
    // Channel F
    input logic inF_req,
    input logic [data_width-1:0] inF_data,
    output logic inF_ack,
    // Channel G
    input logic inG_req,
    input logic [data_width-1:0] inG_data,
    output logic inG_ack,
    // Channel H
    input logic inH_req,
    input logic [data_width-1:0] inH_data,
    output logic inH_ack,
    // Output Channel
    output logic out_req,
    output logic [data_width-1:0] out_data,
    input logic out_ack

);
logic in1_req;
logic [data_width-1:0] in1_data;
logic in1_ack;

logic in2_req;
logic [data_width-1:0] in2_data;
logic in2_ack;

arbiter4#(.data_width(data_width)) arbiterABCD(
    .rst        (rst),
    .inA_ack    (inA_ack),
    .inA_data   (inA_data),
    .inA_req    (inA_req),

    .inB_ack    (inB_ack),
    .inB_data   (inB_data),
    .inB_req    (inB_req),

    .inC_ack    (inC_ack),
    .inC_data   (inC_data),
    .inC_req    (inC_req),

    .inD_ack    (inD_ack),
    .inD_data   (inD_data),
    .inD_req    (inD_req),


    .outC_ack    (in1_ack),
    .outC_data   (in1_data),
    .outC_req    (in1_req)
);

arbiter4#(.data_width(data_width)) arbiterEFGH(
     .rst        (rst),
    .inA_ack    (inE_ack),
    .inA_data   (inE_data),
    .inA_req    (inE_req),

    .inB_ack    (inF_ack),
    .inB_data   (inF_data),
    .inB_req    (inF_req),

    .inC_ack    (inG_ack),
    .inC_data   (inG_data),
    .inC_req    (inG_req),

    .inD_ack    (inH_ack),
    .inD_data   (inH_data),
    .inD_req    (inH_req),

    .outC_ack    (in2_ack),
    .outC_data   (in2_data),
    .outC_req    (in2_req)
);

arbiter#() arbiter12(
    .rst        (rst),
    .inA_ack    (in1_ack),
    .inA_data   (in1_data),
    .inA_req    (in1_req),

    .inB_ack    (in2_ack),
    .inB_data   (in2_data),
    .inB_req    (in2_req),

    .outC_ack    (out_ack),
    .outC_data   (out_data),
    .outC_req    (out_req)
);

endmodule