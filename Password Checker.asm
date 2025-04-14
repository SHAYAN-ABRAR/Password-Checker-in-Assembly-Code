.MODEL SMALL
.STACK 100h
.DATA
    prompt db 'Enter your password: $'
    correct db 'mypassword$'
    matched db 0Dh, 0Ah, 'Password Matched$'
    notmatched db 0Dh, 0Ah, 'Password Not Matched$'
    input db 20 dup('$')    ; reserve 20 bytes for input
.CODE
MAIN PROC
    ; Init data segment
    mov ax, @data
    mov ds, ax
    ; Show prompt
    mov ah, 09h
    lea dx, prompt
    int 21h
    ; Read characters one by one
    lea si, input      ; SI points to input buffer
read_loop:
    mov ah, 01h        ; Read char
    int 21h
    cmp al, 13         ; Check if ENTER (carriage return)
    je end_input
    mov [si], al       ; Store char in input buffer
    inc si
    jmp read_loop
end_input:
    mov byte ptr [si], '$'   ; Terminate input string with '$'
    ; Compare input with correct password
    lea si, input
    lea di, correct
compare_loop:
    mov al, [si]
    mov bl, [di]
    cmp al, bl
    jne not_match       ; If mismatch, jump (uses signed conditional logic)
    cmp al, '$'         ; End of string check
    je match_found
    inc si
    inc di
    jmp compare_loop
match_found:
    mov ah, 09h
    lea dx, matched
    int 21h
    jmp exit
not_match:
    mov ah, 09h
    lea dx, notmatched
    int 21h
exit:
    mov ah, 4Ch
    int 21h
MAIN ENDP
END MAIN
