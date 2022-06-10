.data 
prompt: .asciz "Enter Fahrenhiet: "
fahrenheit: .float  100.0
const32: .float 32.0
const5: .float 5.0
const9: .float 9.0
const273: .float 273.15
printC: .asciz "Celcius: "
printK: .asciz "Kelvin: "
newln: .asciz "\r\n"

.text 
main:
	li a7,4
	la a0, prompt
	ecall
	li a7,6
	ecall
	fmv.s f0,fa0
	
	flw f1, const32, t0
	flw f2, const5, t0
	flw f3, const9, t0
	flw f9, const273, t0
	
	jal celsius
	jal kelvin
	
	j exit

celsius:
	fsub.s f6, f0, f1	#fahrenhiet -32
	fdiv.s f7, f2,f3	# 5/9
	fmul.s f10,f6,f7		# gives celsius
	ret
	
kelvin:
	fadd.s f11, f10, f9
	ret
	
exit: 
	li a7, 4
	la a0, printC
	ecall
	li a7,2
	ecall
	
	li a7,4
	la a0,newln
	ecall
	
	li a7,4
	la a0,printK
	ecall
	
	fmv.s fa0,fa1
	li a7,2
	ecall	