

;  #10 10�i���l
; #$10 16�i���l
;  $10 16�i�A�h���X
; #%00000000 2�i��

.setcpu		"6502"
.autoimport	on

.include "define.asm"

.include "defineDMA.asm"

; iNES�w�b�_
.segment "HEADER"
	.byte	$4E, $45, $53, $1A	; "NES" Header
	.byte	$02			; PRG-BANKS
	.byte	$01			; CHR-BANKS
	.byte	$01			; �����~���[Vertical Mirror
	.byte	$00			; 
	.byte	$00, $00, $00, $00	; 
	.byte	$00, $00, $00, $00	; 

.segment "STARTUP"
; ���Z�b�g���荞��
.org $8000
.proc	Reset
	sei			; IRQ���荞�݂��֎~���܂��B

; �X�N���[���I�t
	lda #$00
	sta $2000
	sta $2001


; �����l

	lda #0
	sta key_state_on
	sta key_state_push
	sta scene_step
	sta cursor_pos
	sta param_duty_cycle			; Duty�T�C�N��
	sta param_loop					; ���[�v���邵�Ȃ�
	sta param_gensui                ; �Q���X�C���邵�Ȃ�
	sta param_gensui_value          ; �{�����[��
	sta param_sweep                 ; �X�C�[�v���邵�Ȃ�
	sta param_sweep_speed           ; �X�C�[�v�X�s�[�h
	sta param_sweep_up_down         ; �X�C�[�v����
	sta param_sweep_change_amount   ; �X�C�[�v�ω���
	sta param_onkai                 ; ���K
	sta sound_type					; �T�E���h�^�C�v
	sta param_counter
	sta param_counter_value_hi
	sta param_counter_value_low
	sta param_noise_loop
	sta param_noise_gensui_enable
	sta param_noise_rnd_type
	sta param_noize_hatyo


	; �h
	lda #%11010101
	sta onkai_do
	lda #%10111101
	sta onkai_re
	lda #%10101001
	sta onkai_mi
	lda #%10011111
	sta onkai_fa
	lda #%10001110
	sta onkai_so
	lda #%01111110
	sta onkai_ra
	lda #%01110000
	sta onkai_si
	lda #%01101010
	sta onkai_do2

	lda #0
	sta debug_var


; ��`�g
;	lda $4015		; �T�E���h���W�X�^
;	ora #%00000001	; ��`�g�`�����l���P��L���ɂ���
;	sta $4015
;
;	lda #%10111111	; Duty��E���������E���������E������
;	sta $4000	; ��`�g�`�����l���P���䃌�W�X�^�P
;	lda #%00000100	; ���g��(����8�r�b�g)
;	sta $4002	; ��`�g�`�����l���P���g�����W�X�^�P
;	lda #%11111011	; �Đ����ԁE���g��(���3�r�b�g)
;	sta $4003	; ��`�g�`�����l���P���g�����W�X�^�Q
;	lda $4015	; �T�E���h���W�X�^
;	ora #%00000010	; ��`�g�`�����l���Q��L���ɂ���
;	sta $4015
;
;	lda #%00000000	; ��`�g�`�����l����L���ɂ���
;	sta $4015
;
	lda $4015		; �T�E���h���W�X�^
	ora #%00000001	; ��`�g�`�����l���P��L���ɂ���
	sta $4015

	lda #%10111111
	sta $4000		; ��`�g�`�����l���P���䃌�W�X�^�P

	lda #%10101011
	sta $4001		; ��`�g�`�����l���P���䃌�W�X�^�Q
	lda #0		; ���V�т�X���W�����Ă݂�
	sta $4002		; ��`�g�`�����l���P���g�����W�X�^�P

	lda #%11111011
	sta $4003		; ��`�g�`�����l���P���g�����W�X�^�Q

; �O�p�g
;	lda #%00000100	; 
;	sta $4015
;
;	lda #%10000001	; �J�E���^�g�p�E����
;	sta $4008	; �O�p�g�`�����l�����䃌�W�X�^
;
;	lda #%00000100	; ���g��(����8�r�b�g)
;	sta $400A	; �O�p�g�`�����l���P���g�����W�X�^�P
;
;	lda #%00001011	; �Đ����ԁE���g��(���3�r�b�g)
;	sta $400B	; �O�p�g�`�����l���P���g�����W�X�^�Q
;
;	lda #%00000100	; 
;	sta $4015

; �m�C�Y
;	lda #%00001000	; 
;	sta $4015
;
;	lda #%11101111	; ���g�p�E���������E���������E������
;	sta $400C	; �m�C�Y���䃌�W�X�^
;
;	lda #%00000001	; �����^�C�v�E���g�p�E�g��
;	sta $400E	; �m�C�Y���g�����W�X�^�P
;	lda #%11111011	; �Đ����ԁE���g�p
;	sta $400F	; �m�C�Y���g�����W�X�^�Q


; �p���b�g�e�[�u���֓]��(BG�p�̂ݓ]��)
	lda	#$3f
	sta	$2006
	lda	#$00
	sta	$2006
	ldx	#$00
	ldy	#$16
copypal:
	lda	palettes_bg, x
	sta $2007
	inx				; X���C���N�������g����
	dey				; Y���f�N�������g����
	bne	copypal

; �p���b�g�e�[�u���֓]��(MAP�p�̂ݓ]��)
	lda	#$3f
	sta	$2006
	lda	#$10
	sta	$2006
	ldx	#$00
	ldy	#12
copypal2:
	lda	palette1, x
	sta $2007
	inx
	dey
	bne	copypal2

; �l�[���e�[�u���֓]��
	lda #%00001000	; VBlank���荞�݂Ȃ��A�X�v���C�g��1�A
	sta $2000

; �X�N���[���I��
	lda #%00001100	; VBlank���荞�݂Ȃ��A�X�v���C�g��1�AVRAM������32byte
	sta $2000


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	lda #%00001000	; VBlank���荞�݂Ȃ��A�X�v���C�g��1�AVRAM������1byte
	sta $2000


	lda	#%00011110
;	lda	#%00000000
	sta	$2001

; �X�N���[���ݒ�
	lda	#$00
	sta	$2005
	sta	$2005

; ���荞�݊J�n
	lda #%10001000	; VBlank���荞�݂���@VRAM������1byte
	sta $2000

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ���C�����[�v
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mainloop:

vblank_wait:
	lda	$2002
	and	#%10000000
	beq	vblank_wait

; �f�o�b�O
	lda #$20
	sta $2006
	lda #$00
	sta $2006
	clc
	lda debug_var
	adc #$37
	sta $2007

; ���̎�ސ؂蕪��
	lda sound_type
	cmp #0
	beq case_kukeiha
	cmp #1
	beq case_sankakuha
	cmp #2
	beq case_noise

case_kukeiha:
	jsr DrawKukeiha
	jmp break_sound_type

case_sankakuha:
	jsr DrawSankakuha
	jmp break_sound_type

case_noise:
	jsr DrawNoise
	jmp break_sound_type

break_sound_type:


	; �X�v���C�g


	; �X�v���C�g�`��(DMA�𗘗p)
	lda #$7  ; �X�v���C�g�f�[�^��$0700�Ԓn����Ȃ̂ŁA7�����[�h����B
	sta $4014 ; �X�v���C�gDMA���W�X�^��A���X�g�A���āA�X�v���C�g�f�[�^��DMA�]������

; �X�N���[���ݒ�
	lda	#$00
	sta	$2005
	sta	$2005

	clc
	lda #%10001000	; VBlank���荞�݂���
	sta $2000
	
	jsr	Update	; �X�V


	jmp	mainloop
.endproc

; ��`�g
.proc DrawKukeiha
	; �X�e�b�v�؂蕪��

lda	scene_step
asl	a		; �\�z�F���[�h�Ȃ̂�2�{���炵
tax
lda	Table_hit, x
sta	DoubleRAM
lda	Table_hit +1,x
sta	DoubleRAM +1
	jmp  (DoubleRAM)

Table_hit:
	.word hit0
	.word hit1
	.word hit2
	.word hit3
	.word hit4

; �^�C�g�������`��
hit0:
	; �^�C�g��bg
	jsr DrawKukeihaHead
	inc scene_step
jmp return

; �J�[�\���`��A�p�����[�^�`��
hit1:
	; �J�[�\���`��
	jsr DrawCursor
	; �p�����[�^�`��
	jsr DrawParam
	inc scene_step
jmp return

; �L�[���͑҂�
hit2:
	lda input_dirty_flg
	cmp #0
	beq hit2_end

	lda input_dirty_flg
	cmp #1
	beq next_hit1
	cmp #2
	beq next_hit3
	cmp #3
	beq next_sankakuha

next_hit1:
	lda #1
	sta scene_step
	jmp return

next_hit3:
	lda #3
	sta scene_step
	jmp return

next_sankakuha:
	lda #1	; �^�C�v���O�p�g�ɂ���
	sta sound_type
	lda #0	; �X�e�b�v������
	sta scene_step
	jmp return

hit2_end:
jmp return

; ���݂̐ݒ�łȂ炷
hit3:
	jsr PlaySoundKukei

	lda #2
	sta scene_step

jmp return

hit4:
jmp return

return:


	rts
.endproc

; �O�p�g
.proc DrawSankakuha
	; �X�e�b�v�؂蕪��

lda	scene_step
asl	a		; �\�z�F���[�h�Ȃ̂�2�{���炵
tax
lda	Table_hit, x
sta	DoubleRAM
lda	Table_hit +1,x
sta	DoubleRAM +1
	jmp  (DoubleRAM)

Table_hit:
	.word hit0
	.word hit1
	.word hit2
	.word hit3
	.word hit4

; �^�C�g�������`��
hit0:
	; �^�C�g��bg
	jsr DrawSankakuhaHead
	inc scene_step
jmp return

; �J�[�\���`��A�p�����[�^�`��
hit1:
	; �J�[�\���`��
	jsr DrawCursor
	; �p�����[�^�`��
	jsr DrawSankakuhaParam
	inc scene_step
jmp return

; �L�[���͑҂�
hit2:
	lda input_dirty_flg
	cmp #0
	beq hit2_end

	lda input_dirty_flg
	cmp #1
	beq next_hit1
	cmp #2
	beq next_hit3
	cmp #3
	beq next_noise

next_hit1:
	lda #1	; �`���
	sta scene_step
	jmp return

next_hit3:
	lda #3	; �v���C�T�E���h��
	sta scene_step
	jmp return

next_noise:
	lda #2	; �^�C�v���m�C�Y�ɂ���
	sta sound_type
	lda #0	; �X�e�b�v������
	sta scene_step
	jmp return

hit2_end:
jmp return

; ���݂̐ݒ�łȂ炷
hit3:
	jsr PlaySoundSankaku

	lda #2
	sta scene_step

jmp return

hit4:
jmp return

return:


	rts
.endproc

; �m�C�Y
.proc DrawNoise
	; �X�e�b�v�؂蕪��

lda	scene_step
asl	a		; �\�z�F���[�h�Ȃ̂�2�{���炵
tax
lda	Table_hit, x
sta	DoubleRAM
lda	Table_hit +1,x
sta	DoubleRAM +1
	jmp  (DoubleRAM)

Table_hit:
	.word hit0
	.word hit1
	.word hit2
	.word hit3
	.word hit4

; �^�C�g�������`��
hit0:
	; �^�C�g��bg
	jsr DrawNoiseHead
	inc scene_step
jmp return

; �J�[�\���`��A�p�����[�^�`��
hit1:
	; �J�[�\���`��
	jsr DrawCursor
	; �p�����[�^�`��
	jsr DrawNoiseParam
	inc scene_step
jmp return

; �L�[���͑҂�
hit2:
	lda input_dirty_flg
	cmp #0
	beq hit2_end

	lda input_dirty_flg
	cmp #1
	beq next_hit1
	cmp #2
	beq next_hit3
	cmp #3
	beq next_kukeiha

next_hit1:
	lda #1	; �`���
	sta scene_step
	jmp return

next_hit3:
	lda #3	; �v���C�T�E���h��
	sta scene_step
	jmp return

next_kukeiha:
	lda #0	; �^�C�v����`�g�ɂ���
	sta sound_type
	lda #0	; �X�e�b�v������
	sta scene_step
	jmp return

hit2_end:
jmp return

; ���݂̐ݒ�łȂ炷
hit3:
	jsr PlaySoundNoise

	lda #2
	sta scene_step

jmp return

hit4:
jmp return

return:


	rts
.endproc

; �w��A�h���X�̐��l��\��
.macro DrawBinaryNumber addr,posh,posl
	.local jmp_7_1
	.local skip_7
	.local jmp_6_1
	.local skip_6
	.local jmp_5_1
	.local skip_5
	.local jmp_4_1
	.local skip_4
	.local jmp_3_1
	.local skip_3
	.local jmp_2_1
	.local skip_2
	.local jmp_1_1
	.local skip_1
	.local jmp_0_1
	.local skip_0

	lda posh
	sta $2006
	lda posl
	sta $2006

	clc
	lda addr
	and #%10000000
	bne jmp_7_1
	lda #0
	jmp skip_7
jmp_7_1:
	lda #1
skip_7:
	adc #$37
	sta $2007

	lda addr
	and #%01000000
	bne jmp_6_1
	lda #0
	jmp skip_6
jmp_6_1:
	lda #1
skip_6:
	adc #$37
	sta $2007

	lda addr
	and #%00100000
	bne jmp_5_1
	lda #0
	jmp skip_5
jmp_5_1:
	lda #1
skip_5:
	adc #$37
	sta $2007

	lda addr
	and #%00010000
	bne jmp_4_1
	lda #0
	jmp skip_4
jmp_4_1:
	lda #1
skip_4:
	adc #$37
	sta $2007

	lda addr
	and #%00001000
	bne jmp_3_1
	lda #0
	jmp skip_3
jmp_3_1:
	lda #1
skip_3:
	adc #$37
	sta $2007

	lda addr
	and #%00000100
	bne jmp_2_1
	lda #0
	jmp skip_2
jmp_2_1:
	lda #1
skip_2:
	adc #$37
	sta $2007

	lda addr
	and #%00000010
	bne jmp_1_1
	lda #0
	jmp skip_1
jmp_1_1:
	lda #1
skip_1:
	adc #$37
	sta $2007

	lda addr
	and #%00000001
	bne jmp_0_1
	lda #0
	jmp skip_0
jmp_0_1:
	lda #1
skip_0:
	adc #$37
	sta $2007

.endmacro

; �T�E���h�Đ��A��`�g
.proc PlaySoundKukei
; ��`�g
	lda $4015		; �T�E���h���W�X�^
	ora #%00000010	; ��`�g�`�����l���Q��L���ɂ���
	sta $4015

; bit7-6: Duty�T�C�N��(positive/negative)
; 00: 2/14
; 01: 4/12
; 10: 8/ 8
; 11:12/ 4
; bit5: �G���x���[�vDecay���[�v/�����J�E���^����(1:���[�v,0:����)
; bit4: �G���x���[�vDecay����(1:����,0:�L��)0�Ō�����(�{�����[��)�L��
; bit3-0: �{�����[��/Decay���[�g�A������

	lda #0
	sta REG0

	; param_duty_cycle��6���V�t�g
	lda param_duty_cycle
	asl 
	asl 
	asl 
	asl 
	asl 
	asl 
	ora REG0
	sta REG0

	; param_loop��5���V�t�g
	lda param_loop
	asl 
	asl 
	asl 
	asl 
	asl 
	ora REG0
	sta REG0

	; param_gensui��4���V�t�g
	lda param_gensui
	asl 
	asl 
	asl 
	asl 
	ora REG0
	sta REG0
	; param_gensui_value�̓V�t�g���Ȃ�
	lda param_gensui_value
	ora REG0
	sta REG0

	DrawBinaryNumber REG0,#$21,#$c7

;	lda #%10011000
	lda REG0
	sta $4004		; ��`�g�`�����l���Q���䃌�W�X�^�P

; ��`�g�`�����l���P���䃌�W�X�^�Q
; bit7: �X�C�[�v�L��(0:����,1:�L��)
; bit6-4: �X�C�[�v���[�g�A�ω��̑����B�傫�قǒx���A�������قǑ����B
; bit3: �X�C�[�v����(1:decrease,0:increase)1�Ȃ�K�オ��A0�Ȃ�K������B
; bit2-0: �X�C�[�v�E�V�t�g�l�B���̕ω��ʂ��w�肵�܂��B

	lda #0
	sta REG1

	; param_sweep��7���V�t�g
	lda param_sweep
	asl 
	asl 
	asl 
	asl 
	asl 
	asl 
	asl 
	ora REG1
	sta REG1

	; param_sweep_speed��4���V�t�g
	lda param_sweep_speed
	asl 
	asl 
	asl 
	asl 
	ora REG1
	sta REG1

	; param_sweep_up_down��3���V�t�g
	lda param_sweep_up_down
	asl 
	asl 
	asl 
	ora REG1
	sta REG1

	; param_sweep_change_amount�̓V�t�g���Ȃ�
	lda param_sweep_change_amount
	ora REG1
	sta REG1

	DrawBinaryNumber REG1,#$21,#$e7

;	lda #%00001111
	lda REG1
	sta $4005		; ��`�g�`�����l���Q���䃌�W�X�^�Q

; bit7-0:�`�����l���Ŏg�����g���̉���8bit���Z�b�g����B

	lda param_onkai
	cmp #0
	beq case_onkai_do
	cmp #1
	beq case_onkai_re
	cmp #2
	beq case_onkai_mi
	cmp #3
	beq case_onkai_fa
	cmp #4
	beq case_onkai_so
	cmp #5
	beq case_onkai_ra
	cmp #6
	beq case_onkai_si
	cmp #7
	beq case_onkai_do2

case_onkai_do:
	lda onkai_do
	jmp break;
case_onkai_re:
	lda onkai_re
	jmp break;
case_onkai_mi:
	lda onkai_mi
	jmp break;
case_onkai_fa:
	lda onkai_fa
	jmp break;
case_onkai_so:
	lda onkai_so
	jmp break;
case_onkai_ra:
	lda onkai_ra
	jmp break;
case_onkai_si:
	lda onkai_si
	jmp break;
case_onkai_do2:
	lda onkai_do2
	jmp break;

break:

	sta REG2
	DrawBinaryNumber REG2,#$22,#$07
;	lda #%11000000	; 
	lda REG2
	sta $4006		; ��`�g�`�����l���Q���g�����W�X�^�P

;bit7-3: ���̒���
;bit2-0: ���g���̏��3bit

	lda #%10110000
	sta REG3
	DrawBinaryNumber REG3,#$22,#$27

	lda REG3
	sta $4007		; ��`�g�`�����l���Q���g�����W�X�^�Q

	rts
.endproc

; �T�E���h�Đ��A�O�p�g
.proc PlaySoundSankaku
; ��`�g
	lda $4015		; �T�E���h���W�X�^
	ora #%00000100	; �O�p�g�`�����l����L���ɂ���
	sta $4015

;	lda #%10000001	; �J�E���^�g�p�E����
;	sta $4008	; �O�p�g�`�����l�����䃌�W�X�^

	lda #0
	sta REG0

	; param_counter��7���V�t�g
	lda param_counter
	asl 
	asl 
	asl 
	asl 
	asl 
	asl 
	asl 
	ora REG0
	sta REG0

	; param_counter_value_hi��4���V�t�g
	lda param_counter_value_hi
	asl 
	asl 
	asl 
	asl 
	ora REG0
	sta REG0

	; param_counter_value_low��0���V�t�g
	lda param_counter_value_low
	ora REG0
	sta REG0

	DrawBinaryNumber REG0,#$21,#$c7
	lda REG0
	sta $4008

;	lda #%00000100	; ���g��(����8�r�b�g)
;	sta $400A	; �O�p�g�`�����l���P���g�����W�X�^�P

; bit7-0:�`�����l���Ŏg�����g���̉���8bit���Z�b�g����B

	lda param_onkai
	cmp #0
	beq case_onkai_do
	cmp #1
	beq case_onkai_re
	cmp #2
	beq case_onkai_mi
	cmp #3
	beq case_onkai_fa
	cmp #4
	beq case_onkai_so
	cmp #5
	beq case_onkai_ra
	cmp #6
	beq case_onkai_si
	cmp #7
	beq case_onkai_do2

case_onkai_do:
	lda onkai_do
	jmp break;
case_onkai_re:
	lda onkai_re
	jmp break;
case_onkai_mi:
	lda onkai_mi
	jmp break;
case_onkai_fa:
	lda onkai_fa
	jmp break;
case_onkai_so:
	lda onkai_so
	jmp break;
case_onkai_ra:
	lda onkai_ra
	jmp break;
case_onkai_si:
	lda onkai_si
	jmp break;
case_onkai_do2:
	lda onkai_do2
	jmp break;

break:

	sta REG1
	DrawBinaryNumber REG1,#$21,#$e7
	lda REG1
	sta $400A


;	lda #%00001011	; �Đ����ԁE���g��(���3�r�b�g)
;	sta $400B	; �O�p�g�`�����l���P���g�����W�X�^�Q

	;lda #%10110000
	lda #%00000000
	sta REG2
	DrawBinaryNumber REG2,#$22,#$07

	lda REG2
	sta $400B

	rts
.endproc

; �T�E���h�Đ��A�m�C�Y
.proc PlaySoundNoise
; �m�C�Y
	lda $4015		; �T�E���h���W�X�^
	ora #%00001000	; �m�C�Y�`�����l����L���ɂ���
	sta $4015

;	lda #%11101111	; ���g�p�E���������E���������E������
;	sta $400C	; �m�C�Y���䃌�W�X�^

	lda #0
	sta REG0

	; param_noise_loop��5���V�t�g
	lda param_noise_loop
	asl 
	asl 
	asl 
	asl 
	asl 
	ora REG0
	sta REG0

	; param_noise_gensui_enable��4���V�t�g
	lda param_noise_gensui_enable
	asl 
	asl 
	asl 
	asl 
	ora REG0
	sta REG0

	; param_noise_gensui_value��0���V�t�g
	lda param_noise_gensui_value
	ora REG0
	sta REG0

	DrawBinaryNumber REG0,#$21,#$c7
	lda REG0
	sta $400C

;	lda #%00000001	; �����^�C�v�E���g�p�E�g��
;	sta $400E	; �m�C�Y���g�����W�X�^�P

	lda #0
	sta REG1

	; param_noise_rnd_type��7���V�t�g
	lda param_noise_rnd_type
	asl 
	asl 
	asl 
	asl 
	asl 
	asl 
	asl 
	ora REG1
	sta REG1

	; param_noize_hatyo��0���V�t�g
	lda param_noize_hatyo
	ora REG1
	sta REG1

	sta REG1
	DrawBinaryNumber REG1,#$21,#$e7

	lda REG1
	sta $400E

;	lda #%11111011	; �Đ����ԁE���g�p
;	sta $400F	; �m�C�Y���g�����W�X�^�Q

	lda #%10110000
	sta REG2
	DrawBinaryNumber REG2,#$22,#$07

	lda REG2
	sta $400F

	rts
.endproc

; �J�[�\���`��
.proc DrawCursor
	; ��1
	lda #2
	sta draw_bg_x
	lda #2
	clc
	adc cursor_pos
	sta draw_bg_y
	
	jsr SetPosition

	lda #$00
	sta $2007
	; ��2
	lda #2
	sta draw_bg_x
	lda #4
	clc
	adc cursor_pos
	sta draw_bg_y
	
	jsr SetPosition

	lda #$00
	sta $2007

	; �J�[�\��
	lda #2
	sta draw_bg_x
	lda #3
	clc
	adc cursor_pos
	sta draw_bg_y
	
	jsr SetPosition

	lda #$7d
	sta $2007

	rts
.endproc

; �p�����[�^�`��
.proc DrawParam

	; �T�C�N��
	lda #$20
	sta $2006
	lda #$8f
	sta $2006

	lda param_duty_cycle
	adc #$37
	sta $2007

	; ���[�v
	lda #$20
	sta $2006
	lda #$af
	sta $2006

	lda param_loop
	adc #$37
	sta $2007

	; �Q���X�C���邵�Ȃ�
	lda #$20
	sta $2006
	lda #$cf
	sta $2006

	lda param_gensui
	adc #$37
	sta $2007

	; �{�����[��
	lda #$20
	sta $2006
	lda #$ef
	sta $2006

	lda param_gensui_value
	adc #$37
	sta $2007

	; �X�C�[�v���邵�Ȃ�
	lda #$21
	sta $2006
	lda #$0f
	sta $2006

	lda param_sweep
	adc #$37
	sta $2007

	; �X�C�[�v�X�s�[�h
	lda #$21
	sta $2006
	lda #$2f
	sta $2006

	lda param_sweep_speed
	adc #$37
	sta $2007

	; �X�C�[�v����
	lda #$21
	sta $2006
	lda #$4f
	sta $2006

	lda param_sweep_up_down
	adc #$37
	sta $2007

	; �X�C�[�v�ω���
	lda #$21
	sta $2006
	lda #$6f
	sta $2006

	lda param_sweep_change_amount
	adc #$37
	sta $2007

	; ���K
	lda #$21
	sta $2006
	lda #$8f
	sta $2006

	lda param_onkai
;	adc #$37
;	sta $2007
	cmp #0
	beq case_do
	cmp #1
	beq case_re
	cmp #2
	beq case_mi
	cmp #3
	beq case_fa
	cmp #4
	beq case_so
	cmp #5
	beq case_ra
	cmp #6
	beq case_si
	cmp #7
	beq case_do2

case_do:
	ldx #0
loop_x_do:

	lda string_onkai_do, x
	sta $2007

	inx
	cpx #2
	bne loop_x_do
	jmp break;

case_re:
	ldx #0
loop_x_re:

	lda string_onkai_re, x
	sta $2007

	inx
	cpx #2
	bne loop_x_re
	jmp break;

case_mi:
	ldx #0
loop_x_mi:

	lda string_onkai_mi, x
	sta $2007

	inx
	cpx #2
	bne loop_x_mi
	jmp break;

case_fa:
	ldx #0
loop_x_fa:

	lda string_onkai_fa, x
	sta $2007

	inx
	cpx #2
	bne loop_x_fa
	jmp break;

case_so:
	ldx #0
loop_x_so:

	lda string_onkai_so, x
	sta $2007

	inx
	cpx #2
	bne loop_x_so
	jmp break;

case_ra:
	ldx #0
loop_x_ra:

	lda string_onkai_ra, x
	sta $2007

	inx
	cpx #2
	bne loop_x_ra
	jmp break;

case_si:
	ldx #0
loop_x_si:

	lda string_onkai_si, x
	sta $2007

	inx
	cpx #2
	bne loop_x_si
	jmp break;

case_do2:
	ldx #0
loop_x_do2:

	lda string_onkai_do, x
	sta $2007

	inx
	cpx #2
	bne loop_x_do2
	jmp break;

break:

	rts
.endproc

; �p�����[�^�`��
.proc DrawSankakuhaParam

	; �J�E���^
	lda #$20
	sta $2006
	lda #$8f
	sta $2006

	lda param_counter
	adc #$37
	sta $2007

	; �J�E���^�lHI
	lda #$20
	sta $2006
	lda #$af
	sta $2006

	lda param_counter_value_hi
	adc #$37
	sta $2007

	; �J�E���^�lLOW
	lda #$20
	sta $2006
	lda #$cf
	sta $2006

	lda param_counter_value_low
	adc #$37
	sta $2007

	; ���K
	lda #$20
	sta $2006
	lda #$ef
	sta $2006

	lda param_onkai
	cmp #0
	beq case_do
	cmp #1
	beq case_re
	cmp #2
	beq case_mi
	cmp #3
	beq case_fa
	cmp #4
	beq case_so
	cmp #5
	beq case_ra
	cmp #6
	beq case_si
	cmp #7
	beq case_do2

case_do:
	ldx #0
loop_x_do:

	lda string_onkai_do, x
	sta $2007

	inx
	cpx #2
	bne loop_x_do
	jmp break;

case_re:
	ldx #0
loop_x_re:

	lda string_onkai_re, x
	sta $2007

	inx
	cpx #2
	bne loop_x_re
	jmp break;

case_mi:
	ldx #0
loop_x_mi:

	lda string_onkai_mi, x
	sta $2007

	inx
	cpx #2
	bne loop_x_mi
	jmp break;

case_fa:
	ldx #0
loop_x_fa:

	lda string_onkai_fa, x
	sta $2007

	inx
	cpx #2
	bne loop_x_fa
	jmp break;

case_so:
	ldx #0
loop_x_so:

	lda string_onkai_so, x
	sta $2007

	inx
	cpx #2
	bne loop_x_so
	jmp break;

case_ra:
	ldx #0
loop_x_ra:

	lda string_onkai_ra, x
	sta $2007

	inx
	cpx #2
	bne loop_x_ra
	jmp break;

case_si:
	ldx #0
loop_x_si:

	lda string_onkai_si, x
	sta $2007

	inx
	cpx #2
	bne loop_x_si
	jmp break;

case_do2:
	ldx #0
loop_x_do2:

	lda string_onkai_do, x
	sta $2007

	inx
	cpx #2
	bne loop_x_do2
	jmp break;

break:


	; ��
	lda #$21
	sta $2006
	lda #$0f
	sta $2006
	lda #0
	sta $2007

	lda #$21
	sta $2006
	lda #$2f
	sta $2006
	lda #0
	sta $2007

	lda #$21
	sta $2006
	lda #$4f
	sta $2006
	lda #0
	sta $2007

	lda #$21
	sta $2006
	lda #$6f
	sta $2006
	lda #0
	sta $2007

	lda #$21
	sta $2006
	lda #$8f
	sta $2006
	lda #0
	sta $2007
	sta $2007


	rts
.endproc

; �p�����[�^�`��
.proc DrawNoiseParam

	; ���[�v
	lda #$20
	sta $2006
	lda #$8f
	sta $2006

	lda param_noise_loop
	adc #$37
	sta $2007

	; �������邵�Ȃ�
	lda #$20
	sta $2006
	lda #$af
	sta $2006

	lda param_noise_gensui_enable
	adc #$37
	sta $2007

	; �����l�E�{�����[��
	lda #$20
	sta $2006
	lda #$cf
	sta $2006

	lda param_noise_gensui_value
	adc #$37
	sta $2007

	; �����^�C�v
	lda #$20
	sta $2006
	lda #$ef
	sta $2006

	lda param_noise_rnd_type
	adc #$37
	sta $2007
	lda #0
	sta $2007

	; �g��
	lda #$21
	sta $2006
	lda #$0f
	sta $2006
	lda param_noize_hatyo
	adc #$37
	sta $2007

	rts
.endproc

; ������`��
.macro DrawConstStrMacro straddr,posh,posl,num_count
	.local loop_x

	lda posh
	sta $2006
	lda posl
	sta $2006

	ldx #0

loop_x:

	lda straddr, x
	sta $2007

	inx
	cpx num_count
	bne loop_x

.endmacro

; ��`�g
.proc DrawKukeihaHead

	; �^�C�g��
	DrawConstStrMacro string_kukeiha,#$20,#$42,#5

	; Duty�T�C�N���F0�`3
	DrawConstStrMacro string_duty,#$20,#$83,#8

	; ���[�v�F���邵�Ȃ�
	DrawConstStrMacro string_loop,#$20,#$a3,#7

	; �����F���邵�Ȃ�
	DrawConstStrMacro string_gensui,#$20,#$c3,#8

	; �{�����[���F0�`15
	DrawConstStrMacro string_volume,#$20,#$e3,#8

	; �X�C�[�v�F�L������
	DrawConstStrMacro string_sweep,#$21,#$03,#5

	; �X�C�[�v�̕ω��̑����F0�`7
	DrawConstStrMacro string_sweep_speed,#$21,#$23,#8

	; �X�C�[�v�����F�K������A�K�オ��
	DrawConstStrMacro string_sweep_direction,#$21,#$43,#9

	; ���̕ω��ʁF0�`7
	DrawConstStrMacro string_sweep_change_amount,#$21,#$63,#11

	; ���K�F�h�`�������̃h
	DrawConstStrMacro string_onkai,#$21,#$83,#8

	; �����F0�`31

	; �A�h���X
	jsr DrawKukeihaAddress

	rts
.endproc

; �O�p�g
.proc DrawSankakuhaHead

	; �^�C�g��
	DrawConstStrMacro string_sankakuha,#$20,#$42,#5

	; �J�E���^�g�p���Ȃ�����
	DrawConstStrMacro string_counter,#$20,#$83,#8

	; �J�E���^�lHI
	DrawConstStrMacro string_counter_value_hi,#$20,#$a3,#7

	; �J�E���^�lLOW
	DrawConstStrMacro string_counter_value_low,#$20,#$c3,#8

	; ���K�F�h�`�������̃h
	DrawConstStrMacro string_onkai,#$20,#$e3,#8

	; 
	DrawConstStrMacro string_null,#$21,#$03,#6
	DrawConstStrMacro string_null,#$21,#$23,#8
	DrawConstStrMacro string_null,#$21,#$43,#9
	DrawConstStrMacro string_null,#$21,#$63,#11
	DrawConstStrMacro string_null,#$21,#$83,#4

	; �A�h���X
	jsr DrawSankakuhaAddress
	rts
.endproc

; �m�C�Y
.proc DrawNoiseHead

	; �^�C�g��
	DrawConstStrMacro string_noise,#$20,#$42,#5

	; ���[�v
	DrawConstStrMacro string_loop,#$20,#$83,#7

	; �����F���邵�Ȃ�
	DrawConstStrMacro string_gensui,#$20,#$a3,#8

	; �������E�{�����[��
	DrawConstStrMacro string_volume,#$20,#$c3,#8

	; �����^�C�v
	DrawConstStrMacro string_rnd_type,#$20,#$e3,#8

	; �g��
	DrawConstStrMacro string_hatyo,#$21,#$03,#5

	; ��
	DrawConstStrMacro string_null,#$21,#$23,#11
	DrawConstStrMacro string_null,#$21,#$43,#11
	DrawConstStrMacro string_null,#$21,#$63,#11
	DrawConstStrMacro string_null,#$21,#$83,#11

	; �A�h���X
	jsr DrawNoiseAddress
	rts
.endproc

.proc DrawKukeihaAddress

	lda #$21
	sta $2006
	lda #$c2
	sta $2006

	lda #$3b
	sta $2007
	lda #$37
	sta $2007
	lda #$37
	sta $2007
	lda #$37
	sta $2007

	lda #$21
	sta $2006
	lda #$e2
	sta $2006

	lda #$3b
	sta $2007
	lda #$37
	sta $2007
	lda #$37
	sta $2007
	lda #$38
	sta $2007

	lda #$22
	sta $2006
	lda #$02
	sta $2006

	lda #$3b
	sta $2007
	lda #$37
	sta $2007
	lda #$37
	sta $2007
	lda #$39
	sta $2007

	lda #$22
	sta $2006
	lda #$22
	sta $2006

	lda #$3b
	sta $2007
	lda #$37
	sta $2007
	lda #$37
	sta $2007
	lda #$3a
	sta $2007

	rts
.endproc

.proc DrawSankakuhaAddress

	lda #$21
	sta $2006
	lda #$c2
	sta $2006

	lda #$3b
	sta $2007
	lda #$37
	sta $2007
	lda #$37
	sta $2007
	lda #$3f
	sta $2007

	lda #$21
	sta $2006
	lda #$e2
	sta $2006

	lda #$3b
	sta $2007
	lda #$37
	sta $2007
	lda #$37
	sta $2007
	lda #$41
	sta $2007

	lda #$22
	sta $2006
	lda #$02
	sta $2006

	lda #$3b
	sta $2007
	lda #$37
	sta $2007
	lda #$37
	sta $2007
	lda #$42
	sta $2007

	DrawConstStrMacro string_null,#$22,#$22,#11
	DrawConstStrMacro string_null,#$22,#$2d,#2

	rts
.endproc

.proc DrawNoiseAddress

	lda #$21
	sta $2006
	lda #$c2
	sta $2006

	lda #$3b
	sta $2007
	lda #$37
	sta $2007
	lda #$37
	sta $2007
	lda #$43
	sta $2007

	lda #$21
	sta $2006
	lda #$e2
	sta $2006

	lda #$3b
	sta $2007
	lda #$37
	sta $2007
	lda #$37
	sta $2007
	lda #$45
	sta $2007

	lda #$22
	sta $2006
	lda #$02
	sta $2006

	lda #$3b
	sta $2007
	lda #$37
	sta $2007
	lda #$37
	sta $2007
	lda #$46
	sta $2007

	rts
.endproc

.proc SetPosition
	; draw_bg_x	X���W
	; draw_bg_y	Y���W

	lda draw_bg_x	
	sta conv_coord_bit_x
	lda draw_bg_y
	sta conv_coord_bit_y
;;;;;�� ���W���A�h���X��Ԃɕϊ� ;;;;;
	;jsr ConvertCoordToBit
	; y * 32 ; Y���W������ɂ��炷��X������32������������
	lda #0
	sta multi_ans_hi
	sta multi_ans_low
	lda conv_coord_bit_y
	sta multi_ans_low

	; 32�{
	clc
	asl multi_ans_low		; ���ʂ͍��V�t�g
	rol multi_ans_hi		; ��ʂ͍����[�e�[�g

	asl multi_ans_low
	rol multi_ans_hi

	asl multi_ans_low
	rol multi_ans_hi

	asl multi_ans_low
	rol multi_ans_hi

	asl multi_ans_low
	rol multi_ans_hi

	

	; + x
	lda multi_ans_low
	adc conv_coord_bit_x
	sta multi_ans_low

	; ���ʁ{����
	clc
	lda multi_ans_low
	adc #$20
	sta conv_coord_bit_low
	; ��ʁ{���
	lda multi_ans_hi
	adc #$20
	sta conv_coord_bit_hi
;;;;;�� ���W���A�h���X��Ԃɕϊ� ;;;;;

	lda conv_coord_bit_hi
	sta $2006
	lda conv_coord_bit_low
	sta $2006

	rts
.endproc


; �X�V
.proc	Update

	; �L�[����
	lda #0
	sta input_dirty_flg

	; ������
	lda #$01
	sta $4016
	lda #$00
	sta $4016

	; �O��̏�Ԃ��i�[
	lda key_state_on
	sta key_state_on_old

	lda #0
	sta key_state_on

	; A,B,SELECT,START,UP,DOWN,LEFT,RIGHT�̏���
	lda $4016	; A
	and #1
	beq SkipPushA
	lda key_state_on
	ora #%00000001
	sta key_state_on

SkipPushA:
	lda $4016	; B
	and #1
	beq SkipPusyB
	lda key_state_on
	ora #%00000010
	sta key_state_on
SkipPusyB:
	lda $4016	; SELECT
	and #1
	beq SkipKeySelect
	lda key_state_on
	ora #%00000100
	sta key_state_on
SkipKeySelect:
	lda $4016	; START
	lda $4016	; ��
	and #1
	beq SkipKeyUp
	lda key_state_on
	ora #%00010000
	sta key_state_on
SkipKeyUp:

	lda $4016	; ��
	and #1
	beq SkipKeyDown
	lda key_state_on
	ora #%00100000
	sta key_state_on
SkipKeyDown:

	lda $4016	; ��
	and #1
	beq SkipKeyLeft
	lda key_state_on
	ora #%01000000
	sta key_state_on
SkipKeyLeft:

	lda $4016	; �E
	and #1
	beq SkipKeyRight
	lda key_state_on
	ora #%10000000
	sta key_state_on
SkipKeyRight:

	lda key_state_on
	eor key_state_on_old
	and key_state_on
	sta key_state_push

; ���̎�ސ؂蕪��
	lda sound_type
	cmp #0
	beq case_kukeiha
	cmp #1
	beq case_sankakuha
	cmp #2
	beq case_noise

case_kukeiha:
	jsr UpdateKukeiha
	jmp break_sound_type

case_sankakuha:
	jsr UpdateSankakuha
	jmp break_sound_type

case_noise:
	jsr UpdateNoise
	jmp break_sound_type

break_sound_type:




	rts	; �T�u���[�`�����畜�A���܂��B
.endproc

.proc UpdateKukeiha
	lda key_state_push
	and #%00000001
	bne button_A
	lda key_state_push
	and #%00000010
	bne button_B
	lda key_state_push
	and #%00000100
	bne button_Select
	lda key_state_push
	and #%00010000
	bne button_Up
	lda key_state_push
	and #%00100000
	bne button_Down
	lda key_state_push
	and #%01000000
	bne button_Left
	lda key_state_push
	and #%10000000
	bne button_Right
	jmp break
	
button_A:
	jsr UpdateKukeihaPushA
	jmp break
button_B:
	jsr UpdateKukeihaPushB
	jmp break
button_Select:
	jsr UpdateKukeihaPushSelect
	jmp break
button_Up:
	jsr UpdateKukeihaPushUp
	jmp break
button_Down:
	jsr UpdateKukeihaPushDown
	jmp break
button_Left:
	jsr UpdateKukeihaPushLeft
	jmp break
button_Right:
	jsr UpdateKukeihaPushRight
	jmp break

break:

	rts
.endproc

.proc UpdateSankakuha
	lda key_state_push
	and #%00000001
	bne button_A
	lda key_state_push
	and #%00000010
	bne button_B
	lda key_state_push
	and #%00000100
	bne button_Select
	lda key_state_push
	and #%00010000
	bne button_Up
	lda key_state_push
	and #%00100000
	bne button_Down
	lda key_state_push
	and #%01000000
	bne button_Left
	lda key_state_push
	and #%10000000
	bne button_Right
	jmp break
	
button_A:
	jsr UpdateSankakuhaPushA
	jmp break
button_B:
	jsr UpdateSankakuhaPushB
	jmp break
button_Select:
	jsr UpdateSankakuhaPushSelect
	jmp break
button_Up:
	jsr UpdateSankakuhaPushUp
	jmp break
button_Down:
	jsr UpdateSankakuhaPushDown
	jmp break
button_Left:
	jsr UpdateSankakuhaPushLeft
	jmp break
button_Right:
	jsr UpdateSankakuhaPushRight
	jmp break

break:

	rts
.endproc

.proc UpdateNoise
	lda key_state_push
	and #%00000001
	bne button_A
	lda key_state_push
	and #%00000010
	bne button_B
	lda key_state_push
	and #%00000100
	bne button_Select
	lda key_state_push
	and #%00010000
	bne button_Up
	lda key_state_push
	and #%00100000
	bne button_Down
	lda key_state_push
	and #%01000000
	bne button_Left
	lda key_state_push
	and #%10000000
	bne button_Right
	jmp break
	
button_A:
	jsr UpdateNoisePushA
	jmp break
button_B:
	jsr UpdateNoisePushB
	jmp break
button_Select:
	jsr UpdateNoisePushSelect
	jmp break
button_Up:
	jsr UpdateNoisePushUp
	jmp break
button_Down:
	jsr UpdateNoisePushDown
	jmp break
button_Left:
	jsr UpdateNoisePushLeft
	jmp break
button_Right:
	jsr UpdateNoisePushRight
	jmp break

break:


	rts
.endproc

; ��`�g�{�^��
.proc	UpdateKukeihaPushA
	lda #2	; �v���C�T�E���h��
	sta input_dirty_flg
	rts
.endproc

.proc	UpdateKukeihaPushB
	rts
.endproc

.proc	UpdateKukeihaPushSelect
	; �^�C�v���O�p�g�ɕύX����
	lda #3
	sta input_dirty_flg
	rts
.endproc

.proc	UpdateKukeihaPushUp
	lda cursor_pos
	cmp #0
	beq end
	dec cursor_pos
	lda #1
	sta input_dirty_flg
end:

	lda #1
	sta debug_var
	rts
.endproc

.proc	UpdateKukeihaPushDown
	lda cursor_pos
	cmp #8
	beq end
	inc cursor_pos
	lda #1
	sta input_dirty_flg
end:

	lda #2
	sta debug_var
	rts
.endproc

; ���L�[����
.proc	UpdateKukeihaPushLeft

	lda cursor_pos
	cmp #0
	beq case_duty_cycle
	cmp #1
	beq case_loop
	cmp #2
	beq case_gensui
	cmp #3
	beq case_gensui_value
	cmp #4
	beq case_sweep
	cmp #5
	beq case_sweep_speed
	cmp #6
	beq case_sweep_up_down
	cmp #7
	beq case_sweep_change_amount
	cmp #8
	beq case_sweep_onkai

case_duty_cycle:
	lda param_duty_cycle
	cmp #0
	beq end
	dec param_duty_cycle
	jmp break;
case_loop:
	lda param_loop
	cmp #0
	beq end
	dec param_loop
	jmp break;
case_gensui:
	lda param_gensui
	cmp #0
	beq end
	dec param_gensui
	jmp break;
case_gensui_value:
	lda param_gensui_value
	cmp #0
	beq end
	dec param_gensui_value
	jmp break;
case_sweep:
	lda param_sweep
	cmp #0
	beq end
	dec param_sweep
	jmp break;
case_sweep_speed:
	lda param_sweep_speed
	cmp #0
	beq end
	dec param_sweep_speed
	jmp break;
case_sweep_up_down:
	lda param_sweep_up_down
	cmp #0
	beq end
	dec param_sweep_up_down
	jmp break;
case_sweep_change_amount:
	lda param_sweep_change_amount
	cmp #0
	beq end
	dec param_sweep_change_amount
	jmp break;
case_sweep_onkai:
	lda param_onkai
	cmp #0
	beq end
	dec param_onkai
	jmp break

break:
	lda #3
	sta debug_var

	lda #1
	sta input_dirty_flg

end:
	rts
.endproc

; �E�L�[����
.proc	UpdateKukeihaPushRight

	lda cursor_pos
	cmp #0
	beq case_duty_cycle
	cmp #1
	beq case_loop
	cmp #2
	beq case_gensui
	cmp #3
	beq case_gensui_value
	cmp #4
	beq case_sweep
	cmp #5
	beq case_sweep_speed
	cmp #6
	beq case_sweep_up_down
	cmp #7
	beq case_sweep_change_amount
	cmp #8
	beq case_sweep_onkai

case_duty_cycle:
	lda param_duty_cycle
	cmp #3
	beq end
	inc param_duty_cycle
	jmp break;
case_loop:
	lda param_loop
	cmp #1
	beq end
	inc param_loop
	jmp break;
case_gensui:
	lda param_gensui
	cmp #1
	beq end
	inc param_gensui
	jmp break;
case_gensui_value:
	lda param_gensui_value
	cmp #15
	beq end
	inc param_gensui_value
	jmp break;
case_sweep:
	lda param_sweep
	cmp #1
	beq end
	inc param_sweep
	jmp break;
case_sweep_speed:
	lda param_sweep_speed
	cmp #7
	beq end
	inc param_sweep_speed
	jmp break;
case_sweep_up_down:
	lda param_sweep_up_down
	cmp #1
	beq end
	inc param_sweep_up_down
	jmp break;
case_sweep_change_amount:
	lda param_sweep_change_amount
	cmp #7
	beq end
	inc param_sweep_change_amount
	jmp break;
case_sweep_onkai:
	lda param_onkai
	cmp #7
	beq end
	inc param_onkai
	jmp break

break:
	lda #4
	sta debug_var

	lda #1
	sta input_dirty_flg

end:

	rts
.endproc

; �O�p�g�{�^��
.proc	UpdateSankakuhaPushA
	lda #2	; �v���C�T�E���h��
	sta input_dirty_flg
	rts
.endproc

.proc	UpdateSankakuhaPushB
	rts
.endproc

.proc	UpdateSankakuhaPushSelect
	; �^�C�v���m�C�Y�ɕύX����
	lda #3
	sta input_dirty_flg
	rts
.endproc

.proc	UpdateSankakuhaPushUp
	lda cursor_pos
	cmp #0
	beq end
	dec cursor_pos
	lda #1
	sta input_dirty_flg
end:

	lda #1
	sta debug_var
	rts
.endproc

.proc	UpdateSankakuhaPushDown
	lda cursor_pos
	cmp #3
	beq end
	inc cursor_pos
	lda #1
	sta input_dirty_flg
end:

	lda #2
	sta debug_var
	rts
.endproc

; ���L�[����
.proc	UpdateSankakuhaPushLeft

	lda cursor_pos
	cmp #0
	beq case_counter
	cmp #1
	beq case_counter_value_hi
	cmp #2
	beq case_counter_value_low
	cmp #3
	beq case_onkai

case_counter:
	lda param_counter
	cmp #0
	beq end
	dec param_counter
	jmp break;
case_counter_value_hi:
	lda param_counter_value_hi
	cmp #0
	beq end
	dec param_counter_value_hi
	jmp break;
case_counter_value_low:
	lda param_counter_value_low
	cmp #0
	beq end
	dec param_counter_value_low
	jmp break;
case_onkai:
	lda param_onkai
	cmp #0
	beq end
	dec param_onkai
	jmp break;

break:
	lda #3
	sta debug_var

	lda #1
	sta input_dirty_flg

end:
	rts
.endproc

; �E�L�[����
.proc	UpdateSankakuhaPushRight

	lda cursor_pos
	cmp #0
	beq case_counter
	cmp #1
	beq case_counter_value_hi
	cmp #2
	beq case_counter_value_low
	cmp #3
	beq case_onkai

case_counter:
	lda param_counter
	cmp #1
	beq end
	inc param_counter
	jmp break;
case_counter_value_hi:
	lda param_counter_value_hi
	cmp #7
	beq end
	inc param_counter_value_hi
	jmp break;
case_counter_value_low:
	lda param_counter_value_low
	cmp #15
	beq end
	inc param_counter_value_low
	jmp break;
case_onkai:
	lda param_onkai
	cmp #7
	beq end
	inc param_onkai
	jmp break;

break:
	lda #4
	sta debug_var

	lda #1
	sta input_dirty_flg

end:

	rts
.endproc

; �m�C�Y�{�^��
.proc	UpdateNoisePushA
	lda #2	; �v���C�T�E���h��
	sta input_dirty_flg
	rts
.endproc

.proc	UpdateNoisePushB
	rts
.endproc

.proc	UpdateNoisePushSelect
	; �^�C�v����`�g�ɕύX����
	lda #3
	sta input_dirty_flg
	rts
.endproc

.proc	UpdateNoisePushUp
	lda cursor_pos
	cmp #0
	beq end
	dec cursor_pos
	lda #1
	sta input_dirty_flg
end:

	lda #1
	sta debug_var
	rts
.endproc

.proc	UpdateNoisePushDown
	lda cursor_pos
	cmp #4
	beq end
	inc cursor_pos
	lda #1
	sta input_dirty_flg
end:

	lda #2
	sta debug_var
	rts
.endproc

; ���L�[����
.proc	UpdateNoisePushLeft

	lda cursor_pos
	cmp #0
	beq case_loop
	cmp #1
	beq case_gensui
	cmp #2
	beq case_volume
	cmp #3
	beq case_random
	cmp #4
	beq case_hatyo

case_loop:
	lda param_noise_loop
	cmp #0
	beq end
	dec param_noise_loop
	jmp break;
case_gensui:
	lda param_noise_gensui_enable
	cmp #0
	beq end
	dec param_noise_gensui_enable
	jmp break;
case_volume:
	lda param_noise_gensui_value
	cmp #0
	beq end
	dec param_noise_gensui_value
	jmp break;
case_random:
	lda param_noise_rnd_type
	cmp #0
	beq end
	dec param_noise_rnd_type
	jmp break;
case_hatyo:
	lda param_noize_hatyo
	cmp #0
	beq end
	dec param_noize_hatyo
	jmp break;

break:
	lda #3
	sta debug_var

	lda #1
	sta input_dirty_flg

end:
	rts
.endproc

; �E�L�[����
.proc	UpdateNoisePushRight

	lda cursor_pos
	cmp #0
	beq case_loop
	cmp #1
	beq case_gensui
	cmp #2
	beq case_volume
	cmp #3
	beq case_random
	cmp #4
	beq case_hatyo

case_loop:
	lda param_noise_loop
	cmp #1
	beq end
	inc param_noise_loop
	jmp break;
case_gensui:
	lda param_noise_gensui_enable
	cmp #1
	beq end
	inc param_noise_gensui_enable
	jmp break;
case_volume:
	lda param_noise_gensui_value
	cmp #15
	beq end
	inc param_noise_gensui_value
	jmp break;
case_random:
	lda param_noise_rnd_type
	cmp #1
	beq end
	inc param_noise_rnd_type
	jmp break;
case_hatyo:
	lda param_noize_hatyo
	cmp #15
	beq end
	inc param_noize_hatyo
	jmp break;

break:
	lda #4
	sta debug_var

	lda #1
	sta input_dirty_flg

end:

	rts
.endproc

; VBlank���荞��
.proc	VBlank


	rti			; ���荞�݂��畜�A����

.endproc







	; �����f�[�^
X_Pos_Init:   .byte 20       ; X���W�����l
Y_Pos_Init:   .byte 40       ; Y���W�����l

; �p���b�g�e�[�u��
palette1:
	.byte	$0c, $23, $3A, $30	; �X�v���C�g�F1
	.byte	$0f, $07, $16, $0d	; �X�v���C�g�F2
	.byte	$0f, $23, $3A, $28	; �X�v���C�g�F3
palette2:
	.byte	$0f, $00, $10, $20
	.byte	$0f, $00, $10, $20
paletteIno:
palettes_bg:
	.byte	$0c, $17, $28, $39	; bg�F1
	.byte	$0f, $0f, $12, $30	; bg�F2
	.byte	$0f, $0f, $0f, $30	; bg�F3
	.byte	$21, $0a, $1a, $2a	; bg�F4

	; ���e�[�u���f�[�^(20��)
Star_Tbl:
   .byte 60,45,35,60,90,65,45,20,90,10,30,40,65,25,65,35,50,35,40,35

; �\��������
string:
	.byte	"HELLO, WORLD!"
;	.byte	$01, $02, $11, $12

string1:
	.byte	$01, $02

string2:
	.byte	$11, $12

string_game_over:
	.byte	"GAME OVER"

string_life:
	.byte	"LIFE"
string_score:
	.byte	"SCORE"
string_time:
	.byte	"TIME"
string_zero_score:
	.byte	"000000"
string_first_time:
	.byte	"400"

string_kukeiha:	; �N�P�C�n�Q
	.byte	_ku, _ke, _i, _ha, $00
string_duty:	; Duty�T�C�N��
	.byte	$44, $75, $74, $79, _sa, _i, _ku, _ru
string_loop:	; ���[�t�K�Q�Q�Q
	.byte	_ru, _tyo, _fu, _h_daku, $00, $00, $00
string_gensui:	; �P�J���X�C�Q�Q�Q
	.byte	_ke, _daku, _nn, _su, _i, $00, $00, $00
string_volume:	; �z�J�����[���Q�Q
	.byte	_ho, _daku, _ri, _xyu, _tyo, _mu, $00, $00
string_sweep:	; �X�C�[�t�K
	.byte	_su, _i, _tyo, _fu, _h_daku
string_sweep_speed:	; �X�C�[�t�K�n���T
	.byte	_su, _i, _tyo, _fu, _h_daku, _ha, _ya, _sa
string_sweep_direction:	; �X�C�[�t�K�z�E�R�E
	.byte	_su, _i, _tyo, _fu, _h_daku, _ho, _u, _ko, _u
string_sweep_change_amount:	; �X�C�[�t�K�w���J�����E
	.byte	_su, _i, _tyo, _fu, _h_daku, _he, _nn, _ka, _ri, _xyo, _u
string_onkai:	; �I���J�C�Q
	.byte	_o, _nn, _ka, _i, $00, $00, $00, $00
string_onkai_do:	; �h
	.byte	_to, _daku
string_onkai_re:	; ��
	.byte	_re, $00
string_onkai_mi:	; �~
	.byte	_mi, $00
string_onkai_fa:	; �t�@
	.byte	_fu, _xa
string_onkai_so:	; �\
	.byte	_so, $00
string_onkai_ra:	; ��
	.byte	_ra, $00
string_onkai_si:	; �V
	.byte	_si, $00

string_sankakuha:		; �T���J�N�n
	.byte	_sa, _nn, _ka, _ku, _ha
string_counter:			; �J�E���^�Q�Q�Q�Q
	.byte	_ka, _u, _nn, _ta, $00, $00, $00, $00
string_counter_value_hi:	; �J�E���^�`HI
	.byte	_ka, _u, _nn, _ta, _ti, $48, $49
string_counter_value_low:	; �J�E���^�`LOW
	.byte	_ka, _u, _nn, _ta, _ti, $4c, $4f, $57

string_noise:		; �m�C�X�J�Q
	.byte	_no, _i, _su, _daku, $00
string_rnd_type:		; �����X�E�^�C�t�K
	.byte	_ra, _nn, _su, _u, _ta, _i, _fu, _h_daku
string_hatyo:			; �n�`���E�Q
	.byte	_ha, _ti, _xyo, _u, $00


string_null:			; �Q�Q�Q�Q�Q�Q�Q�Q�Q�Q�Q
	.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00



.segment "VECINFO"
	.word	VBlank
	.word	Reset
	.word	$0000

; �p�^�[���e�[�u��
.segment "CHARS"
	.incbin	"character.chr"
