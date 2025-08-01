{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.iverilog
    pkgs.gtkwave
    pkgs.verilator    
    #pkgs.pkgsCross.riscv32-embedded.buildPackages.binutils
    #pkgs.pkgsCross.riscv32-embedded.buildPackages.gcc
    #pkgs.nlohmann_json
    #pkgs.nodejs-slim_24
  ];

  shellHook = ''
    echo "Ambiente Verilog com toolchain RISC-V pronto."
    echo "Ferramentas disponíveis:"
    echo " - iverilog (simulação Verilog)"
    echo " - gtkwave (visualização de waveforms)"
    echo " - verilator (compilador Verilog para C++)"
  '';
}