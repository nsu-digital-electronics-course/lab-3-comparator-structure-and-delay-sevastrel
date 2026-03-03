`timescale 1ns / 1ps

module comp(
    input [31:0] a,
    input [31:0] b,
    output logic gt,
    output logic eq,
    output logic lt
    );

    logic [31:0] bit_eq;
    
    logic [32:0] eq_chain;
    
    logic [31:0] gt_terms;
    
    logic [31:0] lt_terms;
    
    assign eq_chain[32] =1'b1;
    
    genvar i;
    generate 
        for (i=0; i<32; i++) begin : bit_compare
            assign bit_eq[i] = ~(a[i] ^ b[i]);
            assign eq_chain[i] = eq_chain[i+1] & bit_eq[i];
            assign gt_terms[i] = eq_chain[i+1] & a[i] & ~b[i];
            assign lt_terms[i] = eq_chain[i+1] & ~a[i] & b[i];
       end
    endgenerate
    
    assign eq = eq_chain[0];
    
    assign gt = |gt_terms;
    
    assign lt = |lt_terms; 
    
// TODO
// Âîò òóò îïèñûâàåì ñâîé êîìïàðàòîð  
    
endmodule
