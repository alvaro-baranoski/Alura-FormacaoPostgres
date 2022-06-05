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

-- Linguagem procedual (PL / plpgSQL)
CREATE OR REPLACE FUNCTION primeira_pl() RETURNS INTEGER AS $$
	DECLARE 
		primeira_variavel INTEGER DEFAULT 3;
	BEGIN
		primeira_variavel := primeira_variavel * 2;
		-- Vários comandos em SQL
		RETURN primeira_variavel;
	END;
$$ LANGUAGE plpgsql;

SELECT primeira_pl();

-- Estruturas de controle
CREATE OR REPLACE FUNCTION salario_ok(id_instrutor INTEGER) RETURNS VARCHAR AS $$
	DECLARE 
		instrutor instrutor;
	BEGIN
		SELECT * FROM instrutor WHERE id = id_instrutor INTO instrutor;
		
		/*
		IF instrutor.salario > 300 THEN
			RETURN 'Salário está ok';
		ELSEIF instrutor.salario = 300 THEN
			RETURN 'Salário pode aumentar';
		ELSE
			RETURN 'Salário está defasado';
		END IF;
		*/
		CASE instrutor.salario
			WHEN 100 THEN
				RETURN 'Salário muito baixo';
			WHEN 200 THEN
				RETURN 'Salário baixo';
			WHEN 300 THEN
				RETURN 'Salário ok';
			ELSE
				RETURN 'Salário ótimo';
			END CASE;
		END;
$$ LANGUAGE plpgsql;

SELECT nome, salario_ok(instrutor.id) FROM instrutor;

-- Estruturas de repetição
CREATE OR REPLACE FUNCTION tabuada(numero INTEGER) RETURNS SETOF INTEGER AS $$
	DECLARE
		multiplicador INTEGER DEFAULT 1;
	BEGIN
		-- Possível também fazer com WHILE multiplicador < 10 LOOP
		-- Ou LOOP ... EXIT WHEN multiplicador := 10
		FOR mult IN 1..9
		LOOP
			RETURN NEXT numero * mult;
		END LOOP;
	END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION instrutor_com_salario(OUT nome VARCHAR, OUT salario_ok VARCHAR) RETURNS SETOF record AS $$
	DECLARE instrutor instrutor;
	BEGIN
		FOR instrutor IN SELECT * FROM instrutor LOOP
			nome := instrutor.nome;
			salario_ok = salario_ok(instrutor.id);
			RETURN NEXT;
		END LOOP;
	END;
$$ LANGUAGE plpgsql;

SELECT * FROM instrutor_com_salario();

SELECT tabuada(9);
