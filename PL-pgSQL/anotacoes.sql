CREATE FUNCTION primeira_funcao() RETURNS INTEGER AS '
	SELECT (5 - 3) * 2
' LANGUAGE SQL;

SELECT primeira_funcao();

CREATE FUNCTION soma_dois_numeros(INTEGER, INTEGER) RETURNS INTEGER AS '
	SELECT $1 + $2
' LANGUAGE SQL;

SELECT soma_dois_numeros(3, 17);

CREATE TEMPORARY TABLE a_temp (nome VARCHAR(255) NOT NULL);

CREATE OR REPLACE FUNCTION cria_a(nome VARCHAR) RETURNS void AS $$
	INSERT INTO a_temp (nome) VALUES (cria_a.nome);
$$ LANGUAGE SQL;

SELECT cria_a('Guilherme Conde');
SELECT * FROM a_temp

-- Tipos e funções
CREATE TABLE instrutor (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL,
	salario DECIMAL(10, 2)
);

INSERT INTO instrutor (nome, salario) VALUES ('Vinícius Dias', 100);
INSERT INTO instrutor (nome, salario) VALUES ('Alexandre Assis', 200);
INSERT INTO instrutor (nome, salario) VALUES ('Roberto Augusto', 300);
INSERT INTO instrutor (nome, salario) VALUES ('Gabriel Limeira', 400);
INSERT INTO instrutor (nome, salario) VALUES ('Pedro Filho', 500);


CREATE FUNCTION dobro_do_salario(instrutor) RETURNS DECIMAL AS $$
	SELECT $1.salario * 2;
$$ LANGUAGE SQL;

SELECT nome, dobro_do_salario(instrutor.*) AS salario_desejado FROM instrutor;

CREATE OR REPLACE FUNCTION cria_instrutor() RETURNS instrutor AS $$
	SELECT 22, 'Rodrigo Ilho', 200::DECIMAL;
$$ LANGUAGE SQL;

SELECT * FROM cria_instrutor();

CREATE FUNCTION instrutores_bem_pagos(valor_salario DECIMAL) RETURNS SETOF instrutor AS $$
	SELECT * FROM instrutor WHERE salario > valor_salario;
$$ LANGUAGE SQL;

SELECT * FROM instrutores_bem_pagos(300);

CREATE TYPE soma_produto AS (soma INTEGER, produto INTEGER);

CREATE FUNCTION soma_e_produto (IN INTEGER, IN INTEGER) RETURNS soma_produto AS $$
	SELECT $1 + $2 AS soma, $1 * $2 AS produto;
$$ LANGUAGE SQL;

SELECT * FROM soma_e_produto(3, 3);