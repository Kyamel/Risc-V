{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.iverilog
    pkgs.gtkwave
    #pkgs.pkgsCross.riscv32-embedded.buildPackages.binutils
    #pkgs.pkgsCross.riscv32-embedded.buildPackages.gcc
  ];

  shellHook = ''
    echo "Ambiente Verilog com toolchain RISC-V pronto."
    echo "Ferramentas disponíveis:"
    echo " - iverilog (simulação Verilog)"
    echo " - gtkwave (visualização de waveforms)"
  '';
}