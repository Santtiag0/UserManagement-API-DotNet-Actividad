using System.ComponentModel.DataAnnotations;

namespace UsuariosApi.DTOs;

public class CambiarPasswordDto
{
    [Required, MinLength(6, ErrorMessage = "La contraseña debe tener mínimo 6 caracteres.")]
    public string Password { get; set; } = string.Empty;
}
