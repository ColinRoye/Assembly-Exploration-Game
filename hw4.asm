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
addiu $sp, $sp, -12
sw $a0, 0($sp) #mf
sw $a1, 4($sp) #mp
sw $a2, 8($sp) #pp

lw $a0, 0($sp)
li $a1, 0
li $a2, 0

li $v0, 13
syscall

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


lb $t0, 0($s1)
lb $t1, 1($s1)
addiu $t0, $t0, -0x30
li $t2, 10
mul $t0, $t0, $t2
addiu $t1, $t1, -0x30
addu $t0, $t0, $t1
#convert first 2 bytes to  an int
lw $a0, 4($sp)
sb $t0, 0($a0)

lb $t0, 3($s1)
lb $t1, 4($s1)
addiu $t0, $t0, -0x30
li $t2, 10
mul $t0, $t0, $t2
addiu $t1, $t1, -0x30
addu $t0, $t0, $t1

lw $a0, 4($sp)
sb $t0, 1($a0)

sb $t0, 1($a0)
sb $t1, 0($a0)

mul $t0, $t0, $t1 #len arr
#loop to load in 2d arr ignoring newlines
li $t2, '\n'
loop_init_map:
beqz $t0, loop_init_map_over
beq $t1, $t2, loop_init_map #read in new char
addiu $t0, $t0, -1
b loop_init_map
loop_init_map_over:
syscall
li $v0, 10
syscall

lw $a0, 0($sp)
lw $a1, 4($sp)
lw $a2, 8($sp)
addiu $sp, $sp, 12
#close and save s reg
jr $ra


# Part II
is_valid_cell:
li $v0, -200
li $v1, -200
jr $ra


# Part III
get_cell:
li $v0, -200
li $v1, -200
jr $ra


# Part IV
set_cell:
li $v0, -200
li $v1, -200
jr $ra

##finished line!

# Part V
reveal_area:
li $v0, -200
li $v1, -200
jr $ra

# Part VI
get_attack_target:
li $v0, -200
li $v1, -200
jr $ra


# Part VII
monster_attacks:
li $v0, -200
li $v1, -200
jr $ra


# Part VIII
player_move:
li $v0, -200
li $v1, -200
jr $ra


# Part IX
complete_attack:
li $v0, -200
li $v1, -200
jr $ra


# Part X
player_turn:
li $v0, -200
li $v1, -200
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
