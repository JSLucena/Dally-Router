module post_tb
import router_pkg::*;
#(

)();


    logic rst;
    logic req_i[2][2];
    logic ack_i[2][2];
    logic[5:0] data_i[2][2];

    logic req_o[2][2];
    logic[5:0] data_o[2][2];
    logic ack_o[2][2];


noc2x2 #(
/*
    .PAYLOAD      (4),
    .X_BITS    (1),
    .Y_BITS    (1),
    .X_CNT      (2),
    .Y_CNT      (2),
    .packet_size (6)
    */
)test
(
    .rst        (rst),
    .\req_i[0][0]    (req_i[0][0]),
    .\req_i[0][1]    (req_i[0][1]),
    .\req_i[1][0]    (req_i[1][0]),
    .\req_i[1][1]    (req_i[1][1]),
    
    .\ack_i[0][0]   (ack_i[0][0]),
    .\ack_i[0][1]   (ack_i[0][1]),
    .\ack_i[1][0]   (ack_i[1][0]),
    .\ack_i[1][1]   (ack_i[1][1]),
    
    .\data_i[0][0] (data_i[0][0]),
    .\data_i[0][1] (data_i[0][1]),
    .\data_i[1][0] (data_i[1][0]),
    .\data_i[1][1] (data_i[1][1]),


    .\req_o[0][0]    (req_o[0][0]),
    .\req_o[0][1]    (req_o[0][1]),
    .\req_o[1][0]    (req_o[1][0]),
    .\req_o[1][1]    (req_o[1][1]),
    
    .\ack_o[0][0]   (ack_o[0][0]),
    .\ack_o[0][1]   (ack_o[0][1]),
    .\ack_o[1][0]   (ack_o[1][0]),
    .\ack_o[1][1]   (ack_o[1][1]),
    
    .\data_o[0][0] (data_o[0][0]),
    .\data_o[0][1] (data_o[0][1]),
    .\data_o[1][0] (data_o[1][0]),
    .\data_o[1][1] (data_o[1][1])
);

always_comb
    if(rst == 1'b1) begin  
        for(int x = 0; x <= 1; x++) begin 
            for(int y = 0; y <= 1; y++) begin    
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
logic [3:0] payload = 'b1;

initial begin
    rst = 1'b1;
    #200;
    rst = 1'b0;
   
    repeat (3) begin // Generate 10 cycles of data
        
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
    repeat (3) begin // Generate 10 cycles of data
 
        data_i[0][1] = {destination,payload}; 
        req_i[0][1] = ~req_i[0][1]; // Assert req signal
        destination += 1'b1;
       // payload = payload + 1'b1;
        @(ack_i[0][1]);   
    end
        payload = payload + 1'b1;
        destination = 2 'b11;
    repeat (3) begin // Generate 10 cycles of data
 
        data_i[1][0] = {destination,payload}; 
        req_i[1][0] = ~req_i[1][0]; // Assert req signal
        destination += 1'b1;
        //payload = payload + 1'b1;
        @(ack_i[1][0]);   
    end
        payload = payload + 1'b1;
        destination = 2 'b00;
    repeat (3) begin // Generate 10 cycles of data
 
        data_i[1][1] = {destination,payload}; 
        req_i[1][1] = ~req_i[1][1]; // Assert req signal
        destination += 1'b1;
        //payload = payload + 1'b1;
        @(ack_i[1][1]);   
    end
    
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
    #800;
    repeat(2) begin
    automatic int  delay =$urandom_range(5,30);
    automatic logic [3:0] p = $urandom();
    # ( 1 * 1ns);
        data_i[1][0] = {2'b00,p};
        req_i[1][0]= ~req_i[1][0] ;
    
    $display("Proc[1][0] , packet generated to [0][0], delay %d",delay);
    @(ack_i[1][0]);

    end
end

initial begin
    #800;
    repeat(2) begin
    automatic logic [3:0] p = $urandom();
    automatic int  delay =$urandom_range(5,30);
    # ( 1 * 1ns);
        data_i[1][1] = {2'b00,p};
        req_i[1][1]= ~req_i[1][1] ;
    
    //$display("Proc[1][1] , packet generated to [0][0], delay %d",delay);
    @(ack_i[1][1]);

    end
end
initial begin
    #800;
    repeat(2) begin
    automatic logic [3:0] p = $urandom();
    automatic int  delay =$urandom_range(5,30);
    # ( 1 * 1ns);
        data_i[0][1] = {2'b00,p};
        req_i[0][1]= ~req_i[0][1] ;
    
    //$display("Proc[0][1] , packet generated to [0][0], delay %d",delay);
    @(ack_i[0][1]);

    end
end



always @(req_o[0][0] ) begin
        if(rst == 0) begin
            $display("Proc[0][0] packet - header: %b, payload: %h", data_o[0][0][5:4],data_o[0][0]);
            #5;
            ack_o[0][0] = ~ack_o[0][0];
        end
    end
always @(req_o[0][1] ) begin
        if(rst == 0) begin
            #10;
            $display("Proc[0][1] packet - header: %b, payload: %h", data_o[0][1][5:4],data_o[0][1]);
            ack_o[0][1] = ~ack_o[0][1];
        end
    end
always @(req_o[1][0] ) begin
        if(rst == 0) begin
            #10;
            $display("Proc[1][0] packet - header: %b, payload: %h", data_o[1][0][5:4],data_o[1][0]);
            ack_o[1][0] = ~ack_o[1][0];
        end
    end
always @(req_o[1][1] ) begin
        if(rst == 0) begin
            #10;
            $display("Proc[1][1] packet - header: %b, payload: %h", data_o[1][1][5:4],data_o[1][1]);
            ack_o[1][1] = ~ack_o[1][1];
        end
end
endmodule