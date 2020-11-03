format PE console

entry Start

include 'win32a.inc'

section '.code' code readable executable

        Start:
          mov eax,[startpoint]
          jmp BitInvert
          return:;return form bitinvert  result in edx
          mov ebx,[startpoint]
          cmp ebx,edx ; compare word and inverted word
            jne notadd
          ;else add new palindrom  
          mov eax,1
          add [counter],eax
          
          ;push [startpoint]
          ;push dbgstr
          ;call [printf]   ;debug printf shows current binary palindrom
          
          notadd:
          mov eax,1
          add [startpoint],eax
          mov eax, [startpoint]
          cmp eax, [endpoint]
            jg Exit



        ; to turn 1101101 to 1011011
        BitInvert: ; dword invert (move new world from eax to edx)
              xor ecx,ecx ;cl - 0 counter
              xor edx,edx
              newbit:
                mov ebx,eax
                and ebx,1
                inc cl  ;cl - counter of zero bits
                cmp ebx,1
                  jne gothrow
                 ;else gothrow addbit
              addbit:  ;1
                shl edx,cl ; edx << cl
                add edx,1   ; add 1 on last bit
                xor cl,cl ;
              
              gothrow:;0
                shr eax,1  ;eax >> 1
                cmp cl,33 ;32bit+1 (for safety)
                  jg return; jump away
              jmp newbit    
        Exit:
          push [counter]
          push outstr
          call [printf]
          
          call [getch]
          xor eax,eax
          push eax
          call [ExitProcess]
                
              
section '.data' data readable writable
        startpoint dd 1
        counter dd 0;  counter of palindroms
        endpoint dd 1000000;10^6
        outstr db 'Number of bit palindroms from 1 to 10^6 : %d',10,0 ;outputstring
        ;dbgstr db '%d',10,0 ;debug string only for debugging

section '.idata' import data readable

        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess'

        import msvcrt,\
               printf, 'printf',\
               getch, '_getch'  