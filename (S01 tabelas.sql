
DROP DATABASE IF EXISTS rastreabilidade_db;
CREATE DATABASE rastreabilidade_db CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
USE rastreabilidade_db;

-- -----------------------------------------------------------------
-- 2) DDL: tabelas (com base no script do usuário, mantive nomes)
-- -----------------------------------------------------------------
CREATE TABLE especies (
    especie_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE fornecedores (
    fornecedor_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    contato VARCHAR(100)
);

CREATE TABLE armazens (
    armazem_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    endereco VARCHAR(250)
);

CREATE TABLE municipios (
    municipio_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    estado VARCHAR(50)
);

CREATE TABLE agricultores (
    agricultor_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    municipio_id INT,
    contato VARCHAR(100),
    FOREIGN KEY(municipio_id) REFERENCES municipios(municipio_id)
);

CREATE TABLE lotes (
    lote_id INT PRIMARY KEY AUTO_INCREMENT,
    numero_lote VARCHAR(50) NOT NULL UNIQUE,
    especie_id INT NOT NULL,
    validade DATE,
    quantidade INT NOT NULL,
    armazem_id INT NOT NULL,
    fornecedor_id INT,
    FOREIGN KEY(especie_id) REFERENCES especies(especie_id),
    FOREIGN KEY(armazem_id) REFERENCES armazens(armazem_id),
    FOREIGN KEY(fornecedor_id) REFERENCES fornecedores(fornecedor_id)
);

CREATE TABLE movimentacoes (
    movimentacao_id INT PRIMARY KEY AUTO_INCREMENT,
    lote_id INT NOT NULL,
    tipo ENUM('entrada', 'saida', 'transferencia') NOT NULL,
    quantidade INT NOT NULL,
    armazem_origem_id INT,
    armazem_destino_id INT,
    data_movimentacao DATETIME NOT NULL,
    FOREIGN KEY(lote_id) REFERENCES lotes(lote_id),
    FOREIGN KEY(armazem_origem_id) REFERENCES armazens(armazem_id),
    FOREIGN KEY(armazem_destino_id) REFERENCES armazens(armazem_id)
);

CREATE TABLE ordens_expedicao (
    ordem_id INT PRIMARY KEY AUTO_INCREMENT,
    municipio_id INT NOT NULL,
    data_prevista DATE NOT NULL,
    status VARCHAR(50),
    FOREIGN KEY(municipio_id) REFERENCES municipios(municipio_id)
);

CREATE TABLE entregas (
    entrega_id INT PRIMARY KEY AUTO_INCREMENT,
    ordem_id INT NOT NULL,
    lote_id INT NOT NULL,
    quantidade INT NOT NULL,
    agricultor_id INT NOT NULL,
    data_entrega DATETIME NOT NULL,
    comprovante VARCHAR(250),
    FOREIGN KEY(ordem_id) REFERENCES ordens_expedicao(ordem_id),
    FOREIGN KEY(lote_id) REFERENCES lotes(lote_id),
    FOREIGN KEY(agricultor_id) REFERENCES agricultores(agricultor_id)
);

CREATE TABLE rastreabilidade (
    rastreio_id INT PRIMARY KEY AUTO_INCREMENT,
    lote_id INT NOT NULL,
    descricao TEXT,
    data_evento DATETIME NOT NULL,
    localizacao VARCHAR(150),
    FOREIGN KEY(lote_id) REFERENCES lotes(lote_id)
);

CREATE TABLE logs_transparencia (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    acao VARCHAR(150),
    data_hora DATETIME NOT NULL,
    detalhe TEXT
);

CREATE TABLE politica_privacidade (
    politica_id INT PRIMARY KEY AUTO_INCREMENT,
    texto TEXT NOT NULL,
    data_publicacao DATE NOT NULL
);

CREATE TABLE cargos (
    cargo_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL UNIQUE,
    descricao TEXT
);

CREATE TABLE usuarios (
    usuario_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha_hash VARCHAR(255) NOT NULL,
    cargo_id INT,
    armazem_id INT,
    ativo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY(cargo_id) REFERENCES cargos(cargo_id),
    FOREIGN KEY(armazem_id) REFERENCES armazens(armazem_id)
);

CREATE TABLE itens_ordem (
    item_ordem_id INT PRIMARY KEY AUTO_INCREMENT,
    ordem_id INT NOT NULL,
    especie_id INT NOT NULL,
    quantidade_solicitada INT NOT NULL,
    FOREIGN KEY(ordem_id) REFERENCES ordens_expedicao(ordem_id) ON DELETE CASCADE,
    FOREIGN KEY(especie_id) REFERENCES especies(especie_id)
);

CREATE TABLE aceite_politica (
    aceite_id INT PRIMARY KEY AUTO_INCREMENT,
    politica_id INT NOT NULL,
    data_aceite DATETIME NOT NULL,
    entidade_tipo ENUM('usuario', 'agricultor') NOT NULL,
    entidade_id INT NOT NULL,
    ip_address VARCHAR(45),
    FOREIGN KEY(politica_id) REFERENCES politica_privacidade(politica_id),
    INDEX idx_entidade (entidade_tipo, entidade_id)
);