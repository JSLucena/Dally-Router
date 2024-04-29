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