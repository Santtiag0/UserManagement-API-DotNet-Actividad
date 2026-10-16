# 📱 User Management Mobile App

Aplicación móvil desarrollada con Kotlin para Android que consume una
API REST desarrollada con ASP.NET Core y utiliza MySQL como sistema
de persistencia.

## 🚀 Tecnologías

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

## 🏗️ Arquitectura

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

## 🔐 Autenticación

Las contraseñas no se almacenan en texto plano.

Durante el registro:

Password → BCrypt Hash → MySQL

Durante el login:

Password → BCrypt Verify → PasswordHash

## 📌 Funcionalidades

- Registro de usuarios
- Inicio de sesión
- Validación de credenciales
- Hash seguro de contraseñas
- Consulta de usuarios
- Actualización de usuarios
- Eliminación de usuarios
- Manejo de roles
- Consumo de API REST desde Android

## 🔗 Endpoints

| Método | Endpoint | Descripción |
|---|---|---|
| GET | /api/Usuarios | Consultar usuarios |
| GET | /api/Usuarios/{id} | Consultar usuario |
| POST | /api/Usuarios | Crear usuario |
| POST | /api/Usuarios/login | Iniciar sesión |
| PUT | /api/Usuarios/{id} | Actualizar usuario |
| PUT | /api/Usuarios/{id}/password | Cambiar contraseña |
| DELETE | /api/Usuarios/{id} | Eliminar usuario |

## 🛠️ Cambios realizados (actividad de modificación)

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
