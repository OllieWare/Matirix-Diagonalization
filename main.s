	.arch armv7-a
	.eabi_attribute 28, 1
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 2
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"main.c"
	.text
	.align	2
	.global	categorize_angle
	.arch armv7-a
	.syntax unified
	.arm
	.fpu neon
	.type	categorize_angle, %function
categorize_angle:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	sub	r3, r0, #16384
	cmp	r3, #0
	eor	r2, r0, r0, asr #31
	rsblt	r3, r3, #0
	sub	r2, r2, r0, asr #31
	cmp	r2, r3
	blt	.L3
	rsb	r0, r0, #32512
	add	r0, r0, #255
	cmp	r3, r0
	movge	r0, #2
	movlt	r0, #1
	bx	lr
.L3:
	mov	r0, #0
	bx	lr
	.size	categorize_angle, .-categorize_angle
	.align	2
	.global	set_rotation
	.syntax unified
	.arm
	.fpu neon
	.type	set_rotation, %function
set_rotation:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	movw	r3, #:lower16:.LANCHOR0
	add	r0, r0, r0, lsl #1
	movt	r3, #:upper16:.LANCHOR0
	add	r3, r3, r0, lsl #2
	ldr	r2, [r3, #4]
	ldrsh	r0, [r3, #8]
	rsb	r1, r2, #0
	sub	sp, sp, #16
	sxth	r3, r2
	sxth	r1, r1
	strh	r3, [sp, #12]	@ movhi
	strh	r3, [sp, #2]	@ movhi
	strh	r0, [sp, #8]	@ movhi
	strh	r0, [sp, #14]	@ movhi
	strh	r0, [sp]	@ movhi
	strh	r0, [sp, #6]	@ movhi
	strh	r1, [sp, #10]	@ movhi
	strh	r1, [sp, #4]	@ movhi
	movw	r2, #:lower16:rot_left
	movw	r3, #:lower16:rot_right
	vldr	d17, [sp, #8]
	vldr	d16, [sp]
	movt	r2, #:upper16:rot_left
	movt	r3, #:upper16:rot_right
	vstr	d17, [r2]
	vstr	d16, [r3]
	add	sp, sp, #16
	@ sp needed
	bx	lr
	.size	set_rotation, .-set_rotation
	.align	2
	.global	arctan
	.syntax unified
	.arm
	.fpu neon
	.type	arctan, %function
arctan:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	add	r3, r0, #32768
	cmp	r3, #65536
	eorcc	ip, r0, r0, asr #31
	movcc	r2, #0
	movcs	r2, #1
	subcc	ip, ip, r0, asr #31
	movwcs	ip, #32767
	mov	r0, #0
	ldr	r3, .L14
	str	r2, [r1]
.L11:
	ldr	r2, [r3], #4
	cmp	r2, ip
	bxge	lr
	add	r0, r0, #1
	cmp	r0, #46
	bne	.L11
	mvn	r0, #0
	bx	lr
.L15:
	.align	2
.L14:
	.word	.LANCHOR0+552
	.size	arctan, .-arctan
	.align	2
	.global	cos_t
	.syntax unified
	.arm
	.fpu neon
	.type	cos_t, %function
cos_t:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	movw	r3, #:lower16:.LANCHOR0
	add	r0, r0, r0, lsl #1
	movt	r3, #:upper16:.LANCHOR0
	add	r3, r3, r0, lsl #2
	ldr	r0, [r3, #8]
	bx	lr
	.size	cos_t, .-cos_t
	.align	2
	.global	sin_t
	.syntax unified
	.arm
	.fpu neon
	.type	sin_t, %function
sin_t:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	movw	r3, #:lower16:.LANCHOR0
	add	r0, r0, r0, lsl #1
	movt	r3, #:upper16:.LANCHOR0
	add	r3, r3, r0, lsl #2
	ldr	r0, [r3, #4]
	bx	lr
	.size	sin_t, .-sin_t
	.align	2
	.global	get_rotatation
	.syntax unified
	.arm
	.fpu neon
	.type	get_rotatation, %function
get_rotatation:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	movw	r3, #:lower16:.LANCHOR0
	vldr	d16, [r0]
	add	r2, r1, r1, lsl #1
	movt	r3, #:upper16:.LANCHOR0
	add	r3, r3, r2, lsl #2
	ldr	r2, [r3, #8]
	cmp	r1, #0
	vmov.32	d16[0], r2
	vstr	d16, [r0]
	blt	.L19
	ldr	r2, [r3, #4]
	vldr	d17, [r0, #8]
	rsb	r2, r2, #0
	vmov.32	d16[1], r2
	vstr	d16, [r0]
	vmov	d16, d17  @ v2si
	add	r2, r3, #4
	vld1.32	{d16[0]}, [r2]
	vstr	d16, [r0, #8]
	add	r3, r3, #8
	vld1.32	{d16[1]}, [r3]
	vstr	d16, [r0, #8]
	bx	lr
.L19:
	add	r2, r3, #4
	vld1.32	{d16[1]}, [r2]
	vstr	d16, [r0]
	vldr	d16, [r0, #8]
	ldr	r2, [r3, #4]
	add	r3, r3, #8
	rsb	r2, r2, #0
	vmov.32	d16[0], r2
	vstr	d16, [r0, #8]
	vld1.32	{d16[1]}, [r3]
	vstr	d16, [r0, #8]
	bx	lr
	.size	get_rotatation, .-get_rotatation
	.align	2
	.global	transpose_32x2
	.syntax unified
	.arm
	.fpu neon
	.type	transpose_32x2, %function
transpose_32x2:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	vldr	d18, [r0]
	vldr	d19, [r0, #8]
	vmov	d17, d18  @ v2si
	vmov	d16, d19  @ v2si
	vuzp.32	d17, d16
	vstr	d17, [r0]
	vstr	d16, [r0, #8]
	bx	lr
	.size	transpose_32x2, .-transpose_32x2
	.align	2
	.global	saturate_q15
	.syntax unified
	.arm
	.fpu neon
	.type	saturate_q15, %function
saturate_q15:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	cmp	r0, #32768
	sbcs	r3, r1, #0
	bge	.L24
	push	{r4, r5}
	mov	r4, #32768
	mvn	r5, #0
	mov	r3, #32768
	movt	r4, 65535
	cmp	r0, r4
	sbcs	r2, r1, r5
	pop	{r4, r5}
	movt	r3, 65535
	movlt	r0, r3
	bx	lr
.L24:
	movw	r0, #32767
	bx	lr
	.size	saturate_q15, .-saturate_q15
	.align	2
	.global	get_lane
	.syntax unified
	.arm
	.fpu neon
	.type	get_lane, %function
get_lane:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	cmp	r0, #3
	ldrls	pc, [pc, r0, asl #2]
	b	.L37
.L33:
	.word	.L36
	.word	.L35
	.word	.L34
	.word	.L32
.L32:
	vmov.32	r0, d1[1]
	bx	lr
.L34:
	vmov.32	r0, d1[0]
	bx	lr
.L35:
	vmov.32	r0, d0[1]
	bx	lr
.L36:
	vmov.32	r0, d0[0]
	bx	lr
.L37:
	mov	r0, #0
	bx	lr
	.size	get_lane, .-get_lane
	.align	2
	.global	set_lane
	.syntax unified
	.arm
	.fpu neon
	.type	set_lane, %function
set_lane:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	cmp	r1, #3
	ldrls	pc, [pc, r1, asl #2]
	b	.L38
.L41:
	.word	.L44
	.word	.L43
	.word	.L42
	.word	.L40
.L40:
	vmov.32	d1[1], r0
.L38:
	bx	lr
.L42:
	vmov.32	d1[0], r0
	bx	lr
.L43:
	vmov.32	d0[1], r0
	bx	lr
.L44:
	vmov.32	d0[0], r0
	bx	lr
	.size	set_lane, .-set_lane
	.section	.rodata
	.align	3
.LC1:
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.text
	.align	2
	.global	matrix_multiply_4x4
	.syntax unified
	.arm
	.fpu neon
	.type	matrix_multiply_4x4, %function
matrix_multiply_4x4:
	@ args = 0, pretend = 0, frame = 120
	@ frame_needed = 0, uses_anonymous_args = 0
	movw	r3, #:lower16:.LC1
	vldr	d22, [r1, #32]
	vldr	d23, [r1, #40]
	vld1.64	{d26-d27}, [r1:64]
	vldr	d24, [r1, #16]
	vldr	d25, [r1, #24]
	movt	r3, #:upper16:.LC1
	vldr	d20, [r1, #48]
	vldr	d21, [r1, #56]
	vldmia	r3, {d0-d7}
	push	{r4, r5, r6, r7, r8, r9, r10, fp, lr}
	mov	fp, r0
	vmov.32	r10, d22[0]
	sub	sp, sp, #124
	add	r3, sp, #36
	vst1.32	{d27[0]}, [r3]
	add	r3, sp, #40
	vst1.32	{d26[0]}, [r3]
	add	r3, sp, #44
	vst1.32	{d24[0]}, [r3]
	add	r3, sp, #48
	vst1.32	{d21[0]}, [r3]
	add	r3, sp, #56
	vstmia	r3, {d0-d7}
	mov	r6, r3
	add	r3, r0, #64
	str	r2, [sp, #52]
	str	r3, [sp, #32]
.L72:
	vld1.64	{d18-d19}, [fp:64]
	vmov.32	r0, d18[0]
	vmov.32	lr, d18[1]
	ldr	r3, [sp, #40]
	ldr	r1, [sp, #44]
	smull	r2, r3, r0, r3
	vmov.32	ip, d19[0]
	strd	r2, [sp]
	smlal	r2, r3, r1, lr
	ldr	r1, [sp, #36]
	strd	r2, [sp, #8]
	smull	r4, r5, r0, r1
	mov	r1, #0
	smlal	r2, r3, r10, ip
	cmp	r1, #2
	strd	r4, [sp, #24]
	mov	r8, r2
	mov	r9, r3
	vmov.i32	q8, #0  @ v4si
	str	r6, [sp, #20]
	beq	.L55
.L126:
	cmp	r1, #3
	beq	.L56
	cmp	r1, #1
	beq	.L123
	ldrd	r2, [sp]
	cmp	r1, #2
	beq	.L60
	cmp	r1, #3
	beq	.L59
	cmp	r1, #1
	beq	.L61
	ldrd	r2, [sp, #8]
	cmp	r1, #2
	beq	.L64
	cmp	r1, #3
	beq	.L63
	cmp	r1, #1
	beq	.L65
	cmp	r1, #2
	mov	r2, r8
	mov	r3, r9
	vmov.32	r4, d19[1]
	beq	.L68
	cmp	r1, #3
	beq	.L67
	cmp	r1, #1
	beq	.L69
	vmov.32	r3, d20[0]
	mov	r6, r8
	mov	r7, r9
	smlal	r6, r7, r3, r4
	adds	r4, r6, #16384
	adc	r5, r7, #0
	lsr	r2, r4, #15
	orr	r2, r2, r5, lsl #17
	asr	r3, r5, #15
	cmp	r2, #32768
	sbcs	r4, r3, #0
	bge	.L124
.L71:
	mov	r4, #32768
	mvn	r5, #0
	mov	r7, #32768
	movt	r4, 65535
	cmp	r2, r4
	sbcs	r4, r3, r5
	movt	r7, 65535
	movlt	r2, r7
.L48:
	cmp	r1, #2
	beq	.L49
	cmp	r1, #3
	beq	.L121
	cmp	r1, #1
	beq	.L51
	cmp	r1, #3
	vmov.32	d16[0], r2
	beq	.L125
.L52:
	add	r1, r1, #1
	cmp	r1, #2
	bne	.L126
.L55:
	ldrd	r2, [sp, #24]
.L60:
	vmov.32	r4, d25[0]
	smlal	r2, r3, r4, lr
.L64:
	vmov.32	r4, d23[0]
	smlal	r2, r3, ip, r4
	vmov.32	r4, d19[1]
.L68:
	ldr	r5, [sp, #48]
	smlal	r2, r3, r4, r5
	adds	r4, r2, #16384
	adc	r5, r3, #0
	lsr	r2, r4, #15
	orr	r2, r2, r5, lsl #17
	asr	r3, r5, #15
	cmp	r2, #32768
	sbcs	r4, r3, #0
	blt	.L71
	movw	r2, #32767
.L49:
	vmov.32	d17[0], r2
	b	.L52
.L121:
	ldr	r6, [sp, #20]
.L50:
	vmov.32	d17[1], r2
.L53:
	ldr	r3, [sp, #32]
	add	fp, fp, #16
	cmp	fp, r3
	vst1.64	{d16-d17}, [r6:64]!
	bne	.L72
	ldr	lr, [sp, #52]
	add	r4, sp, #56
	add	r5, sp, #120
.L73:
	mov	ip, r4
	ldmia	ip!, {r0, r1, r2, r3}
	cmp	ip, r5
	str	r0, [lr]	@ unaligned
	str	r1, [lr, #4]	@ unaligned
	str	r2, [lr, #8]	@ unaligned
	str	r3, [lr, #12]	@ unaligned
	mov	r4, ip
	add	lr, lr, #16
	bne	.L73
	add	sp, sp, #124
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r9, r10, fp, pc}
.L123:
	vmov.32	r2, d26[1]
	smull	r2, r3, r0, r2
.L61:
	vmov.32	r4, d24[1]
	smlal	r2, r3, r4, lr
.L65:
	vmov.32	r4, d22[1]
	smlal	r2, r3, ip, r4
	vmov.32	r4, d19[1]
.L69:
	vmov.32	r5, d20[1]
	smlal	r2, r3, r4, r5
	adds	r4, r2, #16384
	adc	r5, r3, #0
	lsr	r2, r4, #15
	orr	r2, r2, r5, lsl #17
	asr	r3, r5, #15
	cmp	r2, #32768
	sbcs	r4, r3, #0
	blt	.L71
	movw	r2, #32767
.L51:
	vmov.32	d16[1], r2
	b	.L52
.L56:
	vmov.32	r2, d27[1]
	smull	r2, r3, r2, r0
.L59:
	vmov.32	r4, d25[1]
	smlal	r2, r3, lr, r4
.L63:
	vmov.32	r4, d23[1]
	smlal	r2, r3, r4, ip
	vmov.32	r4, d19[1]
.L67:
	vmov.32	r5, d21[1]
	smlal	r2, r3, r5, r4
	adds	r4, r2, #16384
	adc	r5, r3, #0
	lsr	r2, r4, #15
	orr	r2, r2, r5, lsl #17
	asr	r3, r5, #15
	cmp	r2, #32768
	sbcs	r4, r3, #0
	blt	.L71
	ldr	r6, [sp, #20]
	movw	r2, #32767
	b	.L50
.L124:
	movw	r2, #32767
	b	.L48
.L125:
	ldr	r6, [sp, #20]
	b	.L53
	.size	matrix_multiply_4x4, .-matrix_multiply_4x4
	.align	2
	.global	matrix_multiply
	.syntax unified
	.arm
	.fpu neon
	.type	matrix_multiply, %function
matrix_multiply:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	vldr	d16, [r1, #8]
	vldr	d19, [r0]
	vldr	d18, [r1]
	vldr	d17, [r0, #8]
	push	{r4, r5, r6, r7, r8, r9, r10, fp, lr}
	vmov.32	lr, d19[1]
	vmov.32	r6, d16[0]
	vmov.32	r3, d16[1]
	vmov.32	r10, d18[1]
	vmov.32	ip, d17[1]
	vmov.32	r0, d19[0]
	vmov.32	r4, d18[0]
	vmov.32	r1, d17[0]
	mul	r6, lr, r6
	mul	lr, lr, r3
	mul	r3, ip, r3
	mul	ip, ip, r10
	mla	r6, r0, r4, r6
	mla	r0, r0, r10, lr
	mla	r4, r1, r4, ip
	mla	r10, r1, r10, r3
	asr	r7, r6, #31
	adds	r8, r6, #16384
	adc	r9, r7, #0
	asr	r1, r0, #31
	lsr	r6, r8, #15
	adds	r8, r0, #16384
	asr	r5, r4, #31
	orr	r6, r6, r9, lsl #17
	asr	r7, r9, #15
	adc	r9, r1, #0
	adds	r0, r4, #16384
	asr	fp, r10, #31
	adc	r1, r5, #0
	mov	r4, r0
	adds	r0, r10, #16384
	mov	r5, r1
	mov	r10, r0
	adc	r1, fp, #0
	mov	fp, r1
	cmp	r6, #32768
	lsr	r0, r8, #15
	lsr	r4, r4, #15
	lsr	r10, r10, #15
	sbcs	r3, r7, #0
	orr	r4, r4, r5, lsl #17
	orr	r10, r10, fp, lsl #17
	orr	r0, r0, r9, lsl #17
	asr	r1, r9, #15
	asr	r5, r5, #15
	asr	fp, fp, #15
	movwge	r6, #32767
	bge	.L128
	mov	r8, #32768
	mvn	r9, #0
	mov	r3, #32768
	movt	r8, 65535
	cmp	r6, r8
	sbcs	ip, r7, r9
	movt	r3, 65535
	movlt	r6, r3
.L128:
	cmp	r0, #32768
	sbcs	r3, r1, #0
	movwge	r0, #32767
	bge	.L129
	mov	r8, #32768
	mvn	r9, #0
	mov	r3, #32768
	movt	r8, 65535
	cmp	r0, r8
	sbcs	ip, r1, r9
	movt	r3, 65535
	movlt	r0, r3
.L129:
	cmp	r4, #32768
	sbcs	r3, r5, #0
	movwge	r4, #32767
	bge	.L130
	mov	r8, #32768
	mvn	r9, #0
	mov	r3, #32768
	movt	r8, 65535
	cmp	r4, r8
	sbcs	r1, r5, r9
	movt	r3, 65535
	movlt	r4, r3
.L130:
	cmp	r10, #32768
	sbcs	r3, fp, #0
	movwge	r10, #32767
	bge	.L131
	mov	r8, #32768
	mvn	r9, #0
	mov	r3, #32768
	movt	r8, 65535
	cmp	r10, r8
	sbcs	r1, fp, r9
	movt	r3, 65535
	movlt	r10, r3
.L131:
	vldr	d17, [r2]
	vldr	d16, [r2, #8]
	vmov.32	d17[0], r6
	vmov.32	d16[0], r4
	vmov.32	d17[1], r0
	vmov.32	d16[1], r10
	vstr	d17, [r2]
	vstr	d16, [r2, #8]
	pop	{r4, r5, r6, r7, r8, r9, r10, fp, pc}
	.size	matrix_multiply, .-matrix_multiply
	.global	__aeabi_ldivmod
	.align	2
	.global	rotate
	.syntax unified
	.arm
	.fpu neon
	.type	rotate, %function
rotate:
	@ args = 0, pretend = 0, frame = 48
	@ frame_needed = 0, uses_anonymous_args = 0
	vldr	d17, [r0, #8]
	vldr	d16, [r0]
	vmov.32	r3, d17[1]
	vmov.32	r1, d16[0]
	push	{r4, r5, r6, r7, r8, r9, r10, fp, lr}
	subs	r2, r3, r1
	sub	sp, sp, #52
	mov	r4, r0
	add	r7, r1, r3
	vmov.32	r9, d17[0]
	vmov.32	r8, d16[1]
	beq	.L142
	add	r0, r8, r9
	asr	r1, r0, #31
	asr	r3, r2, #1
	lsl	fp, r1, #15
	lsl	r10, r0, #15
	orr	fp, fp, r0, lsr #17
	adds	r0, r10, r3
	adc	r1, fp, r3, asr #31
	asr	r3, r2, #31
	bl	__aeabi_ldivmod
	cmp	r7, #0
	mov	r5, r0
	add	r6, r0, #32768
	beq	.L165
.L156:
	sub	r2, r9, r8
	asr	r3, r2, #31
	lsl	r3, r3, #15
	asr	r0, r7, #1
	orr	r3, r3, r2, lsr #17
	lsl	r2, r2, #15
	adds	r8, r2, r0
	adc	r9, r3, r0, asr #31
	mov	r2, r7
	asr	r3, r7, #31
	mov	r0, r8
	mov	r1, r9
	bl	__aeabi_ldivmod
	add	r7, r0, #32768
.L143:
	cmp	r6, #65536
	movwcs	lr, #32767
	eorcc	lr, r5, r5, asr #31
	subcc	lr, lr, r5, asr #31
.L144:
	ldr	r1, .L171
	mov	r3, #0
	mov	r2, r1
	b	.L146
.L167:
	add	r3, r3, #1
	cmp	r3, #46
	beq	.L166
.L146:
	ldr	ip, [r2], #4
	cmp	lr, ip
	bgt	.L167
.L145:
	cmp	r7, #65536
	eorcc	ip, r0, r0, asr #31
	subcc	ip, ip, r0, asr #31
	movwcs	ip, #32767
	mov	r2, #0
	b	.L149
.L169:
	add	r2, r2, #1
	cmp	r2, #46
	beq	.L168
.L149:
	ldr	r0, [r1], #4
	cmp	r0, ip
	blt	.L169
.L148:
	add	r2, r2, r3
	asr	r2, r2, #2
	sub	r3, r3, r2
	cmp	r3, #46
	movw	ip, #:lower16:.LANCHOR0
	vmov.i32	q8, #0  @ ti
	beq	.L150
	mov	r0, sp
	lsl	r1, r3, #1
	movt	ip, #:upper16:.LANCHOR0
	add	r5, r1, r3
	add	r5, ip, r5, lsl #2
	add	r6, sp, #16
	cmp	r3, #0
	ldr	lr, [r5, #8]
	vst1.64	{d16-d17}, [r0:64]
	vst1.64	{d16-d17}, [r6:64]
	bge	.L155
	vldr	d16, [sp, #8]
	vmov.i32	d17, #0  @ v2si
	ldr	r3, [r5, #4]
	vmov.32	d17[0], lr
	rsb	r1, r3, #0
	vmov.32	d16[0], r1
	vmov.32	d17[1], r3
	vmov.32	d16[1], lr
	cmn	r2, #1
	vstr	d17, [sp]
	vstr	d16, [sp, #8]
	vldr	d17, [sp, #16]
	beq	.L153
.L170:
	add	r2, r2, r2, lsl #1
	add	ip, ip, r2, lsl #2
	ldr	r3, [ip, #8]
	vldr	d16, [sp, #24]
	vmov.32	d17[0], r3
	ldr	r2, [ip, #4]
	rsb	r1, r2, #0
	vmov.32	d17[1], r1
	vmov.32	d16[0], r2
	vstr	d17, [sp, #16]
	vmov.32	d16[1], r3
	vmov	d20, d17  @ v2si
.L154:
	vmov	d17, d20  @ v2si
	vmov.i32	q9, #0  @ ti
	vuzp.32	d17, d16
	add	r5, sp, #32
	mov	r2, r5
	mov	r1, r4
	vstr	d17, [sp, #16]
	vstr	d16, [sp, #24]
	vst1.64	{d18-d19}, [r5:64]
	bl	matrix_multiply
	mov	r2, r4
	mov	r1, r6
	mov	r0, r5
	bl	matrix_multiply
	add	sp, sp, #52
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r9, r10, fp, pc}
.L142:
	cmp	r7, #0
	bne	.L160
	movw	lr, #32767
	movw	r7, #65535
	mov	r0, lr
	b	.L144
.L150:
	mov	r0, sp
	add	r6, sp, #16
	vst1.64	{d16-d17}, [r0:64]
	vst1.64	{d16-d17}, [r6:64]
	mov	r3, #45
	mov	r1, #90
	movt	ip, #:upper16:.LANCHOR0
	ldr	lr, [ip, #548]
.L155:
	vldr	d17, [sp, #8]
	vmov.i32	d16, #0  @ v2si
	add	r3, r1, r3
	add	r3, ip, r3, lsl #2
	ldr	r1, [r3, #4]
	vmov.32	d16[0], lr
	vmov.32	d17[0], r1
	add	r3, r3, #8
	rsb	r1, r1, #0
	vld1.32	{d17[1]}, [r3]
	vmov.32	d16[1], r1
	cmn	r2, #1
	vstr	d17, [sp, #8]
	vstr	d16, [sp]
	vldr	d17, [sp, #16]
	bne	.L170
.L153:
	ldr	r3, [ip, #-4]
	vldr	d16, [sp, #24]
	vmov.32	d17[0], r3
	ldr	r2, [ip, #-8]
	rsb	r1, r2, #0
	vmov.32	d17[1], r2
	vmov.32	d16[0], r1
	vstr	d17, [sp, #16]
	vmov.32	d16[1], r3
	vmov	d20, d17  @ v2si
	b	.L154
.L165:
	movw	r7, #65535
	movw	r0, #32767
	b	.L143
.L160:
	movw	r6, #65535
	movw	r5, #32767
	b	.L156
.L166:
	mvn	r3, #0
	b	.L145
.L168:
	mvn	r2, #0
	b	.L148
.L172:
	.align	2
.L171:
	.word	.LANCHOR0+552
	.size	rotate, .-rotate
	.align	2
	.global	transpose_32x4x4
	.syntax unified
	.arm
	.fpu neon
	.type	transpose_32x4x4, %function
transpose_32x4x4:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	vldr	d20, [r0, #32]
	vldr	d21, [r0, #40]
	vld1.64	{d22-d23}, [r0:64]
	vldr	d18, [r0, #16]
	vldr	d19, [r0, #24]
	vldr	d16, [r0, #48]
	vldr	d17, [r0, #56]
	vmov	d24, d22  @ v2si
	vmov	d25, d20  @ v2si
	vmov	d22, d23  @ v2si
	vmov	d20, d18  @ v2si
	vmov	d23, d21  @ v2si
	vmov	d21, d16  @ v2si
	vmov	d16, d19  @ v2si
	vst1.64	{d24-d25}, [r0:64]
	vstr	d22, [r0, #32]
	vstr	d23, [r0, #40]
	vstr	d20, [r0, #16]
	vstr	d21, [r0, #24]
	vstr	d16, [r0, #48]
	vstr	d17, [r0, #56]
	bx	lr
	.size	transpose_32x4x4, .-transpose_32x4x4
	.align	2
	.global	transpose_32x2x2
	.syntax unified
	.arm
	.fpu neon
	.type	transpose_32x2x2, %function
transpose_32x2x2:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	vld1.64	{d20-d21}, [r0:64]
	vldr	d22, [r0, #16]
	vldr	d23, [r0, #24]
	vmov	q9, q10  @ v4si
	vmov	q8, q11  @ v4si
	vtrn.32	q9, q8
	vst1.64	{d18-d19}, [r0:64]
	vstr	d16, [r0, #16]
	vstr	d17, [r0, #24]
	bx	lr
	.size	transpose_32x2x2, .-transpose_32x2x2
	.align	2
	.global	transpose_32x4
	.syntax unified
	.arm
	.fpu neon
	.type	transpose_32x4, %function
transpose_32x4:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	vld1.64	{d18-d19}, [r0:64]
	vldr	d16, [r0, #16]
	vldr	d17, [r0, #24]
	vmov.i32	q11, #0  @ v4si
	vtrn.32	q9, q8
	vmov	q10, q11  @ v4si
	vmov	q13, q9  @ v4si
	vmov	q14, q8  @ v4si
	vmov	d24, d18  @ v2si
	vmov	d25, d22  @ v2si
	vmov	d18, d16  @ v2si
	vmov	d22, d27  @ v2si
	vmov	d19, d20  @ v2si
	vmov	d16, d29  @ v2si
	vmov	d17, d21  @ v2si
	vst1.64	{d24-d25}, [r0:64]
	vstr	d22, [r0, #32]
	vstr	d23, [r0, #40]
	vstr	d18, [r0, #16]
	vstr	d19, [r0, #24]
	vstr	d16, [r0, #48]
	vstr	d17, [r0, #56]
	bx	lr
	.size	transpose_32x4, .-transpose_32x4
	.align	2
	.global	max_off_diag
	.syntax unified
	.arm
	.fpu neon
	.type	max_off_diag, %function
max_off_diag:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	vld1.64	{d16-d17}, [r0:64]
	vmov.32	r3, d16[1]
	vmov.32	r1, d17[0]
	cmp	r3, #0
	rsblt	r3, r3, #0
	cmp	r1, #0
	vmov.32	r2, d17[1]
	rsblt	r1, r1, #0
	cmp	r3, r1
	vldr	d16, [r0, #16]
	vldr	d17, [r0, #24]
	movlt	r3, r1
	cmp	r2, #0
	rsblt	r2, r2, #0
	vmov.32	r1, d16[0]
	cmp	r3, r2
	movlt	r3, r2
	eor	r2, r1, r1, asr #31
	sub	r2, r2, r1, asr #31
	vmov.32	r1, d17[0]
	cmp	r3, r2
	movlt	r3, r2
	cmp	r1, #0
	vmov.32	r2, d17[1]
	rsblt	r1, r1, #0
	cmp	r3, r1
	vldr	d16, [r0, #32]
	vldr	d17, [r0, #40]
	movlt	r3, r1
	cmp	r2, #0
	rsblt	r2, r2, #0
	vmov.32	r1, d16[0]
	cmp	r3, r2
	movlt	r3, r2
	eor	r2, r1, r1, asr #31
	sub	r2, r2, r1, asr #31
	vmov.32	r1, d16[1]
	cmp	r3, r2
	movlt	r3, r2
	cmp	r1, #0
	vmov.32	r2, d17[1]
	rsblt	r1, r1, #0
	cmp	r3, r1
	vldr	d16, [r0, #48]
	vldr	d17, [r0, #56]
	movlt	r3, r1
	cmp	r2, #0
	vmov.32	r0, d16[0]
	rsblt	r2, r2, #0
	cmp	r3, r2
	movlt	r3, r2
	cmp	r0, #0
	vmov.32	r2, d16[1]
	rsblt	r0, r0, #0
	cmp	r3, r0
	movlt	r3, r0
	cmp	r2, #0
	vmov.32	r0, d17[0]
	rsblt	r2, r2, #0
	cmp	r3, r2
	movlt	r3, r2
	cmp	r0, #0
	rsblt	r0, r0, #0
	cmp	r3, r0
	movge	r0, r3
	bx	lr
	.size	max_off_diag, .-max_off_diag
	.section	.rodata
	.align	3
.LC4:
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.section	.text.startup,"ax",%progbits
	.align	2
	.global	main
	.syntax unified
	.arm
	.fpu neon
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 496
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r9, r10, fp, lr}
	movw	r3, #:lower16:.LANCHOR0
	vpush.64	{d8, d9, d10}
	movt	r3, #:upper16:.LANCHOR0
	sub	sp, sp, #500
	vldr	d22, [r3, #736]
	vldr	d23, [r3, #744]
	vldr	d20, [r3, #752]
	vldr	d21, [r3, #760]
	vldr	d18, [r3, #768]
	vldr	d19, [r3, #776]
	vldr	d16, [r3, #784]
	vldr	d17, [r3, #792]
	vldr	d24, [r3, #800]
	vldr	d25, [r3, #808]
	vldr	d26, [r3, #816]
	vldr	d27, [r3, #824]
	vldr	d28, [r3, #832]
	vldr	d29, [r3, #840]
	vldr	d30, [r3, #848]
	vldr	d31, [r3, #856]
	vldr	d6, [r3, #864]
	vldr	d7, [r3, #872]
	vldr	d4, [r3, #880]
	vldr	d5, [r3, #888]
	vldr	d2, [r3, #896]
	vldr	d3, [r3, #904]
	vldr	d0, [r3, #912]
	vldr	d1, [r3, #920]
	str	r3, [sp, #24]
	movw	r3, #:lower16:.LANCHOR1
	movw	r2, #26215
	movt	r3, #:upper16:.LANCHOR1
	str	r3, [sp, #28]
	mov	r3, #0
	vstr	d22, [sp, #112]
	vstr	d23, [sp, #120]
	vstr	d20, [sp, #128]
	vstr	d21, [sp, #136]
	vstr	d18, [sp, #144]
	vstr	d19, [sp, #152]
	vstr	d16, [sp, #160]
	vstr	d17, [sp, #168]
	vstr	d24, [sp, #176]
	vstr	d25, [sp, #184]
	vstr	d26, [sp, #192]
	vstr	d27, [sp, #200]
	vstr	d28, [sp, #208]
	vstr	d29, [sp, #216]
	vstr	d30, [sp, #224]
	vstr	d31, [sp, #232]
	vstr	d6, [sp, #240]
	vstr	d7, [sp, #248]
	vstr	d4, [sp, #256]
	vstr	d5, [sp, #264]
	vstr	d2, [sp, #272]
	vstr	d3, [sp, #280]
	vstr	d0, [sp, #288]
	vstr	d1, [sp, #296]
	vmov.i32	q4, #0  @ ti
	movt	r2, 26214
	str	r2, [sp, #40]
	str	r3, [sp, #44]
.L178:
	add	r0, sp, #240
	bl	max_off_diag
	cmp	r0, #1000
	ble	.L226
	mov	r5, #0
	mov	r7, r5
	ldr	r3, [sp, #44]
	add	fp, sp, #304
	add	r8, sp, #368
	add	r3, r3, #1
	str	fp, [sp, #16]
	str	r8, [sp, #20]
	str	r3, [sp, #44]
	add	r10, sp, #64
	add	r9, sp, #80
.L206:
	add	r3, r7, #1
	mov	r6, r3
	str	r3, [sp, #36]
	ldr	r3, [sp, #20]
	vmov.i32	d10, #0  @ v2si
	str	r3, [sp]
	ldr	r3, [sp, #16]
	str	r3, [sp, #4]
	mov	r3, r7
	mov	r7, r6
	mov	r6, r3
.L205:
	add	r3, sp, #48
	cmp	r6, #1
	vst1.64	{d8-d9}, [r3:64]
	beq	.L179
	cmp	r6, #2
	beq	.L180
	cmp	r7, #2
	vldr	d18, [sp, #240]
	vldr	d19, [sp, #248]
	beq	.L181
	cmp	r7, #3
	beq	.L182
	vldr	d20, [sp, #256]
	vldr	d21, [sp, #264]
	vmov.32	r2, d18[0]
	vmov.32	r3, d20[0]
	vldr	d17, [sp, #56]
	vldr	d16, [sp, #48]
	vmov.32	d17[0], r3
	vmov.32	d16[0], r2
	vmov.32	r3, d20[1]
	vmov.32	r2, d18[1]
.L230:
	vmov.32	d16[1], r2
	vmov.32	d17[1], r3
	vstr	d16, [sp, #48]
	vstr	d17, [sp, #56]
	vmov	d18, d16  @ v2si
.L183:
	vldr	d16, [sp, #56]
	vmov.32	r5, d18[0]
	vmov.32	r3, d16[1]
	subs	r2, r3, r5
	add	r3, r5, r3
	str	r3, [sp, #8]
	vmov.32	r3, d18[1]
	vmov.32	r4, d17[0]
	mov	r5, r3
	beq	.L186
	add	r0, r3, r4
	asr	r1, r0, #31
	lsl	r1, r1, #15
	asr	r3, r2, #1
	orr	r1, r1, r0, lsr #17
	lsl	r0, r0, #15
	adds	r0, r0, r3
	adc	r1, r1, r3, asr #31
	asr	r3, r2, #31
	bl	__aeabi_ldivmod
	ldr	r3, [sp, #8]
	str	r0, [sp, #32]
	cmp	r3, #0
	add	r3, r0, #32768
	str	r3, [sp, #12]
	bne	.L211
	ldr	r3, [sp, #12]
	movw	lr, #65535
	cmp	r3, #65536
	movw	r0, #32767
	movwcs	r4, #32767
	bcc	.L231
.L188:
	ldr	r2, .L238
	mov	r3, #0
	mov	r1, r2
	b	.L190
.L233:
	add	r3, r3, #1
	cmp	r3, #46
	beq	.L232
.L190:
	ldr	ip, [r1], #4
	cmp	ip, r4
	blt	.L233
	add	r3, r3, r3, lsl #2
.L191:
	cmp	lr, #65536
	movwcs	r0, #32767
	bcs	.L192
	cmp	r0, #0
	rsblt	r0, r0, #0
.L192:
	mov	r1, #0
	b	.L194
.L235:
	add	r1, r1, #1
	cmp	r1, #46
	beq	.L234
.L194:
	ldr	ip, [r2], #4
	cmp	ip, r0
	blt	.L235
	add	r1, r1, r1, lsl #2
.L195:
	add	r1, r3, r1
	asr	r0, r1, #2
	cmp	r0, #4
	sub	r2, r3, r0
	movle	r3, #1
	ble	.L196
	cmp	r0, #49
	movgt	r3, #9
	ldrle	r3, [sp, #40]
	asrle	r1, r1, #31
	smullle	r0, r3, r3, r0
	rsble	r3, r1, r3, asr #1
.L196:
	cmp	r2, #4
	ble	.L217
	cmp	r2, #49
	ble	.L236
	mov	r2, #9
.L197:
	vst1.64	{d8-d9}, [r10:64]
	vst1.64	{d8-d9}, [r9:64]
.L210:
	vldr	d17, [sp, #80]
	vldr	d16, [sp, #88]
	ldr	ip, [sp, #24]
	add	r3, r3, r3, lsl #1
	add	r3, ip, r3, lsl #2
	ldrd	r0, [r3, #4]
	vldr	d18, [sp, #72]
	vmov.32	d17[0], r1
	vmov.32	d16[0], r0
	vmov	d19, d10  @ v2si
	add	r2, r2, r2, lsl #1
	add	r2, ip, r2, lsl #2
	rsb	r0, r0, #0
	ldmib	r2, {r3, ip}
	vmov.32	d17[1], r0
	vmov.32	d19[0], ip
	vmov.32	d16[1], r1
	vmov.32	d18[0], r3
	rsb	r3, r3, #0
	vuzp.32	d17, d16
	vmov.32	d19[1], r3
	vmov.32	d18[1], ip
	add	r2, sp, #96
	add	r1, sp, #48
	mov	r0, r10
	vstr	d17, [sp, #80]
	vstr	d16, [sp, #88]
	vstr	d19, [sp, #64]
	vstr	d18, [sp, #72]
	vst1.64	{d8-d9}, [r2:64]
	bl	matrix_multiply
	add	r2, sp, #48
	mov	r1, r9
	add	r0, sp, #96
	bl	matrix_multiply
	vldr	d18, [sp, #80]
	vldr	d19, [sp, #88]
	vmov	d17, d18  @ v2si
	vmov	d16, d19  @ v2si
	ldr	r3, [sp, #28]
	vuzp.32	d17, d16
	vldmia	r3, {d24-d31}
	cmp	r6, #1
	vstr	d17, [sp, #80]
	vstr	d16, [sp, #88]
	vstmia	fp, {d24-d31}
	vstmia	r8, {d24-d31}
	beq	.L198
	cmp	r6, #2
	beq	.L199
	cmp	r7, #2
	vldr	d27, [r10, #8]
	vldr	d26, [r9]
	vldr	d25, [r9, #8]
	vldr	d24, [r10]
	beq	.L200
	cmp	r7, #3
	beq	.L201
	vmov.32	r1, d27[0]
	vldr	d18, [fp, #16]
	vldr	d19, [fp, #24]
	vld1.64	{d16-d17}, [r8:64]
	vldr	d20, [r8, #16]
	vldr	d21, [r8, #24]
	vld1.64	{d22-d23}, [fp:64]
	vmov.32	r0, d26[0]
	vmov.32	r2, d25[0]
	vmov.32	r3, d24[0]
	vmov.32	d18[0], r1
	vmov.32	d16[0], r0
	vmov.32	d20[0], r2
	vmov.32	d22[0], r3
	vmov.32	r1, d27[1]
	vmov.32	r2, d26[1]
	vmov.32	r3, d25[1]
	vmov.32	r0, d24[1]
	vmov.32	d18[1], r1
	vmov.32	d16[1], r2
	vmov.32	d20[1], r3
	vmov.32	d22[1], r0
	vstr	d18, [fp, #16]
	vstr	d19, [fp, #24]
	vst1.64	{d16-d17}, [r8:64]
	vstr	d20, [r8, #16]
	vstr	d21, [r8, #24]
	vst1.64	{d22-d23}, [fp:64]
.L202:
	vldr	d18, [sp, #176]
	vldr	d19, [sp, #184]
	vldr	d16, [sp, #192]
	vldr	d17, [sp, #200]
	vldr	d22, [sp, #208]
	vldr	d23, [sp, #216]
	vtrn.32	q9, q8
	vldr	d20, [sp, #224]
	vldr	d21, [sp, #232]
	vmov	q1, q8  @ v4si
	vmov	q8, q11  @ v4si
	vtrn.32	q8, q10
	movw	r3, #:lower16:.LC4
	vmov	q2, q9  @ v4si
	vmov	q0, q10  @ v4si
	movt	r3, #:upper16:.LC4
	vldmia	r3, {d24-d31}
	vmov	d6, d18  @ v2si
	vmov	d7, d16  @ v2si
	vmov	d22, d5  @ v2si
	vmov	d18, d2  @ v2si
	vmov	d16, d3  @ v2si
	vmov	d23, d17  @ v2si
	vmov	d19, d20  @ v2si
	vmov	d17, d1  @ v2si
	add	r2, sp, #176
	add	r3, sp, #432
	mov	r1, r2
	mov	r0, r8
	vstmia	r3, {d24-d31}
	vstr	d6, [sp, #176]
	vstr	d7, [sp, #184]
	vstr	d22, [sp, #208]
	vstr	d23, [sp, #216]
	vstr	d18, [sp, #192]
	vstr	d19, [sp, #200]
	vstr	d16, [sp, #224]
	vstr	d17, [sp, #232]
	bl	matrix_multiply_4x4
	add	r2, sp, #432
	add	r1, sp, #240
	mov	r0, fp
	bl	matrix_multiply_4x4
	vld1.64	{d18-d19}, [r8:64]
	vldr	d16, [r8, #16]
	vldr	d17, [r8, #24]
	vldr	d22, [r8, #32]
	vldr	d23, [r8, #40]
	vtrn.32	q9, q8
	vldr	d20, [r8, #48]
	vldr	d21, [r8, #56]
	vmov	q14, q8  @ v4si
	vmov	q8, q11  @ v4si
	vtrn.32	q8, q10
	vmov	q13, q9  @ v4si
	vmov	q15, q10  @ v4si
	vmov	d24, d18  @ v2si
	vmov	d25, d16  @ v2si
	vmov	d22, d27  @ v2si
	vmov	d23, d17  @ v2si
	vmov	d18, d28  @ v2si
	vmov	d19, d20  @ v2si
	vmov	d16, d29  @ v2si
	vmov	d17, d31  @ v2si
	add	r2, sp, #240
	mov	r1, r8
	add	r0, sp, #432
	vst1.64	{d24-d25}, [r8:64]
	vstr	d22, [r8, #32]
	vstr	d23, [r8, #40]
	vstr	d18, [r8, #16]
	vstr	d19, [r8, #24]
	vstr	d16, [r8, #48]
	vstr	d17, [r8, #56]
	bl	matrix_multiply_4x4
	vld1.64	{d18-d19}, [fp:64]
	vldr	d16, [fp, #16]
	vldr	d17, [fp, #24]
	vldr	d22, [fp, #32]
	vldr	d23, [fp, #40]
	vtrn.32	q9, q8
	vldr	d20, [fp, #48]
	vldr	d21, [fp, #56]
	vmov	q14, q8  @ v4si
	vmov	q8, q11  @ v4si
	vtrn.32	q8, q10
	vmov	q13, q9  @ v4si
	vmov	q15, q10  @ v4si
	vmov	d24, d18  @ v2si
	vmov	d25, d16  @ v2si
	vmov	d23, d17  @ v2si
	vmov	d22, d27  @ v2si
	vmov	d18, d28  @ v2si
	vmov	d19, d20  @ v2si
	vmov	d16, d29  @ v2si
	vmov	d17, d31  @ v2si
	add	r2, sp, #112
	mov	r1, fp
	mov	r0, r2
	vst1.64	{d24-d25}, [fp:64]
	vstr	d22, [fp, #32]
	vstr	d23, [fp, #40]
	vstr	d18, [fp, #16]
	vstr	d19, [fp, #24]
	vstr	d16, [fp, #48]
	vstr	d17, [fp, #56]
	bl	matrix_multiply_4x4
	ldr	r3, [sp, #4]
	add	r7, r7, #1
	add	r3, r3, #16
	str	r3, [sp, #4]
	ldr	r3, [sp]
	cmp	r7, #4
	add	r3, r3, #16
	str	r3, [sp]
	bne	.L205
	mov	r0, #10
	bl	putchar
	ldr	r3, [sp, #16]
	ldr	r7, [sp, #36]
	add	r3, r3, #16
	str	r3, [sp, #16]
	ldr	r3, [sp, #20]
	cmp	r7, #3
	add	r3, r3, #16
	str	r3, [sp, #20]
	bne	.L206
	movw	r0, #:lower16:.LC2
	ldr	r1, [sp, #44]
	movt	r0, #:upper16:.LC2
	movw	r5, #:lower16:.LC3
	bl	printf
	add	r4, sp, #240
	movt	r5, #:upper16:.LC3
.L207:
	vld1.64	{d16-d17}, [r4:64]
	mov	r0, r5
	vmov.32	r1, d16[0]
	bl	printf
	vld1.64	{d16-d17}, [r4:64]!
	mov	r0, r5
	vmov.32	r1, d16[1]
	bl	printf
	vldr	d16, [r4, #-16]
	vldr	d17, [r4, #-8]
	mov	r0, r5
	vmov.32	r1, d17[0]
	bl	printf
	vldr	d16, [r4, #-16]
	vldr	d17, [r4, #-8]
	mov	r0, r5
	vmov.32	r1, d17[1]
	bl	printf
	mov	r0, #10
	bl	putchar
	cmp	fp, r4
	bne	.L207
	mov	r0, #10
	bl	putchar
	ldr	r3, [sp, #44]
	cmp	r3, #20
	bne	.L178
.L226:
	mov	r0, #0
	add	sp, sp, #500
	@ sp needed
	vldm	sp!, {d8-d10}
	pop	{r4, r5, r6, r7, r8, r9, r10, fp, pc}
.L217:
	mov	r2, #1
	b	.L197
.L219:
	movw	r3, #65535
	str	r3, [sp, #12]
	movw	r3, #32767
	str	r3, [sp, #32]
.L211:
	sub	r2, r4, r5
	ldr	ip, [sp, #8]
	asr	r3, r2, #31
	lsl	r3, r3, #15
	asr	r0, ip, #1
	orr	r3, r3, r2, lsr #17
	lsl	r2, r2, #15
	adds	r4, r2, r0
	adc	r5, r3, r0, asr #31
	mov	r1, r5
	mov	r0, r4
	asr	r3, ip, #31
	mov	r2, ip
	bl	__aeabi_ldivmod
	ldr	r3, [sp, #12]
	add	lr, r0, #32768
	cmp	r3, #65536
	movwcs	r4, #32767
	bcs	.L188
.L231:
	ldr	r4, [sp, #32]
	cmp	r4, #0
	rsblt	r4, r4, #0
	b	.L188
.L186:
	ldr	r3, [sp, #8]
	cmp	r3, #0
	bne	.L219
	movw	r4, #32767
	movw	lr, #65535
	mov	r0, r4
	b	.L188
.L236:
	ldr	r1, [sp, #40]
	vst1.64	{d8-d9}, [r10:64]
	smull	r0, r1, r1, r2
	asr	r2, r2, #31
	vst1.64	{d8-d9}, [r9:64]
	rsb	r2, r2, r1, asr #1
	b	.L210
.L234:
	mvn	r1, #4
	b	.L195
.L232:
	mvn	r3, #4
	b	.L191
.L199:
	vldr	d21, [r10]
	vldr	d20, [r9]
	vmov.32	r2, d21[0]
	vldr	d18, [fp, #32]
	vldr	d19, [fp, #40]
	vldr	d16, [r8, #32]
	vldr	d17, [r8, #40]
	vmov.32	r3, d20[0]
	vmov.32	d19[0], r2
	vmov.32	d17[0], r3
	vmov.32	r2, d21[1]
	vmov.32	r3, d20[1]
	vmov.32	d19[1], r2
	vmov.32	d17[1], r3
	vstr	d18, [fp, #32]
	vstr	d19, [fp, #40]
	vldr	d21, [r10, #8]
	vstr	d16, [r8, #32]
	vstr	d17, [r8, #40]
	vldr	d20, [r9, #8]
	ldr	r1, [sp, #4]
	ldr	r0, [sp]
	vldr	d18, [r1, #16]
	vldr	d19, [r1, #24]
	vmov.32	r2, d21[0]
	vldr	d16, [r0, #16]
	vldr	d17, [r0, #24]
	vmov.32	r3, d20[0]
	vmov.32	d19[0], r2
	vmov.32	d17[0], r3
	vmov.32	r2, d21[1]
	vmov.32	r3, d20[1]
	vmov.32	d19[1], r2
	vmov.32	d17[1], r3
	vstr	d18, [r1, #16]
	vstr	d19, [r1, #24]
	vstr	d16, [r0, #16]
	vstr	d17, [r0, #24]
	b	.L202
.L198:
	cmp	r7, #2
	beq	.L203
	cmp	r7, #3
	bne	.L202
	vldr	d27, [r10]
	vldr	d26, [r10, #8]
	vldr	d25, [r9]
	vldr	d24, [r9, #8]
	vmov.32	r0, d27[0]
	vldr	d18, [fp, #16]
	vldr	d19, [fp, #24]
	vldr	d16, [fp, #48]
	vldr	d17, [fp, #56]
	vldr	d20, [r8, #16]
	vldr	d21, [r8, #24]
	vldr	d22, [r8, #48]
	vldr	d23, [r8, #56]
	vmov.32	r1, d26[0]
	vmov.32	r2, d25[0]
	vmov.32	r3, d24[0]
	vmov.32	d18[1], r0
	vmov.32	d16[1], r1
	vmov.32	d20[1], r2
	vmov.32	d22[1], r3
	vmov.32	r0, d27[1]
	vmov.32	r1, d26[1]
	vmov.32	r2, d25[1]
	vmov.32	r3, d24[1]
	vmov.32	d19[1], r0
	vmov.32	d17[1], r1
	vmov.32	d21[1], r2
	vmov.32	d23[1], r3
	vstr	d18, [fp, #16]
	vstr	d19, [fp, #24]
	vstr	d16, [fp, #48]
	vstr	d17, [fp, #56]
	vstr	d20, [r8, #16]
	vstr	d21, [r8, #24]
	vstr	d22, [r8, #48]
	vstr	d23, [r8, #56]
	b	.L202
.L180:
	add	r3, sp, #240
	add	r3, r3, r7, lsl #4
	vld1.64	{d20-d21}, [r3:64]
	vldr	d18, [sp, #272]
	vldr	d19, [sp, #280]
	vmov.32	r2, d21[0]
	vldr	d17, [sp, #56]
	vldr	d16, [sp, #48]
	vmov.32	r3, d19[0]
.L229:
	vmov.32	d17[0], r2
	vmov.32	d16[0], r3
	vmov.32	r2, d21[1]
	vmov.32	r3, d19[1]
	vmov.32	d17[1], r2
	vmov.32	d16[1], r3
	vstr	d17, [sp, #56]
	vstr	d16, [sp, #48]
	vmov	d18, d16  @ v2si
	b	.L183
.L179:
	cmp	r7, #2
	beq	.L184
	cmp	r7, #3
	bne	.L237
	vldr	d20, [sp, #256]
	vldr	d21, [sp, #264]
	vldr	d18, [sp, #288]
	vldr	d19, [sp, #296]
	vmov.32	r2, d20[1]
	vmov.32	r3, d18[1]
	vldr	d16, [sp, #48]
	vldr	d17, [sp, #56]
	vmov.32	d16[0], r2
	vmov.32	d17[0], r3
	vmov.32	r2, d21[1]
	vmov.32	r3, d19[1]
.L228:
	vmov.32	d16[1], r2
	vmov.32	d17[1], r3
	vstr	d16, [sp, #48]
	vstr	d17, [sp, #56]
	vmov	d18, d16  @ v2si
	b	.L183
.L237:
	vmov.i32	d17, #0  @ v2si
	vldr	d18, [sp, #48]
	b	.L183
.L184:
	vldr	d20, [sp, #256]
	vldr	d21, [sp, #264]
	vldr	d18, [sp, #272]
	vldr	d19, [sp, #280]
	vmov.32	r2, d20[1]
	vmov.32	r3, d18[1]
	vldr	d16, [sp, #48]
	vldr	d17, [sp, #56]
	vmov.32	d16[0], r2
	vmov.32	d17[0], r3
	vmov.32	r2, d21[0]
	vmov.32	r3, d19[0]
	b	.L228
.L203:
	vldr	d27, [r10]
	vldr	d26, [r10, #8]
	vldr	d25, [r9]
	vldr	d24, [r9, #8]
	vmov.32	r0, d27[0]
	vldr	d18, [fp, #16]
	vldr	d19, [fp, #24]
	vldr	d16, [fp, #32]
	vldr	d17, [fp, #40]
	vldr	d20, [r8, #16]
	vldr	d21, [r8, #24]
	vldr	d22, [r8, #32]
	vldr	d23, [r8, #40]
	vmov.32	r1, d26[0]
	vmov.32	r2, d25[0]
	vmov.32	r3, d24[0]
	vmov.32	d18[1], r0
	vmov.32	d16[1], r1
	vmov.32	d20[1], r2
	vmov.32	d22[1], r3
	vmov.32	r0, d27[1]
	vmov.32	r1, d26[1]
	vmov.32	r2, d25[1]
	vmov.32	r3, d24[1]
	vmov.32	d19[0], r0
	vmov.32	d17[0], r1
	vmov.32	d21[0], r2
	vmov.32	d23[0], r3
	vstr	d18, [fp, #16]
	vstr	d19, [fp, #24]
	vstr	d16, [fp, #32]
	vstr	d17, [fp, #40]
	vstr	d20, [r8, #16]
	vstr	d21, [r8, #24]
	vstr	d22, [r8, #32]
	vstr	d23, [r8, #40]
	b	.L202
.L201:
	vmov.32	r0, d27[0]
	vldr	d18, [fp, #48]
	vldr	d19, [fp, #56]
	vld1.64	{d16-d17}, [r8:64]
	vldr	d20, [r8, #48]
	vldr	d21, [r8, #56]
	vld1.64	{d22-d23}, [fp:64]
	vmov.32	r1, d26[0]
	vmov.32	r2, d25[0]
	vmov.32	r3, d24[0]
	vmov.32	d18[0], r0
	vmov.32	d16[0], r1
	vmov.32	d20[0], r2
	vmov.32	d22[0], r3
	vmov.32	r0, d27[1]
	vmov.32	r1, d26[1]
	vmov.32	r2, d25[1]
	vmov.32	r3, d24[1]
	vmov.32	d19[1], r0
	vmov.32	d17[1], r1
	vmov.32	d21[1], r2
	vmov.32	d23[1], r3
	vstr	d18, [fp, #48]
	vstr	d19, [fp, #56]
	vst1.64	{d16-d17}, [r8:64]
	vstr	d20, [r8, #48]
	vstr	d21, [r8, #56]
	vst1.64	{d22-d23}, [fp:64]
	b	.L202
.L200:
	vmov.32	r1, d27[0]
	vldr	d18, [fp, #32]
	vldr	d19, [fp, #40]
	vld1.64	{d16-d17}, [r8:64]
	vldr	d20, [r8, #32]
	vldr	d21, [r8, #40]
	vld1.64	{d22-d23}, [fp:64]
	vmov.32	r0, d26[0]
	vmov.32	r2, d25[0]
	vmov.32	r3, d24[0]
	vmov.32	d18[0], r1
	vmov.32	d16[0], r0
	vmov.32	d20[0], r2
	vmov.32	d22[0], r3
	vmov.32	r1, d27[1]
	vmov.32	r2, d26[1]
	vmov.32	r3, d25[1]
	vmov.32	r0, d24[1]
	vmov.32	d19[0], r1
	vmov.32	d17[0], r2
	vmov.32	d21[0], r3
	vmov.32	d23[0], r0
	vstr	d18, [fp, #32]
	vstr	d19, [fp, #40]
	vst1.64	{d16-d17}, [r8:64]
	vstr	d20, [r8, #32]
	vstr	d21, [r8, #40]
	vst1.64	{d22-d23}, [fp:64]
	b	.L202
.L182:
	vldr	d20, [sp, #288]
	vldr	d21, [sp, #296]
	vldr	d17, [sp, #56]
	vmov.32	r2, d20[0]
	vldr	d16, [sp, #48]
	vmov.32	r3, d18[0]
	b	.L229
.L181:
	vldr	d20, [sp, #272]
	vldr	d21, [sp, #280]
	vmov.32	r2, d18[0]
	vmov.32	r3, d20[0]
	vldr	d17, [sp, #56]
	vldr	d16, [sp, #48]
	vmov.32	d17[0], r3
	vmov.32	d16[0], r2
	vmov.32	r3, d21[0]
	vmov.32	r2, d19[0]
	b	.L230
.L239:
	.align	2
.L238:
	.word	.LANCHOR0+552
	.size	main, .-main
	.comm	rot_left,8,8
	.comm	rot_right,8,8
	.global	ARCTAN_VALS
	.global	trig_table
	.global	vt_4
	.global	vt_3
	.global	vt_2
	.global	vt_1
	.global	u_4
	.global	u_3
	.global	u_2
	.global	u_1
	.global	m_4
	.global	m_3
	.global	m_2
	.global	m_1
	.comm	f,4,4
	.data
	.align	3
	.set	.LANCHOR0,. + 0
	.type	trig_table, %object
	.size	trig_table, 552
trig_table:
	.word	0
	.word	0
	.word	32767
	.word	1
	.word	572
	.word	32766
	.word	2
	.word	1144
	.word	32758
	.word	3
	.word	1716
	.word	32744
	.word	4
	.word	2287
	.word	32723
	.word	5
	.word	2858
	.word	32695
	.word	6
	.word	3429
	.word	32660
	.word	7
	.word	3999
	.word	32618
	.word	8
	.word	4569
	.word	32570
	.word	9
	.word	5139
	.word	32514
	.word	10
	.word	5708
	.word	32452
	.word	11
	.word	6276
	.word	32383
	.word	12
	.word	6844
	.word	32307
	.word	13
	.word	7411
	.word	32224
	.word	14
	.word	7977
	.word	32134
	.word	15
	.word	8543
	.word	32037
	.word	16
	.word	9108
	.word	31933
	.word	17
	.word	9672
	.word	31822
	.word	18
	.word	10235
	.word	31704
	.word	19
	.word	10797
	.word	31579
	.word	20
	.word	11358
	.word	31447
	.word	21
	.word	11918
	.word	31308
	.word	22
	.word	12477
	.word	31162
	.word	23
	.word	13035
	.word	31009
	.word	24
	.word	13591
	.word	30849
	.word	25
	.word	14146
	.word	30682
	.word	26
	.word	14700
	.word	30508
	.word	27
	.word	15252
	.word	30327
	.word	28
	.word	15803
	.word	30139
	.word	29
	.word	16352
	.word	29944
	.word	30
	.word	16900
	.word	29742
	.word	31
	.word	17446
	.word	29533
	.word	32
	.word	17990
	.word	29317
	.word	33
	.word	18533
	.word	29094
	.word	34
	.word	19073
	.word	28864
	.word	35
	.word	19612
	.word	28627
	.word	36
	.word	20149
	.word	28383
	.word	37
	.word	20684
	.word	28132
	.word	38
	.word	21217
	.word	27874
	.word	39
	.word	21748
	.word	27609
	.word	40
	.word	22276
	.word	27337
	.word	41
	.word	22803
	.word	27058
	.word	42
	.word	23327
	.word	26772
	.word	43
	.word	23849
	.word	26479
	.word	44
	.word	24368
	.word	26179
	.word	45
	.word	24885
	.word	25872
	.type	ARCTAN_VALS, %object
	.size	ARCTAN_VALS, 184
ARCTAN_VALS:
	.word	0
	.word	572
	.word	1144
	.word	1716
	.word	2289
	.word	2862
	.word	3436
	.word	4010
	.word	4585
	.word	5161
	.word	5738
	.word	6316
	.word	6895
	.word	7475
	.word	8056
	.word	8639
	.word	9223
	.word	9808
	.word	10394
	.word	10982
	.word	11571
	.word	12162
	.word	12754
	.word	13348
	.word	13943
	.word	14540
	.word	15138
	.word	15738
	.word	16340
	.word	16943
	.word	17548
	.word	18155
	.word	18763
	.word	19373
	.word	19985
	.word	20598
	.word	21213
	.word	21830
	.word	22448
	.word	23068
	.word	23690
	.word	24313
	.word	24938
	.word	25565
	.word	26193
	.word	32767
	.type	u_1, %object
	.size	u_1, 16
u_1:
	.word	32767
	.word	0
	.word	0
	.word	0
	.type	u_2, %object
	.size	u_2, 16
u_2:
	.word	0
	.word	32767
	.word	0
	.word	0
	.type	u_3, %object
	.size	u_3, 16
u_3:
	.word	0
	.word	0
	.word	32767
	.word	0
	.type	u_4, %object
	.size	u_4, 16
u_4:
	.word	0
	.word	0
	.word	0
	.word	32767
	.type	vt_1, %object
	.size	vt_1, 16
vt_1:
	.word	32767
	.word	0
	.word	0
	.word	0
	.type	vt_2, %object
	.size	vt_2, 16
vt_2:
	.word	0
	.word	32767
	.word	0
	.word	0
	.type	vt_3, %object
	.size	vt_3, 16
vt_3:
	.word	0
	.word	0
	.word	32767
	.word	0
	.type	vt_4, %object
	.size	vt_4, 16
vt_4:
	.word	0
	.word	0
	.word	0
	.word	32767
	.type	m_1, %object
	.size	m_1, 16
m_1:
	.word	10000
	.word	5000
	.word	2500
	.word	1250
	.type	m_2, %object
	.size	m_2, 16
m_2:
	.word	5000
	.word	10000
	.word	5000
	.word	2500
	.type	m_3, %object
	.size	m_3, 16
m_3:
	.word	2500
	.word	5000
	.word	10000
	.word	5000
	.type	m_4, %object
	.size	m_4, 16
m_4:
	.word	1250
	.word	2500
	.word	5000
	.word	10000
	.section	.rodata
	.align	3
	.set	.LANCHOR1,. + 0
.LC0:
	.word	32767
	.word	0
	.word	0
	.word	0
	.word	0
	.word	32767
	.word	0
	.word	0
	.word	0
	.word	0
	.word	32767
	.word	0
	.word	0
	.word	0
	.word	0
	.word	32767
	.section	.rodata.str1.4,"aMS",%progbits,1
	.align	2
.LC2:
	.ascii	"Sweep %d of Matrix M:\012\000"
	.space	1
.LC3:
	.ascii	"%.2d \000"
	.ident	"GCC: (GNU) 8.2.1 20180801 (Red Hat 8.2.1-2)"
	.section	.note.GNU-stack,"",%progbits
