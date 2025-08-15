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
	.global	arctan
	.arch armv7-a
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
	movw	r3, #:lower16:.LANCHOR0
	subcc	ip, ip, r0, asr #31
	movwcs	ip, #32767
	mov	r0, #0
	str	r2, [r1]
	movt	r3, #:upper16:.LANCHOR0
.L4:
	ldr	r2, [r3], #4
	cmp	r2, ip
	bxge	lr
	add	r0, r0, #1
	cmp	r0, #46
	bne	.L4
	mvn	r0, #0
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
	movw	r3, #:lower16:.LANCHOR0
	add	r0, r0, r0, lsl #1
	movt	r3, #:upper16:.LANCHOR0
	add	r3, r3, r0, lsl #2
	ldr	r0, [r3, #192]
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
	ldr	r0, [r3, #188]
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
	ldr	r2, [r3, #192]
	cmp	r1, #0
	vmov.32	d16[0], r2
	vstr	d16, [r0]
	blt	.L11
	ldr	r2, [r3, #188]
	vldr	d17, [r0, #8]
	rsb	r2, r2, #0
	vmov.32	d16[1], r2
	vstr	d16, [r0]
	vmov	d16, d17  @ v2si
	add	r2, r3, #188
	vld1.32	{d16[0]}, [r2]
	vstr	d16, [r0, #8]
	add	r3, r3, #192
	vld1.32	{d16[1]}, [r3]
	vstr	d16, [r0, #8]
	bx	lr
.L11:
	add	r2, r3, #188
	vld1.32	{d16[1]}, [r2]
	vstr	d16, [r0]
	vldr	d16, [r0, #8]
	ldr	r2, [r3, #188]
	add	r3, r3, #192
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
	bge	.L16
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
.L16:
	movw	r0, #32767
	bx	lr
	.size	saturate_q15, .-saturate_q15
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
.L48:
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
	beq	.L31
.L102:
	cmp	r1, #3
	beq	.L32
	cmp	r1, #1
	beq	.L99
	ldrd	r2, [sp]
	cmp	r1, #2
	beq	.L36
	cmp	r1, #3
	beq	.L35
	cmp	r1, #1
	beq	.L37
	ldrd	r2, [sp, #8]
	cmp	r1, #2
	beq	.L40
	cmp	r1, #3
	beq	.L39
	cmp	r1, #1
	beq	.L41
	cmp	r1, #2
	mov	r2, r8
	mov	r3, r9
	vmov.32	r4, d19[1]
	beq	.L44
	cmp	r1, #3
	beq	.L43
	cmp	r1, #1
	beq	.L45
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
	bge	.L100
.L47:
	mov	r4, #32768
	mvn	r5, #0
	mov	r7, #32768
	movt	r4, 65535
	cmp	r2, r4
	sbcs	r4, r3, r5
	movt	r7, 65535
	movlt	r2, r7
.L24:
	cmp	r1, #2
	beq	.L25
	cmp	r1, #3
	beq	.L97
	cmp	r1, #1
	beq	.L27
	cmp	r1, #3
	vmov.32	d16[0], r2
	beq	.L101
.L28:
	add	r1, r1, #1
	cmp	r1, #2
	bne	.L102
.L31:
	ldrd	r2, [sp, #24]
.L36:
	vmov.32	r4, d25[0]
	smlal	r2, r3, r4, lr
.L40:
	vmov.32	r4, d23[0]
	smlal	r2, r3, ip, r4
	vmov.32	r4, d19[1]
.L44:
	ldr	r5, [sp, #48]
	smlal	r2, r3, r4, r5
	adds	r4, r2, #16384
	adc	r5, r3, #0
	lsr	r2, r4, #15
	orr	r2, r2, r5, lsl #17
	asr	r3, r5, #15
	cmp	r2, #32768
	sbcs	r4, r3, #0
	blt	.L47
	movw	r2, #32767
.L25:
	vmov.32	d17[0], r2
	b	.L28
.L97:
	ldr	r6, [sp, #20]
.L26:
	vmov.32	d17[1], r2
.L29:
	ldr	r3, [sp, #32]
	add	fp, fp, #16
	cmp	fp, r3
	vst1.64	{d16-d17}, [r6:64]!
	bne	.L48
	ldr	lr, [sp, #52]
	add	r4, sp, #56
	add	r5, sp, #120
.L49:
	mov	ip, r4
	ldmia	ip!, {r0, r1, r2, r3}
	cmp	ip, r5
	str	r0, [lr]	@ unaligned
	str	r1, [lr, #4]	@ unaligned
	str	r2, [lr, #8]	@ unaligned
	str	r3, [lr, #12]	@ unaligned
	mov	r4, ip
	add	lr, lr, #16
	bne	.L49
	add	sp, sp, #124
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r9, r10, fp, pc}
.L99:
	vmov.32	r2, d26[1]
	smull	r2, r3, r0, r2
.L37:
	vmov.32	r4, d24[1]
	smlal	r2, r3, r4, lr
.L41:
	vmov.32	r4, d22[1]
	smlal	r2, r3, ip, r4
	vmov.32	r4, d19[1]
.L45:
	vmov.32	r5, d20[1]
	smlal	r2, r3, r4, r5
	adds	r4, r2, #16384
	adc	r5, r3, #0
	lsr	r2, r4, #15
	orr	r2, r2, r5, lsl #17
	asr	r3, r5, #15
	cmp	r2, #32768
	sbcs	r4, r3, #0
	blt	.L47
	movw	r2, #32767
.L27:
	vmov.32	d16[1], r2
	b	.L28
.L32:
	vmov.32	r2, d27[1]
	smull	r2, r3, r2, r0
.L35:
	vmov.32	r4, d25[1]
	smlal	r2, r3, lr, r4
.L39:
	vmov.32	r4, d23[1]
	smlal	r2, r3, r4, ip
	vmov.32	r4, d19[1]
.L43:
	vmov.32	r5, d21[1]
	smlal	r2, r3, r5, r4
	adds	r4, r2, #16384
	adc	r5, r3, #0
	lsr	r2, r4, #15
	orr	r2, r2, r5, lsl #17
	asr	r3, r5, #15
	cmp	r2, #32768
	sbcs	r4, r3, #0
	blt	.L47
	ldr	r6, [sp, #20]
	movw	r2, #32767
	b	.L26
.L100:
	movw	r2, #32767
	b	.L24
.L101:
	ldr	r6, [sp, #20]
	b	.L29
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
	bge	.L104
	mov	r8, #32768
	mvn	r9, #0
	mov	r3, #32768
	movt	r8, 65535
	cmp	r6, r8
	sbcs	ip, r7, r9
	movt	r3, 65535
	movlt	r6, r3
.L104:
	cmp	r0, #32768
	sbcs	r3, r1, #0
	movwge	r0, #32767
	bge	.L105
	mov	r8, #32768
	mvn	r9, #0
	mov	r3, #32768
	movt	r8, 65535
	cmp	r0, r8
	sbcs	ip, r1, r9
	movt	r3, 65535
	movlt	r0, r3
.L105:
	cmp	r4, #32768
	sbcs	r3, r5, #0
	movwge	r4, #32767
	bge	.L106
	mov	r8, #32768
	mvn	r9, #0
	mov	r3, #32768
	movt	r8, 65535
	cmp	r4, r8
	sbcs	r1, r5, r9
	movt	r3, 65535
	movlt	r4, r3
.L106:
	cmp	r10, #32768
	sbcs	r3, fp, #0
	movwge	r10, #32767
	bge	.L107
	mov	r8, #32768
	mvn	r9, #0
	mov	r3, #32768
	movt	r8, 65535
	cmp	r10, r8
	sbcs	r1, fp, r9
	movt	r3, 65535
	movlt	r10, r3
.L107:
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
	.global	__aeabi_ldivmod
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
	@ args = 0, pretend = 0, frame = 488
	@ frame_needed = 0, uses_anonymous_args = 0
	movw	r3, #:lower16:.LANCHOR0
	push	{r4, r5, r6, r7, r8, r9, r10, fp, lr}
	movt	r3, #:upper16:.LANCHOR0
	vpush.64	{d8, d9, d10}
	vldr	d22, [r3, #736]
	vldr	d23, [r3, #744]
	vldr	d0, [r3, #752]
	vldr	d1, [r3, #760]
	vldr	d2, [r3, #768]
	vldr	d3, [r3, #776]
	vldr	d4, [r3, #784]
	vldr	d5, [r3, #792]
	vldr	d20, [r3, #800]
	vldr	d21, [r3, #808]
	vldr	d6, [r3, #816]
	vldr	d7, [r3, #824]
	vldr	d30, [r3, #832]
	vldr	d31, [r3, #840]
	vldr	d28, [r3, #848]
	vldr	d29, [r3, #856]
	vldr	d18, [r3, #864]
	vldr	d19, [r3, #872]
	vldr	d26, [r3, #880]
	vldr	d27, [r3, #888]
	vldr	d24, [r3, #896]
	vldr	d25, [r3, #904]
	vldr	d16, [r3, #912]
	vldr	d17, [r3, #920]
	movw	r3, #:lower16:.LANCHOR1
	sub	sp, sp, #492
	movt	r3, #:upper16:.LANCHOR1
	movw	r2, #26215
	str	r3, [sp, #20]
	mov	r3, #0
	vstr	d22, [sp, #104]
	vstr	d23, [sp, #112]
	vstr	d0, [sp, #120]
	vstr	d1, [sp, #128]
	vstr	d2, [sp, #136]
	vstr	d3, [sp, #144]
	vstr	d4, [sp, #152]
	vstr	d5, [sp, #160]
	vstr	d20, [sp, #168]
	vstr	d21, [sp, #176]
	vstr	d6, [sp, #184]
	vstr	d7, [sp, #192]
	vstr	d30, [sp, #200]
	vstr	d31, [sp, #208]
	vstr	d28, [sp, #216]
	vstr	d29, [sp, #224]
	vstr	d18, [sp, #232]
	vstr	d19, [sp, #240]
	vstr	d26, [sp, #248]
	vstr	d27, [sp, #256]
	vstr	d24, [sp, #264]
	vstr	d25, [sp, #272]
	vstr	d16, [sp, #280]
	vstr	d17, [sp, #288]
	vmov.i32	q4, #0  @ ti
	movt	r2, 26214
	str	r2, [sp, #32]
	str	r3, [sp, #36]
.L119:
	add	r0, sp, #232
	bl	max_off_diag
	cmp	r0, #1000
	ble	.L167
	mov	r9, #0
	ldr	r3, [sp, #36]
	add	fp, sp, #296
	add	r8, sp, #360
	add	r3, r3, #1
	str	fp, [sp, #12]
	str	r8, [sp, #16]
	str	r3, [sp, #36]
	add	r10, sp, #72
.L147:
	add	r3, r9, #1
	mov	r7, r3
	str	r3, [sp, #28]
	ldr	r3, [sp, #16]
	vmov.i32	d10, #0  @ v2si
	str	r3, [sp]
	ldr	r3, [sp, #12]
	str	r3, [sp, #4]
	mov	r3, r9
	mov	r9, r7
	mov	r7, r3
.L146:
	add	r3, sp, #40
	cmp	r7, #1
	vst1.64	{d8-d9}, [r3:64]
	beq	.L120
	cmp	r7, #2
	beq	.L121
	cmp	r9, #2
	vldr	d18, [sp, #232]
	vldr	d19, [sp, #240]
	beq	.L122
	cmp	r9, #3
	beq	.L123
	vldr	d20, [sp, #248]
	vldr	d21, [sp, #256]
	vmov.32	r2, d18[0]
	vmov.32	r3, d20[0]
	vldr	d17, [sp, #48]
	vldr	d16, [sp, #40]
	vmov.32	d17[0], r3
	vmov.32	d16[0], r2
	vmov.32	r3, d20[1]
	vmov.32	r2, d18[1]
.L171:
	vmov.32	d16[1], r2
	vmov.32	d17[1], r3
	vstr	d16, [sp, #40]
	vstr	d17, [sp, #48]
	vmov	d18, d16  @ v2si
.L124:
	vldr	d16, [sp, #48]
	vmov.32	r6, d18[0]
	vmov.32	r3, d16[1]
	subs	r2, r3, r6
	vmov.32	r4, d18[1]
	add	r6, r6, r3
	vmov.32	r5, d17[0]
	beq	.L127
	add	r0, r4, r5
	asr	r1, r0, #31
	lsl	r1, r1, #15
	asr	r3, r2, #1
	orr	r1, r1, r0, lsr #17
	lsl	r0, r0, #15
	adds	r0, r0, r3
	adc	r1, r1, r3, asr #31
	asr	r3, r2, #31
	bl	__aeabi_ldivmod
	cmp	r6, #0
	add	r3, r0, #32768
	str	r0, [sp, #24]
	str	r3, [sp, #8]
	bne	.L152
	ldr	r3, [sp, #8]
	movw	lr, #65535
	cmp	r3, #65536
	movw	r0, #32767
	movwcs	r4, #32767
	bcc	.L172
.L129:
	movw	r2, #:lower16:.LANCHOR0
	movt	r2, #:upper16:.LANCHOR0
	mov	r5, r2
	mov	r1, r2
	mov	r3, #0
	b	.L131
.L174:
	add	r3, r3, #1
	cmp	r3, #46
	beq	.L173
.L131:
	ldr	ip, [r1], #4
	cmp	ip, r4
	blt	.L174
	add	r3, r3, r3, lsl #2
.L132:
	cmp	lr, #65536
	movwcs	r0, #32767
	bcs	.L133
	cmp	r0, #0
	rsblt	r0, r0, #0
.L133:
	mov	r1, #0
	b	.L135
.L176:
	add	r1, r1, #1
	cmp	r1, #46
	beq	.L175
.L135:
	ldr	ip, [r2], #4
	cmp	ip, r0
	blt	.L176
	add	r1, r1, r1, lsl #2
.L136:
	add	r1, r3, r1
	asr	r0, r1, #2
	cmp	r0, #4
	sub	r2, r3, r0
	movle	r3, #1
	ble	.L137
	cmp	r0, #49
	movgt	r3, #9
	ldrle	r3, [sp, #32]
	asrle	r1, r1, #31
	smullle	r0, r3, r3, r0
	rsble	r3, r1, r3, asr #1
.L137:
	cmp	r2, #4
	ble	.L158
	cmp	r2, #49
	ble	.L177
	mov	r2, #9
.L138:
	add	r1, sp, #56
	vst1.64	{d8-d9}, [r1:64]
	vst1.64	{d8-d9}, [r10:64]
.L151:
	vldr	d17, [sp, #72]
	vldr	d16, [sp, #80]
	add	r3, r3, r3, lsl #1
	add	r3, r5, r3, lsl #2
	ldr	r0, [r3, #192]
	ldr	r1, [r3, #188]
	vldr	d18, [sp, #64]
	vmov.32	d17[0], r0
	vmov.32	d16[0], r1
	vmov	d19, d10  @ v2si
	add	r2, r2, r2, lsl #1
	add	r5, r5, r2, lsl #2
	ldr	ip, [r5, #192]
	ldr	r3, [r5, #188]
	rsb	r1, r1, #0
	vmov.32	d19[0], ip
	vmov.32	d17[1], r1
	vmov.32	d16[1], r0
	vmov.32	d18[0], r3
	rsb	r3, r3, #0
	vuzp.32	d17, d16
	vmov.32	d19[1], r3
	vmov.32	d18[1], ip
	add	r2, sp, #88
	add	r1, sp, #40
	add	r0, sp, #56
	vstr	d17, [sp, #72]
	vstr	d16, [sp, #80]
	vstr	d19, [sp, #56]
	vstr	d18, [sp, #64]
	vst1.64	{d8-d9}, [r2:64]
	bl	matrix_multiply
	add	r2, sp, #40
	mov	r1, r10
	add	r0, sp, #88
	bl	matrix_multiply
	vldr	d18, [sp, #72]
	vldr	d19, [sp, #80]
	vmov	d17, d18  @ v2si
	vmov	d16, d19  @ v2si
	ldr	r3, [sp, #20]
	vuzp.32	d17, d16
	vldmia	r3, {d24-d31}
	cmp	r7, #1
	vstr	d17, [sp, #72]
	vstr	d16, [sp, #80]
	vstmia	fp, {d24-d31}
	vstmia	r8, {d24-d31}
	beq	.L139
	cmp	r7, #2
	beq	.L140
	cmp	r9, #2
	vldr	d27, [sp, #64]
	vldr	d26, [r10]
	vldr	d25, [r10, #8]
	vldr	d24, [sp, #56]
	beq	.L141
	cmp	r9, #3
	beq	.L142
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
.L143:
	vldr	d18, [sp, #168]
	vldr	d19, [sp, #176]
	vldr	d16, [sp, #184]
	vldr	d17, [sp, #192]
	vldr	d22, [sp, #200]
	vldr	d23, [sp, #208]
	vtrn.32	q9, q8
	vldr	d20, [sp, #216]
	vldr	d21, [sp, #224]
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
	add	r2, sp, #168
	add	r3, sp, #424
	mov	r1, r2
	mov	r0, r8
	vstmia	r3, {d24-d31}
	vstr	d6, [sp, #168]
	vstr	d7, [sp, #176]
	vstr	d22, [sp, #200]
	vstr	d23, [sp, #208]
	vstr	d18, [sp, #184]
	vstr	d19, [sp, #192]
	vstr	d16, [sp, #216]
	vstr	d17, [sp, #224]
	bl	matrix_multiply_4x4
	add	r2, sp, #424
	add	r1, sp, #232
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
	add	r2, sp, #232
	mov	r1, r8
	add	r0, sp, #424
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
	add	r2, sp, #104
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
	add	r9, r9, #1
	add	r3, r3, #16
	str	r3, [sp, #4]
	ldr	r3, [sp]
	cmp	r9, #4
	add	r3, r3, #16
	str	r3, [sp]
	bne	.L146
	mov	r0, #10
	bl	putchar
	ldr	r3, [sp, #12]
	ldr	r9, [sp, #28]
	add	r3, r3, #16
	str	r3, [sp, #12]
	ldr	r3, [sp, #16]
	cmp	r9, #3
	add	r3, r3, #16
	str	r3, [sp, #16]
	bne	.L147
	movw	r0, #:lower16:.LC2
	ldr	r1, [sp, #36]
	movt	r0, #:upper16:.LC2
	movw	r5, #:lower16:.LC3
	bl	printf
	add	r4, sp, #232
	movt	r5, #:upper16:.LC3
.L148:
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
	bne	.L148
	mov	r0, #10
	bl	putchar
	ldr	r3, [sp, #36]
	cmp	r3, #20
	bne	.L119
.L167:
	mov	r0, #0
	add	sp, sp, #492
	@ sp needed
	vldm	sp!, {d8-d10}
	pop	{r4, r5, r6, r7, r8, r9, r10, fp, pc}
.L158:
	mov	r2, #1
	b	.L138
.L160:
	movw	r3, #65535
	str	r3, [sp, #8]
	movw	r3, #32767
	str	r3, [sp, #24]
.L152:
	sub	r2, r5, r4
	asr	r3, r2, #31
	lsl	r3, r3, #15
	orr	r3, r3, r2, lsr #17
	asr	r0, r6, #1
	lsl	r2, r2, #15
	adds	r4, r2, r0
	adc	r5, r3, r0, asr #31
	mov	r1, r5
	mov	r0, r4
	asr	r3, r6, #31
	mov	r2, r6
	bl	__aeabi_ldivmod
	ldr	r3, [sp, #8]
	add	lr, r0, #32768
	cmp	r3, #65536
	movwcs	r4, #32767
	bcs	.L129
.L172:
	ldr	r4, [sp, #24]
	cmp	r4, #0
	rsblt	r4, r4, #0
	b	.L129
.L127:
	cmp	r6, #0
	bne	.L160
	movw	r4, #32767
	movw	lr, #65535
	mov	r0, r4
	b	.L129
.L177:
	add	r1, sp, #56
	vst1.64	{d8-d9}, [r1:64]
	ldr	r1, [sp, #32]
	vst1.64	{d8-d9}, [r10:64]
	smull	r0, r1, r1, r2
	asr	r2, r2, #31
	rsb	r2, r2, r1, asr #1
	b	.L151
.L175:
	mvn	r1, #4
	b	.L136
.L173:
	mvn	r3, #4
	b	.L132
.L140:
	vldr	d21, [sp, #56]
	vldr	d20, [r10]
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
	vldr	d21, [sp, #64]
	vstr	d16, [r8, #32]
	vstr	d17, [r8, #40]
	vldr	d20, [r10, #8]
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
	b	.L143
.L139:
	cmp	r9, #2
	beq	.L144
	cmp	r9, #3
	bne	.L143
	vldr	d27, [sp, #56]
	vldr	d26, [sp, #64]
	vldr	d25, [r10]
	vldr	d24, [r10, #8]
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
	b	.L143
.L121:
	add	r3, sp, #232
	add	r3, r3, r9, lsl #4
	vld1.64	{d20-d21}, [r3:64]
	vldr	d18, [sp, #264]
	vldr	d19, [sp, #272]
	vmov.32	r2, d21[0]
	vldr	d17, [sp, #48]
	vldr	d16, [sp, #40]
	vmov.32	r3, d19[0]
.L170:
	vmov.32	d17[0], r2
	vmov.32	d16[0], r3
	vmov.32	r2, d21[1]
	vmov.32	r3, d19[1]
	vmov.32	d17[1], r2
	vmov.32	d16[1], r3
	vstr	d17, [sp, #48]
	vstr	d16, [sp, #40]
	vmov	d18, d16  @ v2si
	b	.L124
.L120:
	cmp	r9, #2
	beq	.L125
	cmp	r9, #3
	bne	.L178
	vldr	d20, [sp, #248]
	vldr	d21, [sp, #256]
	vldr	d18, [sp, #280]
	vldr	d19, [sp, #288]
	vmov.32	r2, d20[1]
	vmov.32	r3, d18[1]
	vldr	d16, [sp, #40]
	vldr	d17, [sp, #48]
	vmov.32	d16[0], r2
	vmov.32	d17[0], r3
	vmov.32	r2, d21[1]
	vmov.32	r3, d19[1]
.L169:
	vmov.32	d16[1], r2
	vmov.32	d17[1], r3
	vstr	d16, [sp, #40]
	vstr	d17, [sp, #48]
	vmov	d18, d16  @ v2si
	b	.L124
.L178:
	vmov.i32	d17, #0  @ v2si
	vldr	d18, [sp, #40]
	b	.L124
.L125:
	vldr	d20, [sp, #248]
	vldr	d21, [sp, #256]
	vldr	d18, [sp, #264]
	vldr	d19, [sp, #272]
	vmov.32	r2, d20[1]
	vmov.32	r3, d18[1]
	vldr	d16, [sp, #40]
	vldr	d17, [sp, #48]
	vmov.32	d16[0], r2
	vmov.32	d17[0], r3
	vmov.32	r2, d21[0]
	vmov.32	r3, d19[0]
	b	.L169
.L144:
	vldr	d27, [sp, #56]
	vldr	d26, [sp, #64]
	vldr	d25, [r10]
	vldr	d24, [r10, #8]
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
	b	.L143
.L142:
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
	b	.L143
.L141:
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
	b	.L143
.L123:
	vldr	d20, [sp, #280]
	vldr	d21, [sp, #288]
	vldr	d17, [sp, #48]
	vmov.32	r2, d20[0]
	vldr	d16, [sp, #40]
	vmov.32	r3, d18[0]
	b	.L170
.L122:
	vldr	d20, [sp, #264]
	vldr	d21, [sp, #272]
	vmov.32	r2, d18[0]
	vmov.32	r3, d20[0]
	vldr	d17, [sp, #48]
	vldr	d16, [sp, #40]
	vmov.32	d17[0], r3
	vmov.32	d16[0], r2
	vmov.32	r3, d21[0]
	vmov.32	r2, d19[0]
	b	.L171
	.size	main, .-main
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
	.data
	.align	3
	.set	.LANCHOR0,. + 0
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
