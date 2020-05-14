  .text
  .global _start

_start:
                            @ for (i = 0;  i < 12; i++)
  mov r0, #11               @ store 11 in r1
  mov r1, #0                @ initialize i to zero
  

forloop:  cmp r1, r0        @ compare i to 11
          bge exit          @ exit if i is equal to 11
          add r1, r1, #1    @ increment i by 1
          b forloop         @ return to forloop is i less than 12
exit:

  .data
 
  .end
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
