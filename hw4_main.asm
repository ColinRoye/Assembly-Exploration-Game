.data
map_filename: .asciiz "map3.txt"
# num words for map: 45 = (num_rows * num_cols + 2) // 4
# map is random garbage initially
.asciiz "Don't touch this region of memory"
map: .word 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212
.asciiz "Don't touch this"
# player struct is random garbage initially
player: .word 0x2912FECD
.asciiz "Don't touch this either"
# visited[][] bit vector will always be initialized with all zeroes
# num words for visited: 6 = (num_rows * num*cols) // 32 + 1
visited: .word 0 0 0 0 0 0
.asciiz "Really, please don't mess with this string"

welcome_msg: .asciiz "Welcome to MipsHack! Prepare for adventure!\n"
pos_str: .asciiz "Pos=["
health_str: .asciiz "] Health=["
coins_str: .asciiz "] Coins=["
your_move_str: .asciiz " Your Move: "
you_won_str: .asciiz "Congratulations! You have defeated your enemies and escaped with great riches!\n"
you_died_str: .asciiz "You died!\n"
you_failed_str: .asciiz "You have failed in your quest!\n"

.text
print_map:
la $t0, map  # the function does not need to take arguments
lbu $t1, 0($t0)
lbu $t2, 1($t0)
addiu $t0, $t0, 2
li $t3, 0
loop_print_map:
beq $t3, $t1, loop_print_map_over
li $t4, 0
sub_loop_print_map:
beq $t4, $t2, sub_loop_print_map_over
mul $a0, $t3, $t2
addu $a0, $t0, $t4
lbu $a0, 0($a0)
li $v0, 11
syscall
addiu $t4, $t4, 1
b sub_loop_print_map
sub_loop_print_map_over:
addiu $t3, $t3, 1
li $a0, '\n'
li $v0, 11
syscall
li $a0, '\n'
li $v0, 11
syscall
b loop_print_map
loop_print_map_over:


jr $ra

print_player_info:
# the idea: print something like "Pos=[3,14] Health=[4] Coins=[1]"
li $a0, ' '
li $v0, 11
syscall
la $t0, player
la $a0, pos_str
li $v0, 4
syscall
lbu $a0, 0($t0)
li $v0, 11
syscall
li $a0, ','
li $v0, 11
syscall
lbu $a0, 1($t0)
li $v0, 11
syscall
la $a0, health_str
li $v0, 4
syscall
lbu $a0, 2($t0)
li $v0, 11
syscall
la $a0, coins_str
li $v0, 4
syscall
lbu $a0, 3($t0)
li $v0, 11
syscall
li $a0, ']'
li $v0, 11
syscall
li $a0, '\n'
li $v0, 11
syscall
jr $ra


.globl main
main:
la $a0, welcome_msg
li $v0, 4
syscall

la $a0, map_filename
la $a1, map
la $a2, player
jal init_game

# fill in arguments
jal reveal_area

li $s0, 0  # move = 0

game_loop:  # while player is not dead and move == 0:

jal print_map # takes no args

jal print_player_info # takes no args

# print prompt
la $a0, your_move_str
li $v0, 4
syscall

li $v0, 12  # read character from keyboard
syscall
move $s1, $v0  # $s1 has character entered
li $s0, 0  # move = 0

li $a0, '\n'
li $v0 11
syscall

# handle input: w, a, s or d
# map w, a, s, d  to  U, L, D, R and call player_turn()

# if move == 0, call reveal_area()  Otherwise, exit the loop.

#j game_loop
li $v0, 10
syscall

game_over:
jal print_map
jal print_player_info
li $a0, '\n'
li $v0, 11
syscall

# choose between (1) player dead, (2) player escaped but lost, (3) player escaped and won

won:
la $a0, you_won_str
li $v0, 4
syscall
j exit

failed:
la $a0, you_failed_str
li $v0, 4
syscall
j exit

player_dead:
la $a0, you_died_str
li $v0, 4
syscall

exit:
li $v0, 10
syscall

.include "hw4.asm"
