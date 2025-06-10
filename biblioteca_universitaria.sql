CREATE DATABASE biblioteca_universitaria;
USE biblioteca_universitaria;
CREATE TABLE alunos (
    id_aluno INT AUTO_INCREMENT PRIMARY KEY
    ,nome VARCHAR(100) NOT NULL
    ,curso VARCHAR(100)
    ,data_matricula DATE NOT NULL
);
CREATE TABLE livros (
    id_livro INT AUTO_INCREMENT PRIMARY KEY
    ,titulo VARCHAR(200) NOT NULL
    ,autor VARCHAR(100) NOT NULL
    ,quantidade_estoque INT NOT NULL CHECK (quantidade_estoque >= 0)
);
CREATE TABLE emprestimos (
    id_emprestimo INT AUTO_INCREMENT PRIMARY KEY
    ,id_aluno INT
    ,id_livro INT
    ,data_emprestimo DATE NOT NULL
    ,data_devolucao DATE DEFAULT NULL 
); 
CREATE TABLE penalidades (
    id_penalidade INT AUTO_INCREMENT PRIMARY KEY
    ,id_aluno INT
    ,descricao TEXT NOT NULL
    ,data_penalidade DATE NOT NULL
);

ALTER TABLE emprestimos ADD CONSTRAINT FK_emprestimos_X_PK_livros
FOREIGN KEY (id_livro) REFERENCES livros (id_livro);

ALTER TABLE emprestimos ADD CONSTRAINT FK_emprestimosXPK_alunos
FOREIGN KEY (id_aluno) REFERENCES alunos (id_aluno);

ALTER TABLE penalidades ADD CONSTRAINT FK_penalidades_X_PK_alunos
FOREIGN KEY (id_aluno) REFERENCES alunos (id_aluno);


#inserindo os alunos
INSERT INTO alunos (nome, curso, data_matricula) VALUES
('João Vitor', 'Engenharia de Software', '2024-02-01'),
('Luiz Antônio', 'Engenharia de Software', '2023-06-01'),
('Samuel Arthur','Educação Fisica','2024-01-16'),
('José Bento','Agronomia','2024-01-01'); 

#inserindo os livros
INSERT INTO livros (titulo, autor, quantidade_estoque) VALUES
('Introdução à Linguagem SQL', 'Thomas Nield', 4),
('O Programador Pragmático: De Aprendiz a Mestre', 'Andrew Hunt', 5),
('Manual de Anatomia do Exercício', 'Ken Ashwell', 6),
('Hipertrofia muscular: Ciência e prática', 'Brad Schoenfeld', 3),
('Manejo ecológico do solo : A agricultura em regiões tropicais', 'Ana Maria Primavesi', 7),
('Manual de Identificação e Controle de Plantas Daninhas', 'Harri Lorenzi', 10),
('Entendendo Algoritmos', 'Aditya Bhargava', 8),
('Código Limpo: Habilidades Práticas do Agile Software', 'Robert C. Martin', 2);


#inserindo dois emprestimos um completo e outro incompleto
INSERT INTO emprestimos(id_aluno, id_livro, data_emprestimo, data_devolcao) VALUES
(1, 1, '2025-01-12',null),
(3, 4, '2025-02-28', '2025-03-05');

-----------view----------

-------------------------
DELIMITER //
CREATE PROCEDURE registrar_emprestimo (
    IN p_id_aluno INT,
    IN p_id_livro INT,
    IN p_data_emprestimo DATE
)
BEGIN
    DECLARE v_estoque INT;

    -- Verifica estoque
    SELECT quantidade_estoque INTO v_estoque
    FROM livros WHERE id_livro = p_id_livro;

    IF v_estoque > 0 THEN
        -- Insere empréstimo
        INSERT INTO emprestimos (id_aluno, id_livro, data_emprestimo)
        VALUES (p_id_aluno, p_id_livro, p_data_emprestimo);

        -- Atualiza estoque
        UPDATE livros SET quantidade_estoque = quantidade_estoque - 1
        WHERE id_livro = p_id_livro;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Livro sem estoque disponível.';
    END IF;
END;
//
DELIMITER ;
----------Trigger--------

-------------------------
