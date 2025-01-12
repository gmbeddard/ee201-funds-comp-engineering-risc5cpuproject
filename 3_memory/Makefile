
# You can modify these examples to compile your own assembly or C code for your processor
exampleasm:
	riscv64-unknown-elf-as example.s -o exampleasm # Assembles `example.s` and produces a binary file `exampleasm`
	riscv64-unknown-elf-objcopy -O binary exampleasm exampleasm.hex # Copies the raw bytes from the text segment into `exampleasm.hex`

examplec: example.c
	riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -nostdlib -o examplec example.c # Compiles example.c into `examplec`
	riscv64-unknown-elf-objdump -dr examplec > examplec.lst
	riscv64-unknown-elf-objcopy -O binary examplec examplec.hex # Copies the raw bytes from the text segment into `examplec.hex`


