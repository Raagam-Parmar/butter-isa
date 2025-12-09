# Specifications

| Sr.No. | Instructions  | Description             | Encoding         | Type |
| ------ | ------------- | ----------------------- | ---------------- | ---- |
| 00     | load rs1 rs2  | rs1 = RAM[rs2]          | [0000] [s1] [s2] | RR   |
| 01     | store rs1 rs2 | RAM[rs2] = rs1          | [0001] [s1] [s2] | RR   |
| 02     | lui imm       | r0[7:4] = imm           | [0010] [  im   ] | I    |
| 03     | lli imm       | r0 = imm                | [0011] [  im   ] | I    |
| 04     | mov rs1 rs2   | rs1 = rs2               | [0101] [s1] [s2] | RR   |
| 05     | add rs1 rs2   | rs1 = rs1 + rs2         | [0100] [s1] [s2] | RR   |
| 06     | sub rs1 rs2   | rs1 = rs1 - rs2         | [0110] [s1] [s2] | RR   |
| 07     | and rs1 rs2   | rs1 = rs1 & rs2         | [0111] [s1] [s2] | RR   |
| 08     | or rs1 rs2    | rs1 = rs1 \| rs2        | [1000] [s1] [s2] | RR   |
| 09     | not rs1       | rs1 = ~rs1              | [1001] [s1] [--] | RR   |
| 10     | beqz rs1 rs2  | if (rs1 == 0) pc' = rs2 | [1010] [s1] [s2] | RR   |
| 11     | bltz rs1 rs2  | if (rs1 < 0) pc' = rs2  | [1011] [s1] [s2] | RR   |
| 12     | bgtz rs1 rs2  | if (rs1 > 0) pc' = rs2  | [1100] [s1] [s2] | RR   |
| 13     | jump rs2      | pc' = rs2               | [1101] [--] [s2] | RR   |
| 14     | stpc rs1      | rs1 = pc                | [1110] [s1] [--] | RR   |
| 15     | dpage rs2     | dpage = rs2             | [1111] [00] [s2] | RR   |
| 16     | ipage rs2     | ipage = rs2             | [1111] [01] [s2] | RR   |

## Instruction Types

### RR-Type

```text
[  . . .  ][  .  ][  .  ]
[ OPCODE  ][ RS1 ][ RS2 ]
```

### I-Type

```text
[  . . .  ][  .  ][  .  ]
[ OPCODE  ][     ][ IMM ]
```

## Register Specifications

- `r0` is used to load immediate
