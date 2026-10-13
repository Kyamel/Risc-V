{
  description = "RISC-V (RV32E) processor in Verilog: simulation, tests and lint";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = [
            pkgs.iverilog   # default simulator (make test)
            pkgs.verilator  # alternative simulator (make test SIM=verilator) and lint
            # Waveforms (make wave). Judy, which gtkwave uses for its symbol table,
            # trips glibc's _FORTIFY_SOURCE=3 checks (a false positive in JudySLIns)
            # and aborts on every VCD; build Judy without fortify.
            (pkgs.gtkwave.override {
              judy = pkgs.judy.overrideAttrs (old: {
                hardeningDisable = (old.hardeningDisable or [ ]) ++ [ "fortify" "fortify3" ];
              });
            })
            (pkgs.lua5_4.withPackages (ps: [ ps.luafilesystem ]))  # test scripts (+ lfs)
            # GNU assembler/linker for RISC-V (riscv32-none-elf-as, -ld, -objcopy, -objdump)
            pkgs.pkgsCross.riscv32-embedded.buildPackages.binutils
            pkgs.gnumake
            # LaTeX for the paper in latex/ (make paper): only what the SBC
            # template and the article use, instead of a full TeX Live
            (pkgs.texliveBasic.withPackages (ps: with ps; [
              latexmk geometry titlesec booktabs pgf xcolor url
              psnfss times helvetic courier
            ]))
          ];

          shellHook = ''
            echo "RISC-V dev shell. Commands: make test | make trace T=<program> | make lint | make paper"
          '';
        };
      });
    };
}
