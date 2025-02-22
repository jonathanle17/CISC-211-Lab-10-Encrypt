/*** asmEncrypt.s   ***/

#include <xc.h>

# Declare the following to be in data memory 
.data  

# Define the globals so that the C code can access them
# (in this lab we return the pointer, so strictly speaking,
# doesn't really need to be defined as global)
# .global cipherText
.type cipherText,%gnu_unique_object

.align
# space allocated for cipherText: 200 bytes, prefilled with 0x2A */
cipherText: .space 200,0x2A  
 
# Tell the assembler that what follows is in instruction memory    
.text
.align

# Tell the assembler to allow both 16b and 32b extended Thumb instructions
.syntax unified

    
/********************************************************************
function name: asmEncrypt
function description:
     pointerToCipherText = asmEncrypt ( ptrToInputText , key )
     
where:
     input:
     ptrToInputText: location of first character in null-terminated
                     input string. Per calling convention, passed in via r0.
     key:            shift value (K). Range 0-25. Passed in via r1.
     
     output:
     pointerToCipherText: mem location (address) of first character of
                          encrypted text. Returned in r0
     
     function description: asmEncrypt reads each character of an input
                           string, uses a shifted alphabet to encrypt it,
                           and stores the new character value in memory
                           location beginning at "cipherText". After copying
                           a character to cipherText, a pointer is incremented 
                           so that the next letter is stored in the bext byte.
                           Only encrypt characters in the range [a-zA-Z].
                           Any other characters should just be copied as-is
                           without modifications
                           Stop processing the input string when a NULL (0)
                           byte is reached. Make sure to add the NULL at the
                           end of the cipherText string.
     
     notes:
        The return value will always be the mem location defined by
        the label "cipherText".
     
     
********************************************************************/    
.global asmEncrypt
.type asmEncrypt,%function
asmEncrypt:   

    # save the caller's registers, as required by the ARM calling convention
    push {r4-r11,LR}
    
   /* YOUR asmEncrypt CODE BELOW THIS LINE! VVVVVVVVVVVVVVVVVVVVV  */
    LDR r3,=cipherText /* gets address of cipherText */
   mov r6,r1 /* copy of key */
   mov r7,122 /* register for z */
   loop:
   LDRB r4,[r0] /* loads the first character */
   CMP r4,0 /* checks if its null */
   beq done 
   
   check_key_and_char:
   cmp r1,0 /* if key is 0, move to store */
   beq encrypted
   cmp r4,65 /* if decimal value is lower than A, move to store */
   bmi encrypted
   cmp r7,r4 /* if decimal value is greated than z, move to store */
   bmi encrypted
   cmp r4,90 /*if decimal value is Z, reset to A */
   beq reset
   cmp r4,122 /* if decimal value is z, reset to a */
   beq reset
   
   shift_by_1:
   add r4,r4,1 /* shifts character by 1 */
   sub r1,r1,1 /* lowers key by 1 for current character */
   b check_key_and_char 
  
   encrypted:
   STRB r4,[r3] /* stores current character into address of cipherText */
   add r0,r0,1 /* adds 1 to r0 to get next character for encryption */
   add r3,r3,1 /* adds 1 to cipherText to shift address where character will be stored */
   add r1,r1,r6 /* resets the key for encrypting the next character */
   b loop
   
   reset:
    sub r4,r4,26 /* resets Z to A or z to a */
    b shift_by_1
    
   done:
    STRB r4,[r3] /* stores the null bit in last address */
    LDR r0,=cipherText 

    /* YOUR asmEncrypt CODE ABOVE THIS LINE! ^^^^^^^^^^^^^^^^^^^^^  */

    # restore the caller's registers, as required by the ARM calling convention
    pop {r4-r11,LR}

    mov pc, lr	 /* asmEncrypt return to caller */
   

/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
           




