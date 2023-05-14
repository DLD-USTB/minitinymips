.section entry, "ax"
.globl _start
.type _start, @function

_start:
  move $fp, $zero
  la $sp, _stack_pointer
  li $t1, 0xa00003f8
  li $t0, 'H'
  sw $t0,0($t1)
  li $t0, 'e'
  sw $t0,0($t1)
  li $t0, 'l'
  sw $t0,0($t1)
  li $t0, 'l'
  sw $t0,0($t1)
  li $t0, 'o'
  sw $t0,0($t1)
  li $t0, ','
  sw $t0,0($t1)
  li $t0, 'w'
  sw $t0,0($t1)
  li $t0, 'o'
  sw $t0,0($t1)
  li $t0, 'r'
  sw $t0,0($t1)
  li $t0, 'l'
  sw $t0,0($t1)
  li $t0, 'd'
  sw $t0,0($t1)
  li $t0, '\n'
  sw $t0,0($t1)
  sdbbp

.fill 0x200
