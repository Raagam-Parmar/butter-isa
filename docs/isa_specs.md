# Specifications

## Base Instructions

| Sr.No. | Instructions  | Description             | Encoding         | Type |
| ------ | ------------- | ----------------------- | ---------------- | ---- |
| 00     | load rs1 rs2  | rs1 = RAM[rs2]          | [0000] [s1] [s2] | RR   |
| 01     | store rs1 rs2 | RAM[rs2] = rs1          | [0001] [s1] [s2] | RR   |

| 02     | lui imm       | r0[7:4] = imm           | [0010] [  imm  ] | I    |
| 03     | lli imm       | r0      = imm           | [0011] [  imm  ] | I    |

| 04     | add rs1 rs2   | rs1 =   rs1  + rs2      | [0100] [s1] [s2] | RR   |
| 05     | sub rs1 rs2   | rs1 =   rs1  - rs2      | [0101] [s1] [s2] | RR   |
| 06     | and rs1 rs2   | rs1 =   rs1  & rs2      | [0110] [s1] [s2] | RR   |
| 07     | or rs1 rs2    | rs1 =   rs1 \| rs2      | [0111] [s1] [s2] | RR   |
| 08     | not rs1       | rs1 = ~ rs1             | [1000] [s1] [--] | RR   |
| 09     | mov rs1 rs2   | rs1 =   rs2             | [1001] [s1] [s2] | RR   |
| 10     |               |                         | [1010]           |      |
| 11     | stpc rs1      | rs1 = pc                | [1011] [s1] [--] | RR   |

| 12     | beqz rs1 rs2  | if (rs1 == 0) pc' = rs2 | [1100] [s1] [s2] | RR   |
| 13     | bltz rs1 rs2  | if (rs1 <  0) pc' = rs2 | [1101] [s1] [s2] | RR   |
| 14     | bgtz rs1 rs2  | if (rs1 >  0) pc' = rs2 | [1110] [s1] [s2] | RR   |
| 15     | jump rs2      |               pc' = rs2 | [1111] [--] [s2] | RR   |

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

## Pseudo-Instructions

| Sr.No. | Instructions | Description             | Expansion          | Comments        |
| ------ | ------------ | ----------------------- | ------------------ | --------------- |
| 00     | li imm       | r0 = imm                | lli imm            | imm < 16        |
| 01     | li imm       | r0 = imm                | lli (imm & 0b1111) | 16 <= imm < 256 |
|        |              |                         | lui (imm >> 4)     |                 |
| 02     | blez rs1 rs2 | if (rs1 <= 0) pc' = rs2 | bltz rs1 rs2       |                 |
|        |              |                         | beqz rs1 rs2       |                 |
| 03     | bgez rs1 rs2 | if (rs1 >= 0) pc' = rs2 | bgtz rs1 rs2       |                 |
|        |              |                         | beqz rs1 rs2       |                 |
| 04     | bnez rs1 rs2 | if (rs1 != 0) pc' = rs2 | bltz rs1 rs2       |                 |
|        |              |                         | bgtz rs1 rs2       |                 |
