namespace UsuariosApi.Helpers;

public static class EdadHelper
{
    // Resta un año si aún no ha llegado el cumpleaños
    public static int CalcularEdad(DateOnly fechaNacimiento, DateOnly hoy)
    {
        var edad = hoy.Year - fechaNacimiento.Year;

        if (hoy.Month < fechaNacimiento.Month ||
            (hoy.Month == fechaNacimiento.Month &&
             hoy.Day < fechaNacimiento.Day))
        {
            edad--;
        }

        return edad;
    }

    public static int CalcularEdad(DateOnly fechaNacimiento)
    {
        return CalcularEdad(
            fechaNacimiento,
            DateOnly.FromDateTime(DateTime.Today)
        );
    }
}
