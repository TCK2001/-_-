text:
	.text
	.align 2
	.global main
main:
	@prologue
	stmfd	sp!, {r0-r10, fp, lr}		
	add	fp, sp, #4
	
	@code body
	sub sp, sp, #16
	str r0, [fp, #-8] 
    str r1, [fp, #-12]
    ldr r3, [fp, #-12]
    ldr r3, [r3,#4]
	mov r9, #0
	
distinguish:
	ldrb r7, [r3]			@check is N or not
	cmp r7, #'N'
	beq negative
	b positive
	@add r4, r4, #1
	
positive:
	ldr r0, =strpositive
	mov r1, r3
	bl printf
	b preturn
	
negative:
	mov r6, #'-'
	strb r6, [r3]
	ldr r0, =strnegative
	mov r1, r3
	bl printf
	
preturn:
	ldr r3, [fp, #-12]
	ldr r3, [r3, #4]		@1995
	ldrb r7, [r3]		
	cmp r7, #'-'
	beq nega
	
turn:
	ldr r0,[fp,#-12]
    ldr r0,[r0,#4]
    mov r2, #10
    bl strtol 		   		@string -> int
    str r0, [fp,#-16]
		
startloop:
	ldr r10, [fp, #-16]
	clz r7, r10  			@check left side amount of 0
	lsl r10, r10, r7 		@remove left side 0
	rsb r9, r7, #31 		
	add r9, r9, #127
	mov r9, r9, lsl #24
	mov r6, #9
	
exponential:
	mov r5, r9
	mov r5, r5, lsr #31		@look only one 0 or 1
	mov r5, r5, lsl #31		
	mov r3, r5				@give r3 to check
	mov r9, r9, lsl #1		@delete after print
	sub r6, r6, #1
	cmp r6, #0
	beq prefraction
	cmp r3, #0
	beq zero				@if 0 goto zero and print
	bne one					@if 1 goto one and print
	
fraction:
	mov r4, r10
	mov r4, r4, lsr #31
	mov r4, r4, lsl #31
	mov r3, r4
	mov r10, r10, lsl #1
	sub r6, r6, #1
	cmp r6, #0
	beq final
	cmp r3, #0
	beq zerofrac
	bne onefrac
	

final:
	sub	sp, fp, #4
	ldmfd	sp!, {r0-r10, fp, lr}
	bx	lr
		
nega:
	mov r6, #'0'		
	strb r6, [r3]
	b turn
	
prefraction:
	mov r10, r10, lsl #1
	mov r6, #24
	b fraction
	
zero:
	ldr r0, =digit;
	mov r1, #0
	bl printf
	b exponential
	
one:
	ldr r0, =digit
	mov r1, #1
	bl printf
	b exponential
	
zerofrac:
	ldr r0, =digit
	mov r1, #0
	bl printf
	b fraction
	
onefrac:
	ldr r0, =digit
	mov r1, #1
	bl printf
	b fraction

digit:
	.asciz "%d"
	
strnegative:
    .asciz "%s is code by 1"
	
strpositive:
    .asciz "%s is code by 0"
		
.end
