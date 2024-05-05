
module router_block4
    import router_pkg::*;
#(
    parameter router_type rtype = CORNERNE,
    parameter integer maxx = 2,
    parameter integer selfx = 2,

    parameter integer selfy = 2,
    parameter integer maxy = 2
)
(
    //input logic req_i,
    input logic [maxx-1:0] dst_x,
    input logic [maxy-1:0] dst_y,
    //input logic dx,
    //input logic dy,

    output logic [1:0] toDemux
//
    //output logic outputNS,
    //output logic outputWE,
    //output logic outputDiag,
    //output logic outputSelf,


);

logic eqx;
logic eqy;
always_comb begin : grants


    if (dst_x == selfx ) begin
        eqx = 1'b1;
    end
    else begin
        eqx = 1'b0;
    end

    if (dst_y == selfy ) begin
        eqy = 1'b1;
    end
    else begin
        eqy = 1'b0;
    end

    if(eqx == 1'b1 && eqy == 1'b1) begin
        toDemux = 2'b00;
    end
    else if (eqx == 1'b1 && eqy == 1'b0) begin
        toDemux = 2'b01;
    end
    else if (eqx == 1'b0 && eqy == 1'b1) begin
        toDemux = 2'b10;
    end
    else begin
        toDemux = 2'b11;
    end
end
    
  //  outputSelf = eqy & eqx;
  //  outputDiag = !(eqy | eqx);
  //  outputWE = eqx & !(eqx ^ eqy);
  //  outputNS = eqy & !(eqx ^ eqy);



endmodule