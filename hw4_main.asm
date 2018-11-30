.data
map_filename: .asciiz "map2.txt"
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
li $a0, '\n'
li $v0, 11
syscall
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
addu $a0, $a0, $t4
addu $a0, $a0, $t0
lbu $a0, 0($a0)
li $v0, 11

li $t9, 0x23
beq $a0, $t9, print
li $t9, '@'
beq $a0, $t9, print
li $t9, '.'
beq $a0, $t9, print
li $t9, '/'
beq $a0, $t9, print
li $t9, '>'
beq $a0, $t9, print
li $t9, '$'
beq $a0, $t9, print
li $t9, '*'
beq $a0, $t9, print
li $t9, 'm'
beq $a0, $t9, print
li $t9, 'B'
beq $a0, $t9, print
li $t9, '?'
beq $a0, $t9, print
li $t9, 'X'
beq $a0, $t9, print
b print_space
print:
syscall
b print_over
print_space:
li $a0, ' '
syscall
print_over:

li $v0, 11
# syscall
addiu $t4, $t4, 1
b sub_loop_print_map
sub_loop_print_map_over:
addiu $t3, $t3, 1
li $a0, '\n'
li $v0, 11
syscall
# #li $a0, '\n'
# li $v0, 11
# syscall
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
li $v0, 1
syscall
li $a0, ','
li $v0, 11
syscall
lbu $a0, 1($t0)
li $v0, 1
syscall
la $a0, health_str
li $v0, 4
syscall
lbu $a0, 2($t0)
li $v0, 1
syscall
la $a0, coins_str
li $v0, 4
syscall
lbu $a0, 3($t0)
li $v0, 1
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
la $t0, player

la $a0, map
lb $a1, 0($t0)
lb $a2, 1($t0)
jal reveal_area

#####################################GET TEST
# la $a0, map
# li $a1, 3
# li $a2, 5
# jal get_cell
# move $a0, $v0
# li $v0, 11
# syscall
# li $v0, 10
# syscall

#####################################SET TEST
# jal print_map
#
# la $a0, map
# li $a1, 0
# li $a2, 1
# li $a3, 'X'
# jal set_cell
#
# la $a0, map
# li $a1, 3
# li $a2, 5
# jal get_cell
# move $a0, $v0
# li $v0, 11
# syscall
# move $a0, $v0
#
#
# jal print_map
# li $v0, 10
# syscall
#################################### get_attack_target TEST
# #set playe location to 1,9
# la $t0, player
# li $t1, 1
# sb $t1, 0($t0)
# li $t1, 9
# sb $t1, 1($t0)
# la $a0, map
# la $a1, player
# li $a2, 'U'
# jal get_attack_target
# move $a0, $v0
# li $v0, 1
# syscall
#
# la $t0, player
# li $t1, 1
# sb $t1, 0($t0)
# li $t1, 9
# sb $t1, 1($t0)
# la $a0, map
# la $a1, player
# li $a2, 'D'
# jal get_attack_target
# move $a0, $v0
# li $v0, 1
# syscall
#
# la $t0, player
# li $t1, 1
# sb $t1, 0($t0)
# li $t1, 9
# sb $t1, 1($t0)
# la $a0, map
# la $a1, player
# li $a2, 'L'
# jal get_attack_target
# move $a0, $v0
# li $v0, 1
# syscall
#
# la $t0, player
# li $t1, 1
# sb $t1, 0($t0)
# li $t1, 9
# sb $t1, 1($t0)
# la $a0, map
# la $a1, player
# li $a2, 'R'
# jal get_attack_target
# move $a0, $v0
# li $v0, 1
# syscall
#
#
# li $v0, 10
# syscall
##################################### Complete Attack Test
#health bellow zeroe
# li $t0, 1
# la $t1, player
# sb $t0, 2($t1)
#
# la $a0, map
# la $a1, player
# li $a2, 1
# li $a3, 8
# jal complete_attack
#
# jal print_map
#
# li $v0, 10
# syscall

# fill in arguments
#jal reveal_area

li $s0, 0  # move = 0

game_loop:  # while player is not dead and move == 0:


jal print_map # takes no args
### print_map_debug
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

li $t0, 'w' #u
li $t1, 'U'
beq $t0, $s1, dir_select
li $t0, 's' #d
li $t1, 'D'
beq $t0, $s1, dir_select
li $t0, 'a' #l
li $t1, 'L'
beq $t0, $s1, dir_select
li $t0, 'd' #r
li $t1, 'R'
beq $t0, $s1, dir_select
li $t1, 0
li $t0, 'r'
beq $t0, $s1, flood_fill_reveal_select
dir_select:
la $a0, map
la $a1, player
move $a2, $t1





jal player_turn

# if move == 0, call reveal_area()  Otherwise, exit the loop.
#bnez $v0, skip_reveal
la $a0, map
la $t0, player
lb $a1, 0($t0)
lb $a2, 1($t0)
jal reveal_area
skip_reveal:
j game_loop
flood_fill_reveal_select:


li $a0, 10000
li $v0, 9
syscall
move $a3, $v0

la $a0, map
la $t0, player
lb $a1, 0($t0)
lb $a2, 1($t0)
jal flood_fill_reveal


j game_loop
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


print_map_debug:
li $a0, '\n'
li $v0, 11
syscall
la $t0, map  # the function does not need to take arguments
lbu $t1, 0($t0)
lbu $t2, 1($t0)
addiu $t0, $t0, 2
li $t3, 0
loop_print_map_debug:
beq $t3, $t1, loop_print_map_over_debug
li $t4, 0
sub_loop_print_map_debug:
beq $t4, $t2, sub_loop_print_map_over_debug
mul $a0, $t3, $t2
addu $a0, $a0, $t4
addu $a0, $a0, $t0
lbu $a0, 0($a0)
li $v0, 11

andi $a0, $a0, 0x7F

li $t9, 0x23
beq $a0, $t9, print_debug
li $t9, '@'
beq $a0, $t9, print_debug
li $t9, '.'
beq $a0, $t9, print_debug
li $t9, '/'
beq $a0, $t9, print_debug
li $t9, '>'
beq $a0, $t9, print_debug
li $t9, '$'
beq $a0, $t9, print_debug
li $t9, '*'
beq $a0, $t9, print_debug
li $t9, 'm'
beq $a0, $t9, print_debug
li $t9, 'B'
beq $a0, $t9, print_debug
li $t9, '?'
beq $a0, $t9, print_debug
li $t9, 'X'
beq $a0, $t9, print_debug
b print_space_debug
print_debug:
syscall
b print_over_debug
print_space_debug:
li $a0, ' '
syscall
print_over_debug:

li $v0, 11
# syscall
addiu $t4, $t4, 1
b sub_loop_print_map_debug
sub_loop_print_map_over_debug:
addiu $t3, $t3, 1
li $a0, '\n'
li $v0, 11
syscall
# #li $a0, '\n'
# li $v0, 11
# syscall
b loop_print_map_debug
loop_print_map_over_debug:


jr $ra



.include "hw4.asm"
