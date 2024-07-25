CREATE TABLE EMPRESA (
    ID_EMPRESA SERIAL PRIMARY KEY,
    RAZAO_SOCIAL VARCHAR(255) NOT NULL,
    INATIVO BOOLEAN DEFAULT FALSE
);
CREATE TABLE PRODUTOS (
    ID_PRODUTO SERIAL PRIMARY KEY,
    DESCRICAO VARCHAR(255) NOT NULL,
    INATIVO BOOLEAN DEFAULT FALSE
);

CREATE TABLE VENDEDORES (
    ID_VENDEDOR SERIAL PRIMARY KEY,
    NOME VARCHAR(255) NOT NULL,
    CARGO VARCHAR(255),
    SALARIO DECIMAL(10, 2),
    DATA_ADMISSAO DATE,
    INATIVO BOOLEAN DEFAULT FALSE
);

CREATE TABLE CONFIG_PRECO_PRODUTO (
    ID_CONFIG_PRECO_PRODUTO SERIAL PRIMARY KEY,
    ID_VENDEDOR INT REFERENCES VENDEDORES(ID_VENDEDOR),
    ID_EMPRESA INT REFERENCES EMPRESA(ID_EMPRESA),
    ID_PRODUTO INT REFERENCES PRODUTOS(ID_PRODUTO),
    PRECO_MINIMO DECIMAL(10, 2) NOT NULL,
    PRECO_MAXIMO DECIMAL(10, 2) NOT NULL
);

CREATE TABLE CLIENTES (
    ID_CLIENTE SERIAL PRIMARY KEY,
    RAZAO_SOCIAL VARCHAR(255) NOT NULL,
    DATA_CADASTRO DATE NOT NULL,
    ID_VENDEDOR INT REFERENCES VENDEDORES(ID_VENDEDOR),
    ID_EMPRESA INT REFERENCES EMPRESA(ID_EMPRESA),
    INATIVO BOOLEAN DEFAULT FALSE
);

CREATE TABLE PEDIDO (
    ID_PEDIDO SERIAL PRIMARY KEY,
    ID_EMPRESA INT REFERENCES EMPRESA(ID_EMPRESA),
    ID_CLIENTE INT REFERENCES CLIENTES(ID_CLIENTE),
    VALOR_TOTAL DECIMAL(10, 2) NOT NULL,
    DATA_EMISSAO DATE NOT NULL,
    DATA_FATURAMENTO DATE,
    DATA_CANCELAMENTO DATE
);

CREATE TABLE ITENS_PEDIDO (
    ID_ITEM_PEDIDO SERIAL PRIMARY KEY,
    ID_PEDIDO INT REFERENCES PEDIDO(ID_PEDIDO),
    ID_PRODUTO INT REFERENCES PRODUTOS(ID_PRODUTO),
    PRECO_PRATICADO DECIMAL(10, 2) NOT NULL,
    QUANTIDADE INT NOT NULL
);

INSERT INTO EMPRESA (razao_social, inativo) VALUES
('Empresa A', FALSE),
('Empresa B', FALSE),
('Empresa C', TRUE),
('Empresa D', FALSE),
('Empresa E', TRUE);

-- Inserindo registros na tabela PRODUTOS
INSERT INTO PRODUTOS (id_produto, descricao, inativo) VALUES
(1, 'Produto 1', FALSE),
(2, 'Produto 2', FALSE),
(3, 'Produto 3', TRUE),
(4, 'Produto 4', FALSE),
(5, 'Produto 5', TRUE);

INSERT INTO VENDEDORES (id_vendedor, nome, cargo, salario, data_admissao, inativo) VALUES
(1, 'Vendedor Z', 'Cargo A', 3000.00, '2023-01-10', FALSE),
(2, 'Vendedor B', 'Cargo B', 4000.00, '2023-02-15', FALSE),
(3, 'Vendedor C', 'Cargo C', 3500.00, '2023-03-20', TRUE),
(4, 'Vendedor D', 'Cargo D', 3800.00, '2023-04-25', FALSE),
(5, 'Vendedor E', 'Cargo E', 4200.00, '2023-05-30', TRUE);

INSERT INTO CONFIG_PRECO_PRODUTO (id_vendedor, id_empresa, id_produto, preco_minimo, preco_maximo) VALUES
(1, 1, 1, 10.00, 20.00),
(2, 2, 2, 15.00, 25.00),
(3, 3, 3, 12.00, 22.00),
(4, 4, 4, 18.00, 28.00),
(5, 5, 5, 20.00, 30.00);

INSERT INTO CLIENTES (id_cliente, razao_social, data_cadastro, id_vendedor, id_empresa, inativo) VALUES
(1, 'Cliente A', '2023-06-01', 1, 1, FALSE),
(2, 'Cliente B', '2023-06-05', 2, 2, FALSE),
(3, 'Cliente C', '2023-06-10', 3, 3, TRUE),
(4, 'Cliente D', '2023-06-15', 4, 4, FALSE),
(5, 'Cliente E', '2023-06-20', 5, 5, TRUE);

INSERT INTO PEDIDO (id_pedido, id_empresa, id_cliente, valor_total, data_emissao, data_faturamento, data_cancelamento) VALUES
(1, 1, 1, 120.00, '2023-07-06', null, null),
(2, 1, 1, 130.00, '2023-07-07', null, null),
(3, 2, 2, 170.00, '2023-07-08', '2023-07-09', null),
(4, 2, 2, 180.00, '2023-07-09', '2023-07-10', '2023-07-11'),
(5, 3, 3, 210.00, '2023-07-10', null, null),
(6, 3, 3, 220.00, '2023-07-11', '2023-07-11', null),
(7, 4, 4, 260.00, '2023-07-12', '2023-07-12', '2023-07-13'),
(8, 4, 4, 270.00, '2023-07-13', '2023-07-14', null);

INSERT INTO ITENS_PEDIDO (id_pedido, id_produto, preco_praticado, quantidade) VALUES
(1, 1, 10.00, 5),
(1, 2, 15.00, 2),
(2, 2, 15.00, 6),
(2, 3, 20.00, 3),
(3, 1, 20.00, 7),
(3, 2, 25.00, 4),
(3, 3, 27.00, 4),
(4, 4, 25.00, 8),
(4, 5, 30.00, 5);


1--
select id_vendedor as id, nome, salario
from vendedores 
where inativo = false
order by salario asc;



2--
Select id_vendedor as id, nome, salario 
from vendedores 
where salario > (Select sum(salario) / count(id_vendedor) as media_salarial from vendedores);



3--
Select c.id_cliente as id, c.razao_social, SUM(p.valor_total) as total
from clientes c, pedido p
where c.id_cliente = p.id_cliente
group by c.id_cliente, c.razao_social
order by SUM(p.valor_total) desc;


4--
select id_pedido as Id, valor_total as Valor, data_cancelamento as dados, 'cancelado' as situacao
from pedido
where data_cancelamento is not null
union
select id_pedido as Id, valor_total as Valor, data_faturamento as dados, 'faturado' as situacao
from pedido
where data_faturamento is not null
and data_cancelamento is null;
union
select id_pedido as Id, valor_total as Valor, data_emissao as dados, 'pendente' as situacao
from pedido
where data_emissao is not null
and data_cancelamento is null
and data_faturamento is null;
