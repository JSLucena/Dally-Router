package router_pkg;

typedef enum integer { 

    CORNERNW  = 0,
    CORNERNE  = 1,
    CORNERSE  = 2,
    CORNERSW  = 3,
    
    SIDEN    = 4,
    SIDEE    = 5,
    SIDES    = 6,
    SIDEW    = 7,
    MIDDLE  = 8

} router_type;

/*
Definitions:

CornerNE:
    Port 1 : West
    Port 2 : South
    Port 3 : Southwest

CornerNW:
    Port 1 : East
    Port 2 : South
    Port 3 : Southeast

CornerSE:
    Port 1 : West
    Port 2 : North
    Port 3 : Northwest

CornerSW:
    Port 1 : East
    Port 2 : North
    Port 3 : Northeast



*/


endpackage;


interface RTPort #(parameter WIDTH = 32);
    logic req;
    logic ack;
    logic [WIDTH-1:0] data;

    // Define the input and output ports
    modport Input (
        input req, data,
        output ack
    );

    // Define the output and input ports
    modport Output (
        output req, data,
        input ack
    );

    // Assignments to actual signals
    //assign ack = ack;
    //assign req = req;
    //assign data = data;
endinterface; //inputPort