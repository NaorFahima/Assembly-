# Computer Architecture  q3.s
#	 
# Input: array of 10 bytes that represent sign numbers  
#.
# Output: 1)the sum of the 10 numbers (to the screen)
#	2)copy the diffrence of eace pair in array into array1
#	
#
## for example 
# for the array: 23,-2,45,67,89,12,-100,0,120,6
#  the sum is 260 
#  and array1: 25,-47,-22,-22, 77, 112,-100,-120,114
# in mem you sould get
#  

################# Data segment #####################
.data
array: 	.byte   23,-2,45,67,89,12,-100,0,120,6
array1:	.space  9
enter:	.asciiz "\n"			
msg1:   .asciiz "\n The sum of the numbers in the array is :"

# 
#
################# Code segment #####################
.text
.globl main
main:	# main program entry

    # print input msg syscall 4
	la $a0,msg1	# The sum of the numbers in the array is :
	li $v0,4		# system call to print
	syscall		# out a string 
#answer
	addi $t1,$t1,9
	addi $t2,$t2,8
loop:	
	lb $t0,array($t1)   #$t1 counter
	lb $t8,array($t2)	#$t2 counter
	
	sub $s1,$t8,$t0
	sb $s1,array1($t1)
	
	subi $t1,$t1,1
	subi $t2,$t2,1
	add $s0,$t0,$s0
	bne $t1,-1,loop
	
	li $v0,1
	move $a0,$s0
	syscall

# end of program
exit:	
	li $v0,10
	syscall
	
