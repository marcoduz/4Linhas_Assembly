##Alunos: Julio Gonçalves, Marco Antonio Duz

##(linha * 7 (tam tabuleiro) + coluna)*4
.data
	op_menu: .asciz "\n1) Configuração\n2) Jogar\n3) Sair\n"
	op_submenu: .asciz "\n1) Quantidade de jogadores\n2) Tamanho do tabuleiro\n3) Modo de dificuldade\n4) Zerar contadores\n5) Configurações atuais\n"

	
	op_dificuldade_menu: .asciz "\nModo de dificuldade: \n1) Jogadas aleatórias \n2) Jogada vizinha\n"	
	op_player_menu: .asciz "\nQuantidade de jogadores:\n1) 1 jogador\n2) 2 jogadores\n"
	op_tabuleiro_menu: .asciz "\nTamanho do tabuleiro:\n1) 7x6\n2) 9x6\n"
	op_comeca_jogando: .asciz "\nQuem começa?\n1) Jogador\n2) Controlador\n"
	
	cfg_print: .asciz  "\nConfiguração atual:\n"
	
	txt_p: .asciz "Jogador(es): "
	
	txt_dif: .asciz "Dificuldade: "
	txt_dif_ale: .asciz "Jogadas aleatórias\n"
	txt_dif_viz: .asciz "Jogada vizinha\n"
	
	txt_tab: .asciz "Tabuleiro: "
	txt_x6: .asciz "x6\n"
	
	txt_venc_a: .asciz "\nVitória do J1"
	txt_venc_b: .asciz "\nVitória do J2"
	
	txt_cont_a: .asciz "\nJ1 venceu: "
	txt_cont_b: .asciz "J2 venceu: "
	txt_empate: .asciz "\nFim de jogo\nEmpate"
	
	txt_jog_1: .asciz "J1: "
	txt_jog_2: .asciz "J2: "
	
	br: .asciz "\n"
	
	space: .word  ' '
	empty_space: .word  '-'
	played_by_a: .word 'O'
	played_by_b: .word '@'
	last_played_place: .word 0
	last_played_column: .word 0
	
	#states
	players: .word 1
	size: .word 7
	dif: .word 1
	cont_a: .word 0
	cont_b: .word 0
	erro: .asciz "Erro, tente novamente\n"
	
	.align 2
	matriz_jogo: .space 216
.text

main:
	la a0, op_menu
	li a7, 4
	ecall
	
	li a7, 5
	ecall
	
	li a1, 1
	beq a1, a0, configuracao
	addi a1, a1, 1
	beq a1, a0, jogar
	addi a1, a1, 1
	beq a1, a0, sair
	
	la a0, erro
	li a7, 4
	ecall
	
	j main
	
configuracao:
	la a0, op_submenu
	li a7, 4
	ecall
	
	li a7, 5
	ecall
	
	li a1, 1
	beq a1, a0, qtd_jogadores
	addi a1, a1, 1
	beq a1, a0, tam_tabuleiro
	addi a1, a1, 1
	beq a1, a0, dificuldade
	addi a1, a1, 1
	beq a1, a0, zerar_contadores
	addi a1, a1, 1
	beq a1, a0, mostrar_config
	
	call erro_handler

	j main

erro_handler:
	la a0, erro
	li a7, 4
	ecall

	ret

qtd_jogadores:
	la a0, op_player_menu
	li a7, 4
	ecall
	
	li a7, 5
	ecall
	
	ble a0, zero, jogadores_erro
	li t0, 2
	bgt a0, t0, jogadores_erro
	
	la t0, players
	sw a0, 0(t0)
	j main


	jogadores_erro:
	call erro_handler
	j qtd_jogadores
	

tam_tabuleiro:
	la a0, op_tabuleiro_menu
	li a7, 4
	ecall
	
	li a7, 5
	ecall
	
	ble a0, zero, tabuleiro_erro
	li t0, 2
	bgt a0, t0, tabuleiro_erro
	
	li t1, 1
	la t0, size
	beq a0, t1, tabuleiro_7
	li t1, 9
	sw t1, 0(t0)
	j main
	
	tabuleiro_7:
	li t1, 7
	sw t1, 0(t0)
	j main


	tabuleiro_erro:
	call erro_handler
	j qtd_jogadores

dificuldade:
	la a0, op_dificuldade_menu
	li a7, 4
	ecall
	
	li a7, 5
	ecall
	
	ble a0, zero, dificuldade_erro
	li t0, 2
	bgt a0, t0, dificuldade_erro
	
	la t0, dif
	sw a0, 0(t0)
	j main


	dificuldade_erro:
	call erro_handler
	j dificuldade

zerar_contadores:
	la a0, cont_a
	sw zero, 0(a0)
	
	la a0, cont_b
	sw zero, 0(a0)
	
	j main

mostrar_config:
	la a0, cfg_print
	li a7, 4
	ecall
	
	la a0, txt_p
	li a7, 4
	ecall
	
	la t1, players
	lw a0, 0(t1)
	
	li a7, 1
	ecall
	
	la a0, br
	li a7, 4
	ecall
	
	la a0, txt_tab
	li a7, 4
	ecall
	
	la t1, size
	lw a0, 0(t1)
	
	li a7, 1
	ecall
	
	la a0, txt_x6
	li a7, 4
	ecall
	
	la a0, txt_dif
	li a7, 4
	ecall
	
	la t1, dif
	lw t1, 0(t1)
	
	li t0, 1
	
	beq t1, t0, mostra_jog_ale
	la a0, txt_dif_viz
	li a7, 4
	ecall
	j skip_mostra_dif
	
	mostra_jog_ale:
	la a0, txt_dif_ale
	li a7, 4
	ecall
	
	skip_mostra_dif:
	call mostrar_placar
	
	j main
	
	
mostrar_placar:
	
	la a0, txt_cont_a
	li a7, 4
	ecall
	
	la t1, cont_a
	lw a0, 0(t1)
	
	li a7, 1
	ecall
	
	la a0, br
	li a7, 4
	ecall
	
	la a0, txt_cont_b
	li a7, 4
	ecall
	
	la t1, cont_b
	lw a0, 0(t1)
	
	li a7, 1
	ecall
	
	la a0, br
	li a7, 4
	ecall
	
	ret

imprime_tabuleiro:
	mv t0, a0
	mv t1, a1
		
	li t3, 0
	
	addi t5, t1, -1
	
	la a0, br
	li a7, 4
	ecall	
	
	for_imprime_num:
		mv a0, t3
		li a7, 1
		ecall
		
		beq t3, t5, break_imprime_num
		
		la t4, space
		lw a0, 0(t4)
		
		li a7, 11
		ecall
		
		addi t3, t3, 1
		j for_imprime_num
	break_imprime_num:
	
	la a0, br
	li a7, 4
	ecall
	
	li t3, 0
	addi t5, t1, -1

	li t1, 6

	for_imprime_tabuleiro:
		beq t3, t1, break_imprime_tabuleiro
		li t6, 0
		
		for_imprime_tabuleiro_in:
			lw a0, 0(t0)
			li a7, 11
			ecall
			
			beq t6, t5, break_imprime_tabuleiro_in
			
			la t4, space
			lw a0, 0(t4)
			
			li a7, 11
			ecall
			
			addi t6, t6, 1
			addi t0, t0, 4
			j for_imprime_tabuleiro_in
		break_imprime_tabuleiro_in:
		
		la a0, br
		li a7, 4
		ecall
		
		addi t0, t0, 4
		addi t3, t3, 1
		j for_imprime_tabuleiro
		
	break_imprime_tabuleiro:
	
	ret
			
inicializa_tabuleiro:
	mv t0, a0
	mv t1, a1
	
	li t3, 6
	mul t1, t3, t1
	
	li t3, 0
	
	la t4, empty_space
	lw t4, 0(t4)
		
	for_inicializa:
		bgt t3, t1, break_inicializa
		sw t4, 0(t0)
		addi t3, t3, 1
		addi t0, t0, 4
		j for_inicializa
	break_inicializa:
	
	ret

jogada_handler:
	mv t0, a0 #matriz
	mv t1, a1 #tamanho
	mv t2, a2 #coluna
	mv t3, a3 #player
	
	####salvando a coluna jogada para usar no verifica ganhador
	la a0, last_played_column
	sw t2, 0(a0)
	
	li t5, 1
	beq t3, t5, set_jogada_1
	la t4, played_by_b
	lw t4, 0(t4)
	j put_jogada
	
	set_jogada_1:
	la t4, played_by_a
	lw t4, 0(t4)
	
	put_jogada:
	
	mv s10, t3
	
	la t3, empty_space
	lw t3, 0(t3)
	
	li t6, 4
	mul t5, t2, t6
	add t0, t0, t5
	
	lw s11, 0(t0)
	bne s11, t3, erro_jogada
	
	li t5, 5
	mul t5, t5, t6
	mul t5, t5, t1
	add t0, t0, t5
	
	find_jogada_position:
		lw t6, 0(t0)
		beq t6, t3, end_jogada
		li t6, 4
		mul t5, t1, t6
		sub t0, t0, t5
		j find_jogada_position
	end_jogada:
	sw t4, 0(t0)
	
	la a0, last_played_place 
	sw t0, 0(a0)	#salva o �ltimo endere�o em que foi jogado na mem�ria
	mv s11, ra 
	la a0, matriz_jogo 
	la a1, size 
	lw a1, 0(a1)
	mv a2, a3
	call verifica_ganhador 

	mv ra, s11	
	ret
	
	erro_jogada:
	li t5, 1
	beq s10, t5, reset_jogada_1
	
	li a1, 1
	la t1, players
	lw t1, 0(t1)
	
	beq a1, t1, random_play
	
	call erro_handler
	j le_jogador_2
	
	reset_jogada_1:
	call erro_handler
	j le_jogador_1

verifica_ganhador:	
	mv t0, a0	# t0 -> primeiro endere�o da matriz
	mv t1, a1	# t1 -> tamanho da matriz
	mv t2, a2	# t2 -> player que jogou
	la a3, last_played_place
	lw t3, 0(a3)	# t3 -> endere�o da jogada
	li t4, 1 	# t4-> contador
	la a3, last_played_column
	lw t6, 0(a3) 	# t6 -> oluna da ultima jogada
	
	
	li t5, 1
	beq t2, t5, set_player_1
	la t5, played_by_b
	lw t5, 0(t5) 	# t5 -> recebe o caracter especifico do jogador
	j baixo
	
	set_player_1:
	la t5, played_by_a
	lw t5, 0(t5)	# t5 -> recebe o caracter especifico do jogador

	
	baixo:
		li a0, 5
		mul a5, a0, t1
		add a5, a5, t1
		addi a5, a5, -1
		slli a5, a5, 2 
		add a5, a5, t0 	# a5 -> armazena o �ltimo endere�o da matriz
			
		li t4, 0 	# t4<<0 set contador em 0
		li a0, 4
		mul a0, a0, t1	#valor que se somado ao endere�o passa pra a proxima linha da matriz
		mv a1, t3
		li a3, 4	# a3<<0 set parametro de compara��o em 0
		loop_baixo:
			lw a2, 0(a1)
			beq t4, a3, ganhou
			bgt a1, a5, laterais
			bne a2, t5,laterais
			add a1, a1, a0 	# a1 << proximo endere�o a ser verificado (linha de baixo na mesma coluna)
			addi t4, t4, 1
			j loop_baixo
			
	laterais:		
		li t4, 0 	# t4<<0 set contador em 0		
		mv a1, t3
		li a3, 4	# a3<<4 set parametro de compara��o em 4
		mv a6, t6	# a6<< ultima coluna jogada
		li a5, 6
		lateral_verify_left:
			lw a2, 0(a1)
			beq t4, a3, ganhou
			bne a2, t5, lateral_end_left
			blt a6, zero, lateral_end_left
			
			addi a1, a1, -4	# a1 << proximo endere�o a ser verificado (coluna a esquerda)
			addi t4, t4, 1
			addi a6, a6, -1
			j lateral_verify_left
		lateral_end_left:
		mv a1, t3
		addi a1, a1, 4	# a1 inicia um a direita pois o jogado j� foi contado no loop anterior
		mv a6, t6
		addi a6, a6, 1
		lateral_verify_right:
			lw a2, 0(a1)
			beq t4, a3, ganhou
			bne a2, t5, diagonal
			bgt a6, a5, diagonal
			
			addi a1, a1, 4 # a1 << proximo endere�o a ser verificado (coluna a direita)
			addi t4, t4, 1
			addi a6, a6, 1
			j lateral_verify_right
	
	diagonal:		
		li t4, 0	# t4<<0 set contador em 0
		li a0, 4
		mul a0, a0, t1	##valor que se somado ao endere�o passa para a proxima linha da matriz
		mv a1, t3
		li a3, 4	# a3<<4 set parametro de compara��o em 4
		mv a6, t6 	# a6<< ultima coluna jogada
		diagonal_1:	# diagonal principal
			diagonal1_left:
				lw a2, 0(a1)
				beq t4, a3, ganhou
				bne a2, t5, start_diagonal1_right
				blt a6, zero, start_diagonal1_right
				
				sub a1, a1, a0	#a1 << anda uma linha pra tr�z na matriz
				addi a1, a1, -4 #a1 << proximo endere�o a ser verificado (1 linha pra cima e 1 coluna pra esquerda)
				addi t4, t4, 1
				addi a6, a6, -1
				j diagonal1_left
			
			start_diagonal1_right:
			li a5, 6
			mv a1, t3
			add a1, a1, a0
			addi a1, a1, 4	# a1 inicia no proximo endere�o pois o jogado j� foi contado no loop anterior
			mv a6, t6
			addi a6, a6, 1	# a6<< ultima coluna jogada + 1
			diagonal1_right:
				lw a2, 0(a1)
				beq t4, a3, ganhou
				bne a2, t5, diagonal_2
				bgt a6, a5, diagonal_2
				
				
				add a1, a1, a0 	##a1 << anda uma linha pra frente na matriz
				addi a1, a1, 4 	#a1 << proximo endere�o a ser verificado (1 linha pra baixo e 1 coluna pra direita)
				addi t4, t4, 1
				addi a6, a6, 1
				j diagonal1_right
				
		diagonal_2:
			li t4, 0 	# t4<<0 set contador em 0
			mv a1, t3
			mv a6, t6	# a6<< ultima coluna jogada
			diagonal2_left:
				lw a2, 0(a1)
				beq t4, a3, ganhou
				bne a2, t5, start_diagonal2_right
				blt a6, zero, start_diagonal2_right
				
				add a1, a1, a0 	#a1 << anda uma linha pra frente na matriz
				addi a1, a1, -4 #a1 << proximo endere�o a ser verificado (1 linha pra baixo e 1 coluna pra esquerda)
				addi t4, t4, 1
				addi a6, a6, -1
				j diagonal2_left
			
			start_diagonal2_right:
			li a5, 6
			mv a1, t3
			sub a1, a1, a0
			addi a1, a1, 4	# a1 inicia no proximo endere�o pois o jogado j� foi contado no loop anterior
			mv a6, t6
			addi a6, a6, 1 # a6<< ultima coluna jogada + 1
			diagonal2_right:
				lw a2, 0(a1)
				beq t4, a3, ganhou
				bne a2, t5, tabuleiro_cheio
				bgt a6, a5, tabuleiro_cheio
				
				sub a1, a1, a0 #a1 << anda uma linha pra tr�z na matriz
				addi a1, a1, 4 #a1 << proximo endere�o a ser verificado (1 linha pra cima e 1 coluna pra direita)
				addi t4, t4, 1
				addi a6, a6, 1
				j diagonal2_right
	tabuleiro_cheio:		
		li t4, 0	# t4<<0 set contador em 0
		
		li a0, 6
		mul a3, t1, a0  #13 << quantidade de c�lulas da matriz (tamanho * 6)
		
		la a0, empty_space
		lw a5, 0(a0)	# a5<< - set parametro de compara��o como o caracter de espa�� vazio
		
		mv a1, t0	#a1 << primeiro endere�o da matriz
		loop_cheio:
			lw a2, 0(a1)
			beq t4, a3, fim_jogo_empate	# tabuleiro cheio quando t4 == a qtd de celulas
			beq a2, a5, nao_ganhou	# caso o tabuleiro n�o eteja cheio
			addi t4, t4, 1
			addi a1, a1, 4
			j loop_cheio
		
	ganhou:
	
	call mostrar_placar
	la a0, matriz_jogo
	la a1, size
	lw a1, 0(a1)
	call imprime_tabuleiro
	
	li t6, 2
	beq t6, t2, ganhou2
		ganhou1:
		la a0, txt_venc_a
		li a7, 4
		ecall
		
		la a0, cont_a
		lw a1, 0(a0)
		addi a1, a1, 1
		sw a1, 0(a0) ##acrescentou 1 no contador de vitorias do J1
		j fim_ganhou
		
		ganhou2:
		la a0, txt_venc_b
		li a7, 4
		ecall
		
		la a0, cont_b
		lw a1, 0(a0)
		addi a1, a1, 1 ##acrescentou 1 no contador de vitorias do J2
		sw a1, 0(a0)
		
	fim_ganhou:
	li a0, 1
	mv a1, a2
	j main
	
	nao_ganhou:
	li a0, -1
	ret
	
	fim_jogo_empate:
		la a0, txt_empate
		li a7, 4
		ecall
		j main

jogar:
	la a0, matriz_jogo
	la a1, size
	lw a1, 0(a1)
	call inicializa_tabuleiro
	
	
	li a1, 1
	la t1, players
	lw t1, 0(t1)
	
	bne a1, t1, while_play
	j jogando_sozinho_comeca
	
	jogar_sozinho_erro:
	call erro_handler
	
	jogando_sozinho_comeca:
	la a0, op_comeca_jogando
	li a7, 4
	ecall
	
	li a7, 5
	ecall
	
	ble a0, zero, jogar_sozinho_erro
	li t0, 2
	bgt a0, t0, jogar_sozinho_erro
	
	beq a0, t0, random_play
	
	while_play:
	call mostrar_placar
	la a0, matriz_jogo
	la a1, size
	lw a1, 0(a1)
	call imprime_tabuleiro
	
	le_jogador_1:
	
	la a0, txt_jog_1
	li a7, 4
	ecall
	
	li a7, 5
	ecall
	
	blt a0, zero, jogador_1_erro
	la t0, size
	lw t0, 0(t0)
	bge a0, t0, jogador_1_erro
	
	mv a2, a0
	
	la a0, matriz_jogo
	la a1, size
	lw a1, 0(a1)
	li a3, 1
	
	call jogada_handler
	
	call mostrar_placar
	la a0, matriz_jogo
	la a1, size
	lw a1, 0(a1)
	call imprime_tabuleiro
	
	li a1, 1
	la t1, players
	lw t1, 0(t1)
	
	beq a1, t1, jogar_1_jogador
	
	j play_jogador_2
	
	jogador_1_erro:
	call erro_handler
	j le_jogador_1
	
	play_jogador_2:
	call mostrar_placar
	la a0, matriz_jogo
	la a1, size
	lw a1, 0(a1)
	call imprime_tabuleiro
	
	le_jogador_2:
	
	la a0, txt_jog_2
	li a7, 4
	ecall
	
	li a7, 5
	ecall
	
	blt a0, zero, jogador_2_erro
	la t0, size
	lw t0, 0(t0)
	bge a0, t0, jogador_2_erro
	
	mv a2, a0
	
	la a0, matriz_jogo
	la a1, size
	lw a1, 0(a1)
	li a3, 2
	
	call jogada_handler
	
	j while_play
	
	jogador_2_erro:
	call erro_handler
	j le_jogador_2
	
	jogar_1_jogador:

	la t1, dif
	lw t1, 0(t1) #dificuldade
	
	li t2, 1
	
	beq t2, t1, random_play
	
	la t6, last_played_column
	lw t6, 0(t6) ##coluna da ultima jogada
	
	li a0, 0
	li a1, 3
	li a7, 42
	ecall
	
	addi t6, t6, -1
	add t6, a0, t6 ##left same right
	
	la a1, size
	lw a1, 0(a1)
	
	blt t6, zero, random_play
	bge t6, a1, random_play
	
	mv a2, t6
	
	j end_bot_play

	random_play:
	
	li a0, 0
	la a1, size
	lw a1, 0(a1)
	li a7, 42
	ecall
	
	mv a2, a0
	
	end_bot_play:
	
	la a0, matriz_jogo
	la a1, size
	lw a1, 0(a1)
	li a3, 2
	
	call jogada_handler
	
	j while_play

	break_play:
	j main	
sair:
 nop
