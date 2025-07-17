// versão mais reaproveitável
module Bne(
  input  logic [31:0] a,
  input  logic [31:0] b,
  output logic taken
);
  logic [31:0] xor_out;
  Xor xor_inst(.a(a), .b(b), .result(xor_out));
  assign taken = |xor_out; // se algum bit for 1, são diferentes
endmodule

