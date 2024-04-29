`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2024 11:24:41 AM
// Design Name: 
// Module Name: noc2x2_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module noc2x2_tb(
    import router_pkg::*;
    #(
    parameter n = 32,
    parameter n_x = 2,
    parameter n_y= 2
    )(
    
        RTPort.Input proc_in[n_x][n_y],
        RTPort.Output proc_out[n_x][n_y]
    
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
    logic [27:0] payload = 28'hFFFFFFF;
    initial  // Stimulus
    begin
            rst = 1'b1;
        #200;
        repeat (8) begin // Generate 10 cycles of data
            rst = 1'b0;
            #50; // Wait for 50 time units
            
            payload = payload - 28'b1;
            /*
            if(destination == 2'b11) begin
                destination += 1;
            end
            */
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
            proc_in.data = {destination,deltas,payload}; 
            proc_in.req = ~proc_in.req; // Assert req signal
            
       
            @(proc_in.ack);
            /*
            if(destination == 2'b00) begin
                destination += 1;
            end
            */
        end    
    end
    
    initial  // Analysis
    begin

    end    
    
//      return ack to requist    
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
    
    
    
    
    
// output to terminal    
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
