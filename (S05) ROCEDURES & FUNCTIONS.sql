-- -----------------------------------------------------------------
-- 6) PROCEDURES & FUNCTIONS (14)
-- -----------------------------------------------------------------
DELIMITER //

-- Procedure 1: registrar_movimentacao (insere movimentacao)
CREATE PROCEDURE registrar_movimentacao(
    IN p_lote INT,
    IN p_tipo ENUM('entrada','saida','transferencia'),
    IN p_qtd INT,
    IN p_origem INT,
    IN p_destino INT
)
BEGIN
    INSERT INTO movimentacoes (lote_id, tipo, quantidade, armazem_origem_id, armazem_destino_id, data_movimentacao)
    VALUES (p_lote, p_tipo, p_qtd, p_origem, p_destino, NOW());
END //

-- Procedure 2: registrar_rastreabilidade
CREATE PROCEDURE registrar_rastreabilidade(
    IN p_lote INT,
    IN p_desc TEXT,
    IN p_local VARCHAR(150)
)
BEGIN
    INSERT INTO rastreabilidade (lote_id, descricao, data_evento, localizacao)
    VALUES (p_lote, p_desc, NOW(), p_local);
END //

-- Procedure 3: criar_ordem (gera ordem + itens)
CREATE PROCEDURE criar_ordem(
    IN p_municipio INT,
    IN p_data_prev DATE,
    IN p_status VARCHAR(50)
)
BEGIN
    INSERT INTO ordens_expedicao (municipio_id, data_prevista, status) VALUES (p_municipio, p_data_prev, p_status);
END //

-- Function 1: estoque_armazem (retorna soma de quantidade de armazem)
CREATE FUNCTION estoque_armazem(p_armazem INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COALESCE(SUM(quantidade),0) INTO total FROM lotes WHERE armazem_id = p_armazem;
    RETURN total;
END //

-- Function 2: estoque_especie (total por especie)
CREATE FUNCTION estoque_especie(p_especie INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COALESCE(SUM(quantidade),0) INTO total FROM lotes WHERE especie_id = p_especie;
    RETURN total;
END //

-- Procedure 4: registrar_entrega (insere entrega e baixa estoque)
CREATE PROCEDURE registrar_entrega(
    IN p_ordem INT,
    IN p_lote INT,
    IN p_qtd INT,
    IN p_agricultor INT,
    IN p_data DATETIME,
    IN p_comprovante VARCHAR(250)
)
BEGIN
    START TRANSACTION;
    INSERT INTO entregas (ordem_id, lote_id, quantidade, agricultor_id, data_entrega, comprovante)
    VALUES (p_ordem, p_lote, p_qtd, p_agricultor, p_data, p_comprovante);
    UPDATE lotes SET quantidade = quantidade - p_qtd WHERE lote_id = p_lote;
    INSERT INTO logs_transparencia (acao, data_hora, detalhe) VALUES ('Registrar entrega', NOW(), CONCAT('Ordem ', p_ordem, ' - Lote ', p_lote, ' - Qtd ', p_qtd));
    COMMIT;
END //

-- Procedure 5: criar_usuario (hash simulado)
CREATE PROCEDURE criar_usuario(
    IN p_nome VARCHAR(150),
    IN p_email VARCHAR(100),
    IN p_senha_hash VARCHAR(255),
    IN p_cargo INT,
    IN p_armazem INT
)
BEGIN
    INSERT INTO usuarios (nome, email, senha_hash, cargo_id, armazem_id) VALUES (p_nome, p_email, p_senha_hash, p_cargo, p_armazem);
END //

-- Function 3: verifica_estoque_disponivel (retorna 1 se disponível)
CREATE FUNCTION verifica_estoque_disponivel(p_lote INT, p_qtd INT) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE dispon INT;
    SELECT quantidade INTO dispon FROM lotes WHERE lote_id = p_lote;
    RETURN (dispon >= p_qtd);
END //

-- Procedure 6: transferir_entre_armazens (faz movimentacao tipo transferencia)
CREATE PROCEDURE transferir_entre_armazens(
    IN p_lote INT,
    IN p_qtd INT,
    IN p_origem INT,
    IN p_destino INT
)
BEGIN
    IF p_origem = p_destino THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Origem e destino devem ser diferentes';
    END IF;
    START TRANSACTION;
    -- registra movimentação
    INSERT INTO movimentacoes (lote_id, tipo, quantidade, armazem_origem_id, armazem_destino_id, data_movimentacao)
    VALUES (p_lote, 'transferencia', p_qtd, p_origem, p_destino, NOW());
    -- atualiza lote (aqui assumimos lote está no armazém origem, movemos atributo armazem_id para destino se todo lote transferido)
    UPDATE lotes SET armazem_id = p_destino WHERE lote_id = p_lote;
    INSERT INTO logs_transparencia (acao, data_hora, detalhe) VALUES ('Transferência entre armazéns', NOW(), CONCAT('Lote ', p_lote, ' - ', p_qtd, ' de ', p_origem, ' para ', p_destino));
    COMMIT;
END //

-- Procedure 7: registrar_aceite_politica
CREATE PROCEDURE registrar_aceite(
    IN p_politica INT,
    IN p_entidade_tipo ENUM('usuario','agricultor'),
    IN p_entidade_id INT,
    IN p_ip VARCHAR(45)
)
BEGIN
    INSERT INTO aceite_politica (politica_id, data_aceite, entidade_tipo, entidade_id, ip_address)
    VALUES (p_politica, NOW(), p_entidade_tipo, p_entidade_id, p_ip);
END //

-- Function 4: total_entregue_por_agricultor
CREATE FUNCTION total_entregue_por_agricultor(p_agricultor INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE tot INT;
    SELECT COALESCE(SUM(quantidade),0) INTO tot FROM entregas WHERE agricultor_id = p_agricultor;
    RETURN tot;
END //

-- Procedure 8: gerar_relatorio_estoque_simples (insere um log)
CREATE PROCEDURE gerar_relatorio_estoque_simples()
BEGIN
    INSERT INTO logs_transparencia (acao, data_hora, detalhe) VALUES ('Relatório estoque', NOW(), 'Relatório de estoque simples gerado');
END //

-- Procedure 9: ajustar_estoque_manual (para testes/admin)
CREATE PROCEDURE ajustar_estoque_manual(
    IN p_lote INT,
    IN p_nova_qtd INT,
    IN p_motivo TEXT
)
BEGIN
    UPDATE lotes SET quantidade = p_nova_qtd WHERE lote_id = p_lote;
    INSERT INTO logs_transparencia (acao, data_hora, detalhe) VALUES ('Ajuste estoque', NOW(), CONCAT('Lote ', p_lote, ' novo estoque ', p_nova_qtd, ' Motivo: ', p_motivo));
END //

DELIMITER ;