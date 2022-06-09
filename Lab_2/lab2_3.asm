.data
Z: .word 2 #int Z = 2
i: .word 0 #int i = 0
.text

main:
	#load variables
	lw a1, Z
	lw a2, i
	
	For:
		slti t1, a2, 21 # t1 = i<21
		beq t1, zero, Do #if wrong, branch to Do
		addi a1,a1,1 #Z++
		addi a2,a2,2 #i+2
		j For
	
	Do:
		addi a1,a1,1 #Z++
		addi t1,zero,100
		slt t3,t1,a1 #if Z > 100
		bne t3,zero,Do2 #if true branch to Do2
		j Do
		
	Do2:
		slt t4,zero,a2 #i>0
		beq t4, zero, Exit #if wrong branch to Exit
		addi a1,a1,-1 #Z =-1
		addi a2,a2,-1 #i=-1
		j Do2
	Exit:
		sw a1,Z, s2 #store Z in a1
		sw a2,i, s3 #store i in a2
		
		