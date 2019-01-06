.intel_syntax noprefix

stack_size = 1024

f_code = 0x80
f_immediate = 0x60

.macro	item	name, flags = 0
	
	link = p_item - .
9:	
	.if	link >= -256/2 && link < 256/2
		.byte	\flags
		.byte	link
	.elseif	link >= -256*256/2 && link < 256*256/2
		.byte	\flags | 1
		.word	link
	.elseif	link >= -256*256*256*256/2 && link < 256*256*256*256/2
		.byte	\flags | 2
		.int	link
	.elseif	link >= -256*256*256*256*256*256*256*256/2 && link < 256*256*256*256*256*256*256*256/2
		.byte	\flags | 3
		.quad	link
	.endif
	
	p_item = 9b
	
	.byte	9f - . - 1
	.ascii	"\name"
9:
.endm
	
.section .data

init_stack:	.quad	0
init_rstack:	.quad	0

emit_buf:	.byte	0

inbuf_size = 256

msg_bad_byte:
.ascii "Bad byte code!\n"
msg_bad_byte_len = . - msg_bad_byte # символу len присваеваетсЯ длина строки

msg_bye:
.ascii "\nBye!\n"
msg_bye_len = . - msg_bye 

bcmd:
.quad		bcmd_bad,	bcmd_bye,	bcmd_num0,	bcmd_num1,	bcmd_num2,	bcmd_num3,	bcmd_num4,	bcmd_num8	# 0x00
.quad		bcmd_lit8,	bcmd_lit16,	bcmd_lit32,	bcmd_lit64,	bcmd_call8,	bcmd_call16,	bcmd_call32,	bcmd_bad
.quad		bcmd_branch8,	bcmd_branch16,	bcmd_qbranch8,	bcmd_qbranch16,	bcmd_qnbranch8,	bcmd_qnbranch16,bcmd_bad,	bcmd_exit	# 0x10
.quad		bcmd_wp,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad
.quad		bcmd_wm,	bcmd_add,	bcmd_sub,	bcmd_mul,	bcmd_div,	bcmd_mod,	bcmd_divmod,	bcmd_abs	# 0x20
.quad		bcmd_var0,	bcmd_var8,	bcmd_var16,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad
.quad		bcmd_dup,	bcmd_drop,	bcmd_swap,	bcmd_rot,	bcmd_mrot,	bcmd_over,	bcmd_pick,	bcmd_roll	# 0x30
.quad		bcmd_depth,	bcmd_nip,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad 
.quad		bcmd_get,	bcmd_set,	bcmd_get8,	bcmd_set8,	bcmd_get16,	bcmd_set16,	bcmd_get32,	bcmd_set32 	# 0x40
.quad		bcmd_setp,	bcmd_setm,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad 
.quad		bcmd_zeq,	bcmd_zlt,	bcmd_zgt,	bcmd_eq,	bcmd_lt,	bcmd_gt,	bcmd_lteq,	bcmd_gteq	# 0x50
.quad		bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad
.quad		bcmd_2r,	bcmd_r2,	bcmd_rget,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad	# 0x60
.quad		bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad
.quad		bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad
.quad		bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad
.quad		bcmd_type,	bcmd_emit,	bcmd_str,	bcmd_strp,	bcmd_count,	bcmd_bad,	bcmd_bad,	bcmd_bad	# 0x80
.quad		bcmd_expect,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad
.quad		bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad	# 0x90
.quad		bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad
.quad		bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad
.quad		bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad
.quad		bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad
.quad		bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad
.quad		bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad
.quad		bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad
.quad		bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad
.quad		bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad
.quad		bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad
.quad		bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad
.quad		bcmd_blword,	bcmd_quit,	bcmd_find,	bcmd_cfa,	bcmd_execute,	bcmd_numberq,	bcmd_bad,	bcmd_bad	# 0xF0
.quad		bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad

# forth last_item context @ ! quit
start:		.byte	b_call16
		.word	forth - . - 2
		.byte	b_call16
		.word	last_item - . - 2
		.byte	b_call16
		.word	context - . - 2
		.byte	b_get
		.byte	b_set
		.byte	b_quit

		inbuf:		.byte	b_var0
		.space inbuf_size

		
# begin inbuf dup tib ! inbuf_size expect span @ #tib ! 0 >in ! interpret again
quit:		.byte	b_strp, 1
		.ascii	"\n"
		.byte	b_call16
		.word	prstack - . - 2
		.byte	b_strp
		.byte	2
		.ascii	"> "
		.byte	b_call16
		.word	inbuf - . - 2
		.byte	b_dup
		.byte	b_call16
		.word	tib - . - 2
		.byte	b_set
		.byte	b_lit16
		.word	inbuf_size
		.byte	b_expect
		.byte	b_call16
		.word	span - . - 2
		.byte	b_get
		.byte	b_call16
		.word	ntib - . - 2
		.byte	b_set
		.byte	b_num0
		.byte	b_call16
		.word	bin - . - 2
		.byte	b_set
		.byte	b_call16
		.word	interpret - . - 2
		.byte	b_branch8, quit - .

p_item = .
		item	forth
forth:		.byte	b_var8
		.byte	does_voc - .
		.quad	0
does_voc:
		.byte	b_call8
		.byte	context - . - 1
		.byte	b_set
		.byte	b_exit

		item	current
		.byte	b_var0
		.quad	0

		item	context
context:	.byte	b_var0
v_context:	.quad	0
		
		item	0, f_code
		.byte	b_num0
		.byte	b_exit

		item	1, f_code
		.byte	b_num1
		.byte	b_exit

		item	2, f_code
		.byte	b_num2
		.byte	b_exit

		item	3, f_code
		.byte	b_num3
		.byte	b_exit

		item	4, f_code
		.byte	b_num4
		.byte	b_exit

		item	8, f_code
		.byte	b_num8
		.byte	b_exit

		item	lit8, f_code
		.byte	b_lit8
		.byte	31
		.byte	b_exit
		
		item	lit16, f_code
		.byte	b_lit16
		.word	31415
		.byte	b_exit

		item	lit32, f_code
		.byte	b_lit32
		.int	31415926
		.byte	b_exit

		item	lit64, f_code
		.byte	b_lit64
		.quad	31415926
		.byte	b_exit

		item	call8, f_code
		.byte	b_call8
		.byte	0f - . - 1
0:		.byte	b_exit
		
		item	call16, f_code
		.byte	b_call16
		.word	0f - . - 2
0:		.byte	b_exit

		item	call32, f_code
		.byte	b_call32
		.int	0f - . - 4
0:		.byte	b_exit

		item	branch8, f_code
		.byte	b_branch8
		.byte	0f - .
0:		.byte	b_exit
		
		item	branch16, f_code
		.byte	b_branch16
		.word	0f - .
0:		.byte	b_exit
		
		item	qbranch8, f_code
		.byte	b_qbranch8
		.byte	0f - .
0:		.byte	b_exit
		
		item	qbranch16, f_code
		.byte	b_qbranch16
		.word	0f - .
0:		.byte	b_exit
		
		item	exit, f_code
		.byte	b_exit
		
		item	1-, f_code
		.byte	b_wm
		.byte	b_exit
		
		item	1+, f_code
		.byte	b_wp
		.byte	b_exit
		
		item	+, f_code
		.byte	b_add
		.byte	b_exit
		
		item	-, f_code
		.byte	b_sub
		.byte	b_exit
		
		item	*, f_code
		.byte	b_mul
		.byte	b_exit
		
 		item	/, f_code
		.byte	b_div
		.byte	b_exit
		
		item	mod, f_code
		.byte	b_mod
		.byte	b_exit
		
		item	/mod, f_code
		.byte	b_divmod
		.byte	b_exit
		
		item	abs, f_code
		.byte	b_abs
		.byte	b_exit

		item	dup, f_code
		.byte	b_dup
		.byte	b_exit
		
		item	drop, f_code
		.byte	b_drop
		.byte	b_exit
		
		item	swap, f_code
		.byte	b_swap
		.byte	b_exit
		
		item	rot, f_code
		.byte	b_rot
		.byte	b_exit
		
 		item	-rot, f_code
		.byte	b_mrot
		.byte	b_exit
		
		item	over, f_code
		.byte	b_over
		.byte	b_exit
		
		item	pick, f_code
		.byte	b_pick
		.byte	b_exit
		
		item	roll, f_code
		.byte	b_roll
		.byte	b_exit
		
		item	depth, f_code
		.byte	b_depth
		.byte	b_exit
		
		item	@, f_code
		.byte	b_get
		.byte	b_exit
		
		item	!, f_code
		.byte	b_set
		.byte	b_exit
		
		item	c@, f_code
		.byte	b_get8
		.byte	b_exit
		
		item	c!, f_code
		.byte	b_set8
		.byte	b_exit
		
		item	w@, f_code
		.byte	b_get16
		.byte	b_exit
		
		item	w!, f_code
		.byte	b_set16
		.byte	b_exit
		
		item	i@, f_code
		.byte	b_get32
		.byte	b_exit
		
		item	i!, f_code
		.byte	b_set32
		.byte	b_exit
		
		item	+!, f_code
		.byte	b_setp
		.byte	b_exit
		
		item	-!, f_code
		.byte	b_setm
		.byte	b_exit
		
		item	>r, f_code
		.byte	b_2r
		.byte	b_exit

		item	r>, f_code
		.byte	b_r2
		.byte	b_exit

		item	r@, f_code
		.byte	b_rget
		.byte	b_exit

		item	"0=", f_code
		.byte	b_zeq
		.byte	b_exit
		
		item	0<, f_code
		.byte	b_zlt
		.byte	b_exit
		
		item	0>, f_code
		.byte	b_zgt
		.byte	b_exit
		
		item	"=", f_code
		.byte	b_eq
		.byte	b_exit
		
		item	<, f_code
		.byte	b_lt
		.byte	b_exit
		
		item	>, f_code
		.byte	b_gt
		.byte	b_exit
		
		item	"<=", f_code
		.byte	b_lteq
		.byte	b_exit
		
		item	">=", f_code
		.byte	b_gteq
		.byte	b_exit
		
		item	type, f_code
		.byte	b_type
		.byte	b_exit

		item	expect, f_code
		.byte	b_expect
		.byte	b_exit
		
		item	emit, f_code
		.byte	b_emit
		.byte	b_exit

		item	count, f_code
		.byte	b_count
		.byte	b_exit

		item	"(\")", f_code
		.byte	b_str
		.byte	b_exit

		item	"(.\")", f_code
		.byte	b_strp
		.byte	b_exit

		item	var8, f_code
		.byte	b_var8
		.byte	0f - .
0:		.byte	b_exit
		
		item	var16, f_code
		.byte	b_var16
		.word	0f - .
0:		.byte	b_exit
		
		item	base
base:		.byte	b_var0
v_base:		.quad	10

holdbuf_len = 70
		item	holdbuf
holdbuf:	.byte	b_var0
		.space	holdbuf_len

		item	holdpoint
holdpoint:	.byte	b_var0
		.quad	0
		
		item	span
span:		.byte	b_var0
v_span:		.quad	0

# : hold holdpoint @ 1- dup holdbuf > if drop drop else dup holdpoint ! c! then ;
		item	hold
hold:		.byte	b_call8
		.byte	holdpoint - . - 1	# holdpoint
		.byte	b_get			# @
		.byte	b_wm			# 1-
		.byte	b_dup			# dup
		.byte	b_call8
		.byte	holdbuf - . - 1		# holdbuf
		.byte	b_gt			# >
		.byte	b_qbranch8		# if
		.byte	0f - .
		.byte	b_drop			# drop
		.byte	b_drop			# drop
		.byte	b_branch8		# команда перехода на возврат (после then)
		.byte	1f - .
0:		.byte	b_dup			# dup
		.byte	b_call8
		.byte	holdpoint - . - 1	# holdpoint
		.byte	b_set			# !
		.byte	b_set8			# c!
1:		.byte	b_exit			# ;

# : # base /mod swap dup 10 < if c" 0 + else 10 - c" A + then hold ;
		item	#
conv:		.byte	b_call16
		.word	base - . - 2		# base
		.byte	b_get			# @
		.byte	b_divmod		# /mod
		.byte	b_swap			# swap
		.byte	b_dup			# dup
		.byte	b_lit8
		.byte	10			# 10
		.byte	b_lt			# <
		.byte	b_qnbranch8		# if
		.byte	0f - .
		.byte	b_lit8
		.byte	'0'			# c" 0
		.byte	b_add			# +
		.byte	b_branch8		# else
		.byte	1f - .
0:		.byte	b_lit8
		.byte	'?'			# c" A
		.byte	b_add			# +
1:		.byte	b_call16
		.word	hold - . - 2		# hold
		.byte	b_exit			# ;

# : <# holdbuf 70 + holdpoint ! ;
		item	<#
conv_start:	.byte	b_call16
		.word	holdbuf - . - 2
		.byte	b_lit8
		.byte	holdbuf_len
		.byte	b_add
		.byte	b_call16
		.word	holdpoint - . - 2
		.byte	b_set
		.byte	b_exit

# : #s do # dup 0=until ;
		item	#s
conv_s:		.byte	b_call8
		.byte	conv - . - 1
		.byte	b_dup
		.byte	b_qbranch8
		.byte	conv_s - .
		.byte	b_exit

# : #> holdpoint @ holdbuf 70 + over - ;
		item	#>
conv_end:	.byte	b_call16
		.word	holdpoint - . - 2
		.byte	b_get
		.byte	b_call16
		.word	holdbuf - . - 2
		.byte	b_lit8
		.byte	holdbuf_len
		.byte	b_add
		.byte	b_over
		.byte	b_sub
		.byte	b_exit

		item	.
dot:		.byte	b_dup
		.byte	b_abs
		.byte	b_call8
		.byte	conv_start - . - 1
		.byte	b_lit8
		.byte	' '
		.byte	b_call16
		.word	hold - . - 2
		.byte	b_call8
		.byte	conv_s - . - 1
		.byte	b_drop
		.byte	b_zlt
		.byte	b_qnbranch8
		.byte	1f - .
		.byte	b_lit8
		.byte	'-'
		.byte	b_call16
		.word	hold - . - 2
1:		.byte	b_call8
		.byte	conv_end - . - 1
		.byte	b_type
		.byte	b_exit

		item	tib
tib:		.byte	b_var0
v_tib:		.quad	0

		item	#tib
ntib:		.byte	b_var0
v_ntib:		.quad	0

		item	>in
bin:		.byte	b_var0
v_in:		.quad	0

# : .s depth dup . c": emit do dup while dup pick . 1- again drop ;
		item	.s		# 11 22 33
prstack:	.byte	b_depth		# 11 22 33 3
		.byte	b_dup		# 11 22 33 3 3
		.byte	b_strp
		.byte	2
		.ascii	"( "
		.byte	b_call16	# 11 22 33 3
		.word	dot - . - 2
		.byte	b_strp		# 11 22 33 3
		.byte	3
		.ascii	"): "
		.byte	b_dup, b_zlt
		.byte	b_qnbranch8, 1f - .
		.byte	b_strp
		.byte	14
		.ascii	"\nStack fault!\n"
		.byte	b_quit
1:		.byte	b_dup		# 11 22 33 3 3
		.byte	b_qnbranch8	# 11 22 33 3
		.byte	2f - .
		.byte	b_dup		# 11 22 33 3 3
		.byte	b_pick		# 11 22 33 3 11
		.byte	b_call16	# 11 22 33 3
		.word	dot - . - 2
		.byte	b_wm		# 11 22 33 2
		.byte	b_branch8
		.byte	1b - .
2:		.byte	b_drop		# 11 22 33
		.byte	b_exit

.macro	prs	new_line = 1
		.byte	b_call16
		.word	prstack - . - 2
		.if	\new_line > 0
		.byte	b_lit8, '\n'
		.byte	b_emit
		.endif
.endm

.macro	pr	string
		.byte	b_strp
		.byte	9f - 8f
8:		.ascii	"\n\string"
9:
.endm

		item	interpret
interpret:	.byte	b_blword
		.byte	b_dup
		.byte	b_qnbranch8
		.byte	0f - .
		.byte	b_over
		.byte	b_over
		.byte	b_find
		.byte	b_dup
		.byte	b_qnbranch8
		.byte	1f - .
		.byte	b_mrot
		.byte	b_drop
		.byte	b_drop
		.byte	b_cfa
		.byte	b_execute
		.byte	b_branch8
		.byte	2f - .
1:		.byte	b_drop
		.byte	b_over, b_over
		.byte	b_numberq
		# проверка, что число преобразовалось
		.byte	b_qbranch8, 3f - . # если на стеке не 0, значит, преобразовалось и идем на метку 3
		.byte	b_type		# иначе печатаем слово
		.byte	b_strp		# потом диагностику
		.byte	19		# это длинна сообщениЯ ниже
		.ascii	" : word not found!\n"
		.byte	b_quit		# и завершаем интерпретацию
3:		.byte	b_nip, b_nip	# удалим значениЯ, сохраненные длЯ печати слова (команды b_over, b_over)
2:		# проверка стека на выход за границу
		.byte	b_depth		# получаем глубину стека
		.byte	b_zlt		# сравниваем, что меньше 0 (команда 0<)
		.byte	b_qnbranch8, interpret_ok - . # если условие ложно, то все в порЯдке, делаем переход
		.byte	b_strp		# иначе выводим диагностику
		.byte	14
		.ascii	"\nstack fault!\n"
		.byte	b_quit		# и завершаем интерпретацию
interpret_ok:	.byte	b_branch8
		.byte	interpret - .
0:		.byte	b_drop
		.byte	b_exit

last_item:	.byte	b_var0
		item	bye, f_code
		.byte	b_bye

.section .text

.global _start # точка входа в программу

_start:		mov	rbp, rsp
		sub	rbp, stack_size
		lea	r8, start
		mov	init_stack, rsp
		mov	init_rstack, rbp
		
		jmp	_next

b_var0 = 0x28
bcmd_var0:	push	r8

b_exit = 0x17
bcmd_exit:      mov     r8, [rbp]
                add     rbp, 8

_next:		movzx	rcx, byte ptr [r8]
		inc	r8
		jmp	[bcmd + rcx*8]

b_num0 = 0x02
bcmd_num0:      push    0
                jmp     _next

b_num1 = 0x03
bcmd_num1:      push    1
                jmp     _next

b_num2 = 0x04
bcmd_num2:      push    2
                jmp     _next

b_num3 = 0x05
bcmd_num3:      push    3
                jmp     _next

b_num4 = 0x06
bcmd_num4:      push    4
                jmp     _next

b_num8 = 0x07
bcmd_num8:      push    8
                jmp     _next

b_lit8 = 0x08
bcmd_lit8:      movsx   rax, byte ptr [r8]
                inc     r8
                push    rax
                jmp     _next

b_lit16 = 0x09
bcmd_lit16:     movsx   rax, word ptr [r8]
                add     r8, 2
                push    rax
                jmp     _next

b_call8 = 0x0C
bcmd_call8:     movsx   rax, byte ptr [r8]
                sub     rbp, 8
                inc     r8
                mov     [rbp], r8
                add     r8, rax
                jmp     _next

b_call16 = 0x0D
bcmd_call16:    movsx   rax, word ptr [r8]
                sub     rbp, 8
                add     r8, 2
                mov     [rbp], r8
                add     r8, rax
                jmp     _next

b_call32 = 0x0E
bcmd_call32:    movsx   rax, dword ptr [r8]
                sub     rbp, 8
                add     r8, 4
                mov     [rbp], r8
                add     r8, rax
                jmp     _next

b_lit32 = 0x0A
bcmd_lit32:     movsx   rax, dword ptr [r8]
                add     r8, 4
                push    rax
                jmp     _next

b_lit64 = 0x0B
bcmd_lit64:     mov     rax, [r8]
                add     r8, 8
                push    rax
                jmp     _next

b_dup = 0x30
bcmd_dup:       push    [rsp]
                jmp     _next

b_wm = 0x20
bcmd_wm:        decq    [rsp]
                jmp     _next

b_wp = 0x18
bcmd_wp:        incq    [rsp]
                jmp     _next

b_add = 0x21
bcmd_add:	pop	rax
		add	[rsp], rax
		jmp	_next

b_sub = 0x22
bcmd_sub:	pop	rax
		sub	[rsp], rax
		jmp	_next

b_mul = 0x23
bcmd_mul:	pop	rax
		pop	rbx
		imul	rbx
		push	rax
		jmp	_next

b_div = 0x24
bcmd_div:	pop	rbx
		pop	rax
		cqo
		idiv	rbx
		push	rax
		jmp	_next

b_mod = 0x25
bcmd_mod:	pop	rbx
		pop	rax
		cqo
		idiv	rbx
		push	rdx
		jmp	_next

b_divmod = 0x26
bcmd_divmod:	pop	rbx
		pop	rax
		cqo
		idiv	rbx
		push	rdx
		push	rax
		jmp	_next

b_abs = 0x27
bcmd_abs:	mov	rax, [rsp]
		or	rax, rax
		jge	_next
		neg	rax
		mov	[rsp], rax
		jmp	_next

b_drop = 0x31
bcmd_drop:	add	rsp, 8
		jmp	_next

b_swap = 0x32
bcmd_swap:	pop	rax
		pop	rbx
		push	rax
		push	rbx
		jmp	_next

b_rot = 0x33
bcmd_rot:	pop	rax
		pop	rbx
		pop	rcx
		push	rbx
		push	rax
		push	rcx
		jmp	_next
		
b_mrot = 0x34
bcmd_mrot:	pop	rcx
		pop	rbx
		pop	rax
		push	rcx
		push	rax
		push	rbx
		jmp	_next
		
b_over = 0x35
bcmd_over:	push	[rsp + 8]
		jmp	_next
		
b_pick = 0x36
bcmd_pick:	pop	rcx
		push	[rsp + 8*rcx]
		jmp	_next
		
b_roll = 0x37
bcmd_roll:	pop	rcx
		mov	rbx, [rsp + 8*rcx]
roll1:		mov	rax, [rsp + 8*rcx - 8]
		mov	[rsp + 8*rcx], rax
		dec	rcx
		jnz	roll1
		push	rbx
		jmp	_next

b_depth = 0x38
bcmd_depth:	mov	rax, init_stack
		sub	rax, rsp
		sar	rax, 3
		push	rax
		jmp	_next
		
b_nip = 0x39
bcmd_nip:	pop	rax
		mov	[rsp], rax
		jmp	_next
		
b_get = 0x40
bcmd_get:	pop	rcx
		push	[rcx]
		jmp	_next

b_set = 0x41
bcmd_set:	pop	rcx
		pop	rax
		mov	[rcx], rax
		jmp	_next

b_get8 = 0x42
bcmd_get8:	pop	rcx
		movsx	rax, byte ptr [rcx]
		push	rax
		jmp	_next

b_set8 = 0x43
bcmd_set8:	pop	rcx
		pop	rax
		mov	[rcx], al
		jmp	_next

b_get16 = 0x44
bcmd_get16:	pop	rcx
		movsx	rax, word ptr [rcx]
		push	rax
		jmp	_next

b_set16 = 0x45
bcmd_set16:	pop	rcx
		pop	rax
		mov	[rcx], ax
		jmp	_next

b_get32 = 0x46
bcmd_get32:	pop	rcx
		movsx	rax, dword ptr [rcx]
		push	rax
		jmp	_next

b_set32 = 0x47
bcmd_set32:	pop	rcx
		pop	rax
		mov	[rcx], eax
		jmp	_next
		
b_setp = 0x48
bcmd_setp:	pop	rcx
		pop	rax
		add	[rcx], rax
		jmp	_next

b_setm = 0x49
bcmd_setm:	pop	rcx
		pop	rax
		sub	[rcx], rax
		jmp	_next

b_2r = 0x60
bcmd_2r:	pop	rax
		sub	rbp, 8
		mov	[rbp], rax
		jmp	_next

b_r2 = 0x61
bcmd_r2:	push	[rbp]
		add	rbp, 8
		jmp	_next

b_rget = 0x62
bcmd_rget:	push	[rbp]
		jmp	_next

# 0=
b_zeq = 0x50
bcmd_zeq:	pop	rax
		or	rax, rax
		jnz	rfalse
rtrue:		push	-1
		jmp	_next
rfalse:		push	0
		jmp	_next
		
# 0<
b_zlt = 0x51
bcmd_zlt:	pop	rax
		or	rax, rax
		jl	rtrue
		push	0
		jmp	_next
		
# 0>
b_zgt = 0x52
bcmd_zgt:	pop	rax
		or	rax, rax
		jg	rtrue
		push	0
		jmp	_next

# =
b_eq = 0x53
bcmd_eq:	pop	rbx
		pop	rax
		cmp	rax, rbx
		jz	rtrue
		push	0
		jmp	_next

# <
b_lt = 0x54
bcmd_lt:	pop	rbx
		pop	rax
		cmp	rax, rbx
		jl	rtrue
		push	0
		jmp	_next
		
# >
b_gt = 0x55
bcmd_gt:	pop	rbx
		pop	rax
		cmp	rax, rbx
		jg	rtrue
		push	0
		jmp	_next

# <=
b_lteq = 0x56
bcmd_lteq:	pop	rbx
		pop	rax
		cmp	rax, rbx
		jle	rtrue
		push	0
		jmp	_next
		
# >=
b_gteq = 0x57
bcmd_gteq:	pop	rbx
		pop	rax
		cmp	rax, rbx
		jge	rtrue
		push	0
		jmp	_next

b_var8 = 0x29
bcmd_var8:	push	r8

b_branch8 = 0x10
bcmd_branch8:   movsx   rax, byte ptr [r8]
                add     r8, rax
                jmp     _next

b_var16 = 0x30
bcmd_var16:	push	r8

b_branch16 = 0x11
bcmd_branch16:  movsx   rax, word ptr [r8]
                add     r8, rax
                jmp     _next

b_qbranch8 = 0x12
bcmd_qbranch8:  pop     rax
                or      rax, rax
                jnz     bcmd_branch8
                inc     r8
                jmp     _next

b_qbranch16 = 0x13
bcmd_qbranch16: pop     rax
                or      rax, rax
                jnz     bcmd_branch16
                add     r8, 2
                jmp     _next

b_qnbranch8 = 0x14
bcmd_qnbranch8:	pop     rax
                or      rax, rax
                jz	bcmd_branch8
                inc     r8
                jmp     _next

b_qnbranch16 = 0x15
bcmd_qnbranch16:pop     rax
                or      rax, rax
                jz	bcmd_branch16
                add     r8, 2
                jmp     _next

b_bad = 0x00
bcmd_bad:	mov	rax, 1			# системный вызов Ь 1 - sys_write
		mov	rdi, 1			# поток Ь 1 С stdout
		mov	rsi, offset msg_bad_byte # указатель на выводимую строку
		mov	rdx, msg_bad_byte_len	# длина строки
		syscall				# вызов Ядра
		mov	rax, 60			# системный вызов Ь 1 - sys_exit
		mov	rbx, 1			# выход с кодом 1
		syscall				# вызов Ядра

b_bye = 0x01
bcmd_bye:	mov	rax, 1			# системный вызов Ь 1 - sys_write
		mov	rdi, 1			# поток Ь 1 С stdout
		mov	rsi, offset msg_bye	# указатель на выводимую строку
		mov	rdx, msg_bye_len	# длина строки
		syscall				# вызов Ядра
		mov	rax, 60			# системный вызов Ь 60 - sys_exit
		mov	rdi, 0			# выход с кодом 0
		syscall				# вызов Ядра

b_strp = 0x83
bcmd_strp:	movsx	rax, byte ptr [r8]
		inc	r8
		push	r8
		add	r8, rax
		push	rax

b_type = 0x80
bcmd_type:	mov	rax, 1			# системный вызов Ь 1 - sys_write
		mov	rdi, 1			# поток Ь 1 - stdout
		pop	rdx			# длинна буфера
		pop	rsi			# адрес буфера
		push	r8
		syscall				# вызов Ядра
		pop	r8
		jmp	_next

b_expect = 0x88
bcmd_expect:	mov	rax, 0			# системный вызов Ь 1 - sys_read
		mov	rdi, 0			# поток Ь 1 - stdout
		pop	rdx			# длинна буфера
		pop	rsi			# адрес буфера
		push	r8
		syscall				# вызов Ядра
		pop	r8
		mov	rbx, rax
		or	rax, rax
		jge	1f
		xor	rbx, rbx
1:		mov	v_span, rbx
		jmp	_next

b_str = 0x82
bcmd_str:	movzx	rax, byte ptr [r8]
		lea	r8, [r8 + rax + 1]
		jmp	_next

b_count = 0x84
bcmd_count:	pop	rcx
		movzx	rax, byte ptr [rcx]
		inc	rcx
		push	rcx
		push	rax
		jmp	_next
		
b_emit = 0x81
bcmd_emit:	pop	rax
		mov	rsi, offset emit_buf	# адрес буфера
		mov	[rsi], al
		mov	rax, 1			# системный вызов Ь 1 - sys_write
		mov	rdi, 1			# поток Ь 1 - stdout
		mov	rdx, 1			# длинна буфера
		push	r8
		syscall				# вызов Ядра
		pop	r8
		jmp	_next
		
b_blword = 0xF0
bcmd_blword:	mov	rsi, v_tib	# адрес текстового буфера
		mov	rdx, rsi	# сохраним в RDX начало текстового буфера длЯ последующего использованиЯ
		mov	rax, v_in	# смещение в текстовом буфере
		mov	rcx, v_ntib	# размер текстового буфера
		mov	rbx, rcx
		add	rsi, rax	# теперь RSI - указатель на начало обрабатываемого текста
		sub	rcx, rax	# получили количество оставшихсЯ символов
		jz	3f
word2:		lodsb			# загрузка в AL по RSI с инкрементом
		cmp	al, ' '
		ja	1f		# пропускаем все разделители (пробел или с кодом меньше)
		dec	rcx
		jnz	word2		# цикл по пробелам
3:		sub	rsi, rdx
		mov	v_in, rsi
		push	rcx
		jmp	_next
1:		lea	rdi, [rsi - 1]	#  RDI = RSI - 1 (начало слова)
		dec rcx
		jz	word9
word3:		lodsb
		cmp	al, ' '
		jbe	2f
		dec	rcx
		jnz	word3
word9:		inc	rsi
2:		mov	rax, rsi
		sub	rsi, rdx	# смещение на первый символ после первого разделителЯ (длЯ поиска следующего слова)
		cmp	rsi, rbx
		jle	4f
		mov	rsi, rbx
4:		mov	v_in, rsi
		sub	rax, rdi
		dec	rax
		jz	word1
		push	rdi		# начало слова
word1:		push	rax		# длина слова
		jmp	_next

b_quit = 0xF1
bcmd_quit:	lea	r8, quit
		mov	rsp, init_stack
		mov	rbp, init_rstack
		jmp	_next

b_find = 0xF2
bcmd_find:	pop	rbx			# длина имени
		pop	r9			# адрес имени
		mov	rdx, v_context
		mov	rdx, [rdx]		# получили адрес последней словарной статьи длЯ поиска
		# цикл поиска
find0:		mov	al, [rdx]		# флаги
		and	al, 3			# два младших - это вариангт длинны полЯ свЯзи, остальные флаги нас не интересуют, они длЯ компилЯтора
		or	al, al
		jz	find_l8
		cmp	al, 1
		jz	find_l16
		cmp	al, 2
		jz	find_l32
		mov	r10, [rdx + 1]		# смещение 64 бита
		lea	rsi, [rdx + 9]		# адрес имени
		jmp	find1
find_l32:	movsx	r10, dword ptr [rdx + 1] 		# смещение 32 бита
		lea	rsi, [rdx + 5]		# адрес имени
		jmp	find1
find_l16:	movsx	r10, word ptr [rdx + 1]	# смещение 16 бит
		lea	rsi, [rdx + 3]		# адрес имени
		jmp	find1
find_l8:	movsx	r10, byte ptr [rdx + 1]	# смещение 8 бит
		lea	rsi, [rdx + 2]		# адрес имени
find1:		movzx	rax, byte ptr [rsi]	# длина имени из проверЯемой словарной статьи
		cmp	rax, rbx
		jz	find2
		# имЯ не совпало по длине
find3:		or	r10, r10
		jz	find_notfound		# конец поиска, слово не найдено
		add	rdx, r10		# переходим к следующей статье
		jmp	find0
		# длина совпала, сравниваем строки
find2:		inc	rsi
		mov	rdi, r9
		mov	rcx, rax
		repz	cmpsb
		jnz	find3
		# слово найдено
		push	rdx
		jmp	_next
find_notfound:	push	r10
		jmp	_next
		
b_cfa = 0xF3
bcmd_cfa:	pop	rdx			# адрес словарной статьи
		mov	al, [rdx]		# флаги
		and	al, 3			# два младших - это вариангт длинны полЯ свЯзи, остальные флаги нас не интересуют, они длЯ компилЯтора
		or	al, al
		jz	cfa_l8
		cmp	al, 1
		jz	cfa_l16
		cmp	al, 2
		jz	cfa_l32
		lea	rsi, [rdx + 9]		# адрес имени (64 бита ссылка)
		jmp	cfa1
cfa_l32:	lea	rsi, [rdx + 5]		# адрес имени (32 бита ссылка)
		jmp	cfa1
cfa_l16:	lea	rsi, [rdx + 3]		# адрес имени (16 бит ссылка)
		jmp	cfa1
cfa_l8:		lea	rsi, [rdx + 2]		# адрес имени (8 бита ссылка)
cfa1:		xor	rax, rax
		lodsb
		add	rsi, rax
		push	rsi
		jmp	_next

b_execute = 0xF4
bcmd_execute:	sub	rbp, 8
		mov	[rbp], r8		# сохранЯем в стеке возвратов адрес возврата
		pop	r8			# адрес байт-кода
                jmp     _next

b_numberq = 0xF5
bcmd_numberq:	pop	rcx			# длина строки
		pop	rsi			# адрес
		xor	rax, rax		# преобрахуемое число
		xor	rbx, rbx		# тут будет преобразуемаЯ цифра
		mov	r9, v_base		# база
		xor	r10, r10		# знак числа
		or	rcx, rcx
		jz	num_false
		mov	bl, [rsi]
		cmp	bl, '+'
		jnz	1f
		inc	rsi
		dec	rcx
		jz	num_false
		jmp	num0
1:		cmp	bl, '-'
		jnz	num0
		mov	r10, 1
		inc	rsi
		dec	rcx
		jz	num_false
num0:		mov	bl, [rsi]
		cmp	bl, '0'
		jb	num_false
		cmp	bl, '9'
		jbe	num_09
		cmp	bl, 'A'
		jb	num_false
		cmp	bl, 'Z'
		jbe	num_AZ
		cmp	bl, 'a'
		jb	num_false
		cmp	bl, 'z'
		ja	num_false
		sub	bl, 'a' - 10
		jmp	num_check
num_AZ:		sub	bl, 'A' - 10
		jmp	num_check
num_09:		sub	bl, '0'
num_check:	cmp	rbx, r9
		jge	num_false
		mul	r9
		add	rax, rbx
		inc	rsi
		dec	rcx
		jnz	num0
		or	r10, r10
		push	rax
		push	1
		jmp	_next
num_false:	xor	rcx, rcx
		push	rcx
		jmp	_next
