-- -----------------------------------------------------------------
-- 3) DML: Inserções (20+ registros por tabela onde aplicável)
-- -----------------------------------------------------------------
-- Observação: os valores foram gerados com padrões para garantir 20 registros por entidade

-- 3.1 especies (20)
INSERT INTO especies (nome) VALUES
('Milho BRS 1055'), ('Soja V-Max'), ('Trigo Prime 01'), ('Arroz Branco A1'), ('Feijão Carioca F1'),
('Milho Híbrido 202'), ('Soja S-Alpha'), ('Café Robusta R1'), ('Café Arábica A2'), ('Sorgo S-10'),
('Aveia Oats'), ('Cevada Barley'), ('Girassol G1'), ('Canola C2'), ('Ervilha P1'),
('Lentilha L1'), ('Batata BRed'), ('Cebola Onion1'), ('Alface Verde'), ('Tomate R2');

-- 3.2 fornecedores (20)
INSERT INTO fornecedores (nome, contato) VALUES
('Agro Sementes S.A.', 'contato@agrosementes.com'),
('Sementes do Sul Ltda', 'vendas@sementessul.com'),
('Distribuidora Norte', 'contato@distnorte.com'),
('ForneceAlta', 'comercial@fornecealta.com'),
('AgroMix Ltda', 'suporte@agromix.com'),
('SeedCorp', 'info@seedcorp.com'),
('Sementes Gerais', 'contato@sementesgerais.com'),
('AgroDistrib', 'vendas@agrodistrib.com'),
('FazendaPro', 'comercial@fazendapro.com'),
('Campo S.A.', 'contato@campo.com'),
('GrainHouse', 'info@grainhouse.com'),
('Sementes Premium', 'premium@sementes.com'),
('AgroPlus', 'hello@agroplus.com'),
('AlphaSeeds', 'alpha@seeds.com'),
('BetaAgro', 'beta@agro.com'),
('DeltaSementes', 'delta@sementes.com'),
('EpsilonAgri', 'epsi@agri.com'),
('ZetaFornece', 'zeta@fornece.com'),
('OmegaSeeds', 'omega@seeds.com'),
('NovaAgro', 'nova@agro.com');

-- 3.3 armazens (6)
INSERT INTO armazens (nome, endereco) VALUES
('Armazém Central', 'Rua Principal, 123'),
('Armazém Filial Sul', 'Av. das Nações, 456'),
('Armazém Norte', 'Rua do Norte, 10'),
('Armazém Leste', 'Av. Leste, 200'),
('Armazém Oeste', 'R. Oeste, 88'),
('Armazém Expresso', 'R. Expresso, 77');

-- 3.4 municipios (20)
INSERT INTO municipios (nome, estado) VALUES
('São Paulo', 'SP'), ('Recife', 'PE'), ('Porto Alegre', 'RS'),
('Belo Horizonte', 'MG'), ('Salvador', 'BA'), ('Brasília', 'DF'),
('Curitiba', 'PR'), ('Fortaleza', 'CE'), ('Manaus', 'AM'), ('Goiânia', 'GO'),
('Belém', 'PA'), ('Campinas', 'SP'), ('Niterói', 'RJ'), ('Juiz de Fora', 'MG'),
('Florianópolis', 'SC'), ('Cuiabá', 'MT'), ('Maceió', 'AL'), ('Teresina', 'PI'),
('Vitoria', 'ES'), ('São Luís', 'MA');

-- 3.5 agricultores (20) — assign municipios 1..20
INSERT INTO agricultores (nome, municipio_id, contato) VALUES
('José da Silva', 1, '11-98888-7777'), ('Maria Oliveira', 2, '81-99999-5555'), ('Carlos Pereira', 3, '51-97777-2222'),
('Ana Souza',4,'31-96666-1111'),('Paulo Lima',5,'71-95555-0000'),('Ricardo Rocha',6,'61-94444-3333'),
('Helena Castro',7,'41-93333-2222'),('Marcos Alves',8,'85-92222-1111'),('Laura Ferreira',9,'92-91111-0000'),
('Pedro Gomes',10,'62-90000-9999'),('Rita Dias',11,'91-88888-7777'),('Sandra Melo',12,'19-87777-6666'),
('Ronaldo Silva',13,'21-86666-5555'),('Patricia Azevedo',14,'32-85555-4444'),('Felipe Santos',15,'48-84444-3333'),
('Camila Ribeiro',16,'65-83333-2222'),('Otavio Pinto',17,'82-82222-1111'),('Bruna Nunes',18,'86-81111-0000'),
('Diego Martins',19,'27-80000-0000'),('Vanessa Rocha',20,'98-79999-1111');

-- 3.6 cargos (6)
INSERT INTO cargos (nome, descricao) VALUES
('Administrador', 'Acesso total'),
('Gerente de Estoque', 'Gerencia armazéns e lotes'),
('Operador de Armazém', 'Processa recebimento e expedição'),
('Analista de Rastreabilidade', 'Gestão de eventos e logs'),
('Motorista', 'Transporte de entregas'),
('Fornecedor', 'Conta de fornecedor - consulta');

-- 3.7 usuarios (20) -> assign cargos 1..6 and armazens 1..6
INSERT INTO usuarios (nome, email, senha_hash, cargo_id, armazem_id) VALUES
('Admin do Sistema','admin@ex.com','hash_admin',1,1),
('Gerente Central','gerente.centro@ex.com','hash_gerente',2,1),
('Operador1','operador1@ex.com','hash_op1',3,1),
('Operador2','operador2@ex.com','hash_op2',3,2),
('Analista1','analista1@ex.com','hash_an1',4,1),
('Motorista1','motorista1@ex.com','hash_mt1',5,1),
('Motorista2','motorista2@ex.com','hash_mt2',5,2),
('Fornecedor1','fornec1@ex.com','hash_for1',6,NULL),
('Usuário A','usera@ex.com','hash_u1',3,3),
('Usuário B','userb@ex.com','hash_u2',3,4),
('Usuário C','userc@ex.com','hash_u3',2,5),
('Usuário D','userd@ex.com','hash_u4',4,6),
('Usuário E','usere@ex.com','hash_u5',3,2),
('Usuário F','userf@ex.com','hash_u6',3,3),
('Usuário G','userg@ex.com','hash_u7',2,4),
('Usuário H','userh@ex.com','hash_u8',4,5),
('Usuário I','useri@ex.com','hash_u9',3,6),
('Usuário J','userj@ex.com','hash_u10',3,1),
('Usuário K','userk@ex.com','hash_u11',2,2),
('Usuário L','userl@ex.com','hash_u12',4,3);

-- 3.8 politica_privacidade (1 or 2)
INSERT INTO politica_privacidade (texto, data_publicacao) VALUES
('Política de Privacidade - Projeto de Rastreabilidade. Uso de dados mediante aceite.', '2025-01-01'),
('Atualização da Política - tratamento de logs e consentimento.', '2025-06-01');

-- 3.9 lote: 20 registros - vincular especies (1..20), armazens (1..6), fornecedores (1..20)
INSERT INTO lotes (numero_lote, especie_id, validade, quantidade, armazem_id, fornecedor_id) VALUES
('LOTE-0001',1,'2026-10-31',1000,1,1),
('LOTE-0002',2,'2025-12-20',5000,2,2),
('LOTE-0003',3,'2025-08-15',1500,3,3),
('LOTE-0004',4,'2025-09-01',2000,4,4),
('LOTE-0005',5,'2026-02-28',1200,5,5),
('LOTE-0006',6,'2026-05-10',800,6,6),
('LOTE-0007',7,'2025-11-11',600,1,7),
('LOTE-0008',8,'2026-03-03',1400,2,8),
('LOTE-0009',9,'2025-07-22',900,3,9),
('LOTE-0010',10,'2025-12-30',1100,4,10),
('LOTE-0011',11,'2026-01-15',1300,5,11),
('LOTE-0012',12,'2025-08-19',700,6,12),
('LOTE-0013',13,'2025-10-05',1600,1,13),
('LOTE-0014',14,'2026-04-01',450,2,14),
('LOTE-0015',15,'2025-09-30',2200,3,15),
('LOTE-0016',16,'2026-07-07',300,4,16),
('LOTE-0017',17,'2025-11-21',950,5,17),
('LOTE-0018',18,'2025-12-10',2100,6,18),
('LOTE-0019',19,'2026-06-06',1700,1,19),
('LOTE-0020',20,'2026-09-09',1900,2,20);

-- 3.10 ordens_expedicao (20)
INSERT INTO ordens_expedicao (municipio_id, data_prevista, status) VALUES
(1,'2025-10-25','Em processamento'),
(2,'2025-11-10','Aguardando expedição'),
(3,'2025-11-15','Em processamento'),
(4,'2025-12-01','Aguardando expedição'),
(5,'2025-12-05','Aguardando expedição'),
(6,'2025-12-10','Em processamento'),
(7,'2025-12-12','Em processamento'),
(8,'2025-12-15','Aguardando expedição'),
(9,'2025-12-20','Aguardando expedição'),
(10,'2026-01-05','Em processamento'),
(11,'2026-01-10','Aguardando expedição'),
(12,'2026-01-20','Em processamento'),
(13,'2026-02-01','Aguardando expedição'),
(14,'2026-02-10','Em processamento'),
(15,'2026-02-20','Aguardando expedição'),
(16,'2026-03-01','Em processamento'),
(17,'2026-03-10','Aguardando expedição'),
(18,'2026-03-20','Em processamento'),
(19,'2026-04-01','Aguardando expedição'),
(20,'2026-04-10','Em processamento');

-- 3.11 entregas (20) - relacionando ordens 1..20, lotes 1..20, agricultores 1..20
INSERT INTO entregas (ordem_id, lote_id, quantidade, agricultor_id, data_entrega, comprovante) VALUES
(1,1,100,1,'2025-10-21 10:30:00','recibo_001.pdf'),
(2,2,500,2,'2025-10-21 10:30:00','recibo_002.pdf'),
(3,3,200,3,'2025-10-22 09:15:00','recibo_003.pdf'),
(4,4,150,4,'2025-10-23 11:00:00','recibo_004.pdf'),
(5,5,300,5,'2025-10-24 08:30:00','recibo_005.pdf'),
(6,6,120,6,'2025-10-25 14:00:00','recibo_006.pdf'),
(7,7,80,7,'2025-10-26 09:45:00','recibo_007.pdf'),
(8,8,400,8,'2025-10-27 13:20:00','recibo_008.pdf'),
(9,9,90,9,'2025-10-28 16:10:00','recibo_009.pdf'),
(10,10,110,10,'2025-10-29 12:00:00','recibo_010.pdf'),
(11,11,130,11,'2025-11-01 09:00:00','recibo_011.pdf'),
(12,12,70,12,'2025-11-02 10:10:00','recibo_012.pdf'),
(13,13,160,13,'2025-11-03 11:11:00','recibo_013.pdf'),
(14,14,45,14,'2025-11-04 15:00:00','recibo_014.pdf'),
(15,15,220,15,'2025-11-05 08:40:00','recibo_015.pdf'),
(16,16,30,16,'2025-11-06 07:30:00','recibo_016.pdf'),
(17,17,95,17,'2025-11-07 14:50:00','recibo_017.pdf'),
(18,18,210,18,'2025-11-08 10:00:00','recibo_018.pdf'),
(19,19,170,19,'2025-11-09 09:25:00','recibo_019.pdf'),
(20,20,190,20,'2025-11-10 11:11:00','recibo_020.pdf');

-- 3.12 movimentacoes (20)
INSERT INTO movimentacoes (lote_id, tipo, quantidade, armazem_origem_id, armazem_destino_id, data_movimentacao) VALUES
(1,'entrada',1000,NULL,1,'2025-01-01 08:00:00'),
(1,'saida',100,1,NULL,'2025-10-21 10:30:00'),
(2,'entrada',5000,NULL,2,'2025-02-02 09:00:00'),
(2,'saida',500,2,NULL,'2025-10-21 10:30:00'),
(3,'entrada',1500,NULL,3,'2025-03-03 10:00:00'),
(4,'entrada',2000,NULL,4,'2025-04-04 11:00:00'),
(5,'entrada',1200,NULL,5,'2025-05-05 12:00:00'),
(6,'entrada',800,NULL,6,'2025-06-06 13:00:00'),
(7,'entrada',600,NULL,1,'2025-07-07 14:00:00'),
(8,'entrada',1400,NULL,2,'2025-08-08 15:00:00'),
(9,'transferencia',200,3,4,'2025-09-09 16:00:00'),
(10,'saida',110,4,NULL,'2025-10-10 17:00:00'),
(11,'saida',130,5,NULL,'2025-10-11 10:30:00'),
(12,'saida',70,6,NULL,'2025-10-12 09:00:00'),
(13,'transferencia',300,1,5,'2025-10-13 08:30:00'),
(14,'entrada',450,NULL,2,'2025-10-14 11:10:00'),
(15,'saida',220,3,NULL,'2025-10-15 14:20:00'),
(16,'entrada',300,NULL,4,'2025-10-16 12:00:00'),
(17,'saida',95,5,NULL,'2025-10-17 13:30:00'),
(18,'transferencia',500,6,1,'2025-10-18 15:40:00');

-- 3.13 rastreabilidade (20)
INSERT INTO rastreabilidade (lote_id, descricao, data_evento, localizacao) VALUES
(1,'Recebido no armazém', '2025-01-01 08:05:00','Armazém Central'),
(1,'Inspeção de qualidade OK','2025-01-02 09:00:00','Laboratório Central'),
(1,'Empacotamento para envio','2025-10-21 09:30:00','Armazém Central'),
(2,'Recebido no armazém','2025-02-02 09:10:00','Armazém Filial Sul'),
(2,'Liberado para expedição','2025-10-21 09:40:00','Armazém Filial Sul'),
(3,'Teste de germinação OK','2025-03-10 10:10:00','Laboratório Norte'),
(4,'Etiqueta anexada','2025-04-05 11:20:00','Armazém Leste'),
(5,'Entrada no estoque','2025-05-06 12:30:00','Armazém Oeste'),
(6,'Transferência entre armazéns','2025-07-07 14:05:00','Armazém Expresso'),
(7,'Requisição de retirada','2025-08-01 09:50:00','Armazém Central'),
(8,'Registros atualizados','2025-08-02 16:00:00','Armazém Filial Sul'),
(9,'Inspeção fitossanitária','2025-09-03 08:00:00','Porto de Embarque'),
(10,'Expedição agendada','2025-10-10 07:30:00','Armazém Leste'),
(11,'Conferência final','2025-11-01 08:55:00','Armazém Oeste'),
(12,'Saída para transporte','2025-11-02 09:05:00','Armazém Expresso'),
(13,'Retorno ao estoque','2025-11-03 10:10:00','Armazém Central'),
(14,'Etiqueta trocada','2025-11-04 11:11:00','Armazém Filial Sul'),
(15,'Teste de umidade OK','2025-11-05 12:12:00','Laboratório'),
(16,'Recolhimento parcial','2025-11-06 13:13:00','Armazém Leste'),
(17,'Notificação de qualidade','2025-11-07 14:14:00','Armazém Oeste'),
(18,'Conferência de cargas','2025-11-08 15:15:00','Porto de Embarque');

-- 3.14 logs_transparencia (20)
INSERT INTO logs_transparencia (acao, data_hora, detalhe) VALUES
('Criação do sistema','2025-01-01 00:00:00','Inicialização do banco de dados'),
('Inserção lote 1','2025-01-01 08:00:00','Lote LOTE-0001 inserido'),
('Inserção lote 2','2025-02-02 09:00:00','Lote LOTE-0002 inserido'),
('Criação ordem 1','2025-10-01 10:00:00','Ordem 1 criada'),
('Registro entrega 1','2025-10-21 10:30:00','Entrega 1 registrada'),
('Movimentação lote3','2025-03-03 10:00:00','Movimentação de LOTE-0003'),
('Atualização política','2025-06-01 00:00:00','Política atualizada'),
('Login administrador','2025-07-01 08:00:00','Usuário admin logado'),
('Erro importacao','2025-07-02 09:30:00','Erro no arquivo X'),
('Relatorio gerado','2025-08-03 10:00:00','Relatório mensal'),
('Backup realizado','2025-09-04 03:00:00','Backup diário'),
('Teste trigger entrega','2025-10-21 10:35:00','Trigger executada'),
('Criação view relat','2025-10-22 11:00:00','View vw_entregas criada'),
('Usuário criado','2025-10-23 12:00:00','Criado operador1'),
('Movimentacao transferencia','2025-10-24 13:00:00','Transferência entre armazéns'),
('Conserto registro','2025-10-25 14:00:00','Atualização manual'),
('Envio notificação','2025-10-26 15:00:00','Notificação enviada'),
('Validação lote','2025-10-27 16:00:00','Validação de qualidade'),
('Relatorio estoque','2025-10-28 17:00:00','Relatório de estoque gerado'),
('Aceite politica','2025-10-29 18:00:00','Usuário X aceitou política');

-- 3.15 itens_ordem (20) - ligar cada ordem a uma especie e quantidade solicitada
INSERT INTO itens_ordem (ordem_id, especie_id, quantidade_solicitada) VALUES
(1,1,100),(2,2,500),(3,3,200),(4,4,150),(5,5,300),
(6,6,120),(7,7,80),(8,8,400),(9,9,90),(10,10,110),
(11,11,130),(12,12,70),(13,13,160),(14,14,45),(15,15,220),
(16,16,30),(17,17,95),(18,18,210),(19,19,170),(20,20,190);

-- 3.16 aceite_politica (20) - alternando entidade usuario/agricultor
INSERT INTO aceite_politica (politica_id, data_aceite, entidade_tipo, entidade_id, ip_address) VALUES
(1,'2025-01-02 09:00:00','usuario',1,'200.100.1.1'),
(1,'2025-01-03 09:10:00','agricultor',1,'200.100.1.2'),
(1,'2025-01-04 09:20:00','usuario',2,'200.100.1.3'),
(2,'2025-06-02 12:00:00','usuario',3,'200.100.1.4'),
(1,'2025-01-06 10:00:00','agricultor',2,'200.100.1.5'),
(1,'2025-01-07 11:00:00','usuario',4,'200.100.1.6'),
(1,'2025-01-08 12:00:00','agricultor',3,'200.100.1.7'),
(2,'2025-06-03 13:00:00','usuario',5,'200.100.2.1'),
(1,'2025-01-09 14:00:00','agricultor',4,'200.100.2.2'),
(1,'2025-01-10 15:00:00','usuario',6,'200.100.2.3'),
(1,'2025-01-11 16:00:00','agricultor',5,'200.100.2.4'),
(1,'2025-01-12 17:00:00','usuario',7,'200.100.2.5'),
(2,'2025-06-04 18:00:00','agricultor',6,'200.100.2.6'),
(1,'2025-01-13 19:00:00','usuario',8,'200.100.3.1'),
(1,'2025-01-14 20:00:00','agricultor',7,'200.100.3.2'),
(1,'2025-01-15 21:00:00','usuario',9,'200.100.3.3'),
(2,'2025-06-05 22:00:00','agricultor',8,'200.100.3.4'),
(1,'2025-01-16 23:00:00','usuario',10,'200.100.3.5'),
(1,'2025-01-17 08:00:00','agricultor',9,'200.100.3.6'),
(1,'2025-01-18 09:00:00','usuario',11,'200.100.3.7');