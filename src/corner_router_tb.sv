module corner_tb
import router_pkg::*;
#(
parameter n = 32
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

    RTPort proc_in ();
    RTPort proc_out ();
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

always_comb
    if(rst == 1'b1) begin
    
        proc_in.ack = 1'b0;
        proc_in.req = 1'b0;
        proc_in.data = '0;
        proc_out.ack = 1'b0;
        proc_out.req = 1'b0;
        proc_out.data = '0;
        
        port1_in.ack = 1'b0;
        port1_in.req = 1'b0;
        port1_in.data = '0;
        port1_out.ack = 1'b0;
        port1_out.req = 1'b0;
        port1_out.data = '0;
        
        port2_in.ack = 1'b0;
        port2_in.req = 1'b0;
        port2_in.data = '0;
        port2_out.ack = 1'b0;
        port2_out.req = 1'b0;
        port2_out.data = '0;
        
        port3_in.ack = 1'b0;
        port3_in.req = 1'b0;
        port3_in.data = '0;
        port3_out.ack = 1'b0;
        port3_out.req = 1'b0;
        port3_out.data = '0;
    
    end

 

logic [1:0] destination = 2'b01;
logic [1:0] deltas = 2'b0;
initial begin
    rst = 1'b1;
    #200;
    repeat (10) begin // Generate 10 cycles of data
        rst = 1'b0;
        #50; // Wait for 10 time units
        
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
        proc_in.data = {destination,deltas,28'hFFFFFFF}; 
        proc_in.req = ~proc_in.req; // Assert req signal
        destination += 1'b1;
   
        @(proc_in.ack);
        
    end
end

initial begin
    #200;
    repeat (2) begin
        #30;
        port1_in.data = {2'b00,2'b10,28'hEEEEEEE};
        port1_in.req = ~port1_in.req ;
        
        @(port1_in.ack);
        port1_in.data = {2'b00,2'b10,28'hAAAAAAA};
        port1_in.req = ~port1_in.req ;
        
    end
end

initial begin
    #200;
    repeat (2) begin
        #40;
        port2_in.data = {2'b00,2'b01,28'hDDDDDDD};
        port2_in.req = ~port2_in.req;
        
         @(port2_in.ack);
/*
        port3_in.data = {2'b00,2'b11,28'hCCCCCCC};
        port3_in.req = ~port3_in.req;
*/
    end
end

    always @( proc_out.req) begin
            if(rst == 0) begin
            #10;
            proc_out.ack = ~proc_out.ack;
            end
        end
    
    always @(port1_out.req) begin
            if(rst == 0) begin
            #10;
            port1_out.ack = ~port1_out.ack ;
            end
        end
    
    always @(port2_out.req) begin
            if(rst == 0) begin
            #10;
            port2_out.ack = ~port2_out.ack ;
            end
        end
    
    always @(port3_out.req) begin
            if(rst == 0) begin
            #10;
            port3_out.ack = ~port3_out.ack ;
            end
        end






always @(proc_in.ack) begin
        #10;
        if(rst == 0) begin
        proc_in.req = ~proc_in.req;
        end
    end

always @(port1_in.ack) begin
        #10;
        if(rst == 0) begin
        port1_in.req = ~port1_in.req;
        end
    end

always @(port2_in.ack) begin
        if(rst == 0) begin
        #10;
        port2_in.req = ~port2_in.req;
        end
    end

always @(port3_in.ack) begin
        if(rst == 0) begin
        #10;
        port3_in.req = ~port3_in.req;
        end
    end

always @( port3_out.req) begin
        $display("Port3 data: %h", port3_out.data);
    end

always @(port2_out.req) begin
        $display("Port2 data: %h", port2_out.data);
    end

always @(port1_out.req) begin
        $display("Port1 data: %h", port1_out.data);
    end

always @(proc_out.req ) begin
        $display("Proc data: %h", proc_out.data);
    end
endmodule