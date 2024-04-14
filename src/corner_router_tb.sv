module corner_tb
import router_pkg::*;
#(
parameter n = 36
)();



//Global
    logic rst;
    
    /// Signals between router and cpu
    logic [n-1:0] proc_data_i; //OK
    logic req_proc_self; //OK
    logic ack_self_proc; //OK
    
    logic ack_proc_self; //TODO
    logic [n-1:0] proc_data_o; //TODO
    logic req_self_proc; //TODO
    //------------------------------------
    
    logic [n-1:0] port1_i;
    logic port1_input_req;
    logic port1_input_ack;
    logic port1_output_ack; //OK
    logic [n-1:0] port1_o;
    logic port1_output_req;
//---------------------------------------------
    logic [n-1:0] port2_i;     
    logic port2_input_req; 
    logic port2_input_ack; 
    
    logic [n-1:0] port2_o;//OK
    logic port2_output_ack;
    logic port2_output_req; 
//----------------------------------------
    logic [n-1:0] port3_i; 
    logic port3_input_req; 
    logic port3_input_ack; 
    logic [n-1:0] port3_o; //OK
    logic port3_output_ack;
    logic port3_output_req;

    RTPort proc_i ();
    RTPort proc_o ();
    RTPort port1_in ();
    RTPort port1_out ();
    RTPort port2_in ();
    RTPort port2_out ();
    RTPort port3_in ();
    RTPort port3_out ();


    Corner_Router #(
    .rtype   (CORNERSW),
    .n              (n),
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
logic [1:0] destination = 2'b01;
logic [1:0] deltas = 2'b0;
initial begin
    repeat (10) begin // Generate 10 cycles of data
        #50; // Wait for 10 time units
        proc_in.req = 1; // Assert req signal
        if(destination == 2'b00) begin
            destination += 1;
        end

        if(destination[0] > 1'b0) begin
            deltas[0] = 1'b1;
        end else begin
            deltas[0] = 1'b0;
        end


        if(destination[1] > 1'b0) begin
            deltas[1] = 1'b1;
        end else begin
            deltas[1] = 1'b0;
        end

        // 2 bits of address, destination in this case is x= 0, y = 0.
        // 2 bits to represent destination, x is higher and y is higher
        proc_in.data = {destination,deltas,32'hFFFFFFFF}; 
        destination += 1'b1;

    end

    repeat (2) begin
        #20;
        port1_in.data = {2'b00,2'b10,32'hEEEEEEEE};
        port1_in.req = 1'b1;

        #20;
        port2_in.data = {2'b00,2'b01,32'hDDDDDDDD};
        port2_in.req = 1'b1;

        port3_in.data = {2'b00,2'b11,32'hCCCCCCCC};
        port3_in.req = 1'b1;

    end
end

always @(posedge proc_in.ack) begin
        proc_in.req = 1'b0;
    end

always @(posedge port1_in.ack) begin
        port1_in.req = 1'b0;
    end

always @(posedge port2_in.ack) begin
        port2_in.req = 1'b0;
    end

always @(posedge port3_in.ack) begin
        port3_in.req = 1'b0;
    end

always @(posedge port3_out.req) begin
        $display("Port3 data: %h", port3_out.data);
    end

always @(posedge port2_out.req) begin
        $display("Port2 data: %h", port2_out.data);
    end

always @(posedge port1_out.req) begin
        $display("Port1 data: %h", port1_out.data);
    end


endmodule