# Computer Architecture
#Question 2:        	
# 
## 
# Example 
# buf=		 "helloworlddlrowolleh"
#output:  0 ( palindrome ) as a result  buf is cleared from mem

################# Data segment #####################
.data
buf:    .ascii "helloworlddlrowolleh"	




################# Code segment #####################
.text
.globl main
main:	# main program entry

#answer
	addi $t0,$t0,19  # $t0 counter start from end
	                 # $t1 counter start from beginning
loop:
	lb $t2,buf($t0)
	lb $t3,buf($t1)
	subi $t0,$t0,1
	addi $t1,$t1,1
	bne $t2,$t3,charNotEquals
	beq $t1,10,checkIfPolidrom
	j loop
charNotEquals:
	addi $t9,$t9,1
	beq $t1,10,checkIfPolidrom
	j loop
	
	
	
checkIfPolidrom:	
	bne $t9,$zero,exit
	addi $t0,$t0,20
loop1:
	sb $zero,buf($t0)
	subi $t0,$t0,1
	beq $t0,$zero,exit
	j loop1
	
# end of program
exit:	
	li $v0,1
	move $a0,$t9
	syscall
	
	li $v0,10
	syscall


