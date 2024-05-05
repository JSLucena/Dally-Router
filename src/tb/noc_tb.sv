module noc_tb
import router_pkg::*;
#(
    parameter integer PAYLOAD = 32,
    parameter integer X_BITS = 1,
    parameter integer Y_BITS= 1,
    parameter integer X_CNT = 2,
    parameter integer Y_CNT = 2,
    parameter integer packet_size = X_BITS + Y_BITS  + PAYLOAD
)();


    logic rst;
    logic req_i[X_CNT][Y_CNT];
    logic ack_i[X_CNT][Y_CNT];
    logic[packet_size-1:0] data_i[X_CNT][Y_CNT];

    logic req_o[X_CNT][Y_CNT];
    logic[packet_size-1:0] data_o[X_CNT][Y_CNT];
    logic ack_o[X_CNT][Y_CNT];


noc2x2 #(
    .PAYLOAD      (PAYLOAD),
    .X_BITS    (X_BITS),
    .Y_BITS    (Y_BITS),
    .X_CNT      (X_CNT),
    .Y_CNT      (Y_CNT),
    .packet_size (packet_size)
)test
(
    .rst        (rst),
    .req_i    (req_i),
    .ack_i   (ack_i),
    .data_i (data_i),
    .req_o (req_o),
    .data_o (data_o),
    .ack_o (ack_o)
);

always_comb
    if(rst == 1'b1) begin  
        for(int x = 0; x <= X_BITS; x++) begin 
            for(int y = 0; y <= Y_BITS; y++) begin    
                req_i[x][y] = 1'b0;
                ack_i[x][y] = 1'b0;
                data_i[x][y] = '0;
                req_o[x][y] = 1'b0;
                data_o[x][y] = 1'b0;
                ack_o[x][y] = 1'b0;
            end
        end
    end

logic [1:0] destination = 2'b01;
logic [1:0] deltas = 2'b0;
logic [PAYLOAD-1:0] payload = 'b1;

initial begin
    rst = 1'b1;
    #200;
    rst = 1'b0;
    /*
    repeat (4) begin // Generate 10 cycles of data
        
        #50; // Wait for 50 time units
        // 2 bits of address, destination in this case is x= 0, y = 0.
        // 2 bits to represent destination, x is higher and y is higher
        
        data_i[0][0] = {destination,payload}; 
        req_i[0][0] = ~req_i[0][0]; // Assert req signal
        destination += 1'b1;
       // payload = payload + 1'b1;
        @(ack_i[0][0]);      
    end
    
        destination = 2 'b10;
        payload = payload + 1'b1;
    repeat (4) begin // Generate 10 cycles of data
 
        data_i[0][1] = {destination,payload}; 
        req_i[0][1] = ~req_i[0][1]; // Assert req signal
        destination += 1'b1;
       // payload = payload + 1'b1;
        @(ack_i[0][1]);   
    end
        payload = payload + 1'b1;
        destination = 2 'b11;
    repeat (4) begin // Generate 10 cycles of data
 
        data_i[1][0] = {destination,payload}; 
        req_i[1][0] = ~req_i[1][0]; // Assert req signal
        destination += 1'b1;
        //payload = payload + 1'b1;
        @(ack_i[1][0]);   
    end
        payload = payload + 1'b1;
        destination = 2 'b00;
    repeat (4) begin // Generate 10 cycles of data
 
        data_i[1][1] = {destination,payload}; 
        req_i[1][1] = ~req_i[1][1]; // Assert req signal
        destination += 1'b1;
        //payload = payload + 1'b1;
        @(ack_i[1][1]);   
    end
    */
end

/*
initial begin
    #1000;
    repeat(4) begin
    
    int randx = $urandom_range(0,1);
    int randy = $urandom_range(0,1);
    bit[1:0] dst = $urandom_range(0,3);
    bit[PAYLOAD-1:0] d = $random();
    
    data_i[randx][randy] = {dst,d};
    req_i[randx][randy] = ~req_i[randx][randy];
    $display("Proc[%d][%d] , packet generated to %b",randx,randy,dst);
    @(ack_i[randx][randy]);
    end
end
*/

initial begin
    #1000;
    repeat(1) begin
    automatic int  delay =$urandom_range(5,30);
    # ( 30 * 1ns);
        data_i[1][0] = {2'b00,$urandom()};
        req_i[1][0]= ~req_i[1][0] ;
    
    $display("Proc[1][0] , packet generated to [0][0], delay %d",delay);
    @(ack_i[1][0]);

    end
end
initial begin
    #1000;
    repeat(1) begin
    automatic int  delay =$urandom_range(5,30);
    # ( 31 * 1ns);
        data_i[1][1] = {2'b00,$urandom()};
        req_i[1][1]= ~req_i[1][1] ;
    
    $display("Proc[1][1] , packet generated to [0][0], delay %d",delay);
    @(ack_i[1][1]);

    end
end
initial begin
    #1000;
    repeat(1) begin
    automatic int  delay =$urandom_range(5,30);
    # ( 32 * 1ns);
        data_i[0][1] = {2'b00,$urandom()};
        req_i[0][1]= ~req_i[0][1] ;
    
    $display("Proc[0][1] , packet generated to [0][0], delay %d",delay);
    @(ack_i[0][1]);

    end
end



always @(req_o[0][0] ) begin
        if(rst == 0) begin
            $display("Proc[0][0] packet - header: %b, payload: %h", data_o[0][0][packet_size-1:packet_size-2],data_o[0][0]);
            #10;
            ack_o[0][0] = ~ack_o[0][0];
        end
    end
always @(req_o[0][1] ) begin
        if(rst == 0) begin
            #10;
            $display("Proc[0][1] packet - header: %b, payload: %h", data_o[0][1][packet_size-1:packet_size-2],data_o[0][1]);
            ack_o[0][1] = ~ack_o[0][1];
        end
    end
always @(req_o[1][0] ) begin
        if(rst == 0) begin
            #10;
            $display("Proc[1][0] packet - header: %b, payload: %h", data_o[1][0][packet_size-1:packet_size-2],data_o[1][0]);
            ack_o[1][0] = ~ack_o[1][0];
        end
    end
always @(req_o[1][1] ) begin
        if(rst == 0) begin
            #10;
            $display("Proc[1][1] packet - header: %b, payload: %h", data_o[1][1][packet_size-1:packet_size-2],data_o[1][1]);
            ack_o[1][1] = ~ack_o[1][1];
        end
end
endmodule