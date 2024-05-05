module corner_tb
import router_pkg::*;
#(
parameter integer n = 32,
parameter integer X_BITS = 1,
parameter integer Y_BITS = 1,
parameter integer packet_size = n + X_BITS + Y_BITS
)();




//Global
    logic rst;
    RTPort#(.WIDTH(packet_size) ) proc_in ();
    RTPort#(.WIDTH(packet_size) ) proc_out ();
    RTPort#(.WIDTH(packet_size) ) port1_in ();
    RTPort#(.WIDTH(packet_size) ) port1_out ();
    RTPort#(.WIDTH(packet_size) ) port2_in ();
    RTPort#(.WIDTH(packet_size) ) port2_out ();
    RTPort#(.WIDTH(packet_size) ) port3_in ();
    RTPort#(.WIDTH(packet_size) ) port3_out ();


    Corner_Router #(
    .rtype   (CORNERSW),
    .n              (packet_size),
    .srcx           (0),
    .srcy           (0),
    .maxx           (X_BITS),
    .maxy           (Y_BITS)
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
logic [n-1:0] payload = '1;

initial begin
    rst = 1'b1;
    #200;
    rst = 1'b0;
    
    repeat (4) begin // Generate 10 cycles of data
        
        #50; // Wait for 50 time units
        
        

        if(destination[1] > 1'b0) begin
            deltas[1] = 1'b1;
        end else begin
            deltas[1] = 1'b0;
        end


        if(destination[0] > 1'b0) begin
            deltas[0] = 1'b1;
        end else begin
            deltas[0] = 1'b0;
        end

        // 2 bits of address, destination in this case is x= 0, y = 0.
        // 2 bits to represent destination, x is higher and y is higher
        destination += 1'b1;
        proc_in.data = {destination,payload}; 
        proc_in.req = ~proc_in.req; // Assert req signal
        
        payload = payload + 1'b1;
   
        @(proc_in.ack);

    end
   
end


initial begin
    #200;
    repeat (1) begin
        #30;
        port1_in.data = {2'b00,$urandom()};
        port1_in.req = ~port1_in.req ;
        
        @(port1_in.ack);
        
      //  #10;
      //  port1_in.data = {2'b00,$urandom()};
      //  port1_in.req = ~port1_in.req ;
      //  @(port1_in.ack);
        
    end
end

initial begin
    #200;
    repeat (1) begin
        #31;
        port2_in.data = {2'b00,$urandom()};
        port2_in.req = ~port2_in.req;
        
         @(port2_in.ack);


    end
end

initial begin
    #200;
    repeat (1) begin
        #32;
        port3_in.data = {2'b00,$urandom()};
        port3_in.req = ~port3_in.req;
        
         @(port3_in.ack);
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





/*
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
*/
always @( port3_out.req) begin
         $display("Port3 packet - header: %b, payload: %h", port3_out.data[packet_size-1:packet_size-2],port3_out.data);
    end

always @(port2_out.req) begin
         $display("Port2 packet - header: %b, payload: %h", port2_out.data[packet_size-1:packet_size-2],port2_out.data);
    end

always @(port1_out.req) begin
         $display("Port1 packet - header: %b, payload: %h", port1_out.data[packet_size-1:packet_size-2],port1_out.data);
    end

always @(proc_out.req ) begin
        $display("Proc packet - header: %b, payload: %h", proc_out.data[packet_size-1:packet_size-2],proc_out.data);
    end
endmodule