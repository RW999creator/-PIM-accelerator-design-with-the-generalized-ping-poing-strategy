# Instruction 1.1
<table>
    <thead>  
   		<tr><th>Operation</th>  
            <th>Ins[63:60]</th> 
            <th>Ins[59:0]</th></tr> 
    <thead>
    <tbody>
		<tr><td>Read weights from Shared_memory</td>  
            <td>1</td> 
            <td>Shared_memory read addr[23:0];<br>
                length[33:24],width[39:34];<br>
                depth of jump[55:40];<br>
                MU write addr[59:56]<br>
                (virtual address 0~8)
        <tr><td>Read data from Shared_memory</td>  
            <td>2</td> 
            <td>Activation_SRAM read addr[17:0];<br>
                length[33:18], width[39:34];<br>
                depth of jump[55:40];<br>
                MU write addr[59:56]<br>
                (virtual address 0~8)
        <tr><td>Process in memory</td>  
            <td>3</td> 
            <td>MVMUx[3:0];<br>
                PIM data addr[19:4]
        <tr><td>Write PIM result to MU</td>  
            <td>4</td> 
            <td>MVMUx[59:56];<br>
                batch_of_data[7:0]<br>
        <tr><td>Write data from MU to Shared_memory</td>  
            <td>5</td> 
            <td>written addr[23:0]<br>
                (Virtual address 0~11)<br>
                MVMUx[59:56]</td></tr>
        <tr><td>SFU operation step1</td>  
            <td>6</td> 
            <td>column[3:0], picture[9:4];<br>
                MVMUa[16:10], MVMUb[21:17];<br>
                MVMUc[26:22], MVMUd[31:27];<br>
                timea[37:32], timeb[43:38];<br>
                MVMUe[49:44], MVMUf[55:50]<br>
                (MVMU: 1~16)</td></tr>
        <tr><td>SFU operation step2</td>  
            <td>7</td> 
            <td>choose layer[3:0];<br>
                choose activation function[7:4]</td></tr>
        <tr><td>Send instructions to core</td>  
            <td>8</td> 
            <td>from instruction[15:0] to [31:16];<br>
                choose the core[47:32] (0~3)<br>
                (At most 64 ins are sent)<br>
                write addr[51:48](virtual address 0~15)
        <tr><td>Set cores state</td>  
            <td>9</td> 
            <td>core0~16[0:15]<br>
                (0: idle, 1: work)</td> </tr>
        <tr><td>Wait</td>  
            <td>10</td> 
            <td>MVMUx[59:56]<br>
                waiting time[31:0]</td>
        <tr><td>Matrix matrix multiplication</td>  
            <td>11</td> 
            <td>weight matrix: [9:0]*[19:10],<br>
                activation matrix: [29:20]*[39:30];<br>
                layer: [41:40];(0~2)<br>
                weight start addr[47:42](column),<br>
                weight start addr[53:48](row),<br>
                activation start addr[59:54]</td>
        <tr><td>Generating basic instructions</td>  
            <td>12</td> 
            <td>xxxx</td>
        <tr><td>Rewrite weight to MVMU</td>  
            <td>13</td> 
            <td>MVMUx: [3:0]</td></tr>
        <tr><td>Stop</td>  
            <td>0</td> 
            <td>xxxx</td></tr>
        </tbody>
    </table>

<table>
    <thead>  
   		<tr><th>Operation</th>  
            <th>Code</th> 
    <thead>
    <tbody>
		<tr><td>Read weights from Shared_memory</td>  
            <td>RWS</td> </tr>
        <tr><td>Read data from Shared_memory</td>  
            <td>RDS</td> </tr>
       	<tr><td>Process in memory</td>  
            <td>PIM</td> </tr>
        <tr><td>Write the PIM_Pro result to the MU</td>  
            <td>WRM</td> </tr>
        <tr><td>Write data from MU to Shared_memory</td>  
            <td>WMS</td> </tr>
        <tr><td>SFU operation step1</td>  
            <td>SO1</td> </tr>
        <tr><td>SFU operation step2</td>  
            <td>SO2</td> </tr>
        <tr><td>Send instructions to core</td>  
            <td>SIC</td> </tr>
        <tr><td>Set cores state</td>  
            <td>SCS</td> </tr>
        <tr><td>Wait</td>  
            <td>W</td>
        <tr><td>Matrix matrix multiplication</td>  
            <td>MMM</td>
        <tr><td>Generating basic instructions</td>  
            <td>GBI</td>
        <tr><td>Rewrite weight to MVMU</td>  
            <td>RWM</td>
        <tr><td>Stop</td>  
            <td>S</td> </tr>
        </tbody>
    </table>

