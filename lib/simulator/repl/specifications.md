# Simulator REPL Specifications

## Commands

1. `step` - Step through one cycle
2. `step n` - Step through `n` cycles
3. `instruction` - Show current instruction
4. `register rx` - Show contents of register `rx`
5. `memory addr` - Show contents of memory address `addr`
6. `help` - Show help text
7. `quit` - Quit repl

## Comments

- After PC has reached out-of-bounds, `step` and `step n` have no effect.

## Future Plans

- Ability to modify register and memory
- Ability to modify program counter
- Ability to step backwards
- Show resolved lables
