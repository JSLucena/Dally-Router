
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
    input logic req_i,
    input logic [maxx-1:0] src_x,
    input logic [maxy-1:0] src_y,
    input logic dx,
    input logic dy,

    output logic outputNS,
    output logic outputWE,
    output logic outputDiag,
    output logic outputSelf

);

logic eqx;
logic eqy;
always_comb begin : grants


    if (src_x == selfx ) begin
        eqx = 1'b1;
    end
    else begin
        eqx = 1'b0;
    end

    if (src_y == selfy ) begin
        eqy = 1'b1;
    end
    else begin
        eqy = 1'b0;
    end


end


always_ff @( req_i ) begin : assignWhenReqComes
    outputSelf = eqy & eqx;
    outputDiag = !(eqy | eqx);
    outputWE = eqx & !(eqx ^ eqy);
    outputNS = eqy & !(eqx ^ eqy);
end


endmodule;