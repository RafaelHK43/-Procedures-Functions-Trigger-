-- -----------------------------------------------------------------
-- 5) VIEWS (10)
-- -----------------------------------------------------------------
-- vw_lotes_completos -> inventário completo
CREATE OR REPLACE VIEW vw_lotes_completos AS
SELECT l.lote_id, l.numero_lote, e.nome AS especie, l.validade, l.quantidade, a.nome AS armazem, f.nome AS fornecedor
FROM lotes l
JOIN especies e ON e.especie_id = l.especie_id
JOIN armazens a ON a.armazem_id = l.armazem_id
LEFT JOIN fornecedores f ON f.fornecedor_id = l.fornecedor_id;

-- vw_entregas_detalhadas -> entrega + ordem + agricultor + lote
CREATE OR REPLACE VIEW vw_entregas_detalhadas AS
SELECT ent.entrega_id, ent.data_entrega, ent.quantidade, ent.comprovante,
 ord.ordem_id, ord.data_prevista, ord.status,
 l.lote_id, l.numero_lote, esp.nome AS especie,
 agr.agricultor_id, agr.nome AS agricultor, mun.nome AS municipio
FROM entregas ent
JOIN ordens_expedicao ord ON ord.ordem_id = ent.ordem_id
JOIN lotes l ON l.lote_id = ent.lote_id
JOIN especies esp ON esp.especie_id = l.especie_id
JOIN agricultores agr ON agr.agricultor_id = ent.agricultor_id
JOIN municipios mun ON mun.municipio_id = agr.municipio_id;

-- vw_estoque_por_armazem
CREATE OR REPLACE VIEW vw_estoque_por_armazem AS
SELECT a.armazem_id, a.nome AS armazem, SUM(l.quantidade) AS estoque_total
FROM armazens a
LEFT JOIN lotes l ON l.armazem_id = a.armazem_id
GROUP BY a.armazem_id;

-- vw_movimentacoes_lote
CREATE OR REPLACE VIEW vw_movimentacoes_lote AS
SELECT mv.movimentacao_id, l.numero_lote, mv.tipo, mv.quantidade, mv.data_movimentacao,
 ao.nome AS origem, ad.nome AS destino
FROM movimentacoes mv
JOIN lotes l ON l.lote_id = mv.lote_id
LEFT JOIN armazens ao ON ao.armazem_id = mv.armazem_origem_id
LEFT JOIN armazens ad ON ad.armazem_id = mv.armazem_destino_id;

-- vw_ordens_resumo
CREATE OR REPLACE VIEW vw_ordens_resumo AS
SELECT o.ordem_id, m.nome AS municipio, o.data_prevista, o.status,
 (SELECT COUNT(*) FROM entregas e WHERE e.ordem_id = o.ordem_id) AS qtde_entregas
FROM ordens_expedicao o
JOIN municipios m ON m.municipio_id = o.municipio_id;

-- vw_rastreabilidade_lote (último evento por lote)
CREATE OR REPLACE VIEW vw_rastreabilidade_lote AS
SELECT r1.lote_id, l.numero_lote, r1.descricao, r1.data_evento, r1.localizacao
FROM rastreabilidade r1
JOIN lotes l ON l.lote_id = r1.lote_id
WHERE r1.data_evento = (SELECT MAX(r2.data_evento) FROM rastreabilidade r2 WHERE r2.lote_id = r1.lote_id);

-- vw_fornecedores_ranking
CREATE OR REPLACE VIEW vw_fornecedores_ranking AS
SELECT f.fornecedor_id, f.nome, SUM(l.quantidade) AS total_fornecido
FROM fornecedores f
JOIN lotes l ON l.fornecedor_id = f.fornecedor_id
GROUP BY f.fornecedor_id
ORDER BY total_fornecido DESC;

-- vw_usuarios_cargos
CREATE OR REPLACE VIEW vw_usuarios_cargos AS
SELECT u.usuario_id, u.nome AS usuario, u.email, c.nome AS cargo, a.nome AS armazem
FROM usuarios u
LEFT JOIN cargos c ON c.cargo_id = u.cargo_id
LEFT JOIN armazens a ON a.armazem_id = u.armazem_id;

-- vw_entregas_mensal (soma por mes)
CREATE OR REPLACE VIEW vw_entregas_mensal AS
SELECT DATE_FORMAT(data_entrega, '%Y-%m') AS mes, COUNT(*) AS qtd_entregas, SUM(quantidade) AS total_qtd
FROM entregas
GROUP BY mes;

-- vw_itens_ordem_detalhe
CREATE OR REPLACE VIEW vw_itens_ordem_detalhe AS
SELECT io.item_ordem_id, io.ordem_id, esp.nome AS especie, io.quantidade_solicitada
FROM itens_ordem io
JOIN especies esp ON esp.especie_id = io.especie_id;