REG0										= $00	; 汎用0
REG1										= $01	; 汎用1
REG2										= $02	; 汎用2
REG3										= $03	; 汎用3
REG4										= $04	; 汎用4
REG5										= $05	; 汎用5
REG6										= $06	; 汎用6
key_state_on								= $07	; 現在のキーボード状態
key_state_on_old							= $08	; 古いキーボード状態
key_state_push								= $09	; このフレームで押された状態
scene_step									= $0A	; 
DoubleRAM									= $0B
;											= $0C
cursor_pos									= $0D
draw_bg_x									= $0F
draw_bg_y									= $10
conv_coord_bit_x							= $11
conv_coord_bit_y							= $12
multi_ans_hi								= $13
multi_ans_low								= $14
conv_coord_bit_hi							= $15
conv_coord_bit_low							= $16
input_dirty_flg								= $17	; 入力ありフラグ
param_duty_cycle							= $18	; Dutyサイクル
param_loop									= $19	; ループするしない
param_gensui								= $1A	; ゲンスイするしない
param_gensui_value							= $1B	; ボリューム
param_sweep									= $1C	; スイープするしない
param_sweep_speed							= $1D	; スイープスピード
param_sweep_up_down							= $1E	; スイープ方向
param_sweep_change_amount					= $1F	; スイープ変化量
param_onkai									= $20	; 音階
onkai_do									= $21	; 音階ド
onkai_re									= $22	; 音階レ
onkai_mi									= $23	; 音階ミ
onkai_fa									= $24	; 音階ファ
onkai_so									= $25	; 音階ソ
onkai_ra									= $26	; 音階ラ
onkai_si									= $27	; 音階シ
onkai_do2									= $28	; 音階ド
sound_type									= $29	; サウンド種別（矩形、三角、ノイズ）
param_counter								= $2A	; カウンタ
param_counter_value_hi						= $2B	; カウンタ値hi
param_counter_value_low						= $2C	; カウンタ値low
param_noise_loop							= $2D	; ループ
param_noise_gensui_enable					= $2E	; ゲンスイするしない
param_noise_gensui_value					= $2F	; ゲンスイ
param_noise_rnd_type						= $30	; 乱数タイプ
param_noize_hatyo							= $31	; 波長
debug_var									= $FF	; デバッグ用

_tyo		= $2d	; 長音
_daku		= $b7	; 濁音
_h_daku 	= $b8	; 半濁点
.org $00c0
_a:		.byte 0
_i:		.byte 0
_u:		.byte 0
_e:		.byte 0
_o:		.byte 0
_ka:	.byte 0
_ki:	.byte 0
_ku:	.byte 0
_ke:	.byte 0
_ko:	.byte 0
_sa:	.byte 0
_si:	.byte 0
_su:	.byte 0
_se:	.byte 0
_so:	.byte 0
_ta:	.byte 0
_ti:	.byte 0
_tu:	.byte 0
_te:	.byte 0
_to:	.byte 0
_na:	.byte 0
_ni:	.byte 0
_nu:	.byte 0
_ne:	.byte 0
_no:	.byte 0
_ha:	.byte 0
_hi:	.byte 0
_fu:	.byte 0
_he:	.byte 0
_ho:	.byte 0
_ma:	.byte 0
_mi:	.byte 0
_mu:	.byte 0
_me:	.byte 0
_mo:	.byte 0
_ya:	.byte 0
_yu:	.byte 0
_yo:	.byte 0
_ra:	.byte 0
_ri:	.byte 0
_ru:	.byte 0
_re:	.byte 0
_ro:	.byte 0
_wa:	.byte 0
_wo:	.byte 0
_nn:	.byte 0
_xa:	.byte 0
_xi:	.byte 0
_xu:	.byte 0
_xe:	.byte 0
_xo:	.byte 0
_xtu:	.byte 0
_xya:	.byte 0
_xyu:	.byte 0
_xyo:	.byte 0
