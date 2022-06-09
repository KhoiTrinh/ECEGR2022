.data
A:	.space 20 # int A[5];
B:	.word 1, 2, 4, 8, 16 # int B[5] = {1,2,4,8,16};
.text

main:
	add	t0, zero, zero	# int i = 0 (t0 is i)
	addi	t1, zero, 5
	
	#load addresses of A[0] and B[0]
	la	a1, A		
	la	a2, B		
	
	For:
		bge 	t0, t1, loop1	# branch if i >= 5
		slli	t3, t0, 2	# t3 = i * 4
		add	t2, t3, a2	# store address of B[i] in t2
		lw	t2, (t2)	# Load VALUE from ADDRESS t2
		addi	t2, t2, -1	# t2 = B[i] - 1
	
		add	t4, t3, a1	# store address of A[i] in t4
		sw	t2, (t4)	# A[i] = B[i] - 1
		addi	t0, t0, 1	# i++
		j	For

	loop1:
		addi	t0, t0, -1	# i--
		slt   	t6,t0,zero      # if i<0
		bne	t6,zero,Exit	# brach to Exit if i<0
		slli	t3, t0, 2	# t3 = i * 4
	
		add	t2, t3, a2	# t2 = &B[i]
		lw	t2, (t2)	# t2 = B[i]
	
		add	t4, t3, a1	# t4 = &A[i]
		lw	t1, (t4)	# t1 = A[i]
	
		add	t2, t2, t1	# t2 = A[i] + B[i]
		add	t2, t2, t2	# t2 *= 2
	
		sw 	t2, (t4)
		j	loop1
	Exit: