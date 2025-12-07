|  Sr.No.  |   Instructions   |        Description        |      Encoding      |
|----------|------------------|---------------------------|--------------------|
|    00    |  load  rs1 rs2   |  rs1 = RAM[rs2]           |  [0000] [s1] [s2]  |
|    01    |  store rs1 rs2   |  RAM[rs1] = rs2           |  [0001] [s1] [s2]  |
|    02    |  lui   rs1 imm   |  rs1[7:4] = imm           |  [0010] [s1] [im]  |
|    03    |  lli   rs1 imm   |  rs1[3:0] = imm           |  [0011] [s1] [im]  |
|    04    |  add   rs1 rs2   |  rs1 = rs1 + rs2          |  [0100] [s1] [s2]  |
|    05    |  addi  rs1 imm   |  rs1 = rs1 + imm          |  [0101] [s1] [im]  |
|    06    |  sub   rs1 rs2   |  rs1 = rs1 - rs2          |  [0110] [s1] [s2]  |
|    07    |  and   rs1 rs2   |  rs1 = rs1 & rs2          |  [0111] [s1] [s2]  |
|    08    |  or    rs1 rs2   |  rs1 = rs1 | rs2          |  [1000] [s1] [s2]  |
|    09    |  not   rs1       |  rs1 = ~rs1               |  [1001] [s1] [..]  |
|    10    |  beqz  rs1 rs2   |  if (rs1 == 0) pc' = rs2  |  [1010] [s1] [s2]  |
|    11    |  bltz  rs1 rs2   |  if (rs1 <  0) pc' = rs2  |  [1011] [s1] [s2]  |
|    12    |  jump  rs2       |  pc' = rs2                |  [1100] [..] [s2]  |
|    13    |  stpc  rs1       |  rs1 = pc                 |  [1101] [s1] [..]  |
|    14    |  dpage rs2       |  dpage = rs2              |  [1110] [..] [s2]  |
|    15    |  ipage rs2       |  ipage = rs2              |  [1111] [..] [s1]  |
