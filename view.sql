/* Criaçao da View*/
CREATE VIEW vw_historico_academico AS
SELECT 
	a.nome AS Aluno, 
	c.nome AS Curso, 
	d.nome AS Disciplina, 
	CONCAT(t.semestre, '/', t.ano)  AS Período, 
	p.nome AS Professor, 
	m.nota as Nota, 
	m.frequencia AS Frequência, 
	m.situacao AS Situaçao
FROM tb_matricula m
	JOIN
	tb_aluno a ON a.id_aluno = m.fk_aluno
    JOIN
    tb_curso c ON c.id_curso = a.fk_curso
    JOIN
    tb_turma t ON t.id_turma = m.fk_turma
    JOIN
    tb_professor p ON p.id_prof = t.fk_proF
    JOIN
    tb_disciplina d ON d.id_disc = t.fk_disc
ORDER BY a.nome;

/* Teste da View*/
SELECT * FROM vw_historico_academico;

		 