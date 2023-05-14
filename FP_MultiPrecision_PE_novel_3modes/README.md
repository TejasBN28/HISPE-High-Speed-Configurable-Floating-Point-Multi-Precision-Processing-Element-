## Description
This folder contains the design of HISPE supporting 3 modes of precision - Half Precision (FP16), Single Precision (FP32) and Double Precision (FP64). 

## Folder Hierarchy
This folder contains two sub-directories
 - Design: Which contains the verilog design with `FP_MultiPrecision_PE_novel_3modes` being the top module contained in the file `FP_MultiPrecision_PE_novel_3modes.v`
 - Testbench: Which contains the testbench to test the Design

## Implementation Detail
 - The design was tested on Vivado 2019.2 and implemented on ZCU-104 evaluation board. 
 - Also, the design was implemented as an ASIC on 45nm process (GPDK045) with Cadence Genus Tool.
