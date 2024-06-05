// Copyright 2009 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#include "textflag.h"

// Set the x_crosscall2_ptr C function pointer variable point to crosscall2.
// It's such a pointer chain: _crosscall2_ptr -> x_crosscall2_ptr -> crosscall2
// Use a local trampoline, to avoid taking the address of a dynamically exported
// function.
TEXT ·set_crosscall2(SB),NOSPLIT,$0-0
	MOVL	_crosscall2_ptr(SB), AX
	MOVL	$crosscall2_trampoline<>(SB), BX
	MOVL	BX, (AX)
	RET

TEXT crosscall2_trampoline<>(SB),NOSPLIT,$0-0
	JMP	crosscall2(SB)

// Called by C code generated by cmd/cgo.
// func crosscall2(fn, a unsafe.Pointer, n int32, ctxt uintptr)
// Saves C callee-saved registers and calls cgocallback with three arguments.
// fn is the PC of a func(a unsafe.Pointer) function.
TEXT crosscall2(SB),NOSPLIT,$28-16
	MOVL BP, 24(SP)
	MOVL BX, 20(SP)
	MOVL SI, 16(SP)
	MOVL DI, 12(SP)

	MOVL	ctxt+12(FP), AX
	MOVL	AX, 8(SP)
	MOVL	a+4(FP), AX
	MOVL	AX, 4(SP)
	MOVL	fn+0(FP), AX
	MOVL	AX, 0(SP)
	CALL	runtime·cgocallback(SB)

	MOVL 12(SP), DI
	MOVL 16(SP), SI
	MOVL 20(SP), BX
	MOVL 24(SP), BP
	RET