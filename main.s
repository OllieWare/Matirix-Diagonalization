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
	rsb	r0, r0, #32768
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
	add	r3, r3, r0, lsl #1
	ldrsh	r1, [r3, #2]
	ldrsh	r3, [r3, #4]
	rsb	r2, r1, #0
	sub	sp, sp, #16
	sxth	r2, r2
	strh	r2, [sp, #10]	@ movhi
	strh	r2, [sp, #4]	@ movhi
	strh	r3, [sp, #8]	@ movhi
	strh	r3, [sp, #14]	@ movhi
	strh	r3, [sp]	@ movhi
	strh	r3, [sp, #6]	@ movhi
	strh	r1, [sp, #12]	@ movhi
	strh	r1, [sp, #2]	@ movhi
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
	mov	r0, #0
	bx	lr
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
	mov	r0, #0
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
	mov	r0, #0
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
	.global	rotate
	.syntax unified
	.arm
	.fpu neon
	.type	rotate, %function
rotate:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	bx	lr
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
	vld1.64	{d22-d23}, [r0:64]
	vldr	d18, [r0, #16]
	vldr	d19, [r0, #24]
	vldr	d20, [r0, #32]
	vldr	d21, [r0, #40]
	vtrn.32	q11, q9
	vldr	d16, [r0, #48]
	vldr	d17, [r0, #56]
	vmov	q14, q9  @ v4si
	vmov	q9, q10  @ v4si
	vtrn.32	q9, q8
	vmov	q13, q11  @ v4si
	vmov	q15, q8  @ v4si
	vmov	d24, d22  @ v2si
	vmov	d21, d16  @ v2si
	vmov	d25, d18  @ v2si
	vmov	d22, d27  @ v2si
	vmov	d23, d19  @ v2si
	vmov	d20, d28  @ v2si
	vmov	d16, d29  @ v2si
	vmov	d17, d31  @ v2si
	vst1.64	{d24-d25}, [r0:64]
	vstr	d22, [r0, #32]
	vstr	d23, [r0, #40]
	vstr	d20, [r0, #16]
	vstr	d21, [r0, #24]
	vstr	d16, [r0, #48]
	vstr	d17, [r0, #56]
	bx	lr
	.size	transpose_32x4, .-transpose_32x4
	.section	.text.startup,"ax",%progbits
	.align	2
	.global	main
	.syntax unified
	.arm
	.fpu neon
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 88
	@ frame_needed = 0, uses_anonymous_args = 0
	movw	r3, #:lower16:.LANCHOR1
	movt	r3, #:upper16:.LANCHOR1
	vld1.64	{d22-d23}, [r3:64]
	vldr	d20, [r3, #16]
	vldr	d21, [r3, #24]
	vldr	d18, [r3, #32]
	vldr	d19, [r3, #40]
	vldr	d16, [r3, #48]
	vldr	d17, [r3, #56]
	push	{r4, r5, r6, r7, r8, r9, r10, fp, lr}
	sub	sp, sp, #92
	add	r7, sp, #24
	movw	r6, #:lower16:.LC1
	vstr	d22, [sp, #24]
	vstr	d23, [sp, #32]
	vstr	d20, [r7, #16]
	vstr	d21, [r7, #24]
	vstr	d18, [r7, #32]
	vstr	d19, [r7, #40]
	vstr	d16, [r7, #48]
	vstr	d17, [r7, #56]
	mov	r4, r7
	mov	r5, r7
	add	r8, sp, #88
	movt	r6, #:upper16:.LC1
.L18:
	vld1.64	{d16-d17}, [r5:64]
	mov	r0, r6
	vmov.32	r1, d16[0]
	bl	printf
	vld1.64	{d16-d17}, [r5:64]!
	mov	r0, r6
	vmov.32	r1, d16[1]
	bl	printf
	vldr	d16, [r5, #-16]
	vldr	d17, [r5, #-8]
	mov	r0, r6
	vmov.32	r1, d17[0]
	bl	printf
	vldr	d16, [r5, #-16]
	vldr	d17, [r5, #-8]
	mov	r0, r6
	vmov.32	r1, d17[1]
	bl	printf
	mov	r0, #10
	bl	putchar
	cmp	r8, r5
	bne	.L18
	mov	r0, r7
	movw	r5, #:lower16:.LC1
	bl	transpose_32x4
	movt	r5, #:upper16:.LC1
.L19:
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
	cmp	r8, r4
	bne	.L19
	mov	r0, #10
	bl	putchar
	vldr	d16, .L29
	movw	r6, #:lower16:.LANCHOR0
	movw	fp, #:lower16:rot_left
	movw	r10, #:lower16:rot_right
	movw	r9, #:lower16:.LC2
	movw	r8, #:lower16:.LC3
	vstr	d16, [sp, #16]
	mov	r1, #1000
	mov	r4, #0
	movt	r6, #:upper16:.LANCHOR0
	movt	fp, #:upper16:rot_left
	movt	r10, #:upper16:rot_right
	movt	r9, #:upper16:.LC2
	movt	r8, #:upper16:.LC3
	add	r5, sp, #18
.L20:
	mov	r2, r4
	add	r4, r4, r4, lsl #1
	lsl	r4, r4, #1
	mov	r0, r9
	bl	printf
	add	r2, r6, r4
	ldrsh	r0, [r2, #2]
	ldrsh	r3, [r2, #4]
	rsb	r1, r0, #0
	sxth	r1, r1
	strh	r0, [sp, #12]	@ movhi
	strh	r0, [sp, #2]	@ movhi
	strh	r1, [sp, #10]	@ movhi
	strh	r1, [sp, #4]	@ movhi
	strh	r3, [sp, #8]	@ movhi
	strh	r3, [sp, #14]	@ movhi
	strh	r3, [sp]	@ movhi
	strh	r3, [sp, #6]	@ movhi
	vldr	d17, [sp, #8]
	vldr	d16, [sp]
	ldrsh	r3, [r2, #4]
	ldrsh	r1, [r6, r4]
	ldrsh	r2, [r2, #2]
	mov	r0, r8
	vstr	d17, [fp]
	vstr	d16, [r10]
	bl	printf
	cmp	r7, r5
	beq	.L28
	ldrsh	r1, [r5], #2
	sub	r4, r1, #16384
	cmp	r4, #0
	eor	r3, r1, r1, asr #31
	sub	r3, r3, r1, asr #31
	rsblt	r4, r4, #0
	cmp	r3, r4
	rsb	r3, r1, #32768
	blt	.L23
	cmp	r4, r3
	movlt	r4, #1
	movge	r4, #2
	b	.L20
.L28:
	mov	r0, #0
	add	sp, sp, #92
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r9, r10, fp, pc}
.L23:
	mov	r4, #0
	b	.L20
.L30:
	.align	3
.L29:
	.short	1000
	.short	14000
	.short	16000
	.short	30000
	.size	main, .-main
	.comm	rot_left,8,8
	.comm	rot_right,8,8
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
	.size	trig_table, 30
trig_table:
	.short	0
	.short	0
	.short	-32768
	.short	22
	.short	12288
	.short	30199
	.short	45
	.short	23170
	.short	23170
	.short	67
	.short	30199
	.short	12288
	.short	90
	.short	-32768
	.short	0
	.space	2
	.type	vt_4, %object
	.size	vt_4, 16
vt_4:
	.word	0
	.word	0
	.word	0
	.word	1
	.type	vt_3, %object
	.size	vt_3, 16
vt_3:
	.word	0
	.word	0
	.word	1
	.word	0
	.type	vt_2, %object
	.size	vt_2, 16
vt_2:
	.word	0
	.word	1
	.word	0
	.word	0
	.type	vt_1, %object
	.size	vt_1, 16
vt_1:
	.word	1
	.word	0
	.word	0
	.word	0
	.type	u_4, %object
	.size	u_4, 16
u_4:
	.word	0
	.word	0
	.word	0
	.word	1
	.type	u_3, %object
	.size	u_3, 16
u_3:
	.word	0
	.word	0
	.word	1
	.word	0
	.type	u_2, %object
	.size	u_2, 16
u_2:
	.word	0
	.word	1
	.word	0
	.word	0
	.type	u_1, %object
	.size	u_1, 16
u_1:
	.word	1
	.word	0
	.word	0
	.word	0
	.bss
	.align	3
	.set	.LANCHOR1,. + 0
	.type	m_1, %object
	.size	m_1, 16
m_1:
	.space	16
	.type	m_2, %object
	.size	m_2, 16
m_2:
	.space	16
	.type	m_3, %object
	.size	m_3, 16
m_3:
	.space	16
	.type	m_4, %object
	.size	m_4, 16
m_4:
	.space	16
	.section	.rodata.str1.4,"aMS",%progbits,1
	.align	2
.LC1:
	.ascii	"%.2d \000"
	.space	2
.LC2:
	.ascii	"Angle %d categorized as %d\012\000"
.LC3:
	.ascii	"Angle: %d, Sin: %d, Cos: %d\012\000"
	.ident	"GCC: (GNU) 8.2.1 20180801 (Red Hat 8.2.1-2)"
	.section	.note.GNU-stack,"",%progbits
