
INSERT INTO Tb_curso (nome, ch_total, tipo) VALUES 
('Ciência da Computação', 3200, 'Graduacao'),
('Engenharia de Software', 3600, 'Graduacao'),
('Especialização em Inteligência Artificial', 360, 'Pos-Graduacao');



INSERT INTO Tb_disciplina (nome, ch, creditos, ementa) VALUES 
('Algoritmos e Programação', 80, 4, 'Introdução à lógica e estruturas básicas.'),
('Banco de Dados I', 80, 4, 'Modelagem conceitual, lógica e física. SQL.'),
('Banco de Dados II', 80, 4, 'Tratamento de transações, concorrência e NoSQL.'),
('Inteligência Artificial', 60, 3, 'Algoritmos de busca, redes neurais e aprendizado.'),
('Programação Orientada a Objetos', 80, 4, 'Classes, objetos, herança e polimorfismo.'),
('Estrutura de Dados', 80, 4, 'Listas, pilhas, filas e árvores.'),
('Redes de Computadores', 60, 3, 'Arquitetura de redes, protocolos e camadas.'),
('Sistemas Operacionais', 80, 4, 'Gerenciamento de processos, memória e arquivos.');



INSERT INTO Tb_pre_requisito (fk_disc, id_pre_req) VALUES 
(3, 2), -- BD II (id 3) depende de BD I (id 2)
(4, 1), -- IA (id 4) depende de Algoritmos (id 1)
(6, 1); -- Estrutura de Dados (id 6) depende de Algoritmos (id 1)


INSERT INTO Tb_curso_disciplina (fk_curso, fk_disc, obrigatoria) VALUES 
(1, 1, 'obrigatoria'), -- Algoritmos na Ciência da Computação
(2, 1, 'obrigatoria'), -- Algoritmos na Eng. Software (Mesma disc. em cursos diferentes)
(1, 2, 'obrigatoria'), -- BD I na CC
(2, 2, 'obrigatoria'), -- BD I na ES (Mesma disc. em cursos diferentes)
(1, 3, 'obrigatoria'), -- BD II na CC
(1, 5, 'obrigatoria'), -- POO na CC
(2, 5, 'obrigatoria'), -- POO na ES
(1, 4, 'optativa'),    -- IA como Optativa na CC
(3, 4, 'obrigatoria'), -- IA como Obrigatória na Pós em IA
(2, 7, 'optativa');    -- Redes como Optativa na ES



INSERT INTO Tb_professor (id_prof, nome, cpf, email, titulacao, fk_curso_coord) VALUES 
(1, 'Alan Turing', '11122233344', 'turing@unidata.edu', 'Doutor', 1), -- Coordenador do Curso 1
(2, 'Grace Hopper', '22233344455', 'hopper@unidata.edu', 'Pos-Doutor', NULL),
(3, 'Barbara Liskov', '33344455566', 'liskov@unidata.edu', 'Mestre', NULL),
(4, 'Ada Lovelace', '44455566677', 'ada@unidata.edu', 'Doutor', NULL);


INSERT INTO Tb_turma (fk_disc, fk_prof, semestre, ano, capacidade) VALUES 
(1, 2, 1, 2026, 30), -- Turma 1: Prof Grace Hopper em 2026
(5, 2, 1, 2026, 30), -- Turma 2: Prof Grace Hopper em 2026
(6, 2, 2, 2026, 30), -- Turma 3: Prof Grace Hopper em 2026 (>2 turmas no ano atual!)
(2, 1, 1, 2025, 25), -- Turma 4: Ano/Semestre variados
(3, 3, 2, 2025, 25); -- Turma 5: Ano/Semestre variados


INSERT INTO Tb_Aluno (nome, cpf, email, dt_nasc, fk_curso) VALUES 
('Ana Silva', '10101010101', 'ana@aluno.com', '2004-03-15', 1),
('Bruno Souza', '20202020202', 'bruno@aluno.com', '2003-07-22', 1),
('Carlos Lima', '30303030303', 'carlos@aluno.com', '2005-01-10', 1),
('Daniela Oliveira', '40404040404', 'daniela@aluno.com', '2004-11-05', 2),
('Eduardo Costa', '50505050505', 'eduardo@aluno.com', '2002-05-18', 2),
('Fernanda Santos', '60606060606', 'fernanda@aluno.com', '2003-09-12', 2),
('Gabriel Jesus', '70707070707', 'gabriel@aluno.com', '1999-12-25', 3),
('Helena Roza', '80808080808', 'helena@aluno.com', '1998-04-30', 3),
('Igor Moreira', '90909090909', 'igor@aluno.com', '2004-06-14', 1),
('Julia Martins', '12121212121', 'julia@aluno.com', '2003-10-08', 2);


INSERT INTO Tb_matricula (fk_aluno, fk_turma, nota, frequencia, situacao) VALUES 
-- Histórico (Turmas de 2025 para validar os aprovados e reprovados)
(1, 4, 8.5, 90.0, 'Aprovado'),              
(2, 4, 9.0, 95.0, 'Aprovado'),              
(3, 4, 4.5, 85.0, 'Reprovado por nota'),    
(4, 4, 7.0, 60.0, 'Reprovado pro falta'),   
(5, 4, 3.0, 50.0, 'Reprovado por nota'),    
(1, 5, 7.5, 88.0, 'Aprovado'),              
(2, 5, 6.0, 40.0, 'Reprovado pro falta'),  
-- Atualidade (Turmas de 2026 onde os alunos estão estudando atualmente)
(1, 1, NULL, NULL, 'Em Curso'),
(2, 1, NULL, NULL, 'Em Curso'),
(3, 1, NULL, NULL, 'Em Curso'),
(4, 2, NULL, NULL, 'Em Curso'),
(5, 2, NULL, NULL, 'Em Curso'),
(6, 2, NULL, NULL, 'Em Curso'),
(7, 3, NULL, NULL, 'Em Curso'),
(8, 3, NULL, NULL, 'Em Curso');