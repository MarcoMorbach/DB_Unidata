CREATE VIEW vw_historico_academico AS
SELECT 
	a.nome as Aluno, 
	c.nome as Curso, 
	d.nome as Disciplina, 
	CONCAT(t.semestre, '/', t.ano)  as Período, 
	p.nome as Professor, 
	m.nota as Nota, 
	m.frequencia as Frequência, 
	m.situacao as Situaçao
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

SELECT * FROM vw_historico_academico;
		 