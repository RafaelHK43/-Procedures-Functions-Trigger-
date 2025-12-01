-- -----------------------------------------------------------------
-- 7) TRIGGERS (12)
-- -----------------------------------------------------------------
-- Observação: usar DELIMITER padrão, cada trigger usa NOW() e insere logs

DELIMITER //

-- Trigger 1: log após inserção em entregas
CREATE TRIGGER trg_log_entrega AFTER INSERT ON entregas
FOR EACH ROW
BEGIN
    INSERT INTO logs_transparencia (acao, data_hora, detalhe)
    VALUES ('Nova entrega registrada', NOW(), CONCAT('Entrega ID: ', NEW.entrega_id, ' Ordem: ', NEW.ordem_id, ' Lote: ', NEW.lote_id, ' Qtd: ', NEW.quantidade));
END //

-- Trigger 2: baixa automática no estoque após inserção de entrega
CREATE TRIGGER trg_baixa_estoque AFTER INSERT ON entregas
FOR EACH ROW
BEGIN
    UPDATE lotes SET quantidade = quantidade - NEW.quantidade WHERE lote_id = NEW.lote_id;
    INSERT INTO logs_transparencia (acao, data_hora, detalhe)
    VALUES ('Baixa estoque após entrega', NOW(), CONCAT('Lote: ', NEW.lote_id, ' - Baixa: ', NEW.quantidade));
END //

-- Trigger 3: evita estoque negativo (antes de update em lotes)
CREATE TRIGGER trg_estoque_nao_negativo BEFORE UPDATE ON lotes
FOR EACH ROW
BEGIN
    IF NEW.quantidade < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Estoque não pode ser negativo';
    END IF;
END //

-- Trigger 4: log inserção de movimentacao
CREATE TRIGGER trg_log_movimentacao AFTER INSERT ON movimentacoes
FOR EACH ROW
BEGIN
    INSERT INTO logs_transparencia (acao, data_hora, detalhe)
    VALUES ('Movimentação registrada', NOW(), CONCAT('Movimentacao ID:', NEW.movimentacao_id, ' Lote:', NEW.lote_id, ' Tipo:', NEW.tipo));
END //

-- Trigger 5: ao inserir rastreabilidade, notifica log
CREATE TRIGGER trg_log_rastreabilidade AFTER INSERT ON rastreabilidade
FOR EACH ROW
BEGIN
    INSERT INTO logs_transparencia (acao, data_hora, detalhe)
    VALUES ('Evento de rastreabilidade', NOW(), CONCAT('Lote:', NEW.lote_id, ' - ', LEFT(NEW.descricao,100)));
END //

-- Trigger 6: ao criar novo usuario, registra log
CREATE TRIGGER trg_log_usuario AFTER INSERT ON usuarios
FOR EACH ROW
BEGIN
    INSERT INTO logs_transparencia (acao, data_hora, detalhe)
    VALUES ('Novo usuário criado', NOW(), CONCAT('Usuário: ', NEW.nome, ' Email: ', NEW.email));
END //

-- Trigger 7: ao inserir aceite_politica, registra log de conformidade
CREATE TRIGGER trg_log_aceite AFTER INSERT ON aceite_politica
FOR EACH ROW
BEGIN
    INSERT INTO logs_transparencia (acao, data_hora, detalhe)
    VALUES ('Aceite política', NOW(), CONCAT('Política ID:', NEW.politica_id, ' Entidade:', NEW.entidade_tipo, ' Id:', NEW.entidade_id));
END //

-- Trigger 8: antes de deletar um fornecedor, bloquear se existirem lotes associados
CREATE TRIGGER trg_block_del_fornecedor BEFORE DELETE ON fornecedores
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM lotes WHERE fornecedor_id = OLD.fornecedor_id) > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não é possível excluir fornecedor com lotes associados';
    END IF;
END //

-- Trigger 9: após inserção de ordens_expedicao, log
CREATE TRIGGER trg_log_ordem AFTER INSERT ON ordens_expedicao
FOR EACH ROW
BEGIN
    INSERT INTO logs_transparencia (acao, data_hora, detalhe)
    VALUES ('Nova ordem de expedição', NOW(), CONCAT('Ordem ID: ', NEW.ordem_id, ' Município: ', NEW.municipio_id));
END //

-- Trigger 10: antes de inserir entregas, valida quantidade disponível via função
CREATE TRIGGER trg_valida_qtd_entrega BEFORE INSERT ON entregas
FOR EACH ROW
BEGIN
    DECLARE estoque_atual INT;
    SELECT quantidade INTO estoque_atual FROM lotes WHERE lote_id = NEW.lote_id;
    IF estoque_atual < NEW.quantidade THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Quantidade da entrega excede estoque disponível';
    END IF;
END //

-- Trigger 11: ao atualizar lote (ex: mudança de armazem), inserir log
CREATE TRIGGER trg_log_atualiza_lote AFTER UPDATE ON lotes
FOR EACH ROW
BEGIN
    INSERT INTO logs_transparencia (acao, data_hora, detalhe)
    VALUES ('Lote atualizado', NOW(), CONCAT('Lote ', NEW.lote_id, ' Quantidade: ', NEW.quantidade, ' Armazem: ', NEW.armazem_id));
END //

-- Trigger 12: ao inserir itens_ordem, log
CREATE TRIGGER trg_log_item_ordem AFTER INSERT ON itens_ordem
FOR EACH ROW
BEGIN
    INSERT INTO logs_transparencia (acao, data_hora, detalhe)
    VALUES ('Item de ordem', NOW(), CONCAT('Ordem: ', NEW.ordem_id, ' Especie: ', NEW.especie_id, ' Qtde: ', NEW.quantidade_solicitada));
END //

DELIMITER ;
