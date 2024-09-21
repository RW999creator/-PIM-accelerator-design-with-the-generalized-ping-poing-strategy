# <center> Generalized Ping-Pong Processing-in-memory architecture

***

## Overview
GPP-PIM is a PIM architecture with weight update capabilities, supporting three modes: Generalized Ping-Pong, naive Ping-Pong, and in situ write/compute.

It possesses a set of customized instructions to facilitate the architecture in completing computational tasks.

Data such as execution time, macro utilization, off-chip bandwidth utilization, and on-chip memory usage will be monitored to test and compare the optimal parallel write/compute strategies.

GPP-PIM now supports comparisons in 12 different strategy usage environments.

***

## Basic Parameters
### Architecture
<table>
    <tr>
        <td> cores	    </td>
        <td> 16	    </td>
    </tr>
    <tr>
        <td> number of macros in a core  </td>
        <td> 16  </td>
    </tr>
    <tr>
        <td> array size	    </td>
        <td> 32*32B	    </td>
    </tr>
    <tr>
        <td> rewrite speed	    </td>
        <td> 8B/cycle~1B/cycle	    </td>
    </tr>
</table>

### ISA
['Instruction.md'] 此文件定义了GPP-PIM使用的ISA。

***

## Scenarios
### Design Phase Optimization
<table>
    <tr>
        <td> off-chip bandwidth	    </td>
        <td> result memory usage by a macro </td>
    </tr>
    <tr>
        <td> 128	    </td>
        <td> 1*512B </td>
    </tr>
    <tr>
        <td> 128	    </td>
        <td> 2*512B </td>
    </tr>
    <tr>
        <td> 128	    </td>
        <td> 4*512B </td>
    </tr>
    <tr>
        <td> 128	    </td>
        <td> 8*512B </td>
    </tr>
    <tr>
        <td> 128	    </td>
        <td> 24*512B </td>
    </tr>
    <tr>
        <td> 128	    </td>
        <td> 56*512B </td>
    </tr>
</table>

### Runtime Phase Pipeline Adaption
<table>
    <tr>
        <td> off-chip bandwidth	    </td>
        <td> result memory usage by a macro </td>
    </tr>
    <tr>
        <td> 512	    </td>
        <td> 4*512B </td>
    </tr>
    <tr>
        <td> 256	    </td>
        <td> 4*512B </td>
    </tr>
    <tr>
        <td> 128	    </td>
        <td> 4*512B </td>
    </tr>
    <tr>
        <td> 64	    </td>
        <td> 4*512B </td>
    </tr>
    <tr>
        <td> 32	    </td>
        <td> 4*512B </td>
    </tr>
    <tr>
        <td> 16	    </td>
        <td> 4*512B </td>
    </tr>
    <tr>
        <td> 8	    </td>
        <td> 4*512B </td>
    </tr>
</table>

***

## Usage

You can utilize the provided instruction code to conduct execution strategy tests for various usage scenarios. For detailed information, please refer to the ['GPP-PIM_usage_guide.md'].

Preparation:
1. Python 3 environment: Employed for running the assembler program.
2. ModelSim software: Utilized for simulating our Verilog files.

***

## Citation
You can cite GPP-PIM using our related paper as: