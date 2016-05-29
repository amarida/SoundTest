

;  #10 10進数値
; #$10 16進数値
;  $10 16進アドレス
; #%00000000 2進数

.setcpu		"6502"
.autoimport	on

.include "define.asm"

.include "defineDMA.asm"

; iNESヘッダ
.segment "HEADER"
	.byte	$4E, $45, $53, $1A	; "NES" Header
	.byte	$02			; PRG-BANKS
	.byte	$01			; CHR-BANKS
	.byte	$01			; 垂直ミラーVertical Mirror
	.byte	$00			; 
	.byte	$00, $00, $00, $00	; 
	.byte	$00, $00, $00, $00	; 

.segment "STARTUP"
; リセット割り込み
.org $8000
.proc	Reset
	sei			; IRQ割り込みを禁止します。

; スクリーンオフ
	lda #$00
	sta $2000
	sta $2001


; 初期値

	lda #0
	sta key_state_on
	sta key_state_push
	sta scene_step
	sta cursor_pos
	sta param_duty_cycle			; Dutyサイクル
	sta param_loop					; ループするしない
	sta param_gensui                ; ゲンスイするしない
	sta param_gensui_value          ; ボリューム
	sta param_sweep                 ; スイープするしない
	sta param_sweep_speed           ; スイープスピード
	sta param_sweep_up_down         ; スイープ方向
	sta param_sweep_change_amount   ; スイープ変化量
	sta param_onkai                 ; 音階
	sta sound_type					; サウンドタイプ
	sta param_counter
	sta param_counter_value_hi
	sta param_counter_value_low
	sta param_noise_loop
	sta param_noise_gensui_enable
	sta param_noise_rnd_type
	sta param_noize_hatyo


	; ド
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


; 矩形波
;	lda $4015		; サウンドレジスタ
;	ora #%00000001	; 矩形波チャンネル１を有効にする
;	sta $4015
;
;	lda #%10111111	; Duty比・長さ無効・減衰無効・減衰率
;	sta $4000	; 矩形波チャンネル１制御レジスタ１
;	lda #%00000100	; 周波数(下位8ビット)
;	sta $4002	; 矩形波チャンネル１周波数レジスタ１
;	lda #%11111011	; 再生時間・周波数(上位3ビット)
;	sta $4003	; 矩形波チャンネル１周波数レジスタ２
;	lda $4015	; サウンドレジスタ
;	ora #%00000010	; 矩形波チャンネル２を有効にする
;	sta $4015
;
;	lda #%00000000	; 矩形波チャンネルを有効にする
;	sta $4015
;
	lda $4015		; サウンドレジスタ
	ora #%00000001	; 矩形波チャンネル１を有効にする
	sta $4015

	lda #%10111111
	sta $4000		; 矩形波チャンネル１制御レジスタ１

	lda #%10101011
	sta $4001		; 矩形波チャンネル１制御レジスタ２
	lda #0		; お遊びでX座標を入れてみる
	sta $4002		; 矩形波チャンネル１周波数レジスタ１

	lda #%11111011
	sta $4003		; 矩形波チャンネル１周波数レジスタ２

; 三角波
;	lda #%00000100	; 
;	sta $4015
;
;	lda #%10000001	; カウンタ使用・長さ
;	sta $4008	; 三角波チャンネル制御レジスタ
;
;	lda #%00000100	; 周波数(下位8ビット)
;	sta $400A	; 三角波チャンネル１周波数レジスタ１
;
;	lda #%00001011	; 再生時間・周波数(上位3ビット)
;	sta $400B	; 三角波チャンネル１周波数レジスタ２
;
;	lda #%00000100	; 
;	sta $4015

; ノイズ
;	lda #%00001000	; 
;	sta $4015
;
;	lda #%11101111	; 未使用・長さ無効・減衰無効・減衰率
;	sta $400C	; ノイズ制御レジスタ
;
;	lda #%00000001	; 乱数タイプ・未使用・波長
;	sta $400E	; ノイズ周波数レジスタ１
;	lda #%11111011	; 再生時間・未使用
;	sta $400F	; ノイズ周波数レジスタ２


; パレットテーブルへ転送(BG用のみ転送)
	lda	#$3f
	sta	$2006
	lda	#$00
	sta	$2006
	ldx	#$00
	ldy	#$16
copypal:
	lda	palettes_bg, x
	sta $2007
	inx				; Xをインクリメントする
	dey				; Yをデクリメントする
	bne	copypal

; パレットテーブルへ転送(MAP用のみ転送)
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

; ネームテーブルへ転送
	lda #%00001000	; VBlank割り込みなし、スプライトが1、
	sta $2000

; スクリーンオン
	lda #%00001100	; VBlank割り込みなし、スプライトが1、VRAM増加量32byte
	sta $2000


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	lda #%00001000	; VBlank割り込みなし、スプライトが1、VRAM増加量1byte
	sta $2000


	lda	#%00011110
;	lda	#%00000000
	sta	$2001

; スクロール設定
	lda	#$00
	sta	$2005
	sta	$2005

; 割り込み開始
	lda #%10001000	; VBlank割り込みあり　VRAM増加量1byte
	sta $2000

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; メインループ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mainloop:

vblank_wait:
	lda	$2002
	and	#%10000000
	beq	vblank_wait

; デバッグ
	lda #$20
	sta $2006
	lda #$00
	sta $2006
	clc
	lda debug_var
	adc #$37
	sta $2007

; 音の種類切り分け
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


	; スプライト


	; スプライト描画(DMAを利用)
	lda #$7  ; スプライトデータは$0700番地からなので、7をロードする。
	sta $4014 ; スプライトDMAレジスタにAをストアして、スプライトデータをDMA転送する

; スクロール設定
	lda	#$00
	sta	$2005
	sta	$2005

	clc
	lda #%10001000	; VBlank割り込みあり
	sta $2000
	
	jsr	Update	; 更新


	jmp	mainloop
.endproc

; 矩形波
.proc DrawKukeiha
	; ステップ切り分け

lda	scene_step
asl	a		; 予想：ワードなので2倍ずらし
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

; タイトルだけ描画
hit0:
	; タイトルbg
	jsr DrawKukeihaHead
	inc scene_step
jmp return

; カーソル描画、パラメータ描画
hit1:
	; カーソル描画
	jsr DrawCursor
	; パラメータ描画
	jsr DrawParam
	inc scene_step
jmp return

; キー入力待ち
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
	lda #1	; タイプを三角波にする
	sta sound_type
	lda #0	; ステップ初期化
	sta scene_step
	jmp return

hit2_end:
jmp return

; 現在の設定でならす
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

; 三角波
.proc DrawSankakuha
	; ステップ切り分け

lda	scene_step
asl	a		; 予想：ワードなので2倍ずらし
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

; タイトルだけ描画
hit0:
	; タイトルbg
	jsr DrawSankakuhaHead
	inc scene_step
jmp return

; カーソル描画、パラメータ描画
hit1:
	; カーソル描画
	jsr DrawCursor
	; パラメータ描画
	jsr DrawSankakuhaParam
	inc scene_step
jmp return

; キー入力待ち
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
	lda #1	; 描画へ
	sta scene_step
	jmp return

next_hit3:
	lda #3	; プレイサウンドへ
	sta scene_step
	jmp return

next_noise:
	lda #2	; タイプをノイズにする
	sta sound_type
	lda #0	; ステップ初期化
	sta scene_step
	jmp return

hit2_end:
jmp return

; 現在の設定でならす
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

; ノイズ
.proc DrawNoise
	; ステップ切り分け

lda	scene_step
asl	a		; 予想：ワードなので2倍ずらし
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

; タイトルだけ描画
hit0:
	; タイトルbg
	jsr DrawNoiseHead
	inc scene_step
jmp return

; カーソル描画、パラメータ描画
hit1:
	; カーソル描画
	jsr DrawCursor
	; パラメータ描画
	jsr DrawNoiseParam
	inc scene_step
jmp return

; キー入力待ち
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
	lda #1	; 描画へ
	sta scene_step
	jmp return

next_hit3:
	lda #3	; プレイサウンドへ
	sta scene_step
	jmp return

next_kukeiha:
	lda #0	; タイプを矩形波にする
	sta sound_type
	lda #0	; ステップ初期化
	sta scene_step
	jmp return

hit2_end:
jmp return

; 現在の設定でならす
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

; 指定アドレスの数値を表示
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

; サウンド再生、矩形波
.proc PlaySoundKukei
; 矩形波
	lda $4015		; サウンドレジスタ
	ora #%00000010	; 矩形波チャンネル２を有効にする
	sta $4015

; bit7-6: Dutyサイクル(positive/negative)
; 00: 2/14
; 01: 4/12
; 10: 8/ 8
; 11:12/ 4
; bit5: エンベロープDecayループ/長さカウンタ無効(1:ループ,0:無効)
; bit4: エンベロープDecay無効(1:無効,0:有効)0で減衰率(ボリューム)有効
; bit3-0: ボリューム/Decayレート、減衰率

	lda #0
	sta REG0

	; param_duty_cycleを6左シフト
	lda param_duty_cycle
	asl 
	asl 
	asl 
	asl 
	asl 
	asl 
	ora REG0
	sta REG0

	; param_loopを5左シフト
	lda param_loop
	asl 
	asl 
	asl 
	asl 
	asl 
	ora REG0
	sta REG0

	; param_gensuiを4左シフト
	lda param_gensui
	asl 
	asl 
	asl 
	asl 
	ora REG0
	sta REG0
	; param_gensui_valueはシフトしない
	lda param_gensui_value
	ora REG0
	sta REG0

	DrawBinaryNumber REG0,#$21,#$c7

;	lda #%10011000
	lda REG0
	sta $4004		; 矩形波チャンネル２制御レジスタ１

; 矩形波チャンネル１制御レジスタ２
; bit7: スイープ有効(0:無効,1:有効)
; bit6-4: スイープレート、変化の速さ。大きほど遅く、小さいほど速い。
; bit3: スイープ方向(1:decrease,0:increase)1なら尻上がり、0なら尻下がり。
; bit2-0: スイープ右シフト値。音の変化量を指定します。

	lda #0
	sta REG1

	; param_sweepを7左シフト
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

	; param_sweep_speedを4左シフト
	lda param_sweep_speed
	asl 
	asl 
	asl 
	asl 
	ora REG1
	sta REG1

	; param_sweep_up_downを3左シフト
	lda param_sweep_up_down
	asl 
	asl 
	asl 
	ora REG1
	sta REG1

	; param_sweep_change_amountはシフトしない
	lda param_sweep_change_amount
	ora REG1
	sta REG1

	DrawBinaryNumber REG1,#$21,#$e7

;	lda #%00001111
	lda REG1
	sta $4005		; 矩形波チャンネル２制御レジスタ２

; bit7-0:チャンネルで使う周波数の下位8bitをセットする。

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
	sta $4006		; 矩形波チャンネル２周波数レジスタ１

;bit7-3: 音の長さ
;bit2-0: 周波数の上位3bit

	lda #%10110000
	sta REG3
	DrawBinaryNumber REG3,#$22,#$27

	lda REG3
	sta $4007		; 矩形波チャンネル２周波数レジスタ２

	rts
.endproc

; サウンド再生、三角波
.proc PlaySoundSankaku
; 矩形波
	lda $4015		; サウンドレジスタ
	ora #%00000100	; 三角波チャンネルを有効にする
	sta $4015

;	lda #%10000001	; カウンタ使用・長さ
;	sta $4008	; 三角波チャンネル制御レジスタ

	lda #0
	sta REG0

	; param_counterを7左シフト
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

	; param_counter_value_hiを4左シフト
	lda param_counter_value_hi
	asl 
	asl 
	asl 
	asl 
	ora REG0
	sta REG0

	; param_counter_value_lowを0左シフト
	lda param_counter_value_low
	ora REG0
	sta REG0

	DrawBinaryNumber REG0,#$21,#$c7
	lda REG0
	sta $4008

;	lda #%00000100	; 周波数(下位8ビット)
;	sta $400A	; 三角波チャンネル１周波数レジスタ１

; bit7-0:チャンネルで使う周波数の下位8bitをセットする。

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


;	lda #%00001011	; 再生時間・周波数(上位3ビット)
;	sta $400B	; 三角波チャンネル１周波数レジスタ２

	;lda #%10110000
	lda #%00000000
	sta REG2
	DrawBinaryNumber REG2,#$22,#$07

	lda REG2
	sta $400B

	rts
.endproc

; サウンド再生、ノイズ
.proc PlaySoundNoise
; ノイズ
	lda $4015		; サウンドレジスタ
	ora #%00001000	; ノイズチャンネルを有効にする
	sta $4015

;	lda #%11101111	; 未使用・長さ無効・減衰無効・減衰率
;	sta $400C	; ノイズ制御レジスタ

	lda #0
	sta REG0

	; param_noise_loopを5左シフト
	lda param_noise_loop
	asl 
	asl 
	asl 
	asl 
	asl 
	ora REG0
	sta REG0

	; param_noise_gensui_enableを4左シフト
	lda param_noise_gensui_enable
	asl 
	asl 
	asl 
	asl 
	ora REG0
	sta REG0

	; param_noise_gensui_valueを0左シフト
	lda param_noise_gensui_value
	ora REG0
	sta REG0

	DrawBinaryNumber REG0,#$21,#$c7
	lda REG0
	sta $400C

;	lda #%00000001	; 乱数タイプ・未使用・波長
;	sta $400E	; ノイズ周波数レジスタ１

	lda #0
	sta REG1

	; param_noise_rnd_typeを7左シフト
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

	; param_noize_hatyoを0左シフト
	lda param_noize_hatyo
	ora REG1
	sta REG1

	sta REG1
	DrawBinaryNumber REG1,#$21,#$e7

	lda REG1
	sta $400E

;	lda #%11111011	; 再生時間・未使用
;	sta $400F	; ノイズ周波数レジスタ２

	lda #%10110000
	sta REG2
	DrawBinaryNumber REG2,#$22,#$07

	lda REG2
	sta $400F

	rts
.endproc

; カーソル描画
.proc DrawCursor
	; 空1
	lda #2
	sta draw_bg_x
	lda #2
	clc
	adc cursor_pos
	sta draw_bg_y
	
	jsr SetPosition

	lda #$00
	sta $2007
	; 空2
	lda #2
	sta draw_bg_x
	lda #4
	clc
	adc cursor_pos
	sta draw_bg_y
	
	jsr SetPosition

	lda #$00
	sta $2007

	; カーソル
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

; パラメータ描画
.proc DrawParam

	; サイクル
	lda #$20
	sta $2006
	lda #$8f
	sta $2006

	lda param_duty_cycle
	adc #$37
	sta $2007

	; ループ
	lda #$20
	sta $2006
	lda #$af
	sta $2006

	lda param_loop
	adc #$37
	sta $2007

	; ゲンスイするしない
	lda #$20
	sta $2006
	lda #$cf
	sta $2006

	lda param_gensui
	adc #$37
	sta $2007

	; ボリューム
	lda #$20
	sta $2006
	lda #$ef
	sta $2006

	lda param_gensui_value
	adc #$37
	sta $2007

	; スイープするしない
	lda #$21
	sta $2006
	lda #$0f
	sta $2006

	lda param_sweep
	adc #$37
	sta $2007

	; スイープスピード
	lda #$21
	sta $2006
	lda #$2f
	sta $2006

	lda param_sweep_speed
	adc #$37
	sta $2007

	; スイープ方向
	lda #$21
	sta $2006
	lda #$4f
	sta $2006

	lda param_sweep_up_down
	adc #$37
	sta $2007

	; スイープ変化量
	lda #$21
	sta $2006
	lda #$6f
	sta $2006

	lda param_sweep_change_amount
	adc #$37
	sta $2007

	; 音階
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

; パラメータ描画
.proc DrawSankakuhaParam

	; カウンタ
	lda #$20
	sta $2006
	lda #$8f
	sta $2006

	lda param_counter
	adc #$37
	sta $2007

	; カウンタ値HI
	lda #$20
	sta $2006
	lda #$af
	sta $2006

	lda param_counter_value_hi
	adc #$37
	sta $2007

	; カウンタ値LOW
	lda #$20
	sta $2006
	lda #$cf
	sta $2006

	lda param_counter_value_low
	adc #$37
	sta $2007

	; 音階
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


	; 空
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

; パラメータ描画
.proc DrawNoiseParam

	; ループ
	lda #$20
	sta $2006
	lda #$8f
	sta $2006

	lda param_noise_loop
	adc #$37
	sta $2007

	; 減衰するしない
	lda #$20
	sta $2006
	lda #$af
	sta $2006

	lda param_noise_gensui_enable
	adc #$37
	sta $2007

	; 減衰値・ボリューム
	lda #$20
	sta $2006
	lda #$cf
	sta $2006

	lda param_noise_gensui_value
	adc #$37
	sta $2007

	; 乱数タイプ
	lda #$20
	sta $2006
	lda #$ef
	sta $2006

	lda param_noise_rnd_type
	adc #$37
	sta $2007
	lda #0
	sta $2007

	; 波長
	lda #$21
	sta $2006
	lda #$0f
	sta $2006
	lda param_noize_hatyo
	adc #$37
	sta $2007

	rts
.endproc

; 文字列描画
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

; 矩形波
.proc DrawKukeihaHead

	; タイトル
	DrawConstStrMacro string_kukeiha,#$20,#$42,#5

	; Dutyサイクル：0～3
	DrawConstStrMacro string_duty,#$20,#$83,#8

	; ループ：するしない
	DrawConstStrMacro string_loop,#$20,#$a3,#7

	; 減衰：するしない
	DrawConstStrMacro string_gensui,#$20,#$c3,#8

	; ボリューム：0～15
	DrawConstStrMacro string_volume,#$20,#$e3,#8

	; スイープ：有効無効
	DrawConstStrMacro string_sweep,#$21,#$03,#5

	; スイープの変化の速さ：0～7
	DrawConstStrMacro string_sweep_speed,#$21,#$23,#8

	; スイープ方向：尻下がり、尻上がり
	DrawConstStrMacro string_sweep_direction,#$21,#$43,#9

	; 音の変化量：0～7
	DrawConstStrMacro string_sweep_change_amount,#$21,#$63,#11

	; 音階：ド～高い方のド
	DrawConstStrMacro string_onkai,#$21,#$83,#8

	; 長さ：0～31

	; アドレス
	jsr DrawKukeihaAddress

	rts
.endproc

; 三角波
.proc DrawSankakuhaHead

	; タイトル
	DrawConstStrMacro string_sankakuha,#$20,#$42,#5

	; カウンタ使用しないする
	DrawConstStrMacro string_counter,#$20,#$83,#8

	; カウンタ値HI
	DrawConstStrMacro string_counter_value_hi,#$20,#$a3,#7

	; カウンタ値LOW
	DrawConstStrMacro string_counter_value_low,#$20,#$c3,#8

	; 音階：ド～高い方のド
	DrawConstStrMacro string_onkai,#$20,#$e3,#8

	; 
	DrawConstStrMacro string_null,#$21,#$03,#6
	DrawConstStrMacro string_null,#$21,#$23,#8
	DrawConstStrMacro string_null,#$21,#$43,#9
	DrawConstStrMacro string_null,#$21,#$63,#11
	DrawConstStrMacro string_null,#$21,#$83,#4

	; アドレス
	jsr DrawSankakuhaAddress
	rts
.endproc

; ノイズ
.proc DrawNoiseHead

	; タイトル
	DrawConstStrMacro string_noise,#$20,#$42,#5

	; ループ
	DrawConstStrMacro string_loop,#$20,#$83,#7

	; 減衰：するしない
	DrawConstStrMacro string_gensui,#$20,#$a3,#8

	; 減衰率・ボリューム
	DrawConstStrMacro string_volume,#$20,#$c3,#8

	; 乱数タイプ
	DrawConstStrMacro string_rnd_type,#$20,#$e3,#8

	; 波長
	DrawConstStrMacro string_hatyo,#$21,#$03,#5

	; 空
	DrawConstStrMacro string_null,#$21,#$23,#11
	DrawConstStrMacro string_null,#$21,#$43,#11
	DrawConstStrMacro string_null,#$21,#$63,#11
	DrawConstStrMacro string_null,#$21,#$83,#11

	; アドレス
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
	; draw_bg_x	X座標
	; draw_bg_y	Y座標

	lda draw_bg_x	
	sta conv_coord_bit_x
	lda draw_bg_y
	sta conv_coord_bit_y
;;;;;↓ 座標をアドレス空間に変換 ;;;;;
	;jsr ConvertCoordToBit
	; y * 32 ; Y座標を一つ下にずらすとX方向に32動かしたこと
	lda #0
	sta multi_ans_hi
	sta multi_ans_low
	lda conv_coord_bit_y
	sta multi_ans_low

	; 32倍
	clc
	asl multi_ans_low		; 下位は左シフト
	rol multi_ans_hi		; 上位は左ローテート

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

	; 下位＋下位
	clc
	lda multi_ans_low
	adc #$20
	sta conv_coord_bit_low
	; 上位＋上位
	lda multi_ans_hi
	adc #$20
	sta conv_coord_bit_hi
;;;;;↑ 座標をアドレス空間に変換 ;;;;;

	lda conv_coord_bit_hi
	sta $2006
	lda conv_coord_bit_low
	sta $2006

	rts
.endproc


; 更新
.proc	Update

	; キー入力
	lda #0
	sta input_dirty_flg

	; 初期化
	lda #$01
	sta $4016
	lda #$00
	sta $4016

	; 前回の状態を格納
	lda key_state_on
	sta key_state_on_old

	lda #0
	sta key_state_on

	; A,B,SELECT,START,UP,DOWN,LEFT,RIGHTの順番
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
	lda $4016	; 上
	and #1
	beq SkipKeyUp
	lda key_state_on
	ora #%00010000
	sta key_state_on
SkipKeyUp:

	lda $4016	; 下
	and #1
	beq SkipKeyDown
	lda key_state_on
	ora #%00100000
	sta key_state_on
SkipKeyDown:

	lda $4016	; 左
	and #1
	beq SkipKeyLeft
	lda key_state_on
	ora #%01000000
	sta key_state_on
SkipKeyLeft:

	lda $4016	; 右
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

; 音の種類切り分け
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




	rts	; サブルーチンから復帰します。
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

; 矩形波ボタン
.proc	UpdateKukeihaPushA
	lda #2	; プレイサウンドへ
	sta input_dirty_flg
	rts
.endproc

.proc	UpdateKukeihaPushB
	rts
.endproc

.proc	UpdateKukeihaPushSelect
	; タイプを三角波に変更する
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

; 左キー押下
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

; 右キー押下
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

; 三角波ボタン
.proc	UpdateSankakuhaPushA
	lda #2	; プレイサウンドへ
	sta input_dirty_flg
	rts
.endproc

.proc	UpdateSankakuhaPushB
	rts
.endproc

.proc	UpdateSankakuhaPushSelect
	; タイプをノイズに変更する
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

; 左キー押下
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

; 右キー押下
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

; ノイズボタン
.proc	UpdateNoisePushA
	lda #2	; プレイサウンドへ
	sta input_dirty_flg
	rts
.endproc

.proc	UpdateNoisePushB
	rts
.endproc

.proc	UpdateNoisePushSelect
	; タイプを矩形波に変更する
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

; 左キー押下
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

; 右キー押下
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

; VBlank割り込み
.proc	VBlank


	rti			; 割り込みから復帰命令

.endproc







	; 初期データ
X_Pos_Init:   .byte 20       ; X座標初期値
Y_Pos_Init:   .byte 40       ; Y座標初期値

; パレットテーブル
palette1:
	.byte	$0c, $23, $3A, $30	; スプライト色1
	.byte	$0f, $07, $16, $0d	; スプライト色2
	.byte	$0f, $23, $3A, $28	; スプライト色3
palette2:
	.byte	$0f, $00, $10, $20
	.byte	$0f, $00, $10, $20
paletteIno:
palettes_bg:
	.byte	$0c, $17, $28, $39	; bg色1
	.byte	$0f, $0f, $12, $30	; bg色2
	.byte	$0f, $0f, $0f, $30	; bg色3
	.byte	$21, $0a, $1a, $2a	; bg色4

	; 星テーブルデータ(20個)
Star_Tbl:
   .byte 60,45,35,60,90,65,45,20,90,10,30,40,65,25,65,35,50,35,40,35

; 表示文字列
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

string_kukeiha:	; クケイハ＿
	.byte	_ku, _ke, _i, _ha, $00
string_duty:	; Dutyサイクル
	.byte	$44, $75, $74, $79, _sa, _i, _ku, _ru
string_loop:	; ルーフ゜＿＿＿
	.byte	_ru, _tyo, _fu, _h_daku, $00, $00, $00
string_gensui:	; ケ゛ンスイ＿＿＿
	.byte	_ke, _daku, _nn, _su, _i, $00, $00, $00
string_volume:	; ホ゛リューム＿＿
	.byte	_ho, _daku, _ri, _xyu, _tyo, _mu, $00, $00
string_sweep:	; スイーフ゜
	.byte	_su, _i, _tyo, _fu, _h_daku
string_sweep_speed:	; スイーフ゜ハヤサ
	.byte	_su, _i, _tyo, _fu, _h_daku, _ha, _ya, _sa
string_sweep_direction:	; スイーフ゜ホウコウ
	.byte	_su, _i, _tyo, _fu, _h_daku, _ho, _u, _ko, _u
string_sweep_change_amount:	; スイーフ゜ヘンカリョウ
	.byte	_su, _i, _tyo, _fu, _h_daku, _he, _nn, _ka, _ri, _xyo, _u
string_onkai:	; オンカイ＿
	.byte	_o, _nn, _ka, _i, $00, $00, $00, $00
string_onkai_do:	; ド
	.byte	_to, _daku
string_onkai_re:	; レ
	.byte	_re, $00
string_onkai_mi:	; ミ
	.byte	_mi, $00
string_onkai_fa:	; ファ
	.byte	_fu, _xa
string_onkai_so:	; ソ
	.byte	_so, $00
string_onkai_ra:	; ラ
	.byte	_ra, $00
string_onkai_si:	; シ
	.byte	_si, $00

string_sankakuha:		; サンカクハ
	.byte	_sa, _nn, _ka, _ku, _ha
string_counter:			; カウンタ＿＿＿＿
	.byte	_ka, _u, _nn, _ta, $00, $00, $00, $00
string_counter_value_hi:	; カウンタチHI
	.byte	_ka, _u, _nn, _ta, _ti, $48, $49
string_counter_value_low:	; カウンタチLOW
	.byte	_ka, _u, _nn, _ta, _ti, $4c, $4f, $57

string_noise:		; ノイス゛＿
	.byte	_no, _i, _su, _daku, $00
string_rnd_type:		; ランスウタイフ゜
	.byte	_ra, _nn, _su, _u, _ta, _i, _fu, _h_daku
string_hatyo:			; ハチョウ＿
	.byte	_ha, _ti, _xyo, _u, $00


string_null:			; ＿＿＿＿＿＿＿＿＿＿＿
	.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00



.segment "VECINFO"
	.word	VBlank
	.word	Reset
	.word	$0000

; パターンテーブル
.segment "CHARS"
	.incbin	"character.chr"
