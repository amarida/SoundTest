REG0										= $00	; �ėp0
REG1										= $01	; �ėp1
REG2										= $02	; �ėp2
REG3										= $03	; �ėp3
REG4										= $04	; �ėp4
REG5										= $05	; �ėp5
REG6										= $06	; �ėp6
key_state_on								= $07	; ���݂̃L�[�{�[�h���
key_state_on_old							= $08	; �Â��L�[�{�[�h���
key_state_push								= $09	; ���̃t���[���ŉ����ꂽ���
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
input_dirty_flg								= $17	; ���͂���t���O
param_duty_cycle							= $18	; Duty�T�C�N��
param_loop									= $19	; ���[�v���邵�Ȃ�
param_gensui								= $1A	; �Q���X�C���邵�Ȃ�
param_gensui_value							= $1B	; �{�����[��
param_sweep									= $1C	; �X�C�[�v���邵�Ȃ�
param_sweep_speed							= $1D	; �X�C�[�v�X�s�[�h
param_sweep_up_down							= $1E	; �X�C�[�v����
param_sweep_change_amount					= $1F	; �X�C�[�v�ω���
param_onkai									= $20	; ���K
onkai_do									= $21	; ���K�h
onkai_re									= $22	; ���K��
onkai_mi									= $23	; ���K�~
onkai_fa									= $24	; ���K�t�@
onkai_so									= $25	; ���K�\
onkai_ra									= $26	; ���K��
onkai_si									= $27	; ���K�V
onkai_do2									= $28	; ���K�h
sound_type									= $29	; �T�E���h��ʁi��`�A�O�p�A�m�C�Y�j
param_counter								= $2A	; �J�E���^
param_counter_value_hi						= $2B	; �J�E���^�lhi
param_counter_value_low						= $2C	; �J�E���^�llow
param_noise_loop							= $2D	; ���[�v
param_noise_gensui_enable					= $2E	; �Q���X�C���邵�Ȃ�
param_noise_gensui_value					= $2F	; �Q���X�C
param_noise_rnd_type						= $30	; �����^�C�v
param_noize_hatyo							= $31	; �g��
debug_var									= $FF	; �f�o�b�O�p

_tyo		= $2d	; ����
_daku		= $b7	; ����
_h_daku 	= $b8	; �����_
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
