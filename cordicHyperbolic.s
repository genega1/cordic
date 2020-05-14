   
   .text
    .global _start

_start:

@r0 = 11  (elements in Alpha - 1)
@r1       is foor loop counter
@r2       is the current angle being processed


@r3       X
@r4       Y
@r5       T
@r6  scratch register

@r8       register for accessing addresses


NEG_EXP:


mov r1, #0         @ for loop counter

ldr r8, =EXP_input       @load address
ldr r3, [r8]            @get val from address

mov r4, #1           @Y = 1
mov r6, #16
lsl r4, r4, r6

ldr r8, =NEG_EXP_ALPHA      @load address




for_1:
    cmp r1, #3
    bgt for_2    @ if (i > 3) break;

    
    
    ldr r6, [r8]              @NEG_EXP_ALPHA[i]

    sub r5, r3, r6    @ t = x - NEG_EXP_ALPHA[i]


    if_1:

    	cmp r5, #0 		@if(t>=0)
    	blt exit_if_1

    	mov r3, r5 	@x=t

    	mov r6, #1
    	mov r7, #3
    	sub r7, r7, r1
    	lsl r7, r6, r7
    	lsr r4, r4, r7  @ y <<= 2^(3 - i)


    exit_if_1:

    add r1, r1, #1
    add r8, r8, #4

    b for_1

for_2:
	cmp r1, #10
	bgt exit_loop


    ldr r6, [r8]              @NEG_EXP_ALPHA[i]

    sub r5, r3, r6    @ t = x - NEG_EXP_ALPHA[i]

    if_2:

    	cmp r5, #0 		@if(t>=0)
    	blt exit_if_2

    	mov r3, r5 	@x=t

    	
    	sub r7, r1, #2  @ i-2
    	asr r7, r4, r7  @ y >> i-2
    	sub r4, r4, r7  @ y= y - y>> i-2

    exit_if_2:

    add r1, r1, #1
    add r8, r8, #4

    b for_2



for_3:
cmp r1, #19
bgt exit_loop



if_3:
    and r6, r3, r0
    cmp r6, #0 		@if(x & 0x100/2^i)
    beq exit_if_3

    

    	
    sub r7, r1, #3  @ i-3
    asr r7, r4, r7  @ y >>= i-3
    add r4, r4, r7  @ y= y+ y>>= i-3

exit_if_3:

add r1, r1, #1
asr r0, r0, #1

b for_3

exit_loop:

    @@ store output into memory

    ldr r8, =NEG_EXP_Y       @load address
    str r4, [r8]            @get val from address

    ldr r8, =NEG_EXP_ret       @load address
    str r3, [r8]            @get val from address

    ldr r8, =NEG_EXP_T      @load address
    str r5, [r8]             @store final angle into mem

    mov r9, r4              @save Y for hyperbolic calc





    
    


 
 






EXP:
    mov r0, #256       		@ counter used near end
	mov r1, #0         		@ for loop counter

	ldr r8, =EXP_input      	@ load address
	ldr r3, [r8]            	@ get val from address

	mov r4, #1           		@ Y = 1
	mov r6, #16
	lsl r4, r4, r6			@ initializing Y to 1 in 16.16

	ldr r8, =EXP_ALPHA      	@ load address

@@ for i = 0; i <= 3; i++
@@ subtract from x the biggest k in the above table that we can without sending x negative
for_1x:
	cmp r1, #3
    	bgt for_2x
    
    	ldr r6, [r8]        		@ EXP_ALPHA[i]

    	sub r5, r3, r6    		@ t = x - EXP_ALPHA[i]

    	if_1x:

    		cmp r5, #0 		@if(t>=0), 
    		blt exit_if_1x		@ x cannot become a negative value, so t cannot be negative

    		mov r3, r5 		@ x=t

    		mov r6, #1
    		mov r7, #3
    		sub r7, r7, r1		
    		lsl r7, r6, r7		
    		lsl r4, r4, r7  	@ y <<= 2^(3 - i)

    	exit_if_1x:

    		add r1, r1, #1		@ increment loop counter
    		add r8, r8, #4		@ move to next address in EXP_ALPHA

    		b for_1x		@ next loop iteration

for_2x:
	cmp r1, #10
	bgt for_3x

    	ldr r6, [r8]   			@ EXP_ALPHA[i]

    	sub r5, r3, r6    		@ t = x - EXP_ALPHA[i]

    	if_2x:

    		cmp r5, #0 		@if(t>=0)
    		blt exit_if_2x

    		mov r3, r5 		@x=t
   	
    		sub r7, r1, #3  	@ i-3
    		asr r7, r4, r7  	@ y >>= i-3
    		add r4, r4, r7  	@ y= y+ y>>= i-3

    	exit_if_2x:

    		add r1, r1, #1
    		add r8, r8, #4

    		b for_2x

for_3x:
	cmp r1, #19
	bgt exit_loopx

	if_3x:
    		and r6, r3, r0
    		cmp r6, #0 			@ if(x & 0x100/2^i)
    		beq exit_if_3x
   	
    		sub r7, r1, #3  		@ i-3
    		asr r7, r4, r7  		@ y >>= i-3
    		add r4, r4, r7  		@ y= y+ y>>= i-3

	exit_if_3x:

		add r1, r1, #1
		asr r0, r0, #1

		b for_3x

@@ store output into memory
exit_loopx:

	ldr r8, =EXP_Y       		@ load address
    	str r4, [r8]            	@ get val from address

    	ldr r8, =EXP_ret       		@ load address
    	str r3, [r8]            	@ get val from address

    	ldr r8, =EXP_T      		@ load address
    	str r5, [r8]            	@ store final angle into mem


    mov r7, #1
    add r3, r4, r9
    asr r3, r3, r7

	ldr r8, =COS_H       		@ load address
    str r3, [r8]            	@ get val from address

        mov r7, #1
    sub r3, r4, r9
    asr r3, r3, r7

    ldr r8, =SIN_H      		@ load address
    str r3, [r8]            	@ get val from address

   

    
.data





NEG_EXP_ALPHA:	.word 363410, 181705, 90852, 45423, 18848, 8749, 4227, 2077, 1028, 511, 255

EXP_ALPHA: .word 363410, 181705, 90852, 45423, 26573, 14624, 7719, 3973, 2017, 1016, 510



@ value of the final angle 
NEG_EXP_ret:  .word 0

@ stores calculated value e^x
NEG_EXP_Y:  .word 0  

@ final value of T
NEG_EXP_T:  .word 0  

EXP_ret:   .word 0			@ value of the final angle

EXP_input: .word 0x10000 		@ angle given to compute e^x, e^-x, cosh, sinh

EXP_Y:     .word 0  			@ stores calculated value e^x

EXP_T:     .word 0			@ final value of T   

COS_H:	.word 0		@hyperbolic cosine of x

SIN_H:	.word 0		@hyperbolic sine of x

.end