.data
a:	.word 0 #int a=0
b:	.word 0 #int b=0
c:	.word 0 #int c=0
.text

main:
	lw a1, a
	lw a2, b
	lw a3, c
	
	
	addi t0, zero,5   #int i = 5 (t0 is i)
	addi t1, zero,10  #int j =10 (t1 is j)
	
	addi sp,sp, -8 # push stack down by 2 bytes
	
	#store value of stack pointer
	sw t0, 0(sp)
	sw t1, 4(sp)
	
	addi sp,sp,0 #change argument to i
	jal AddItUp #  AddItUp(i)
  	add a1, zero, a0 #  a=AddItUp( i )
  

  
  	addi sp, sp, 4  #change argument to j
  	jal AddItUp #  AddItUp(j)
  	add a2, zero, a0 #  b=AddItUp( j )
  
  	add a3, a2, a1 # c = a + b
  
  	#restore i and j values into t0 and t1

  	lw t0, -4(sp)
 
  	lw t1, 0(sp)
  
  	#store value of a,b,c in a1,a2,a3
  	sw a1, a, s2 
 	sw a2, b, s3 
 	sw a3, c, s4  
  
  	li a7, 10 #system exit 
  	ecall
  
	AddItUp:
  
  		add t1, zero, zero #x=0
  		add t0, zero, zero #i=0
  		j forLoop

	forLoop:
  		lw a6, 0(sp) #stores parameter into a6
  		bge t0, a6, Exit #check exit condition for loop
  
  		#for loop body
  		add t1, t1, t0 #x=x+i
  		addi t1, t1, 1 #x=x+i+1

  		addi t0, t0, 1 #increment i
  
  		j forLoop
  
	Exit:
  		add a0, t1, zero #set value of x 
  		jr ra #return to adress stored in ra
	
	
	
	