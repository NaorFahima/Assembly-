# Title: Excercise 4   	 Filename: 
# Author: Ram Fridman & Naor Fahima   ID:  203783907 & 315783563  Date: 25.8.2019
# Description: Manipulate numbers in matrix.
# Input: Keyboard
# Output: Console
################# Data segment #####################
.data
matrix: .byte 2,7,34,68,56,89,156,122,135,0,33,122,122,66,18,255
##menu##
msg1: .asciiz "The Options are: \n1. Print matrix unsigned \n2. Print matrix signed \n" 
msg2: .asciiz "3. Change a number in the matrix \n4. Negate a number in the matrix \n5. Swap numbers in the matrix \n"
msg3: .asciiz "6. Find the max sum of a row (Unsigned) \n7. Find the max sum of a row(Signed) \n8. END \n"
msg4: .asciiz "Number of row?"
msg5: .asciiz "Number of colum?"
msg6: .asciiz "You have to choose a number between 1-4"
msg7: .asciiz "What number you want to input?"
msg8: .asciiz "The number you selected is greater than the number of bits \n"
msg9: .asciiz "The first number:\n"
msg10: .asciiz "The secand number:\n"
space: .asciiz "  "
space1: .asciiz " "
enter: .asciiz "\n"
negative: .asciiz "-"

Jump_table:
	choose1: .word Print_unsigned
	choose2: .word Print_signed
	choose3: .word Change_number
	choose4: .word Negate
	choose5: .word Swap 
	#choose6: .word maxUnsign 	
	#choose7: .word maxSign 
	#choose8: .word ExitProgram
################# Register ########################
#Permanent:  $s0 = Address of Jump_table
#            $s1 = Number 127
#            $s2 = Number 256
#            $s3 = Number 10
#            $s4 = Number 100
#Temp:  $t0 = Number of matrix array
#       $t1 = Counter for the Address number	
#       $t3 = Result of slt	
#       $t4 = Number that the user choose	
#       $t5 = Address of the function
#       $t6 = Counter for loop
#       $t7 = Counter for enter
#       $t8 = Number of row the user choose
#       $t9 = Number of colum the user choose
################# Code segment #####################
.text

.globl main
main:	# main program entry

loopMenu:
 	li $v0, 4
	la $a0, enter
	syscall
 	jal Print_menu #Print the menu
 	
 	la $s0, Jump_table  #the Address of Jump_table in $s0
 	la $a2, matrix      #the Address of matrix in $a2 
 	li $v0, 5	#read integer to $a0 of the menu
 	syscall
 	
 	addi $s1,$zero,127    # $s1 = 127 
 	addi $s2,$zero,256    # $s2 = 256 
 	addi $s3,$zero,10     # $s3 = 10
 	addi $s4,$zero,100    # $s4 = 100
 	
 	move $t4, $v0       # in $t4 = the number that the user choose
 	
 	#####Calculates user selection and goes to function#####
 	subi $t4, $t4, 1
 	sll  $t4, $t4, 2
 	add  $t4,$t4 , $s0
 	lw   $t5,($t4)  # $t5 = Address of the function
 	#####
 	
	jalr $t5
 	
 	j loopMenu
ExitProgram:	
	li $v0, 10	# Exit program
	syscall

Print_menu:
	li $v0, 4
	la $a0, msg1
	syscall
	la $a0, msg2
	syscall
	la $a0, msg3	
	syscall

	jr $ra

Swap:
#save address for main pc+4
	sub $sp, $sp, 4
	sw $ra, 0($sp) 
###########################

#save address for Negate
	sub $sp, $sp, 4
	sw $ra, 0($sp) 
	
	li $v0, 4      	#print msg
	la $a0, msg9
	syscall
	jal Get_position
	move $t1,$t8

	li $v0, 4    	
	la $a0, msg10	#print msg
	syscall
	jal Get_position
	move $t2,$t8
	######Swep######
	lb $t3,matrix($t1)
	lb $t4,matrix($t2)
	sb $t3,matrix($t2)
	sb $t4,matrix($t1)
	#################
	
	jal Print_signed
	
##load address for main pc+4
	lw $ra, 0($sp)
	addi $sp, $sp, 4
###########################
	jr $ra

Negate: 
#save address for main pc+4
	sub $sp, $sp, 4
	sw $ra, 0($sp) 
###########################

#save address for Negate
	sub $sp, $sp, 4
	sw $ra, 0($sp) 
###########################
	jal Get_position
	lbu $t2,matrix($t8) # load number from matrix
	sub $t2,$t2,1	# Makes the complement method to 2
	xori $t2,$t2,0xff
	sb $t2,matrix($t8) # store number from matrix
	
	jal Print_signed
	
##load address for main pc+4
	lw $ra, 0($sp)
	addi $sp, $sp, 4
###########################
	jr $ra
	
	
	
	
##load address for main pc+4
	lw $ra, 0($sp)
	addi $sp, $sp, 4
###########################
	jr $ra
	
	
	
	
Change_number:
#save address for main pc+4
	sub $sp, $sp, 4
	sw $ra, 0($sp) 
###########################
	
	
#save address for Change_number
	sub $sp, $sp, 4
	sw $ra, 0($sp) 
###########################
	jal Get_position
	
	j readInteger
	
ErrerBigNumber:
	li $v0, 4      	#print msg
	la $a0, msg8
	syscall
readInteger:
	li $v0, 4      	#print msg
	la $a0, msg7
	syscall
	
	li $v0, 5	#read integer to $a0
 	syscall
 	
 	slt $t3,$v0,$s2	# if (number > 256 ) go to ErrerBigNumber
 	beq $t3,0,ErrerBigNumber
 	sb $v0,matrix($t8)
 	
	jal Print_signed
	
##load address for main pc+4
	lw $ra, 0($sp)
	addi $sp, $sp, 4
###########################
	jr $ra	
Get_position:	

loop1:
	li $v0, 4	#print massege
	la $a0, msg4
	syscall
	li $v0, 5	#read integer to $a0
 	syscall
 	slti $t3,$v0,5	#if (number > 5) go to ErrerMassege
 	beq $t3,0,ErrerMassege
 	move $t8,$v0
	la $a0, msg5	#print massege
	li $v0, 4
	syscall
	li $v0, 5	#read integer to $a0
 	syscall
 	slti $t3,$v0,5	#if (number > 5) go to ErrerMassege
 	beq  $t3,0,ErrerMassege
 	move $t9,$v0
	
	#####Calculates the location in matrix#####
	subi $t9,$t9,1
	subi $t8,$t8,1
	sll $t8,$t8,2
	add $t8,$t8,$t9
	###########################################
	jr $ra
	

ErrerMassege:	
	li $v0, 4	#print Errer massege
	la $a0,msg6
	syscall
	
	j loop1
	


Print_signed:
#save address for main pc+4
	sub $sp, $sp, 4
	sw $ra, 0($sp) 
###########################

	addi $a3, $zero , 2  #paramter for printing signed
	
	addi $t1, $zero, 0   ## counter for the Address number
	addi $t6, $zero, 16  ## counter for loop
	
	
#save address for Print_unsigned
	sub $sp, $sp, 4
	sw $ra, 0($sp) 
###########################
	jal resetEnterCounter




Print_unsigned:
#save address for main pc+4
	sub $sp, $sp, 4
	sw $ra, 0($sp) 
###########################

	addi $a3, $zero , 1   #paramter for printing unsigned
	

	addi $t1, $zero, 0   ## counter for the Address number
	addi $t6, $zero, 16  ## counter for loop

		
				
resetEnterCounter:	
	addi $t7,$zero,0 #setting enter counter
	li $v0, 4
	la $a0, enter
	syscall
	bne $t6, 0, nextNum
	j endLoop
nextNum:
	beq $a3, 2, nextNumSigned #checking if to print unsigned or signed
	lbu $t0 ,matrix($t1) ## loading one number from the array (byte) unsigned
	addi $t1,$t1,1      #adding 1 to get next byte
	j loop
	
nextNumSigned:
	lb $t0 ,matrix($t1) ## loading one number from the array (byte) signed
	addi $t1,$t1,1      #adding 1 to get next byte
loop:
	jal print_num 
	subi $t6,$t6,1 #substract 1 from the loop counter
	addi $t7,$t7,1 #adding 1 for the enter counter
	beq $t7,4,resetEnterCounter #checking if need to make an enter
	bne $t6,0,nextNum #checking if to go to next num
	
	
endLoop:	
##load address for main pc+4
	lw $ra, 0($sp)
	addi $sp, $sp, 4
###########################
	jr $ra	
			
print_num:
#save address for function print_num pc+4
	sub $sp, $sp, 4
	sw $ra, 0($sp)
##################################
	beq $a3, 1, unsigned
	beq $a3, 2, signed
	j exit
	
	signed:	
		slt $t3 ,$t0 ,$zero 
		beq $t3,0,unsignedEnter # if $t3 = 1 is possitive number
		
		slti $t3,$t0,-99
		beq $t3,0,printZero
		#printing the num without zero's
		li $v0,1
		add $a0, $zero, $t0
		syscall
		#########################
		##adding space
		li $v0,4
		la $a0 , space
		syscall
		#############
		
		j exit
		
	printZero:	slti $t3,$t0,-9
		beq $t3,0,printTwoZero
		##adding zero before the num
		li $v0,1
		add $a0, $zero, $zero
		syscall
		add $a0, $zero, $t0
		syscall
		########################
		##adding space
		li $v0,4
		la $a0 , space
		syscall
		##############
		j exit
	printTwoZero:
		li $v0,1  
		add $a0, $zero, $zero
		syscall
		add $a0, $zero, $zero
		syscall
		add $a0, $zero, $t0
		syscall
		###################################
		##print space
		li $v0,4
		la $a0 , space
		syscall
		#############
		j exit
		
		
	unsignedEnter:	##print space
		li $v0,4
		la $a0 , space1
		syscall
	
	unsigned:	
		
		slt $t3 ,$t0 ,$s3 #checking if the num is lower than 10
		bne $t3,1,biggerThan10 #if bigger go to biggerThan10
		##print zero's before the number < 10
		li $v0,1  
		add $a0, $zero, $zero
		syscall
		add $a0, $zero, $zero
		syscall
		add $a0, $zero, $t0
		syscall
		###################################
		##print space
		li $v0,4
		la $a0 , space
		syscall
		#############
		
		j exit

	biggerThan10:
		slt $t3 ,$t0 ,$s4	#checking if the num < 100
		bne $t3,1,biggerThan100 #if not go to 
		##adding zero before the num
		li $v0,1
		add $a0, $zero, $zero
		syscall
		add $a0, $zero, $t0
		syscall
		########################
		##adding space
		li $v0,4
		la $a0 , space
		syscall
		##############
		
		j exit
		
	biggerThan100: 
		#printing the num without zero's
		li $v0,1
		add $a0, $zero, $t0
		syscall
		#########################
		##adding space
		li $v0,4
		la $a0 , space
		syscall
		#############
exit:	

	##load address for function print_num pc+4
		lw $ra, 0($sp)
		addi $sp, $sp, 4
	##########################	
		jr $ra
