# Simulator REPL Specifications

## Commands

1. `step` - Step through one cycle
2. `step n` - Step through `n` cycles
3. `prog` - Show current program
4. `inst` - Show current instruction
5. `reg` - Show register file
6. `reg rx` - Show contents of register `rx`
7. `mem` - Show contents of memory
8. `mem addr` - Show contents of memory address `addr`
9. `dpage` - Show RAM page register
10. `ipage` - Show ROM page register
11. `help` - Show help text
12. `quit` - Quit repl

## Comments

- After PC has reached out-of-bounds, `step` and `step n` have no effect.

## Future Plans

- Ability to modify register and memory
- Ability to modify program counter
- Ability to step backwards
- Show resolved lables
- Ability to restore program
