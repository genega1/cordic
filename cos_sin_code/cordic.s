@@Authors: Robert Genega, Mike Aebig, Dina Sagitova, Max Ricketts-Uy

@@ infocenter.arm.com
@@ arm arch. ref manual
@@gp 64 bit registers: x0 to x30
@@gp 32 bit registers: w0 to w30
@@slide 10 is register use 
@@slide 15 is addi 
@@slide 34 is compiling if stmt 
   
.text

.global _start

@r0 = 11    (elements in Alpha - 1)
@r1         is foor loop counter
@r2         CORDIC_input; the current angle being processed
@r3         CORDIC_COS
@r4         CORDIC_SIN
@r5         scratch register
@r8         register for accessing addresses

@ x0 - x7: args / rets
@ x8: indirect rets location register 
@ x9 - x15: temps

_start:
   mov r0, #11                  @ elements in Alpha
   mov r1, #0                   @ for loop counter ; " i " 

   ldr r8, =CORDIC_COS          @ load address
   ldr r3, [r8]                 @ get val from address

   mov r4, #0

   ldr r8, =CORDIC_input        @ get address of the input angle
   ldr r2, [r8]                 @ get the input angle

for_1:
   cmp r1, r0                   @ i < 11
   bgt exit_for
   
if_1:

   cmp r2, #0                   @ compare current angle 
                            
   bgt else_1                   @ branch is less than 

   asr r5, r4, r1               @ (Y >> i)
   add r5, r3, r5               @ NEWX = X + (Y >> i)
   asr r3, r3, r1               @ (X >> i)
   sub r4, r4, r3               @ Y -= (X >> i)

   mov r3, r5                   @ X = NEWX

   ldr r8, =CORDIC_ALPHA        @ load address
   mov r5, #2
   lsl r5, r1, r5               @ maps index to byte offset
   add r8, r8, r5               @ move r8 to index of next Alpha value         
   ldr r5, [r8]                 @ Alpha[i]

   add r2, r2, r5               @ CurrAngle += Alpha[i]

   @@ Then skip over the else_1 section
   b skip_else_1                @ if we exe. the if, skip the else part
    
else_1:

   asr r5, r4, r1               @ (Y >> i)
   sub r5, r3, r5               @ NEWX = X - (Y >> i)
   asr r3, r3, r1               @ (X >> i)
   add r4, r4, r3               @ Y += (X >> i)
   
   mov r3, r5                   @ X = NEWX

   ldr r8, =CORDIC_ALPHA        @ load address
   mov r5, #2
   lsl r5, r1, r5               @ maps index to byte offset
   add r8, r8, r5               @ move r8 to index of next Alpha value
   ldr r5, [r8]                 @ Alpha[i]

   sub r2, r2, r5               @ CurrAngle -= Alpha[i]
    
@@ Repeat for loop by checking r1(loop counter) against r0 (N-1=11)
@@  and jump to the top of the for loop, otherwise store current     
skip_else_1:
    
   add r1, r1, #1               @ inc loop ctr by 1
   b for_1                      @ jump back to begining
    
@@ store output into memory    
exit_for:    
    
   ldr r8, =CORDIC_COS          @ load address
   str r3, [r8]                 @ get val from address

   ldr r8, =CORDIC_SIN          @ load address
   str r4, [r8]                 @ get val from address

   ldr r8, =CORDIC_ret          @ load address
   str r2, [r8]                 @ store final angle into mem
    
.data

CORDIC_ALPHA: .word 2949120, 1740963, 919876, 466945, 234378, 117303, 58666, 29334, 14667, 7333, 3666, 1833

CORDIC_N:     .word 11          @ Number of elements in Alpha table (0-11)

CORDIC_ret:   .word 0           @ value of the final angle 

CORDIC_input: .word 2949120     @ angle given to compute cos/sin/tan/e^x  

CORDIC_COS:   .word 39797       @ki * 1; @ final value for COSINE

CORDIC_SIN:   .word 0           @  final value for SINE 
 
.end
