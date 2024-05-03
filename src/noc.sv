module noc2x2
import router_pkg::*;
#(
    parameter integer PAYLOAD = 32,
    parameter integer X_BITS = 1,
    parameter integer Y_BITS= 1,
    parameter integer X_CNT = 2,
    parameter integer Y_CNT = 2,
    parameter integer packet_size = X_BITS + Y_BITS + 2 + PAYLOAD
)(
    input logic rst,
   // RTPort.Input  proc_in[X_BITS][Y_BITS],
   // RTPort.Output proc_out[X_BITS][Y_BITS]
   input logic req_i[X_CNT][Y_CNT],
   output logic ack_i[X_CNT][Y_CNT],
   input logic[packet_size-1:0] data_i[X_CNT][Y_CNT],

   output logic req_o[X_CNT][Y_CNT],
   output logic[packet_size-1:0] data_o[X_CNT][Y_CNT],
   input logic ack_o[X_CNT][Y_CNT]

);





//Global
   
   // RTPort proc_in ();
   // RTPort proc_out ();
  //  RTPort port1_in[X_BITS][Y_BITS] ();
  //  RTPort port1_out[X_BITS][Y_BITS] ();
  //  RTPort port2_in[X_BITS][Y_BITS] ();
  //  RTPort port2_out[X_BITS][Y_BITS] ();
  //  RTPort port3_in[X_BITS][Y_BITS] ();
  //  RTPort port3_out[X_BITS][Y_BITS] ();
    
    logic req[X_CNT][Y_CNT];
    logic ack[X_CNT][Y_CNT];

    logic [packet_size-1:0] data[X_CNT][Y_CNT];

    RTPort#(.WIDTH(packet_size) ) port1_i[X_CNT][Y_CNT] ();
    RTPort#(.WIDTH(packet_size) ) port2_i[X_CNT][Y_CNT] ();
    RTPort#(.WIDTH(packet_size) ) port3_i[X_CNT][Y_CNT] ();
    
    RTPort#(.WIDTH(packet_size) ) port1_o[X_CNT][Y_CNT] ();
    RTPort#(.WIDTH(packet_size) ) port2_o[X_CNT][Y_CNT] ();
    RTPort#(.WIDTH(packet_size) ) port3_o[X_CNT][Y_CNT] ();

   // port1_i.req = req;
   // ack,data);

    RTPort#(.WIDTH(packet_size) ) proc_in[X_CNT][Y_CNT] ();
    RTPort#(.WIDTH(packet_size) ) proc_out[X_CNT][Y_CNT]();

generate
        for(genvar x = 0; x < X_CNT; x++) begin : assignX
            for(genvar y = 0; y < Y_CNT ; y++) begin : assignY
                assign proc_in[x][y].req = req_i[x][y];
                assign proc_in[x][y].ack = ack_i[x][y];
                assign proc_in[x][y].data = data_i[x][y];
                
                assign proc_out[x][y].req = req_o[x][y];
                assign proc_out[x][y].ack = ack_o[x][y];
                assign proc_out[x][y].data = data_o[x][y];
            end
        end
endgenerate

  generate
        for(genvar x = 0; x < X_CNT; x++) begin : geX_BITS_procs
            for(genvar y = 0; y < Y_CNT ; y++) begin : geY_BITS_procs
                Corner_Router #(
               // .rtype   (CORNERSW),
                .n              (packet_size),
                .srcx           (x),
                .srcy           (y),
                .maxx           (X_BITS),
                .maxy           (Y_BITS)
                ) node
                (
                .rst            (rst),
                .proc_input     (proc_in[x][y].Input),
                .proc_output    (proc_out[x][y].Output),
                .port1_input    (port1_i[x][y].Input),
                .port1_output   (port1_o[x][y].Output),
                .port2_output   (port2_o[x][y].Output),
                .port2_input    (port2_i[x][y].Input),
                .port3_input    (port3_i[x][y].Input),
                .port3_output   (port3_o[x][y].Output)    


            );
            end
        end

endgenerate;

/*
always_comb begin : blockName
    
    port1_i[0][0].ack =  port1_o[1][0].ack;
    port1_i[0][0].req =  port1_o[1][0].req;
    port1_i[0][0].data = port1_o[1][0].data;
    port2_i[0][0].ack =  port2_o[0][1].ack;
    port2_i[0][0].req =  port2_o[0][1].req;
    port2_i[0][0].data = port2_o[0][1].data;
    port3_i[0][0].ack =  port3_o[1][1].ack;
    port3_i[0][0].req =  port3_o[1][1].req;
    port3_i[0][0].data = port3_o[1][1].data;


    port1_i[1][0].ack =  port1_o[0][0].ack;
    port1_i[1][0].req =  port1_o[0][0].req;
    port1_i[1][0].data = port1_o[0][0].data;
    port2_i[1][0].ack =  port2_o[1][1].ack;
    port2_i[1][0].req =  port2_o[1][1].req;
    port2_i[1][0].data = port2_o[1][1].data;
    port3_i[1][0].ack =  port3_o[0][1].ack;
    port3_i[1][0].req =  port3_o[0][1].req;
    port3_i[1][0].data = port3_o[0][1].data;

    port1_i[0][1].ack =  port1_o[1][1].ack;
    port1_i[0][1].req =  port1_o[1][1].req;
    port1_i[0][1].data = port1_o[1][1].data;
    port2_i[0][1].ack =  port2_o[0][0].ack;
    port2_i[0][1].req =  port2_o[0][0].req;
    port2_i[0][1].data = port2_o[0][0].data;
    port3_i[0][1].ack =  port3_o[1][0].ack;
    port3_i[0][1].req =  port3_o[1][0].req;
    port3_i[0][1].data = port3_o[1][0].data;


    port1_i[1][1].ack =  port1_o[0][1].ack;
    port1_i[1][1].req =  port1_o[0][1].req;
    port1_i[1][1].data = port1_o[0][1].data;
    port2_i[1][1].ack =  port2_o[1][0].ack;
    port2_i[1][1].req =  port2_o[1][0].req;
    port2_i[1][1].data = port2_o[1][0].data;
    port3_i[1][1].ack =  port3_o[0][0].ack;
    port3_i[1][1].req =  port3_o[0][0].req;
    port3_i[1][1].data = port3_o[0][0].data;

end

*/





generate
   for(genvar x = 0; x < X_CNT; x++) begin
            for(genvar y = 0; y < Y_CNT ; y++) begin

                if (x != X_CNT -1) begin
                    //assign port1_i[x][y] = port1_o[x+1][y];
                    assign port1_i[x][y].ack =  port1_o[x+1][y].ack;
                    assign port1_i[x][y].req =  port1_o[x+1][y].req;
                    assign port1_i[x][y].data = port1_o[x+1][y].data;
                end else begin
                    assign port1_i[x][y].ack =  port1_o[x-1][y].ack;
                    assign port1_i[x][y].req =  port1_o[x-1][y].req;
                    assign port1_i[x][y].data = port1_o[x-1][y].data;
                end

                if (y != Y_CNT -1) begin
                   // assign port2_i[x][y].Input = port2_o[x][y+1].Output;
                    assign port2_i[x][y].ack =  port2_o[x][y+1].ack;
                    assign port2_i[x][y].req =  port2_o[x][y+1].req;
                    assign port2_i[x][y].data = port2_o[x][y+1].data;
                end else begin
                   // assign port2_i[x][y].Input = port2_o[x][y-1].Output;
                    assign port2_i[x][y].ack =  port2_o[x][y-1].ack;
                    assign port2_i[x][y].req =  port2_o[x][y-1].req;
                    assign port2_i[x][y].data = port2_o[x][y-1].data;
                end

                if(x == 0 && y == 0) begin
                    //assign port3_i[x][y].Input = port3_o[x+1][y+1].Output;
                    assign port3_i[x][y].ack =  port3_o[x+1][y+1].ack;
                    assign port3_i[x][y].req =  port3_o[x+1][y+1].req;
                    assign port3_i[x][y].data = port3_o[x+1][y+1].data;
                end else if(x == X_CNT-1 && y == Y_CNT - 1) begin
                    //assign port3_i[x][y].Input = port3_o[x-1][y-1].Output;
                    assign port3_i[x][y].ack =  port3_o[x-1][y-1].ack;
                    assign port3_i[x][y].req =  port3_o[x-1][y-1].req;
                    assign port3_i[x][y].data = port3_o[x-1][y-1].data;
                end else begin
                    if (x > y) begin
                       // assign port3_i[x][y].Input =  port3_o[x-1][y+1].Output;
                        assign port3_i[x][y].ack =  port3_o[x-1][y+1].ack;
                        assign port3_i[x][y].req =  port3_o[x-1][y+1].req;
                        assign port3_i[x][y].data = port3_o[x-1][y+1].data;
                    end else begin
                        //assign port3_i[x][y].Input =  port3_o[x+1][y-1].Output;
                        assign port3_i[x][y].ack =  port3_o[x+1][y-1].ack;
                        assign port3_i[x][y].req =  port3_o[x+1][y-1].req;
                        assign port3_i[x][y].data = port3_o[x+1][y-1].data;
                    end
                end

            end
    end 
endgenerate

//    Corner_Router #(
//    .rtype   (CORNERSW),
//    .n              (n),
//    .srcx           (0),
//    .srcy           (0),
//    .maxx           (1),
//    .maxy           (1)
//    ) corner00
//
//(
//    .rst            (rst),
//    .proc_input     (proc_in.Input),
//    .proc_output    (proc_out.Output),
//    .port1_input    (port1_in.Input),
//    .port1_output   (port1_out.Output),
//    .port2_output   (port2_out.Output),
//    .port2_input    (port2_in.Input),
//    .port3_input    (port3_in.Input),
//    .port3_output   (port3_out.Output)    
//
//
//);

endmodule