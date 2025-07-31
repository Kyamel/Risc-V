#!/bin/bash

# Fix include paths
find src tb -name "*.v" -exec sed -i 's/`include "constants.v"/`include "core\/constants.v"/' {} \;

# Create symlink as backup
cd src && ln -sf core/constants.v constants.v

echo "Include paths fixed and symlink created"
