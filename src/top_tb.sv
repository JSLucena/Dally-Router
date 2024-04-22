module top_corner_tb;
import router_pkg::*;


RTPort proc_i ();
RTPort proc_o ();
RTPort port1_in ();
RTPort port1_out ();
RTPort port2_in ();
RTPort port2_out ();
RTPort port3_in ();
RTPort port3_out ();



corner_tb tb(
    .proc_input     (proc_in.Output),
    .proc_output    (proc_out.Input),
    .port1_input    (port1_in.Output),
    .port1_output   (port1_out.Input),
    .port2_output   (port2_out.Input),
    .port2_input    (port2_in.Output),
    .port3_input    (port3_in.Output),
    .port3_output   (port3_out.Input)   
);



Corner_Router #(
    .rtype   (CORNERSW),
    .n              (32),
    .srcx           (0),
    .srcy           (0),
    .maxx           (1),
    .maxy           (1)
) TEST

(
    .rst            (rst),
    .proc_input     (proc_in.Input),
    .proc_output    (proc_out.Output),
    .port1_input    (port1_in.Input),
    .port1_output   (port1_out.Output),
    .port2_output   (port2_out.Output),
    .port2_input    (port2_in.Input),
    .port3_input    (port3_in.Input),
    .port3_output   (port3_out.Output)    


);



endmodule