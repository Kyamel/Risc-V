`timescale 1ns/1ps

module tb_memory_interface;

  reg clk = 0;
  reg reset = 0;

  // Entradas conforme a interface do módulo
  reg [31:0] addr;
  reg [31:0] write_data;
  reg [2:0] mem_size;
  reg mem_read;
  reg mem_write;
  
  // Saídas conforme a interface do módulo
  wire [31:0] mem_addr;
  wire [31:0] mem_data_out;
  reg [31:0] mem_data_in;  // Agora é um reg para podermos dirigir
  wire mem_read_en;
  wire mem_write_en;
  wire [3:0] byte_enable;
  wire [31:0] read_data;

  // Instância do DUT
  memory_interface dut (
    .clk(clk),
    .reset(reset),
    .addr(addr),
    .write_data(write_data),
    .mem_size(mem_size),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .mem_addr(mem_addr),
    .mem_data_out(mem_data_out),
    .mem_data_in(mem_data_in),
    .mem_read_en(mem_read_en),
    .mem_write_en(mem_write_en),
    .byte_enable(byte_enable),
    .read_data(read_data)
  );

  // Clock
  always #5 clk = ~clk;

  task check(string test_name, logic [31:0] expected, logic [31:0] actual);
    if (expected === actual) begin
      $display("\033[32m[PASS]\033[0m %s: Got 0x%h", test_name, actual);
    end else begin
      $display("\033[31m[FAIL]\033[0m %s: Expected 0x%h, got 0x%h", test_name, expected, actual);
    end
  endtask

  initial begin
    $display("---- Teste da memory_interface ----");
    reset = 1;
    mem_read = 0;
    mem_write = 0;
    addr = 0;
    write_data = 0;
    mem_size = 3'b010; // word por padrão
    mem_data_in = 0;
    #10;
    reset = 0;

    // Teste 1: Escrita de word completa
    addr = 32'h00000000;
    write_data = 32'hAABBCCDD;
    mem_write = 1;
    #10;
    mem_write = 0;
    
    // Verificar byte_enable para escrita de word
    check("Byte enable word", 4'b1111, byte_enable);

    // Teste 2: Leitura de word
    mem_data_in = 32'h11223344; // Dados simulados da memória
    mem_read = 1;
    #10;
    check("Read word", 32'h11223344, read_data);
    mem_read = 0;

    // Teste 3: Escrita de byte
    addr = 32'h00000004;
    write_data = 32'h000000EE;
    mem_size = 3'b000; // byte
    mem_write = 1;
    #10;
    mem_write = 0;
    
    // Verificar byte_enable para byte no endereço 0
    check("Byte enable byte[0]", 4'b0001, byte_enable);

    // Teste 4: Leitura de byte com extensão de sinal
    mem_data_in = 32'hFFEEDDCC;
    mem_size = 3'b000; // byte
    addr = 32'h00000001; // Byte 1
    mem_read = 1;
    #10;
    check("Read byte with sign extension", 32'hFFFFFFDD, read_data);
    mem_read = 0;

    $display("---- Fim dos testes ----");
    #10;
    $finish;
  end

endmodule