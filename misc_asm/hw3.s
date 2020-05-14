   
   
   @@ infocenter.arm.com
   @@ arm arch. ref manual
   @@ 
   @@ nov 18 - arm code done, cpi & clock times
   @@        -
   @@ 
   @@ nov 25 - meet with TA to resolve issues
   @@        -
   @@ 
   @@ dec 2 - finsh report and turn in
   @@       - schedule time to show the TA
   @@ 
   @@ 
   @@ 
   
   .text
    .global _start

_start:
@ x0 - x7: args / rets
@ x8: indirect rets location register 
@ x9 - x15: temps

ldr r8, =CORDIC_N   
ldr r0, [r8]         @ elements in Alpha
@mov r0, #11         @ elements in Alpha
mov r1, #0         @ for loop counter
@ldr r1, =CORDIC_i         @ for loop counter

for_1:
    cmp r1, r0
    bgt exit_for
   
   
if_1:
    ldr r8, =CORDIC_curr    @ get address of the current angle
    ldr r2, [r8]            @ get the current angle
    
    cmp r2, #0              @ compare current angle 
                            
    blt else_1              @ branch is less than 
    
    @@ TO DO...
    @@ Code to calculate newX when
    @@  current angle > 0:
    @@  
    @@   // Ki*[xi - yi * di * 2^-i]

    @@DEMO...
    @@ how to load, change and store a memory variable  
    ldr r8, =CORDIC_newX    @load addreess
    ldr r3, [r8]            @get val from address
    add r3, r3, #1          @edit value
    str r3, [r8]            @store in var at this address
    
    @@  CORDIC_newX = CORDIC_X - (CORDIC_Y >> CORDIC_i);
    @@  CORDIC_Y += (CORDIC_X >> CORDIC_i);
    @@  CORDIC_X = CORDIC_newX;
    @@  CORDIC_curr -= Alpha[CORDIC_i];
    @@
    
    @@ Then skip over the else_1 section
    b skip_else_1       @if we exe. the if, skip the else part
    
else_1:
    @@ Code to calculate newX when 
    @@  the current angle is <0
    @@  
    @@  CORDIC_newX = CORDIC_X + (CORDIC_Y >> CORDIC_i);
    @@  CORDIC_Y -= (CORDIC_X >> CORDIC_i);
    @@  CORDIC_X = CORDIC_newX;
    @@  CORDIC_curr += Alpha[CORDIC_i];
    @@  
    
skip_else_1:
    @@ Repeat for loop by checking CORDIC_i against CORDIC_N (=12)
    @@  and jump to the top of the for loop, otherwise store current 

    add r1, r1, #1      @ inc loop ctr by 1
    b for_1             @ jump back to begining
    
exit_for:    
    @@ move CORDIC_curr into CORDIC_ret
    
    
    .data

CORDIC_ALPHA:   .word 2949120, 1740963, 919876, 466945, 234378, 117303, 58666, 29334, 14667, 7333, 3666, 1833
@ Number of elements in Alpha table (0-11)
CORDIC_N:  .word 11
@ Index of current element in Alpha
CORDIC_i:  .word 0
@ ki constant
CORDIC_AG:  .word 39797



@ Returns the answer 
CORDIC_ret:  .word 0
@ Maintains the currnet angle 
CORDIC_curr:  .word 0



@ Stores current value for X component
CORDIC_X:  .word 0
@ Stores current value for Y component
CORDIC_Y:  .word 0


@ Stores next value for X component
CORDIC_newX:  .word 0





@gp 64 bit registers: x0 to x30
@gp 32 bit registers: w0 to w30

 
@slide 10 is register use 
@slide 15 is addi 
@slide 34 is compiling if stmt 
 
 
 
 .end
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
