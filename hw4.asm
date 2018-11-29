# type your first and last name here
# type your Net ID here (e.g., jmsmith)
# type your SBU ID # here (e.g., 111234567)

#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################

.text

# Part I
init_game:
addiu $sp, $sp, -20
sw $a0, 0($sp) #mf
sw $a1, 4($sp) #mp
sw $a2, 8($sp) #pp
sw $s0, 12($sp)
sw $s1, 16($sp)

lw $a0, 0($sp)
li $a1, 0
li $a2, 0

li $v0, 13
syscall
bltz $v0, init_err

move $s0, $v0 #file dec

li $a0, 5
li $v0, 9
syscall
move $s1, $v0

move $a0, $s0
move $a1, $v0
li $a2, 5

li $v0, 14
syscall
bltz $v0, init_err


lb $t0, 0($s1)
lb $t1, 1($s1)
addiu $t0, $t0, -0x30
li $t2, 10
mul $t0, $t0, $t2
addiu $t1, $t1, -0x30
addu $t0, $t0, $t1
#convert first 2 bytes to  an int



lw $a0, 4($sp)
sb $t0, 0($a0) #save row

lb $t0, 3($s1)
lb $t1, 4($s1)
addiu $t0, $t0, -0x30
li $t2, 10


mul $t0, $t0, $t2
addiu $t1, $t1, -0x30
addu $t0, $t0, $t1


lw $a0, 4($sp)
sb $t0, 1($a0) #save col

lb $t0, 1($a0)
lb $t1, 0($a0)




mul $t0, $t0, $t1 #len arr

#loop to load in 2d arr ignoring newlines
li $t2, '\n'
lw $t3, 4($sp) #mp
addiu $t3, $t3, 2
loop_init_map:
move $a0, $s0
move $a1, $s1
li $a2, 1
li $v0, 14
syscall
bltz $v0, init_err

lb $t1, 0($s1)


beqz $t0, loop_init_map_over
beq $t1, $t2, loop_init_map #read in new char

move $t5, $t1
#xori $t5, $t5, 0x80
sb $t5, 0($t3)



li $t5, '@'
bne $t1, $t5, player_mark_over

lw $a0, 4($sp)


lb $t5, 1($a0)
lb $t6, 0($a0)

mul $t6, $t5, $t6
sub $t6, $t6, $t0

div $t6, $t5

mflo $t5 #row
mfhi $t6 #col



lw $t7, 8($sp) #pp

sb $t5, 0($t7)
sb $t6, 1($t7)

move $a0, $t6
li $v0, 1

player_mark_over:

addiu $t3, $t3, 1
addiu $t0, $t0, -1
b loop_init_map
loop_init_map_over:

move $a0, $s0
move $a1, $s1
li $a2, 2

li $v0, 14
syscall
bltz $v0, init_err
lb $t0, 0($s1)
lb $t1, 1($s1)
addiu $t0, $t0, -0x30
li $t2, 10
mul $t0, $t0, $t2
addu $t0, $t0, $t1



lw $a0, 8($sp)
sb $t0, 2($a0) #save health

li $t0, 0
sb $t0, 3($a0) #zero coins


lw $a0, 0($sp)
lw $a1, 4($sp)
lw $a2, 8($sp)
lw $s0, 12($sp)
lw $s1, 16($sp)
addiu $sp, $sp, 12

li $v0, 0
b init_over
init_err:
li $v0, -1
init_over:


#close and save s reg
jr $ra


# Part II
is_valid_cell:

bltz $a1, not_valid
bltz $a2, not_valid

lbu $t1, 0($a0)
lbu $t2, 1($a0)

bge $a1, $t1, not_valid
bge $a2, $t2, not_valid

li $v0, 0

b is_valid_over
not_valid:
li $v0, -1
is_valid_over:

jr $ra


# Part III
get_cell:
addiu $sp, $sp, -8
sw $ra, 0($sp)
sw $s0, 4($sp)

lb $t1, 0($a0)
lb $t2, 1($a0)
addiu $a0, $a0, 2
mul $t2, $t2, $a1 #row ind times num num_cols
addu $t2, $t2, $a2
addu $t2, $t2, $a0
move $s0, $t2


#args?
jal is_valid_cell

bltz $v0, get_err
move $v0, $s0
lbu $v0, 0($v0)






b get_over
get_err:
li $v0, -1
get_over:

lw $ra, 0($sp)
lw $s0, 4($sp)
addiu $sp, $sp, 8

jr $ra


# Part IV
set_cell:

addiu $sp, $sp, -12
sw $ra, 0($sp)
sw $s0, 4($sp)
sw $s1, 8($sp)

move $s1, $a3
lb $t1, 0($a0)
lb $t2, 1($a0)
addiu $a0, $a0, 2
mul $t2, $t2, $a1 #row ind times num num_cols
addu $t2, $t2, $a2
addu $t2, $t2, $a0
move $s0, $t2

#args?
jal is_valid_cell

bltz $v0, set_err
li $v0, 0
sb $s1, 0($s0)

lw $ra, 0($sp)
lw $s0, 4($sp)
lw $s1, 8($sp)
addiu $sp, $sp, 12




b set_over
set_err:
li $v0, -1
set_over:

jr $ra

##finished line!

# Part V
reveal_area:
##########save s reg
addiu $sp, $sp, -12
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s7, 8($sp)


addiu $a1, $a1, -1
addiu $a2, $a2, -1

li $s7, 3
li $s1, 0
rva_loop:
beq $s1, $s7, rva_loop_over
li $s0, 0
rva_sub_loop:
beq $s0, $s7, rva_sub_loop_over
addiu $sp, $sp, -16
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $a2, 8($sp)
sw $ra, 12($sp)
#is valid

addu $a1, $a1, $s0
addu $a2, $a2, $s1

jal is_valid_cell
bltz $v0, skip_set
#get cell
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $a2, 8($sp)
jal get_cell
#and
sll $t0, $v0, 3
beqz $t0, skip_set #already revealed

xori $a3, $v0 0x80
#set cell
jal set_cell


skip_set:
lw $ra, 12($sp)
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $a2, 8($sp)
addiu $sp, $sp, 16
addiu $s0, $s0, 1
b rva_sub_loop
rva_sub_loop_over:
addiu $s1, $s1, 1
rva_loop_over:

sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s7, 8($sp)
addiu $sp, $sp, 12

#######save s reg
jr $ra

# Part VI
get_attack_target:
addiu $sp, $sp, -12
sw $ra, 0($sp)
sw $s0, 4($sp)
sw $s1, 8($sp)
#load in the pos of the character
#0,1 plr row,col
lb $s0, 0($a1)
lb $s1, 1($a1)
#switch statement to interpret dir





trns_case_U:
li $t0, 'U'
bne $t0, $a2, trns_case_D
#row -1
addiu $s0, $s0, -1
b trns_mv_over

trns_case_D:
li $t0, 'D'
bne $t0, $a2, trns_case_L
#row + 1
addiu $s0, $s0, 1
b trns_mv_over

trns_case_L:
li $t0, 'L'
bne $t0, $a2, trns_case_R
#col -1
addiu $s1 $s1, -1
b trns_mv_over

trns_case_R:
li $t0, 'R'
bne $t0, $a2, trns_mv_over
#col +1
addiu $s1, $s1, 1
trns_mv_over:
#add dir to row or col

#target = m B or / otherwise -1


addiu $sp, $sp, -4
sw $ra, 4($sp)

move $a1, $s0
move $a2, $s1
jal get_cell

lw $ra, 4($sp)
addiu $sp, $sp, 4

rtm_case_m:
li $t0, 'm'
bne $t0, $v0, rtm_case_B
#row -1
# addiu $s0, $s0, -1
b  rtm_over
b trns_mv_over

rtm_case_B:
li $t0, 'B'
bne $t0, $v0, rtm_case_slash
b  rtm_over
b trns_mv_over

rtm_case_slash:
li $t0, '/'
bne $t0, $v0, rtm_err
#col +1
# addiu $s1, $s1, 1
b rtm_over
rtm_err:
li $v0, -1
rtm_over:

lw $ra, 0($sp)
lw $s0, 4($sp)
lw $s1, 8($sp)
addiu $sp, $sp, 12


jr $ra



# Part VII
complete_attack:
addiu $sp, $sp, -24
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $a2, 8($sp)
sw $a3, 12($sp)
sw $ra, 16($sp)
sw $s0, 20($sp)

lb $s0, 2($a1) #player health

move $a1, $a2
move $a2, $a3
jal get_cell

#load in players health
mstr_m:
li $t0, 'm'
bne $t0, $v0, mstr_B

lw $a0, 0($sp)
lw $a1, 8($sp)
lw $a2, 12($sp)
li $a3, '$'
jal set_cell
#replace with "$"

addiu $s0, $s0, -1


b mstr_over
mstr_B:
li $t0, 'B'
bne $t0, $v0, mstr_slash

lw $a0, 0($sp)
lw $a1, 8($sp)
lw $a2, 12($sp)
li $a3, '*'
jal set_cell
#replace with "*"
addiu $s0, $s0, -2
b mstr_over
mstr_slash:
li $t0, '/'
bne $t0, $v0, mstr_over

lw $a0, 0($sp)
lw $a1, 8($sp)
lw $a2, 12($sp)
li $a3, '.'
jal set_cell
#replace with "."

mstr_over:
lw $a2, 4($sp)
sb $s0, 2($a2) #player health


player_check:
#set and check players health
bgtz $s0, player_check_over

lw $t0, 4($sp)

lw $a0, 0($sp)
lb $a1, 0($t0)
lb $a2, 1($t0)
li $a3, 'X'
jal set_cell


#
# sw $a0, 0($sp)
#
# lb $a1, 0($a2) #row
# lb $a2, 1($a2) #col
# li $a3, 'X'

player_check_over:

lw $ra, 16($sp)
lw $s0, 20($sp)
addiu $sp, $sp, 24


jr $ra


# Part VIII
monster_attacks:
addiu $sp, $sp, -20
sw $a0, 0($sp)
sw $ra, 4($sp)
sw $s0, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)

lb $s0, 0($a1) #row
lb $s1, 1($a1) #col


li $s2, 0

lw $a0, 0($sp)
move $a1, $s0
addi $a2 , $s1, -1
jal get_cell
move $a0, $v0
jal get_dmg
addu $s2, $s2, $v0

lw $a0, 0($sp)
move $a1, $s0
addiu $a2 , $s1, 1
jal get_cell
move $a0, $v0
jal get_dmg
addu $s2, $s2, $v0

lw $a0, 0($sp)
move $a2, $s1
addiu $a1 , $s0, -1
jal get_cell
move $a0, $v0
jal get_dmg
addu $s2, $s2, $v0

lw $a0, 0($sp)
move $a2, $s1
addiu $a1 , $s0, 1
jal get_cell
move $a0, $v0
jal get_dmg
addu $s2, $s2, $v0

move $v0, $s2

lw $ra, 4($sp)
lw $s0, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
addiu $sp, $sp, 20


jr $ra

get_dmg:
dmg_case_B:
li $t0, 'B'
bne $a0, $t0, dmg_case_m
li $v0, 2
b dmg_case_over
dmg_case_m:
li $t0, 'm'
bne $a0, $t0, dmg_case_other
li $v0, 1
b dmg_case_over
dmg_case_other:
li $v0, 0
dmg_case_over:
jr $ra

# Part IX
player_move:
addiu $sp, $sp, -32
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)
sw $s5 20($sp)
sw $s6, 24($sp)
sw $ra, 28($sp)

move $s0, $a0 #map
move $s1, $a1 #player
move $s2, $a2 #row
move $s3, $a3 #col

lb $s5, 0($s1)
lb $s6, 1($s1)

move $a0, $s0
move $a1, $s1
jal monster_attacks

#subtract $v0 from the players health


lb $t0, 2($s1) #health
sub $t0, $t0, $v0
sb $t0, 2($s1) #health

#health <= 0
bgtz $t0, health_check_over
move $a0, $s0
lb $a1, 0($s1)
lb $a2, 1($s1)
li $a3, 'X'
jal set_cell

li $v0, 0
b player_move_over
health_check_over:

move $t0, $s1
sb $s2, 0($t0)
sb $s3, 1($t0)


######
move $a0, $s0
lb $a1, 0($s1)
lb $a2, 1($s1)
jal get_cell
move $a0, $v0
######
#'.'
move_case_dt:
######
move $a0, $s0
lb $a1, 0($s1)
lb $a2, 1($s1)
jal get_cell
move $a0, $v0
######



li $t0, '.'
bne $t0, $a0, move_case_dllr

move $a0, $s0
# lb $a1, 0($s1)
# lb $a2, 1($s1)
move $a1, $s5
move $a2, $s6
li $a3, '.'

jal set_cell

move $a0, $s0
move $a1, $s2
move $a2, $s3
li $a3, '@'
jal set_cell



li $v0, 0
b player_move_over

#'$'
move_case_dllr:
######
move $a0, $s0
lb $a1, 0($s1)
lb $a2, 1($s1)
jal get_cell
move $a0, $v0
######



li $t0, '$'
bne $t0, $a0, move_case_str

move $a0, $s0
# lb $a1, 0($s1)
# lb $a2, 1($s1)
move $a1, $s5
move $a2, $s6
li $a3, '.'
jal set_cell


move $a0, $s0
move $a1, $s2
move $a2, $s3
li $a3, '@'
jal set_cell


li $v0, 0
b player_move_over

#'*'
move_case_str:
######
move $a0, $s0
lb $a1, 0($s1)
lb $a2, 1($s1)
jal get_cell
move $a0, $v0
######


li $t0, '*'
bne $t0, $a0, move_case_door

move $a0, $s0
# lb $a1, 0($s1)
# lb $a2, 1($s1)
move $a1, $s5
move $a2, $s6
li $a3, '.'
jal set_cell

move $a0, $s0
move $a1, $s2
move $a2, $s3
li $a3, '@'
jal set_cell

li $v0, 0
b player_move_over
#'>'
move_case_door:
######
move $a0, $s0
lb $a1, 0($s1)
lb $a2, 1($s1)
jal get_cell
move $a0, $v0
######


li $t0, '>'
bne $t0, $a0, player_move_over

move $a0, $s0
# lb $a1, 0($s1)
# lb $a2, 1($s1)
move $a1, $s5
move $a2, $s6
li $a3, '.'
jal set_cell

move $a0, $s0
move $a1, $s2
move $a2, $s3
li $a3, '@'
jal set_cell


li $v0, -1
player_move_over:

lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
lw $s5 20($sp)
lw $s6, 24($sp)
lw $ra, 28($sp)
addiu $sp, $sp, 32

jr $ra


# Part X
player_turn:

addiu $sp, $sp, -24
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)
sw $ra, 20($sp)



move $s0, $a0 #map
move $s1, $a1 #player
move $s2, $a2 #dir

lb $t1, 0($s1)
li $t2, 0 #temp
li $t0, 'U'
addiu $t2, $t1, -1
beq $t0, $a2, dir_match_row
li $t2, 0 #temp
li $t0, 'D'
addiu $t2, $t1, 1
beq $t0, $a2, dir_match_row
li $t2, 0 #temp

lb $t1, 1($s1)

li $t0, 'L'
addiu $t2, $t1, -1
beq $t0, $a2, dir_match_col
li $t2, 0 #temp
li $t0, 'R'
addiu $t2, $t1, 1
beq $t0, $a2, dir_match_col
li $t2, 0 #temp
li $v0, -1
b player_turn_over

dir_match_row:
# sb $t2, 0($s1)
#
# move $a1, $t2
# lb $a1, 1($s1)


lb $a2, 1($s1)
move $a1, $t2

b dir_match_over
dir_match_col:
# sb $t2, 1($s1)
#
# lb $a1, 0($s1)
# move $a2, $t2


lb $a1, 0($s1)
move $a2, $t2
dir_match_over:


move $s3, $a1
move $s4, $a2
check_valid:
#$a0 is map
#row
#col
jal is_valid_cell
bltz $v0 ld_zero
b get_attk_cell
ld_zero:
li $v0, 0
b player_turn_over
get_attk_cell:
move $a0, $s0
move $a1, $s3
move $a2, $s4
jal get_cell
move $t0, $v0
li $v0, 0
li $t1, 0x23 # #
beq $t0, $t1, player_turn_over
#assuming valid attack target?

move $a0, $s0
move $a1, $s1
move $a2, $s2
jal get_attack_target
bltz $v0, not_attkble

is_attkble:
###
move $a0, $s0
move $a1, $s1
move $a2, $s3
move $a3, $s4
jal complete_attack
li $v0, 0
b player_turn_over

not_attkble:
#load args into player move
move $a0, $s0
move $a1, $s1
move $a2, $s3
move $a3, $s4
jal player_move

# jal player_turn
b player_turn_over

player_turn_over:

lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
lw $ra, 20($sp)
addiu $sp, $sp, 24


jr $ra


# Part XI
flood_fill_reveal:
li $v0, -200
li $v1, -200
jr $ra

#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################
