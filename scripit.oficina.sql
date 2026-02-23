DROP DATABASE IF EXISTS oficina;
CREATE DATABASE oficina;
USE oficina;

CREATE TABLE IF NOT EXISTS cliente (
id_Cliente INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(100),
telefone VARCHAR(20),
endereco VARCHAR(150)
);

CREATE TABLE veiculo (
id_Veiculo INT AUTO_INCREMENT PRIMARY KEY,
placa VARCHAR(10),
modelo VARCHAR(50),
marca VARCHAR(50),
ano INT,
id_Cliente INT,
FOREIGN KEY (id_Cliente) REFERENCES cliente(id_Cliente)
);

CREATE TABLE equipe (
id_Equipe INT AUTO_INCREMENT PRIMARY KEY,
nome_equipe VARCHAR(50)
);

CREATE TABLE mecanico (
id_Mecanico INT AUTO_INCREMENT PRIMARY KEY,
codigo VARCHAR(20),
nome VARCHAR(100),
endereco VARCHAR(150),
especialidade VARCHAR(50),
id_Equipe INT,
FOREIGN KEY (id_Equipe) REFERENCES equipe(id_Equipe)
);

CREATE TABLE ordem_servico (
id_os INT AUTO_INCREMENT PRIMARY KEY,
numero_os VARCHAR(20),
data_emissao DATE,
data_conclusao DATE,
status VARCHAR(30),
valor_total DECIMAL (10,2),
id_Veiculo INT,
id_Equipe INT,
FOREIGN KEY (id_Veiculo) REFERENCES veiculo(id_Veiculo),
FOREIGN KEY (id_Equipe) REFERENCES equipe(id_Equipe)
);

CREATE TABLE servico (
id_Servico INT AUTO_INCREMENT PRIMARY KEY,
descricao VARCHAR(100),
valor_mao_obra DECIMAL (10,2)
);

CREATE TABLE os_servico (
id_os INT,
id_servico INT,
quantidade INT,
valor_servico DECIMAL (10,2),
PRIMARY KEY (id_os, id_Servico),
FOREIGN KEY (id_os) REFERENCES ordem_servico(id_os),
FOREIGN KEY (id_Servico) REFERENCES servico(id_Servico)
);

CREATE TABLE peca (
id_peca INT AUTO_INCREMENT PRIMARY KEY,
descricao VARCHAR(100),
valor_unitario DECIMAL (10,2)
);

CREATE TABLE os_peca (
id_os INT,
id_peca INT,
quantidade INT,
valor_peca DECIMAL (10,2),
PRIMARY KEY (id_os, id_peca),
FOREIGN KEY (id_os) REFERENCES ordem_servico(id_os),
FOREIGN KEY (id_peca) REFERENCES peca(id_peca)
);

-- Inserts Testes
INSERT INTO equipe (nome_equipe)
Values ('Equipe Alfa');

INSERT INTO cliente (nome, telefone, endereco) VALUES
('Carlos Silva' , '11999999999' , 'Rua A') ,
('Ana Souza' , '21988888888' , 'Rua B') ;

INSERT INTO veiculo (placa, modelo, ano , id_Cliente) VALUES
('ABC1234' , 'Amarok' , 2018 , 1) ,
('AXY' , 'Camaro' , 2020 , 2) ;

INSERT INTO mecanico (nome, especialidade) VALUES
('Ruan Alvez' , 'Motor') ,
('Pedro Martins' , 'Suspensao') ;

INSERT INTO servico (descricao, valor_mao_obra) VALUES
('Troca de óleo' , 150.00) ,
('Amortecedor' , 400.00) ;

INSERT INTO peca (descricao, valor_unitario) VALUES
('Filtro de óleo' , 35.00) ,
('Amortecedor' , 450.00) ;

INSERT INTO ordem_servico (
numero_os,
data_emissao,
data_conclusao,
status,
valor_total,
id_Veiculo,
id_Equipe
)
VALUES (
'OS001',
'2024-09-01',
'2024-09-02',
'Finalizada',
585.000,
1,
1
),
(
'OS002',
'2024-09-05',
'2024-09-06',
NULL,
'Em andamento',
300.00,
2,
1
);
select * from equipe;
INSERT INTO ordem_servico VALUES
(1, 1, 1) ,
(2, 2, 2) ;

INSERT INTO ordem_servico_peca VALUES
(1, 1, 1) ,
(2, 2, 2) ;

-- Queries
-- Quais clientes cadastrados?
SELECT * FROM cliente;

-- Quais ordens estão finalizadas?
SELECT numero_os, status
FROM ordem_servico
WHERE status = 'Finalizada';

-- Valor total de pecas por ordem
SELECT
   id_os,
   SUM(quantidade * valor_peca) AS total_pecas
   FROM os_peca
   GROUP BY is_os;
   
-- Serviços ordenados mais caro para mais barato
SELECT descricao, valor_mao_obra
FROM servico
ORDER BY valor_mao_obra DESC;

-- Ordens com gasto de peça acima de R$300
SELECT
   id_os,
   SUM(quantidade * valor_peca) AS total_pecas
From os_peca
GROUP BY id_os
HAVING total_pecas > 300;

-- Cliente, veículo, equipe e status da OS
SELECT
    c.name AS cliente,
    v.modelo AS veiculo,
    e.nome_equipe,
    os.status
FROM ordem_servico os
JOIN veiculo v ON os.id_veiculo = v.id_Veiculo
JOIN cliente c ON v.id_cliente = c.id_Cliente
JOIN equipe e ON os.id_equipe = e.id_Equipe;    
