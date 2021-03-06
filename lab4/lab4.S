.global lab4
.syntax unified

#define X1 #-17
#define X2 #12
#define X3 #17
#define X4 #3

lab4:
	push {lr}
	bl task1
	bl task2
	pop {pc}

task1:
	push {lr}
	mov r0, X1
	mov r1, #0xFFFFFFFF

	mov r2, X2
	mov r3, #0

	mov r4, X3
	mov r5, #0

	mov r6, X4
	mov r7, #0

	// Calculation start
	adds r0, r2
	adc r1, r3

	subs r0, #1
	sbc r1, #0
	
	lsls r0, #1	//	*2
	lsl r1, #1
	adc r1, #0
	

	lsls r0, #1	//	*4
	lsl r1, #1
	adc r1, #0


	lsls r0, #1	//	*8
	lsl r1, #1
	adc r1, #0


	lsls r0, #1	//	*16
	lsl r1, #1
	adc r1, #0



	sub r4, r6	//	(x3-x4)/2 start
	sub r5, r7
	lsrs r4, 1
	bcc branch5
	rrx r5, r5
	b branch6
branch5:
	asr r5, #1
branch6:

	and r0, r4
	and r1, r5

	
	bl check_result
	pop {pc}
	


// Result correction
check_result:
	push {lr}
	bvc step2
	lsrs r0, #1
	rrx r1, r1
step2:
	orrs r0, #0	// Update flag reg
	bne step4

	mov r0, #0b1111110111000
	lsl r0, #19
step4:
	mov r8, #0b1111110111000
	adds r1, r8

// step 5
	and r9, r1, #0x80000000
	beq marker1
	and r9, r1, #0x40000000
	beq normalize
	b step7

marker1:
	and r1, r1, #0x40000000
	beq step7
	
normalize:
	lsrs r0, #1
	rrx r1, r1
step7:
	bvs end_check_result
	lsrs r0, #1
	rrx r1, r1

end_check_result:
	pop {pc}

task2:
	push {lr}

	// Init regs
	mov r0, #2
	mov r1, #3
	mov r2, #4

prog_a:
	add r0, r1
	add r0, r2
	
l3:
	movs r0, #0
	
	bne l1
	bl prog_b
	mov r0, #1
	lsrs r0, #1

	b l2
l1:
	mov r0, #1
	lsrs r0, #1
l2:
	bcc l3
	orr r0, r1
	pop {pc}

prog_b:
	push {lr}
l5:
	sub r2, #1
	bl prog_c
	bmi l4
	movs r1, #0
l4:
	bne l5

	add r0, r1
	and r1, r2
	pop {pc}

prog_c:
	push {lr}
	mov r0, #5
	movs r2, #255
	pop {pc}

