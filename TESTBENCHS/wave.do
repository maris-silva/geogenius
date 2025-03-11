onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /tb_template_ganha/caso
add wave -noupdate /tb_template_ganha/botoes_in
add wave -noupdate /tb_template_ganha/clock
add wave -noupdate -divider {Sinais de Condicao}
add wave -noupdate -height 20 /tb_template_ganha/db_endereco_igual_limite_out
add wave -noupdate -height 20 /tb_template_ganha/db_fez_jogada_out
add wave -noupdate -height 20 /tb_template_ganha/db_jogada_igual_memoria_out
add wave -noupdate -height 20 /tb_template_ganha/db_ultimo_nivel_out
add wave -noupdate -height 20 /tb_template_ganha/dut/FD/deu_timeout
add wave -noupdate -height 20 /tb_template_ganha/dut/FD/fim_timer_led
add wave -noupdate -height 20 /tb_template_ganha/dut/FD/meio_timer_led
add wave -noupdate -divider {Sinais de Controle}
add wave -noupdate -height 20 /tb_template_ganha/dut/FD/conta_jogada
add wave -noupdate -height 20 /tb_template_ganha/dut/FD/conta_nivel
add wave -noupdate -height 20 /tb_template_ganha/dut/FD/conta_timeout
add wave -noupdate -height 20 /tb_template_ganha/dut/FD/conta_timer_led
add wave -noupdate -height 20 /tb_template_ganha/dut/FD/contar_led
add wave -noupdate -divider Saidas
add wave -noupdate -height 20 /tb_template_ganha/leds_out
add wave -noupdate -height 20 /tb_template_ganha/dut/FD/db_memoria
add wave -noupdate -height 20 /tb_template_ganha/dut/FD/db_jogada
add wave -noupdate -height 20 -radix unsigned /tb_template_ganha/dut/FD/fio_contador_jogada
add wave -noupdate -height 20 -radix unsigned /tb_template_ganha/dut/FD/db_nivel
add wave -noupdate -height 20 -radix hexadecimal /tb_template_ganha/dut/UC/db_estado
add wave -noupdate -height 20 /tb_template_ganha/ganhou_out
add wave -noupdate -height 20 /tb_template_ganha/perdeu_out
add wave -noupdate -height 20 /tb_template_ganha/pronto_out
add wave -noupdate -height 20 /tb_template_ganha/timeout_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {12714000000 ns} 0} {{Cursor 2} {147830000000 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits sec
update
WaveRestoreZoom {0 ns} {68257875 us}
