.data
Z: .word 0 #int Z = 0
A: .word 15 #int A = 10
B: .word 15 #int B = 15
C: .word 10 #int C = 6
.text
main:
	#load variables
	lw a1, A 
	lw a2, B
	lw a3, C
	lw a4, Z
	
	#if(A < B && C > 5)
	slt t1,a1,a2
	addi t2,zero,5
	slt t3,t2,a3
	
	addi t4,zero,2
	add t1,t1,t3 #t1 will be 2 if both A<B and C>5 is true)
	beq t1,t4, IF_1 #branch to IF_1 if t1 is 2
	
	#if( A > B || ((C+1) == 7))
	slt t1,a1,a2 #t1 = a>b
	bne t1,zero,IF_2 #branch to IF_2 if true
	addi t2,zero,7 #t2=7
	addi t3,a3,1 #t3 = C+1
	beq t3,t2,IF_2 #branch to IF_2 if true
	
	#else
	j IF_3 #jump to IF_3
	 
	
	
	IF_1:
		addi a4, zero, 1 #Z=1
		j case
	IF_2:
		addi a4, zero, 2 #Z=2
		j case
	IF_3:
		addi a4, zero, 3 #Z=3
		j case
	
	case: 
		addi t1, zero, 1
  		addi t2, zero, 2
  		addi t3, zero, 3
  		
  		beq a4, t1, case1 #branch to case1 if Z = 1
  		beq a4, t2, case2 #branch to case1 if Z = 2
  		beq a4, t3, case3 #branch to case1 if Z = 3
  		add a4, zero, zero #default Z = 0
  		
  	case1:
   		addi a4, zero, -1 
   		j result
	case2:
   		addi a4, zero, -2
   		j result
	case3:
   		addi a4, zero, -3
   		j result

	result:
 		sw a1, A, s2 
 		sw a2, C, s3   
 		sw a3, B, s4  
 		sw a4, Z, s5  
 