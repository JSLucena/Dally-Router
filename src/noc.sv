module noc2x2
import router_pkg::*;
#(
parameter n = 32,
parameter n_x = 2,
parameter n_y= 2
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

    RTPort port1[n_x][n_y] ();
    RTPort port2[n_x][n_y] ();
    RTPort port3[n_x][n_y] ();

  generate
        for (genvar x = 0; x < n_x; x++) begin : gen_x
            for (genvar y = 0; y < n_y; y++) begin : gen_y
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
                .proc_input     (proc_in[x][y].Input),
                .proc_output    (proc_out[x][y].Output),
                .port1_input    (port1[x][y].Input),
                .port1_output   (port1[x][y].Output),
                .port2_output   (port2[x][y].Output),
                .port2_input    (port2[x][y].Input),
                .port3_input    (port3[x][y].Input),
                .port3_output   (port3[x][y].Output)    


            );
            end
        end

endgenerate


always_comb begin : connections
   for (int x = 0; x < n_x; x++) begin 
            for (int y = 0; y < n_y; y++) begin

                if (x != n_x -1) begin
                    port1[x][y].Input = port[x+1][y].Output;
                end else begin
                    port1[x][y].Input = port[x-1][y].Output;
                end

                if (y != n_y -1) begin
                    port2[x][y].Input = port[x][y+1].Output;
                end else begin
                    port2[x][y].Input = port[x][y-1].Output;
                end

                if(x == 0 && y == 0) begin
                    port3[x][y].Input = port[x+1][y+1].Output;
                end else if(x == n_x-1 && y == n_y - 1) begin
                    port3[x][y].Input = port[x-1][y-1].Output;
                end else begin
                    if (x > y) begin
                        port3[x][y].Input =  port3[x-1][y+1].Output;
                    end else begin
                        port3[x][y].Input =  port3[x+1][y-1].Output;
                    end
                end

            end
    end 
end

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