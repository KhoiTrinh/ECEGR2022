.data
varZ: .word 0
.text
main:
	addi a0, x0, 15 #A = 15
	addi a1, x0, 10 #B = 10
	addi a2, x0, 5  #C = 5
	addi a3, x0, 2  #D = 2
	addi a4, x0, 18 #E = 18
	addi a5, x0, -3 #F = -3
	
	sub t0, a0, a1 # A-B
	mul t1, a2, a3 # C*D
	sub t2, a4, a5 # E-F
	div t3, a0, a2 # A/C
	
	add t4, t0, t1  # (A-B) + (C*D)	
	add t4, t4, t2 # ((A-B) + (C*D)) + (E-F)
	sub t4, t4, t3 # (((A-B) + (C*D)) + (E-F)) - (A/C)
	
	sw t4, varZ, t6
	