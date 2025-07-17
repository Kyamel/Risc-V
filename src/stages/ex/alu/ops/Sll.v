module Sll(
  input  logic [31:0] a,
  input  logic [31:0] b,
  output logic [31:0] result
);
  assign result = a << b[4:0];  // apenas 5 bits válidos
endmodule
