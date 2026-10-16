-- Cambios en la tabla Usuarios
-- Reemplace TU_BASE_DATOS por el nombre de su base de datos
USE TU_BASE_DATOS;

-- OPCIÓN A: la tabla Usuarios ya existe
ALTER TABLE Usuarios
    ADD COLUMN FechaNacimiento DATE NULL AFTER PasswordHash,
    ADD COLUMN Universidad VARCHAR(150) NOT NULL DEFAULT '' AFTER Edad,
    ADD COLUMN Semestre INT NOT NULL DEFAULT 1 AFTER Universidad;

-- Fecha estimada para los usuarios existentes
UPDATE Usuarios
SET FechaNacimiento = DATE_SUB(CURDATE(), INTERVAL Edad YEAR)
WHERE FechaNacimiento IS NULL;

ALTER TABLE Usuarios
    MODIFY COLUMN FechaNacimiento DATE NOT NULL;

-- Si RolId tiene llave foránea, eliminarla antes con DROP FOREIGN KEY
ALTER TABLE Usuarios
    DROP COLUMN RolId;

ALTER TABLE Usuarios
    ADD CONSTRAINT CK_Usuarios_Semestre CHECK (Semestre BETWEEN 1 AND 10);

-- OPCIÓN B: base de datos nueva
/*
CREATE TABLE Usuarios (
    Id              INT AUTO_INCREMENT PRIMARY KEY,
    Nombre          VARCHAR(100) NOT NULL,
    Apellido        VARCHAR(100) NOT NULL,
    Correo          VARCHAR(150) NOT NULL,
    PasswordHash    VARCHAR(255) NOT NULL,
    FechaNacimiento DATE         NOT NULL,
    Edad            INT          NOT NULL,
    Universidad     VARCHAR(150) NOT NULL,
    Semestre        INT          NOT NULL,
    Activo          TINYINT(1)   NOT NULL DEFAULT 1,
    FechaCreacion   DATETIME(6)  NOT NULL,
    CONSTRAINT UQ_Usuarios_Correo UNIQUE (Correo),
    CONSTRAINT CK_Usuarios_Semestre CHECK (Semestre BETWEEN 1 AND 10)
);
*/

-- Evidencia
DESCRIBE Usuarios;

SELECT Id, Nombre, Apellido, Correo, FechaNacimiento, Edad,
       Universidad, Semestre, Activo, FechaCreacion
FROM Usuarios;
