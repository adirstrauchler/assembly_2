.text

    .globl sum_positive_ints
    .type sum_positive_ints, @function
    
sum_positive_ints:
    pushq %rbp
    movq %rsp, %rbp
    movq $0, %rax
    movq $0, %r10
    cmpq $0, %rdi
    je sum_positive_ints_null

sum_positive_ints_loop:
    movslq (%rdi), %r9
    cmpq $0, %r9
    jg sum_positive_ints_add
    addq $4, %rdi
    addq $1, %r10
    cmpq %r10, %rsi
    jg sum_positive_ints_loop
    leave
    ret

sum_positive_ints_add:
    addq %r9, %rax
    addq $4, %rdi
    addq $1, %r10
    cmpq %r10, %rsi
    jg sum_positive_ints_loop
    leave
    ret

sum_positive_ints_null:
    leave
    ret

    .globl reverse_longs
    .type reverse_longs, @function
reverse_longs:
    pushq %rbp
    movq %rsp, %rbp
    subq $16, %rsp
    movq $0, %rax
    cmpq $0, %rdi
    je reverse_longs_end
    movq $0, %r10
    movq $0, %r11
    subq $16, %rsp
    addq $8, %rax
    imulq %rsi
    addq %rax, %r11
    addq %rdi, %r11
    subq $8, %r11

reverse_longs_loop:
    cmpq %rdi, %r11
    jle reverse_longs_end
    movq (%r11), %r12
    movq (%rdi), %r13
    movq %r13, (%r11)
    movq %r12, (%rdi)
    movq (%rdi), %rax
    subq $8, %r11
    addq $8, %rdi
    jmp reverse_longs_loop

reverse_longs_end:
    leave
    ret

    .globl sensor_score
    .type sensor_score, @function
sensor_score:
    pushq %rbp
    movq %rsp, %rbp
    movslq (%rdi), %r9
    movq 8(%rdi), %r10
    movslq 16(%rdi), %r11
    movq %r11, %rax
    imulq %r10
    addq %r9, %rax
    leave
    ret

    .globl sensor_array_total
    .type sensor_array_total, @function
sensor_array_total:
    pushq %rbp
    movq %rsp, %rbp
    movq $0, %rax
    subq $48, %rsp
    subq $24, %rdi
    movq $0, -16(%rbp)
    movq %rdi, -48(%rbp)
    movq %rsi, -8(%rbp)
    movq $-1, -24(%rbp)
    cmpq $0, %rdi
    je sensor_array_total_loop_end

sensor_array_total_loop:
    addq $1, -24(%rbp)
    movq -24(%rbp), %r9
    movq -8(%rbp), %r10
    cmpq %r9, %r10
    jle sensor_array_total_loop_end
    addq $24, -48(%rbp)
    movq -48(%rbp), %rdi
    call sensor_score
    addq %rax, -16(%rbp)
    jmp sensor_array_total_loop

sensor_array_total_loop_end:
    movq -16(%rbp), %r9
    movq %r9, %rax
    leave
    ret

    .globl make_arithmetic_sequence
    .type make_arithmetic_sequence, @function
make_arithmetic_sequence:
    pushq %rbp
    movq %rsp, %rbp
    movq $8, %rax
    imulq %rdx, %rax
    subq %rax, %rsp
    subq $48, %rsp
    movq $0, (%rsp)
    movq $-1, -8(%rbp)
    movq %rdx, -16(%rbp)
    movq %rsi, -24(%rbp)
    movq %rdi, -32(%rbp)
    movq $0, -48(%rbp)
    cmpq $0, %rdx
    jle make_arithmetic_sequence_fail
    movq %rax, %rdi
    call malloc
    cmpq $0, %rax
    je make_arithmetic_sequence_fail
    movq %rax, %r8
    movq %rax, -48(%rbp)

malloc_loop:
    addq $1, -8(%rbp)
    movq -8(%rbp), %r9
    movq -16(%rbp), %r10
    cmpq %r10, %r9
    jge make_arithmetic_sequence_end
    movq $0, %rax
    addq -24(%rbp), %rax
    imulq %r9
    addq -32(%rbp), %rax
    movq %rax, %r11
    movq -8(%rbp), %r9
    movq $8, %rax
    imulq %r9
    movq %rax, %r12
    movq $8, %r12
    movq %r11, (%r8)
    addq %r12, %r8
    jmp malloc_loop

make_arithmetic_sequence_end:
    movq -48(%rbp), %rax
    leave
    ret

make_arithmetic_sequence_fail:
    movq $0, %rax
    leave
    ret

    .globl make_sensor
    .type make_sensor, @function
make_sensor:
    pushq %rbp
    movq %rsp, %rbp
    subq $32, %rsp
    movq %rdi, -8(%rbp)
    movq %rsi, -16(%rbp)
    movq %rdx, -24(%rbp)
    movq $0, %rax
    movq $24, %rdi
    call malloc
    cmpq $0, %rax
    je make_sensor_fail
    movq -8(%rbp), %rdi
    movq -16(%rbp), %rsi
    movq -24(%rbp), %rdx
    movq %rdi, (%rax)
    movq %rsi, 8(%rax)
    movq %rdx, 16(%rax)
    leave
    ret

make_sensor_fail:
    movq $0, %rax
    leave
    ret

    .globl sensor_destroy
    .type sensor_destroy, @function
sensor_destroy:
    pushq %rbp
    movq %rsp, %rbp
    cmpq $0, %rdi
    je sensor_destroy_null
    call free
    leave
    ret

sensor_destroy_null:
    movq $0, %rax
    leave
    ret

    .section .note.GNU-stack,"",@progbits
