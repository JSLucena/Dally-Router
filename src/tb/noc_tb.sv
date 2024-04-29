module corner_tb
import router_pkg::*;
#(
    parameter n = 32,
    parameter integer n_x = 2,
    parameter integer n_y= 2
)();



RTPort proc_in[n_x][n_y];
RTPort proc_out[n_x][n_y];


noc2x2 #(
    .n      (n),
    .n_x    (n_x),
    .n_y    (n_y)
)
(
    .proc_in    (proc_in),
    .proc_out   (proc_out)
)


always @(proc_out[0][0].req ) begin
        $display("Proc[0][0] packet - header: %b, payload: %h", proc_out[0][0].data[n-1:n-4],proc_out[0][0].data[n-4:0]);
        proc_out[0][0].ack = ~proc_out[0][0].ack;
    end
always @(proc_out[0][1].req ) begin
        $display("Proc[0][1] packet - header: %b, payload: %h", proc_out[0][1].data[n-1:n-4],proc_out[0][1].data[n-4:0]);
        proc_out[0][1].ack = ~proc_out[0][1].ack;
    end
always @(proc_out[1][0].req ) begin
        $display("Proc[1][0] packet - header: %b, payload: %h", proc_out[1][0].data[n-1:n-4],proc_out[1][0].data[n-4:0]);
        proc_out[1][0].ack = ~proc_out[1][0].ack;
    end
always @(proc_out[1][1].req ) begin
        $display("Proc[1][1] packet - header: %b, payload: %h", proc_out[1][1].data[n-1:n-4],proc_out[1][1].data[n-4:0]);
        proc_out[1][1].ack = ~proc_out[1][1].ack;
    end


endmodule