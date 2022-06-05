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