@@Authors: Robert Genega, Mike Aebig, Dina Sagitova, Max Ricketts-Uy

@@ CORDIC TANGENT FUNCTION
   
.text
.global _start

@r0 = 11  (elements in Alpha - 1)
@r1       is foor loop counter
@r2       is the current angle being processed
@r3       current TAN value
@r4  scratch register
@r8       register for accessing addresses
@ x0 - x7: args / rets
@ x8: indirect rets location register 
@ x9 - x15: temps

_start:
   mov r3, #0                    @ TAN = 0 at start
   mov r0, #11                   @ elements in Alpha
   mov r1, #0                    @ for loop counter

   ldr r8, =CORDIC_input         @ get address of the input angle
   ldr r2, [r8]                  @ get the input angle

for_1:
   cmp r1, r0
   bgt exit_for
   
if_1:
    
   cmp r2, #0                    @ compare current angle                            
   bgt else_1                    @ branch is less than 

   mov r4, #65536
   asr r4, r4, r1                @(65536 >> i)
   sub r3, r3, r4

   ldr r8, =CORDIC_ALPHA         @ load address
   mov r4, #2
   lsl r4, r1, r4                @ maps index to byte offset
   add r8, r8, r4
   ldr r4, [r8]                  @ Alpha[i]

   add r2, r2, r4                @ CurrAngle += Alpha[i]

   @@ Then skip over the else_1 section
   
   b skip_else_1                 @ if we exe. the if, skip the else part
    
else_1:

   mov r4, #65536
   asr r4, r4, r1                @ (65536 >> i)
   add r3, r3, r4

   ldr r8, =CORDIC_ALPHA         @ load address
   mov r4, #2
   lsl r4, r1, r4                @ maps index to byte offset
   add r8, r8, r4
   ldr r4, [r8]                  @ Alpha[i]

   sub r2, r2, r4                @ CurrAngle -= Alpha[i]

@@ Repeat for loop by checking r1(loop counter) against r0 (N-1=11)
@@ and jump to the top of the for loop, otherwise store current 

skip_else_1:
   
   add r1, r1, #1                @ inc loop ctr by 1
   b for_1                       @ jump back to begining
   
@@ store output into memory
exit_for:    

   ldr r8, =CORDIC_TAN           @ load address
   str r3, [r8]                  @ store TAN into mem

   ldr r8, =CORDIC_ret           @ load address
   str r2, [r8]                  @ store final angle into mem
    
.data

   CORDIC_ALPHA: .word 2949120, 1740963, 919876, 466945, 234378, 117303, 58666, 29334, 14667, 7333, 3666, 1833
   
   CORDIC_N:     .word 11        @ Number of elements in Alpha table (0-11)

   CORDIC_TAN:   .word 0         @ computed tangent value

   CORDIC_ret:   .word 0         @ value of the final angle 

   CORDIC_input: .word 2949120   @ angle given to compute cos/sin/tan/e^x

.end
