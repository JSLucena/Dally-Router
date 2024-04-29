module noc_tb
import router_pkg::*;
#(
    parameter n = 32,
    parameter integer n_x = 2,
    parameter integer n_y= 2
)();


logic rst;
RTPort proc_in[n_x][n_y];
RTPort proc_out[n_x][n_y];


noc2x2 #(
    .n      (n),
    .n_x    (n_x),
    .n_y    (n_y)
)
(
    .rst        (rst),
    .proc_in    (proc_in),
    .proc_out   (proc_out)
);

always_comb
    if(rst == 1'b1) begin  
        for(int x = 0; x < n_x; x++) begin 
            for(int y = 0; y < n_y; y++) begin    
                proc_in[x][y].ack = 1'b0;
                proc_in[x][y].req = 1'b0;
                proc_in[x][y].data = '0;
                proc_out[x][y].ack = 1'b0;
                proc_out[x][y].req = 1'b0;
                proc_out[x][y].data = '0;
            end
        end
    end

always @(proc_out[0][0].req ) begin
        $display("Proc[0][0] packet - header: %b, payload: %h", proc_out.data[n-1:n-4],proc_out.data[n-4:0]);
    end
endmodule