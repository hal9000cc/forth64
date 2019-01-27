.intel_syntax noprefix

stack_size = 1024

f_code = 0x80
f_immediate = 0x40

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

.macro		callb	adr
		.if	\adr > .
			.error	"callb do not for forward!"
		.endif
		.byte	b_call8b0 + (. - \adr + 1) >> 8
		.byte	(. - \adr + 1) & 255
.endm
	
.section .data

data0:

init_stack:	.quad	0
init_rstack:	.quad	0

emit_buf:	.byte	0

inbuf_size = 256

msg_bye:
.ascii "\nBye!\n"
msg_bye_len = . - msg_bye 

bcmd:
.quad		bcmd_bad,	bcmd_bye,	bcmd_num0,	bcmd_num1,	bcmd_num2,	bcmd_num3,	bcmd_num4,	bcmd_num8	# 0x00
.quad		bcmd_lit8,	bcmd_lit16,	bcmd_lit32,	bcmd_lit64,	bcmd_call8f,	bcmd_call16,	bcmd_call32,	bcmd_call64
.quad		bcmd_branch8,	bcmd_branch16,	bcmd_qbranch8,	bcmd_qbranch16,	bcmd_qnbranch8,	bcmd_qnbranch16,bcmd_bad,	bcmd_exit	# 0x10
.quad		bcmd_wp,	bcmd_neg,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad
.quad		bcmd_wm,	bcmd_add,	bcmd_sub,	bcmd_mul,	bcmd_div,	bcmd_mod,	bcmd_divmod,	bcmd_abs	# 0x20
.quad		bcmd_var0,	bcmd_var8,	bcmd_var16,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad
.quad		bcmd_dup,	bcmd_drop,	bcmd_swap,	bcmd_rot,	bcmd_mrot,	bcmd_over,	bcmd_pick,	bcmd_roll	# 0x30
.quad		bcmd_depth,	bcmd_nip,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad 
.quad		bcmd_get,	bcmd_set,	bcmd_get8,	bcmd_set8,	bcmd_get16,	bcmd_set16,	bcmd_get32,	bcmd_set32 	# 0x40
.quad		bcmd_setp,	bcmd_setm,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_neq 
.quad		bcmd_zeq,	bcmd_zlt,	bcmd_zgt,	bcmd_eq,	bcmd_lt,	bcmd_gt,	bcmd_lteq,	bcmd_gteq	# 0x50
.quad		bcmd_and,	bcmd_or,	bcmd_xor,	bcmd_invert,	bcmd_rshift,	bcmd_lshift,	bcmd_bad,	bcmd_bad
.quad		bcmd_2r,	bcmd_r2,	bcmd_rget,	bcmd_rpick,	bcmd_bfind,	bcmd_compare,	bcmd_move,	bcmd_fill	# 0x60
.quad		bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad
.quad		bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad
.quad		bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad
.quad		bcmd_type,	bcmd_emit,	bcmd_str,	bcmd_strp,	bcmd_count,	bcmd_bad,	bcmd_bad,	bcmd_bad	# 0x80
.quad		bcmd_expect,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad
.quad		bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad	# 0x90
.quad		bcmd_do,	bcmd_i,		bcmd_j,		bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad
.quad		bcmd_call8b0,	bcmd_call8b1,	bcmd_call8b2,	bcmd_call8b3,	bcmd_call8b4,	bcmd_call8b5,	bcmd_call8b6,	bcmd_call8b7	# 0xA0
.quad		bcmd_call8b8,	bcmd_call8b9,	bcmd_call8b10,	bcmd_call8b11,	bcmd_call8b12,	bcmd_call8b13,	bcmd_call8b14,	bcmd_call8b15
.quad		bcmd_loop8b0,	bcmd_loop8b1,	bcmd_loop8b2,	bcmd_loop8b3,	bcmd_loop8b4,	bcmd_loop8b5,	bcmd_loop8b6,	bcmd_loop8b7	# 0xB0
.quad		bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad
.quad		bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad
.quad		bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad
.quad		bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad
.quad		bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad
.quad		bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad
.quad		bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad
.quad		bcmd_blword,	bcmd_quit,	bcmd_find,	bcmd_cfa,	bcmd_execute,	bcmd_numberq,	bcmd_word,	bcmd_bad	# 0xF0
.quad		bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_bad,	bcmd_syscall

# forth last_item context @ ! h dup 8 + swap ! quit
start:		.byte	b_call16
		.word	forth - . - 2
		.byte	b_call16
		.word	last_item - . - 2
		.byte	b_call16
		.word	context - . - 2
		.byte	b_get
		.byte	b_set
		.byte	b_call16
		.word	vhere - . - 2
		.byte	b_dup
		.byte	b_call16
		.word	h - . - 2
		.byte	b_set
		.byte	b_call16
		.word	definitions - . - 2
		.byte	b_call16
		.word	tib - . - 2
		.byte	b_set
		.byte	b_lit16
		.word	fcode_end - fcode
		.byte	b_call16
		.word	ntib - . - 2
		.byte	b_set
		.byte	b_call16
		.word	interpret - . - 2
		.byte	b_quit

inbuf:		.byte	b_var0
		.space inbuf_size

		
# begin inbuf dup tib ! inbuf_size expect span @ #tib ! 0 >in ! interpret again
quit:		.byte	b_lit8, 10
		.byte	b_call16
		.word	base - . - 2
		.byte	b_set
		.byte	b_num0
		.byte	b_call16
		.word	state - . - 2
		.byte	b_set
quit0:		.byte	b_strp, 1
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
		.byte	b_dup
		.byte	b_qnbranch8, quit_bye - .
		.byte	b_call16
		.word	ntib - . - 2
		.byte	b_set
		.byte	b_num0
		.byte	b_call16
		.word	bin - . - 2
		.byte	b_set
		.byte	b_call16
		.word	interpret - . - 2
		.byte	b_branch8, quit0 - .
quit_bye:	.byte	b_bye

bad_code:	.byte	b_lit8, 16
		.byte	b_call16
		.word	base - . - 2
		.byte	b_set
		.byte	b_call16
		.word	dot - . - 2
		.byte	b_call16
		.word	dot - . - 2
		.byte	b_strp
		.byte	1f - 0f
0:		.ascii " : bad byte code!"
1:		.byte	b_branch8
		.byte	quit - .

p_item = .
		item	forth
forth:		.byte	b_var8
		.byte	does_voc - .
		.quad	0
does_voc:
		.byte	b_call8f, context - . - 1
		.byte	b_set
		.byte	b_exit

		item	current
current:	.byte	b_var0
		.quad	0

		item	definitions
definitions:	.byte	b_call8f, context - . - 1
		.byte	b_get
		callb	current
		.byte	b_set, b_exit

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
		.quad	31415926897
		.byte	b_exit

		item	call8f, f_code
		.byte	b_call8f
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

		item	call64, f_code
		.byte	b_call64
		.quad	0f - . - 8
0:		.byte	b_exit

		item	call8b0, f_code
		callb	0b
		.byte	b_exit

		item	branch8, f_code
		.byte	b_branch8
		.byte	0f - .
0:		.byte	b_exit
		
		item	branch16, f_code
		.byte	b_branch16
		.word	0f - .
0:		.byte	b_exit
		
		item	"?branch8", f_code
		.byte	b_qbranch8
		.byte	0f - .
0:		.byte	b_exit
		
		item	"?branch16", f_code
		.byte	b_qbranch16
		.word	0f - .
0:		.byte	b_exit
		
		item	"?nbranch8", f_code
		.byte	b_qnbranch8
		.byte	0f - .
0:		.byte	b_exit
		
		item	"?nbranch16", f_code
		.byte	b_qnbranch16
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

		item	rpick, f_code
		.byte	b_rpick
		.byte	b_exit
		
		item	move, f_code
		.byte	b_move
		.byte	b_exit
		
		item	fill, f_code
		.byte	b_fill
		.byte	b_exit

		item	syscall, f_code
		.byte	b_syscall
		.byte	b_exit

		item	compare, f_code
		.byte	b_compare
		.byte	b_exit

		item	bfind, f_code
		.byte	b_bfind
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
		
		item	"<>", f_code
		.byte	b_neq
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
		
		item	and, f_code
		.byte	b_and
		.byte	b_exit
		
		item	or, f_code
		.byte	b_or
		.byte	b_exit

		item	xor, f_code
		.byte	b_xor
		.byte	b_exit
		
		item	invert, f_code
		.byte	b_invert
		.byte	b_exit
		
		item	rshift, f_code
		.byte	b_rshift
		.byte	b_exit
		
		item	lshift, f_code
		.byte	b_lshift
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

		item	blword, f_code
		.byte	b_blword
		.byte	b_exit

		item	word, f_code
		.byte	b_word
		.byte	b_exit
		
		item	find, f_code
		.byte	b_find
		.byte	b_exit

		item	cfa, f_code
		.byte	b_cfa
		.byte	b_exit
		
		item	execute, f_code
		.byte	b_execute
		.byte	b_exit
		
		item	quit
		.byte	b_quit
		
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
hold:		callb	holdpoint	# holdpoint
		.byte	b_get		# @
		.byte	b_wm		# 1-
		.byte	b_dup		# dup
		callb	holdbuf		# holdbuf
		.byte	b_gt		# >
		.byte	b_qbranch8	# if
		.byte	0f - .
		.byte	b_drop		# drop
		.byte	b_drop		# drop
		.byte	b_branch8	# команда перехода на возврат (после then)
		.byte	1f - .
0:		.byte	b_dup		# dup
		callb	holdpoint	# holdpoint
		.byte	b_set		# !
		.byte	b_set8		# c!
1:		.byte	b_exit		# ;

# : # base /mod swap dup 10 < if c" 0 + else 10 - c" A + then hold ;
		item	"#"
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
		.byte	'A' - 10		# c" A
		.byte	b_add			# +
1:		.byte	b_call16
		.word	hold - . - 2		# hold
		.byte	b_exit			# ;

# : <# holdbuf 70 + holdpoint ! ;
		item	'<#'
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
		item	"#s"
conv_s:		callb	conv
		.byte	b_dup
		.byte	b_qbranch8
		.byte	conv_s - .
		.byte	b_exit

# : #> holdpoint @ holdbuf 70 + over - ;
		item	"#>"
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

		item	"."
dot:		.byte	b_dup
		.byte	b_abs
		callb	conv_start
		.byte	b_lit8
		.byte	' '
		.byte	b_call16
		.word	hold - . - 2
		callb	conv_s
		.byte	b_drop
		.byte	b_zlt
		.byte	b_qnbranch8
		.byte	1f - .
		.byte	b_lit8
		.byte	'-'
		.byte	b_call16
		.word	hold - . - 2
1:		callb	conv_end
		.byte	b_type
		.byte	b_exit

		item	tib
tib:		.byte	b_var0
v_tib:		.quad	0

		item	"#tib"
ntib:		.byte	b_var0
v_ntib:		.quad	0

		item	">in"
bin:		.byte	b_var0
v_in:		.quad	0

# : .s depth dup . c": emit do dup while dup pick . 1- again drop ;
		item	".s"		# 11 22 33
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

		item	state
state:		.byte	b_var0
		.quad	0

		item	"]"
		.byte	b_num1
		callb	state
		.byte	b_set, b_exit
		
		item	"[", f_immediate
		.byte	b_num0
		callb	state
		.byte	b_set, b_exit
		
		item	test_bvc
test_bvc:	.byte	b_dup, b_neg
		.byte	b_num0
		.byte	b_gteq
		.byte	b_over
		.byte	b_lit16
		.word	0x3ff
		.byte	b_lteq
		.byte	b_and
		.byte	b_qnbranch8, 1f - .
		.byte	b_num0
		.byte	b_exit
		
		item	test_bv
test_bv:	.byte	b_dup, b_lit8,  0x80, b_gteq, b_over, b_lit8, 0x7f, b_lteq, b_and, b_qnbranch8, 1f - ., b_num0
		.byte	b_exit

1:		.byte	b_dup
		.byte	b_lit16
		.word	0x8001
		.byte	b_gteq
		.byte	b_over
		.byte	b_lit16
		.word	0x7ffe
		.byte	b_lteq, b_and, b_qnbranch8, 2f - ., b_num1, b_exit
		
2:		.byte	b_dup
		.byte	b_lit32
		.int	0x80000002
		.byte	b_gteq
		.byte	b_over
		.byte	b_lit32
		.int	0x7ffffffd
		.byte	b_lteq, b_and, b_qnbranch8, 3f - ., b_num2, b_exit
		
3:		.byte	b_num3
		.byte	b_exit
		
		.byte	b_num0, b_exit
		
		item	h
h:		.byte	b_var0
		.quad	0

		item	here
here:		callb	h
		.byte	b_get
		.byte	b_exit
		
# : allot h +! ;
		item	allot
allot:		callb	h
		.byte	b_setp, b_exit

# : , here ! 8 allot ;
		item	","
c_64:		callb	here
		.byte	b_set, b_num8
		callb	allot
		.byte	b_exit
		
# : i, here w! 4 allot ;
		item	"i,"
c_32:		callb	here
		.byte	b_set32, b_num4
		callb	allot
		.byte	b_exit
		
# : w, here w! 2 allot ;
		item	"w,"
c_16:		callb	here
		.byte	b_set16, b_num2
		callb	allot
		.byte	b_exit
		
# : c, here c! 1 allot ;
		item	"c,"
c_8:		callb	here
		.byte	b_set8, b_num1
		callb	allot
		.byte	b_exit

# компиляция байт-кода		
# : compile_bf here 1+  ;
		item	compile_c
compile_c:	.byte	b_get8
		callb	c_8
		.byte	b_exit

# компиляция значения в один, два, четыре или восемь байт
# на стеке значение и байт, полученный test_dv
		item	compile_1248
compile_1248:	.byte	b_dup
		.byte	b_zeq
		.byte	b_qnbranch8, 1f - .
		.byte	b_drop
		callb	c_8
		.byte	b_exit
1:		.byte	b_dup, b_num1, b_eq, b_qnbranch8, 2f - .
		.byte	b_drop
		callb	c_16
		.byte	b_exit
2:		.byte	b_num2, b_eq, b_qnbranch8, 3f - .
		callb	c_32
		.byte	b_exit
3:		callb	c_64
		.byte	b_exit

# компиляция числа
		item	compile_n
compile_n:	callb	test_bv
		.byte	b_dup
		.byte	b_zeq
		.byte	b_qnbranch8, 1f - .
		.byte	b_drop, b_lit8, b_lit8
		callb	c_8
		callb	c_8
		.byte	b_exit
1:		.byte	b_dup, b_num1, b_eq, b_qnbranch8, 2f - ., b_drop, b_lit8, b_lit16
		callb	c_8
		callb	c_16
		.byte	b_exit
2:		.byte	b_num2, b_eq, b_qnbranch8, 3f - ., b_lit8, b_lit32
		callb	c_8
		callb	c_32
		.byte	b_exit
3:		.byte	b_lit8, b_lit64
		callb	c_8
		callb	c_64
		.byte	b_exit

# компиляция вызова байт-кода
		item	compile_b
compile_b:	callb here
		.byte	b_num2, b_add
		.byte	b_sub
		callb	test_bvc
		.byte	b_dup
		.byte	b_zeq
		.byte	b_qnbranch8, 1f - .
		.byte	b_drop
		.byte	b_neg
		.byte	b_dup
		.byte	b_lit8, 8
		.byte	b_rshift
		.byte	b_lit8, b_call8b0
		.byte	b_or
		callb	c_8
		callb	c_8
		.byte	b_exit
1:		.byte	b_dup, b_num1, b_eq, b_qnbranch8, 2f - ., b_drop, b_lit8, b_call16
		callb	c_8
		.byte	b_wm
		callb	c_16
		.byte	b_exit
2:		.byte	b_num2, b_eq, b_qnbranch8, 3f - ., b_lit8, b_call32
		callb	c_8
		.byte	b_num2, b_sub
		callb	c_32
		.byte	b_exit
3:		.byte	b_lit8, b_call64
		callb	c_8
		.byte	b_num3, b_sub
		callb	c_64
		.byte	b_exit

#: $compile dup c@ 0x80 and if cfa compile_c else cfa compile_b then ;
		item	"$compile"
_compile:	.byte	b_dup, b_get8, b_lit8, 0x80, b_and, b_qnbranch8, 1f - ., b_cfa
		callb	compile_c
		.byte	b_exit
1:		.byte	b_cfa
		callb	compile_b
		.byte	b_exit

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
		callb	state
		.byte	b_get
		.byte	b_qnbranch8, irpt_execute - .	# если 0, поехали на исполнение
		.byte	b_dup, b_get8, b_lit8, f_immediate, b_and # вытащили immediate из флагов слова
		.byte	b_qbranch8, irpt_execute - .	# если флаг установлен - на исполнение
		# все сложилосьб компилируем!
		callb	_compile
		.byte	b_branch8, 2f - .
irpt_execute:	.byte	b_cfa				# сюда попадаем, когда надо исполнять (state = 0 или immediate слова установлен)
		.byte	b_execute
		.byte	b_branch8, 2f - .
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
3:		.byte	b_nip, b_nip	# удалим значения, сохраненные для печати слова (команды b_over, b_over)
		# в стеке - преобразованное число
		callb	state		# проверим, компиляция или исполнение
		.byte	b_get
		.byte	b_qnbranch8, 2f - . # если исполнение - больше ничего делать не нужно; на проверку - и выход
		# компиляция числа
		callb	compile_n
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

# : str, dup -rot dup c, here swap move 1+ h +!;
		item	"str,"
c_str:		.byte	b_dup, b_mrot, b_dup
		callb	c_8
		callb	here
		.byte	b_swap, b_move
		callb	h
		.byte	b_setp
		.byte	b_exit

# : : here blword dup ifnot drop drop ." error - name" exit then here current @ @ - test_bv dup c, compile_1248 str, current @ ! ' exit c, 1 state ! 128 ; immediate
		item	":", f_immediate
colon:		callb	here
		.byte	b_blword
		.byte	b_dup
		.byte	b_qbranch8
		.byte	1f - .
		.byte	b_drop, b_drop
		.byte	b_strp			# не получили слово из входного потока
		.byte	3f - 2f			# это длинна сообщениЯ ниже
2:		.ascii	"name not found!\n"
3:		.byte	b_exit
1:		callb	current
		.byte	b_get, b_get
		callb	here
		.byte	b_sub
		callb	test_bv
		.byte	b_dup
		callb	c_8
		callb	compile_1248
		callb	c_str
		callb	current
		.byte	b_get, b_set
		.byte	b_lit8, b_exit
		callb	here
		.byte	b_set8
		.byte	b_num1
		callb	state
		.byte	b_set
		.byte	b_lit8, 110
		.byte	b_exit

#: ?pairs = ifnot exit then ." \nerror: no pairs operators" quit then ;
		item	"?pairs"
		.byte	b_eq, b_qbranch8, 1f - .
		.byte	b_strp
		.byte	3f - 2f
2:		.ascii	"\nerror: no pairs operators"
3:		.byte	b_quit
1:		.byte	b_exit

#: ?state state @ 0= if abort" error: no compile state" then ;
		item	"?state"
		callb	state
		.byte	b_get, b_zeq, b_qnbranch8, 1f - .
		.byte	b_strp
		.byte	3f - 2f
2:		.ascii	"\nerror: no compile state"
3:		.byte	b_quit
1:		.byte	b_exit

last_item:	.byte	b_var0
		item	bye, f_code
		.byte	b_bye
vhere:		.byte	b_var0
fcode:		.ascii	"                

: ; ?state 110 ?pairs lit8 [ blword exit find cfa c@ c, ] c, 0 state ! exit [ current @ @ dup c@ 96 or swap c! drop

: immediate current @ @ dup c@ 96 or swap c! ;

: hex 16 base ! ;
: decimal 10 base ! ;
: bl 32 ;
: tab 9 ;

: cmove over c@ 1+ move ;

: if ?state lit8 [ blword ?nbranch8 find cfa c@ c, ] c, here 0 c, 111 ; immediate
: then 111 ?state ?pairs dup here swap - swap c! ; immediate
: else ?state 111 ?pairs lit8 [ blword branch8 find cfa c@ c, ] c, here 0 c, swap dup here swap - swap c! 111 ; immediate

: .\" 34 word dup if lit8 [ blword (.\") find cfa c@ c, ] c, str, else drop then ; immediate

: (compile_c) r> dup c@ swap 1+ >r c, ;
: (compile_b) r> dup @ swap 8 + >r compile_b ;

: compile
	blword over over find dup
	if
		dup c@ 128 and
			if cfa c@ (compile_b) [ blword (compile_c) find cfa , ] c,
			else cfa (compile_b) [ blword (compile_b) find cfa , ] , then
		drop drop
	else
		drop .\" compile: \" type .\"  - not found\"
	then
; immediate

: ifnot ?state compile ?branch8 here 0 c, 111 ; immediate

: begin ?state here 112 ; immediate
: until ?state 112 ?pairs compile ?nbranch8 here - c, ; immediate
: while ?state 112 ?pairs compile ?nbranch8 here 0 c, 113 ; immediate
: repeat ?state 113 ?pairs swap compile branch8 here - c, dup here swap - swap c! ; immediate

: link@ dup c@ 3 and swap 1+ swap 
	dup 0= if drop dup 1+ swap c@ else
	dup 1 = if drop dup 2 + swap w@ else
	2 = if drop dup 4 + swap i@ else
	drop dup 8 + swap @
	then then then ;
	
: words context @ @ 0
	begin
		+ dup link@
		swap count type tab emit
		dup 0=
	until
drop drop ;

: file_open 0 0 0 2 syscall ;
: file_close 0 0 0 0 0 3 syscall ;
: file_read 0 0 0 0 syscall ;
: file_O_RDONLY 0 ;
: file_O_WRONLY 1 ;
: file_O_RDWR 3 ;

: _start
	0 pick 1 > if
		2 pick file_O_RDONLY 0 file_open
		dup 0< if .\" error: \" . quit then
		dup here 32 + 32768 file_read
		dup 0< if .\" error: \" . quit then
		swap file_close drop
		#tib ! here 32 + tib ! 0 >in ! interpret
	then
;

_start

quit"
fcode_end:

.bss
		.space	65536
		
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

b_call8f = 0x0C
bcmd_call8f:	movzx   rax, byte ptr [r8]
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

b_call64 = 0x0F
bcmd_call64:    movsx   rax, dword ptr [r8]
                sub     rbp, 8
                add     r8, 8
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

b_neg = 0x19
bcmd_neg:	negq	[rsp]
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
		mov	rbx, [rsp + 8 * rcx]
roll1:		mov	rax, [rsp + 8 * rcx - 8]
		mov	[rsp + 8 * rcx], rax
		dec	rcx
		jnz	roll1
		add	rsp, 8
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
		
b_rpick = 0x63
bcmd_rpick:	pop	rcx
		push	[rbp + rcx * 8]
		jmp	_next
		
b_compare = 0x64
bcmd_compare:	pop	rcx
		pop	rsi
		pop	rdi
		repz	cmpsb
		jnz	1f
		push	-1
		jmp	_next
1:		xor	rax,rax
		push	rax
		jmp	_next
		
b_bfind = 0x65
bcmd_bfind:	pop	rax
		pop	rcx
		pop	rdi
		repnz	scasb
		jnz	1f
		push	rdi
		push	-1
		jmp	_next
1:		xor	rax,rax
		push	rax
		jmp	_next

b_move = 0x66
bcmd_move:	pop	rcx
		pop	rdi
		pop	rsi
		repz	movsb
		jmp	_next

b_fill = 0x67
bcmd_fill:	pop	rax
		pop	rcx
		pop	rdi
		repz	stosb
		jmp	_next

b_syscall = 0xFF
bcmd_syscall:	sub	rbp, 8
		mov	[rbp], r8
		pop	rax
		pop	r9
		pop	r8
		pop	r10
		pop	rdx
		pop	rsi
		pop	rdi
		syscall
		push	rax
		mov	r8, [rbp]
		add	rbp, 8
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

# <>
b_neq = 0x4F
bcmd_neq:	pop	rbx
		pop	rax
		cmp	rax, rbx
		jnz	rtrue
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

b_and = 0x58
bcmd_and:	pop	rax
		and	[rsp], rax
		jmp	_next

b_or = 0x59
bcmd_or:	pop	rax
		or	[rsp], rax
		jmp	_next

b_xor = 0x5A
bcmd_xor:	pop	rax
		xor	[rsp], rax
		jmp	_next

b_invert = 0x5B
bcmd_invert:	notq	[rsp]
		jmp	_next

b_rshift = 0x5C
bcmd_rshift:	pop	rcx
		or	rcx, rcx
		jz	_next
1:		shrq	[rsp]
		dec	rcx
		jnz	1b
		jmp	_next

b_lshift = 0x5D
bcmd_lshift:	pop	rcx
		or	rcx, rcx
		jz	_next
1:		shlq	[rsp]
		dec	rcx
		jnz	1b
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
bcmd_branch16:  movsx	rax, word ptr [r8]
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

b_bye = 0x01
bcmd_bye:	mov	rax, 1			# системный вызов № 1 - sys_write
		mov	rdi, 1			# поток № 1 С stdout
		mov	rsi, offset msg_bye	# указатель на выводимую строку
		mov	rdx, msg_bye_len	# длина строки
		syscall				# вызов ядра
		mov	rax, 60			# системный вызов № 60 - sys_exit
		mov	rdi, 0			# выход с кодом 0
		syscall				# вызов ядра

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
		
b_do = 0x98
bcmd_do:	pop	rax
		pop	rbx
		sub	rbp, 16
		mov	[rbp + 8], rbx
		mov	[rbp], rax
                jmp     _next
		
b_i = 0x99
bcmd_i:		push	[rbp]
		jmp	_next

b_j = 0x9A
bcmd_j:		push	[rbp + 8 * 2]
		jmp	_next

b_loop8b0 = 0xB0
bcmd_loop8b0:	mov	rax, [rbp]
		inc	rax
		mov	[rbp], rax
		cmp	rax, [rbp + 8]
		jae	loop_exit
                movzx	rax, byte ptr [r8]
		sub	r8, rax
                jmp     _next
loop_exit:	add	rbp, 16
		inc	r8
		jmp	_next

.macro		loop8b	N
		
b_loop8b\N = 0xB\N
bcmd_loop8b\N:	mov	rax, [rbp]
		inc	rax
		mov	[rbp], rax
		cmp	rax, [rbp + 8]
		jl	loop_exit\N
		sub	r8, \N * 256
                movzx	rax, byte ptr [r8]
		sub	r8, rax
                jmp     _next
loop_exit\N:	add	rbp, 16
		inc	r8
		jmp	_next
.endm

		loop8b	1
		loop8b	2
		loop8b	3
		loop8b	4
		loop8b	5
		loop8b	6
		loop8b	7

b_call8b0 = 0xA0
bcmd_call8b0:	movzx   rax, byte ptr [r8]
                sub     rbp, 8
                inc     r8
                mov     [rbp], r8
                sub     r8, rax
                jmp     _next
		
.macro		call8b	N

b_call8b\N = 0xA\N
bcmd_call8b\N:	movzx   rax, byte ptr [r8]
                sub     rbp, 8
                inc     r8
		add	rax, \N * 256
                mov     [rbp], r8
                sub     r8, rax
                jmp     _next
.endm

		call8b	1
		call8b	2
		call8b	3
		call8b	4
		call8b	5
		call8b	6
		call8b	7
		call8b	8
		call8b	9
		call8b	10
		call8b	11
		call8b	12
		call8b	13
		call8b	14
		call8b	15

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
		sub	rsi, rdx	# смещение на первый символ после первого разделителЯ (для поиска следующего слова)
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

b_word = 0xF6
bcmd_word:	pop	r9		# разделитель
		mov	rsi, v_tib	# адрес текстового буфера
		mov	rdx, rsi	# сохраним в RDX начало текстового буфера длЯ последующего использованиЯ
		mov	rax, v_in	# смещение в текстовом буфере
		mov	rcx, v_ntib	# размер текстового буфера
		mov	rbx, rcx
		add	rsi, rax	# теперь RSI - указатель на начало обрабатываемого текста
		sub	rcx, rax	# получили количество оставшихсЯ символов
		jz	3f
wd2:		lodsb			# загрузка в AL по RSI с инкрементом
		cmp	al, r9b
		jnz	1f		# пропускаем все разделители (пробел или с кодом меньше)
		dec	rcx
		jnz	wd2		# цикл по пробелам
3:		sub	rsi, rdx
		mov	v_in, rsi
		push	rcx
		jmp	_next
1:		lea	rdi, [rsi - 1]	#  RDI = RSI - 1 (начало слова)
		dec rcx
		jz	wd9
wd3:		lodsb
		cmp	al, r9b
		jz	2f
		dec	rcx
		jnz	wd3
wd9:		inc	rsi
2:		mov	rax, rsi
		sub	rsi, rdx	# смещение на первый символ после первого разделителЯ (для поиска следующего слова)
		cmp	rsi, rbx
		jle	4f
		mov	rsi, rbx
4:		mov	v_in, rsi
		sub	rax, rdi
		dec	rax
		jz	wd1
		push	rdi		# начало слова
wd1:		push	rax		# длина слова
		jmp	_next

b_quit = 0xF1
bcmd_quit:	lea	r8, quit
		mov	rsp, init_stack
		mov	rbp, init_rstack
		jmp	_next

b_bad = 0x00
bcmd_bad:	mov	rsp, init_stack
		mov	rbp, init_rstack
		dec	r8
		movzx	rax, byte ptr [r8]
		sub	r8, offset data0
		push	rax
		push	r8
		lea	r8, bad_code
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
		jz	2f
		neg	rax
2:		push	rax
		push	1
		jmp	_next
num_false:	xor	rcx, rcx
		push	rcx
		jmp	_next
