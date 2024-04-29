module noc2x2
import router_pkg::*;
#(
    parameter integer n = 32,
    parameter integer n_x = 2,
    parameter integer n_y= 2
)(

    RTPort.Input proc_in[n_x][n_y],
    RTPort.Output proc_out[n_x][n_y]

);





//Global
    logic rst;
   // RTPort proc_in ();
   // RTPort proc_out ();
  //  RTPort port1_in[n_x][n_y] ();
  //  RTPort port1_out[n_x][n_y] ();
  //  RTPort port2_in[n_x][n_y] ();
  //  RTPort port2_out[n_x][n_y] ();
  //  RTPort port3_in[n_x][n_y] ();
  //  RTPort port3_out[n_x][n_y] ();
    

    RTPort port1_i[n_x][n_y] ();
    RTPort port2_i[n_x][n_y] ();
    RTPort port3_i[n_x][n_y] ();
    
    RTPort port1_o[n_x][n_y] ();
    RTPort port2_o[n_x][n_y] ();
    RTPort port3_o[n_x][n_y] ();

  generate
        for(genvar x = 0; x < n_x; x++) begin : gen_x
            for(genvar y = 0; y < n_y; y++) begin : gen_y
                Corner_Router #(
               // .rtype   (CORNERSW),
                .n              (n),
                .srcx           (x),
                .srcy           (y),
                .maxx           (1),
                .maxy           (1)
                ) node
                (
                .rst            (rst),
                .proc_input     (proc_in[x][y]),
                .proc_output    (proc_out[x][y]),
                .port1_input    (port1_i[x][y].Input),
                .port1_output   (port1_o[x][y].Output),
                .port2_output   (port2_o[x][y].Output),
                .port2_input    (port2_i[x][y].Input),
                .port3_input    (port3_i[x][y].Input),
                .port3_output   (port3_o[x][y].Output)    


            );
            end
        end

endgenerate


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
/*
assign port1_i[0][0] = port1_o[1][0];
assign port2_i[0][0] = port2_o[0][1];
assign port3_i[0][0] = port3_o[1][1];
*/
/*
assign port1_i[1][0].Input = port1_o[0][0].Output;
assign port2_i[1][0].Input = port2_o[1][1].Output;
assign port3_i[1][0].Input = port3_o[0][1].Output;

assign port1_i[0][1].Input = port1_o[1][1].Output;
assign port2_i[0][1].Input = port2_o[0][0].Output;
assign port3_i[0][1].Input = port3_o[1][0].Output;

assign port1_i[1][1].Input = port1_o[0][1].Output;
assign port2_i[1][1].Input = port2_o[1][0].Output;
assign port3_i[1][1].Input = port3_o[0][0].Output;
*/
//always_comb begin : connections
//   for (int x = 0; x < n_x; x++) begin 
//            for (int y = 0; y < n_y; y++) begin
//
//                if (x != n_x -1) begin
//                    port1[x][y].Input = port1[x+1][y].Output;
//                end else begin
//                    port1[x][y].Input = port1[x-1][y].Output;
//                end
//
//                if (y != n_y -1) begin
//                    port2[x][y].Input = port2[x][y+1].Output;
//                end else begin
//                    port2[x][y].Input = port2[x][y-1].Output;
//                end
//
//                if(x == 0 && y == 0) begin
//                    port3[x][y].Input = port3[x+1][y+1].Output;
//                end else if(x == n_x-1 && y == n_y - 1) begin
//                    port3[x][y].Input = port3[x-1][y-1].Output;
//                end else begin
//                    if (x > y) begin
//                        port3[x][y].Input =  port3[x-1][y+1].Output;
//                    end else begin
//                        port3[x][y].Input =  port3[x+1][y-1].Output;
//                    end
//                end
//
//            end
//    end 
//end

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