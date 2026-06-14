/* Criação do Trigger*/
DELIMITER //
CREATE TRIGGER trg_calcula_situacao 
BEFORE UPDATE ON tb_matricula
FOR EACH ROW
BEGIN
	IF NEW.frequencia < 75 THEN
		SET NEW.situacao = 'Reprovado pro Falta';
    END IF;
    IF NEW.frequencia >= 75 AND NEW.nota < 6 THEN
		SET NEW.situacao = 'Reprovado por Nota';
    END IF;
	IF NEW.frequencia >= 75 AND New.nota >= 6 THEN
		SET NEW.situacao = 'Aprovado';
	END IF;
END // 

DELIMITER ;

DROP TRIGGER  trg_calcula_situacao ;

/* Aprovado */
UPDATE tb_matricula
SET nota = 6.0, frequencia = 90.00
WHERE fk_aluno = 1 AND fk_turma = 1;

SELECT * FROM tb_matricula;

/* Reprovado por falta */
UPDATE tb_matricula
SET nota = 8.5, frequencia = 50.00
WHERE fk_aluno = 2 AND fk_turma = 1;

SELECT * FROM tb_matricula;

/* Reprovado por Nota */
UPDATE tb_matricula
SET nota = 5.0, frequencia = 80.00
WHERE fk_aluno = 3 AND fk_turma = 1;

SELECT * FROM tb_matricula;
    
