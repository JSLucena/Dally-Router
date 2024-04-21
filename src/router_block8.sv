
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
    input logic dx,
    input logic dy,

    output logic [2:0] toDemux
//
    //output logic outputNS,
    //output logic outputWE,
    //output logic outputDiag,
    //output logic outputSelf,


);
logic eqx;
logic eqy;
logic godown_x = 1'b0;
logic godown_y = 1'b0;
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


    if(selfx[maxx-1:0] > dst_x) begin
        godown_x = 1'b1;
    end
    else begin
        godown_x = 1'b0;
    end

    if(selfy[maxy-1:0] > dst_y) begin
        godown_y = 1'b1;
    end
    else begin
        godown_y = 1'b0;
    end

    if(eqx == 1'b0 && eqy == 1'b0) begin

        if(godown_x == 1'b0 && godown_y == 1'b0) begin
            toDemux = 3'b000; //NE
        end
        else if(godown_x == 1'b1 && godown_y == 1'b0) begin
            toDemux = 3'b001; //NW
        end
        else if(godown_x == 1'b0 && godown_y == 1'b1) begin
            toDemux = 3'b010; //SE
        end
        else if(godown_x == 1'b1 && godown_y == 1'b1) begin
            toDemux = 3'b011; //SW
        end
    end

    else if (eqx == 1'b1 && eqy == 1'b0) begin
        if(godown_y == 1'b0) begin
            toDemux = 3'b100; //N
        end
        else if(godown_y == 1'b1) begin
            toDemux = 3'b101; //S
        end
    end
    else if (eqx == 1'b0 && eqy == 1'b1) begin
        if(godown_x == 1'b0) begin
            toDemux = 3'b110; //E
        end
        else if(godown_x == 1'b1) begin
            toDemux = 3'b111; //W
        end
    end
end
    
  //  outputSelf = eqy & eqx;
  //  outputDiag = !(eqy | eqx);
  //  outputWE = eqx & !(eqx ^ eqy);
  //  outputNS = eqy & !(eqx ^ eqy);



endmodule;