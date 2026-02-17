section .data
  a dd 10
  b dw 22
  c dd 2
  d dw 3
  e dd -1
global _start

; b * c + a / (d + e) - d*d / b * e + a * e
; d + e == 0 => exit 1
; b == 0 => exit 1
; e == 0 => exit 1
; exit 0

section .text
_start:
  cmp word [b], 0
  je div_zero
  ; checked b zero

  movsx rax, word [b]
  movsxd rcx, dword [c]
  imul rax, rcx

  mov r8, rax
  ; r8 holds b * c

  cmp dword [e], 0
  je div_zero
  ; checked e zero

  movsxd rax, dword [a]
  movsxd rcx, dword [e]
  imul rax, rcx

  mov r9, rax
  ; r9 holds a * e

  movsx rbx, word [d]
  movsxd rcx, dword [e]
  add rbx, rcx
  cmp rbx, 0
  je div_zero
  ; checked d + e zero
  ; rbx = d + e
  
  movsxd rax, dword [a]
  cqo
  ; rax ---> rdx:rax
  idiv rbx;

  mov r10, rax
  ; r10 holds a / (d + e)

  movsx rbx, word [b]
  movsxd rcx, dword [e]
  imul rbx, rcx
  ; rbx = b * e
  movsx rax, word [d]
  imul rax, rax
  ; rax = d * d
  cqo
  ; rax ---> rdx:rax
  idiv rbx;

  mov r11, rax
  ; r11 holds d * d / b * e

  mov rax, r8
  add rax, r9
  add rax, r10
  sub rax, r11
  
  mov rdi, rax
  mov rax, 60
  syscall

div_zero:
  mov rax, 60
  mov edi, 1
  syscall

