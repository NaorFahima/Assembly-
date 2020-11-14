# Computer Architecture
#Question 1:        	
# Input: 1)in buf (in the data segment) string of exactly 10 chars  
#        
# 
# Output:     1)swap each pair chars in the string
#	    (if the pair identical change the second to '*' )
#		2)print buf in reverse
##
## 
# Example
# buf=		 "aabb456788"
#
#After swap buf= "a*b*54768*

#
# in reverse  = "*86745*b*a"

################# Data segment #####################
.data
buf:    .ascii "aabb456788"	
enter: .ascii "\n"



################# Code segment #####################
.text
.globl main
main:	# main program entry

#answer

	#addi $t0,$t0,10 # $t0 counter
	addi $s0,$s0,0x2a # $s0 = '*'
	addi $t9,$t9,0x1 # mask 
	
loop:	
	lb $t1,buf($t0)
	addi $t0,$t0,1
	lb $t2,buf($t0)
	bne $t1,$t2,loop
	
	sb $s0,buf($t0)
	addi $t0,$t0,1
	bne $t0,10,loop
		
	li $v0,4
	la $a0,buf
	syscall
	
	li $v0,4
	la $a0,enter
	syscall
	
	addi $t9,$zero,10
loop1:	
	lb $a0,buf($t9)
	subi $t9,$t9,1
	li $v0,11
	syscall
	bne $t9,-1,loop1

	
# end of program
exit:	
	li $v0,10
	syscall
