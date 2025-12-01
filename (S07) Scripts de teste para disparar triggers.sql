-- -----------------------------------------------------------------
-- 8) Scripts de teste para disparar triggers / procedimentos (exemplos)
-- -----------------------------------------------------------------
-- Teste 1: executar procedure registrar_movimentacao
CALL registrar_movimentacao(1,'saida',50,1,NULL);

-- Teste 2: executar procedure registrar_rastreabilidade
CALL registrar_rastreabilidade(1,'Evento de teste: liberação para transporte','Armazém Central');

-- Teste 3: executar procedure registrar_entrega (usa transação e baixa estoque)
-- Para garantir sucesso, usar valores dentro do estoque atual
CALL registrar_entrega(1,1,10,1,'2025-10-30 09:00:00','teste_comprovante.pdf');

-- Teste 4: executar transferir_entre_armazens (transferência de lote 8 do armazém 2 para 3)
CALL transferir_entre_armazens(8,100,2,3);

-- Teste 5: ajustar estoque manual
CALL ajustar_estoque_manual(20, 1800, 'Ajuste por inventário');