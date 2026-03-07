`timescale 1ns / 1ps

module comp #(
    parameter int size = 32  // Параметр с значением по умолчанию
) (
    input [size-1:0] a,
    input [size-1:0] b,
    output logic gt,
    output logic eq,
    output logic lt
    );
    
    logic [size-1:0] bit_eq;
    
    logic [size:0] eq_chain;
    
    logic [size-1:0] gt_terms;
    
    logic [size-1:0] lt_terms;
    
    assign eq_chain[size] =1'b1;
    
    genvar i;
    generate 
        for (i=0; i<size; i++) begin : bit_compare
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
// Вот тут описываем свой компаратор  
    
endmodule
