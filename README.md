# User Management Mobile App

Aplicación móvil desarrollada con Kotlin para Android que consume una
API REST desarrollada con ASP.NET Core y utiliza MySQL como sistema
de persistencia.

> **Versión 1 (v1):** primera versión funcional de la actividad. Aún faltan algunos detalles por ajustar.

## Tecnologías

### Mobile
- Kotlin
- Android Studio
- Retrofit
- Gson
- XML Layouts

### Backend
- C#
- ASP.NET Core Web API
- Entity Framework Core
- BCrypt
- Repository Pattern

### Database
- MySQL

## Arquitectura

Android App
    ↓
Retrofit
    ↓
ASP.NET Core REST API
    ↓
Controller
    ↓
Service
    ↓
Repository
    ↓
Entity Framework Core
    ↓
MySQL

## Autenticación

Las contraseñas no se almacenan en texto plano.

Durante el registro:

Password → BCrypt Hash → MySQL

Durante el login:

Password → BCrypt Verify → PasswordHash

## Funcionalidades

- Registro de usuarios
- Inicio de sesión
- Validación de credenciales
- Hash seguro de contraseñas
- Consulta de usuarios
- Actualización de usuarios
- Eliminación de usuarios
- Cambio de contraseña
- Consumo de API REST desde Android

App Android que consume este API: [UserManagement-Android-Kotlin-Actividad](https://github.com/Santtiag0/UserManagement-Android-Kotlin-Actividad)

## Instalación y ejecución

### Requisitos
- [.NET 8 SDK](https://dotnet.microsoft.com/download/dotnet/8.0)
- MySQL 8 o superior (y opcionalmente MySQL Workbench)

### 1. Clonar el repositorio
```bash
git clone https://github.com/Santtiag0/UserManagement-API-DotNet-Actividad.git
cd UserManagement-API-DotNet-Actividad
```

### 2. Crear la base de datos
En MySQL Workbench (o la consola de MySQL) crear la base y ejecutar el `CREATE TABLE` de la **Opción B** de `Database/cambios_usuarios.sql`:
```sql
CREATE DATABASE usuarios_db;
USE usuarios_db;
-- Pegar aquí el CREATE TABLE Usuarios de la Opción B
```
Si ya existe la tabla del proyecto original, usar en cambio la **Opción A** del mismo script.

### 3. Configurar la conexión
Crear el archivo `appsettings.Development.json` (no se sube al repositorio) con los datos de su MySQL:
```json
{
  "ConnectionStrings": {
    "MySql": "server=localhost;port=3306;database=usuarios_db;user=root;password=SU_PASSWORD"
  }
}
```

### 4. Ejecutar el API
```bash
dotnet run
```
El API queda en `http://localhost:62129` y Swagger en **http://localhost:62129/swagger**.

### 5. Conectar la app Android
Con el API corriendo, la app Android se conecta desde el emulador a `http://10.0.2.2:62129/`.

## Endpoints

| Método | Endpoint | Descripción |
|---|---|---|
| GET | /api/Usuarios | Consultar usuarios |
| GET | /api/Usuarios/{id} | Consultar usuario |
| POST | /api/Usuarios | Crear usuario |
| POST | /api/Usuarios/login | Iniciar sesión |
| PUT | /api/Usuarios/{id} | Actualizar usuario |
| PUT | /api/Usuarios/{id}/password | Cambiar contraseña |
| DELETE | /api/Usuarios/{id} | Eliminar usuario |

## Cambios realizados (actividad de modificación)

### Modelo y DTOs
- Se eliminó **RolId** de la entidad y de `CrearUsuarioDto`.
- **Edad** ya no se recibe: se recibe **FechaNacimiento** (`"yyyy-MM-dd"`) y la edad se calcula en el servidor con día, mes y año (`Helpers/EdadHelper.cs`).
- Se agregaron **Universidad** (obligatoria, máx. 150) y **Semestre** (entre 1 y 10).
- `UsuarioDto` devuelve FechaNacimiento, Edad, Universidad y Semestre. **No** expone la contraseña ni su hash.
- `ActualizarUsuarioDto`, el servicio y el mapeo se actualizaron con los mismos campos.

### Validaciones
- Se mantiene la validación de correo único: `400 { "mensaje": "Ya existe un usuario con ese correo." }`.
- La fecha de nacimiento no puede ser futura.
- Los errores de validación de los DTOs también responden con el formato `{ "mensaje": "..." }` (configurado en `Program.cs`).
- La contraseña se sigue guardando con **BCrypt**.

### Base de datos
Configurar la conexión en `appsettings.json` (o en `appsettings.Development.json`, que no se sube al repositorio).

Ejecutar `Database/cambios_usuarios.sql`:
- Agrega `FechaNacimiento`, `Universidad` y `Semestre`.
- Elimina `RolId`.
- Incluye el `CREATE TABLE` completo para una base de datos nueva y las consultas de evidencia.

| Campo | Tipo |
|---|---|
| Id | INT (PK) |
| Nombre | VARCHAR(100) |
| Apellido | VARCHAR(100) |
| Correo | VARCHAR(150) único |
| PasswordHash | VARCHAR(255) |
| FechaNacimiento | DATE |
| Edad | INT (calculada) |
| Universidad | VARCHAR(150) |
| Semestre | INT (1 – 10) |
| Activo | TINYINT(1) |
| FechaCreacion | DATETIME |

### Ejemplo de registro (Swagger)
```json
POST /api/Usuarios
{
  "nombre": "Alexander",
  "apellido": "Navarro",
  "correo": "alex@correo.com",
  "password": "123456",
  "fechaNacimiento": "2002-05-14",
  "universidad": "UCompensar",
  "semestre": 5
}
```
