-- -----------------------------------------------------------------
-- 4) DQL: 20 consultas (todas usam JOIN/subselect)
-- -----------------------------------------------------------------
-- Nota: cada consulta inclui comentário explicando finalidade

-- 1) Lotes com detalhes de especie, armazem e fornecedor
-- Finalidade: Relatório de inventário detalhado
SELECT l.numero_lote, e.nome AS especie, a.nome AS armazem, f.nome AS fornecedor, l.quantidade, l.validade
FROM lotes l
JOIN especies e ON e.especie_id = l.especie_id
JOIN armazens a ON a.armazem_id = l.armazem_id
JOIN fornecedores f ON f.fornecedor_id = l.fornecedor_id;

-- 2) Agricultores e seus municípios
-- Finalidade: Identificar agricultores por localização
SELECT agr.nome AS agricultor, m.nome AS municipio, m.estado
FROM agricultores agr
JOIN municipios m ON m.municipio_id = agr.municipio_id;

-- 3) Entregas recentes com dados do lote e agricultor
-- Finalidade: Acompanhar expedições realizadas
SELECT ent.entrega_id, ent.data_entrega, ent.quantidade, l.numero_lote, esp.nome AS especie, agr.nome AS agricultor
FROM entregas ent
JOIN lotes l ON l.lote_id = ent.lote_id
JOIN especies esp ON esp.especie_id = l.especie_id
JOIN agricultores agr ON agr.agricultor_id = ent.agricultor_id
ORDER BY ent.data_entrega DESC
LIMIT 50;

-- 4) Lotes com validade a vencer nos próximos 30 dias
-- Finalidade: Ação preventiva contra vencimento de sementes
SELECT l.numero_lote, l.validade, DATEDIFF(l.validade, CURDATE()) AS dias_restantes
FROM lotes l
WHERE l.validade BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY);

-- 5) Total entregue por agricultor (ranking)
-- Finalidade: Ver quem recebeu mais produtos
SELECT agr.nome, SUM(ent.quantidade) AS total_entregue
FROM entregas ent
JOIN agricultores agr ON agr.agricultor_id = ent.agricultor_id
GROUP BY agr.nome
ORDER BY total_entregue DESC;

-- 6) Estoque total por armazém (somando lotes)
-- Finalidade: Relatório de capacidade/estoque por unidade
SELECT a.nome AS armazem, SUM(l.quantidade) AS estoque_total
FROM armazens a
LEFT JOIN lotes l ON l.armazem_id = a.armazem_id
GROUP BY a.armazem_id;

-- 7) Histórico de rastreabilidade de um lote específico (subselect para escolher lote)
-- Finalidade: Rastreio completo do lote
SELECT l.numero_lote, r.descricao, r.data_evento, r.localizacao
FROM rastreabilidade r
JOIN lotes l ON l.lote_id = r.lote_id
WHERE l.lote_id = (SELECT lote_id FROM lotes WHERE numero_lote = 'LOTE-0001' LIMIT 1)
ORDER BY r.data_evento;

-- 8) Ordens atrasadas (data_prevista < hoje)
-- Finalidade: Identificar ordens que precisam de atenção
SELECT o.ordem_id, o.data_prevista, o.status, m.nome AS municipio
FROM ordens_expedicao o
JOIN municipios m ON m.municipio_id = o.municipio_id
WHERE o.data_prevista < CURDATE() AND o.status NOT LIKE '%Concluída%';

-- 9) Movimentações por lote com nomes de armazéns
-- Finalidade: Traçar movimentações logísticas
SELECT mv.*, l.numero_lote,
 ao.nome AS armazem_origem, ad.nome AS armazem_destino
FROM movimentacoes mv
JOIN lotes l ON l.lote_id = mv.lote_id
LEFT JOIN armazens ao ON ao.armazem_id = mv.armazem_origem_id
LEFT JOIN armazens ad ON ad.armazem_id = mv.armazem_destino_id
ORDER BY mv.data_movimentacao DESC;

-- 10) Usuários ativos por cargo
-- Finalidade: Controle de acesso e responsabilidade
SELECT c.nome AS cargo, COUNT(u.usuario_id) AS qtd_usuarios
FROM cargos c
LEFT JOIN usuarios u ON u.cargo_id = c.cargo_id AND u.ativo = TRUE
GROUP BY c.cargo_id;

-- 11) Itens de ordem e disponibilidade em estoque (subselect para estoque do armazém)
-- Finalidade: Conferir se a ordem pode ser atendida
SELECT io.item_ordem_id, io.ordem_id, e.nome AS especie, io.quantidade_solicitada,
 (SELECT SUM(l2.quantidade) FROM lotes l2 WHERE l2.especie_id = io.especie_id) AS estoque_total_especie
FROM itens_ordem io
JOIN especies e ON e.especie_id = io.especie_id;

-- 12) Quantidade total movimentada por tipo (entrada/saida/transferencia)
-- Finalidade: Indicador operacional
SELECT tipo, SUM(quantidade) AS total_qtd
FROM movimentacoes
GROUP BY tipo;

-- 13) Últimos 10 logs de transparência
-- Finalidade: Auditoria e verificação
SELECT * FROM logs_transparencia ORDER BY data_hora DESC LIMIT 10;

-- 14) Ordens e quantidades totais solicitadas (join com itens)
-- Finalidade: Resumo pedido x entrega
SELECT o.ordem_id, m.nome AS municipio, o.data_prevista, SUM(io.quantidade_solicitada) AS total_solicitado
FROM ordens_expedicao o
JOIN itens_ordem io ON io.ordem_id = o.ordem_id
JOIN municipios m ON m.municipio_id = o.municipio_id
GROUP BY o.ordem_id;

-- 15) Agricultores que nunca receberam entregas (left join)
-- Finalidade: Identificar agricultores inativos/sem entrega
SELECT agr.agricultor_id, agr.nome
FROM agricultores agr
LEFT JOIN entregas ent ON ent.agricultor_id = agr.agricultor_id
WHERE ent.entrega_id IS NULL;

-- 16) Lotes com fornecedor e tempo desde recebimento (subselect para primeira movimentação de entrada)
-- Finalidade: Medir tempo em estoque
SELECT l.lote_id, l.numero_lote, f.nome AS fornecedor,
 TIMESTAMPDIFF(DAY, (SELECT MIN(mv.data_movimentacao) FROM movimentacoes mv WHERE mv.lote_id = l.lote_id), NOW()) AS dias_no_estoque
FROM lotes l
LEFT JOIN fornecedores f ON f.fornecedor_id = l.fornecedor_id;

-- 17) Entregas por mês (agrupado)
-- Finalidade: Análise temporal de distribuição
SELECT DATE_FORMAT(data_entrega,'%Y-%m') AS mes, COUNT(*) AS qtd_entregas, SUM(quantidade) AS total_quantidade
FROM entregas
GROUP BY mes
ORDER BY mes DESC;

-- 18) Fornecedores com quantidade total fornecida (soma dos lotes)
-- Finalidade: Ranking de fornecedores
SELECT f.fornecedor_id, f.nome, SUM(l.quantidade) AS total_fornecido
FROM fornecedores f
JOIN lotes l ON l.fornecedor_id = f.fornecedor_id
GROUP BY f.fornecedor_id
ORDER BY total_fornecido DESC;

-- 19) Usuários que aceitaram a política de privacidade (join com aceite_politica)
-- Finalidade: Compliance (quem aceitou)
SELECT u.usuario_id, u.nome, ap.data_aceite, ap.ip_address
FROM usuarios u
JOIN aceite_politica ap ON ap.entidade_tipo = 'usuario' AND ap.entidade_id = u.usuario_id
JOIN politica_privacidade pp ON pp.politica_id = ap.politica_id;

-- 20) Entregas detalhadas com ordem, armazém de origem (via lote) e agricultor
-- Finalidade: Rastreio final do fluxo de saída
SELECT ent.entrega_id, ent.data_entrega, ent.quantidade, ord.status AS status_ordem,
 arm.nome AS armazem_origem, agr.nome AS agricultor, l.numero_lote
FROM entregas ent
JOIN ordens_expedicao ord ON ord.ordem_id = ent.ordem_id
JOIN lotes l ON l.lote_id = ent.lote_id
JOIN armazens arm ON arm.armazem_id = l.armazem_id
JOIN agricultores agr ON agr.agricultor_id = ent.agricultor_id;