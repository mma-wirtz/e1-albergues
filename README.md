
# E1 - Base de datos de albergues con Docker Compose

## Descripción

Proyecto que utiliza Docker Compose para desplegar una base de datos PostgreSQL y una interfaz web Adminer para consultar y gestionar la información de diferentes albergues del Camino de Santiago.

La base de datos contiene la tabla `albergues`, con información sobre su nombre, dirección, concello, camino, número de plazas y precio por noche.

## Requisitos

- Docker Desktop o Docker Engine.
- Docker Compose.

## Estructura del proyecto

- `compose.yaml`: configuración de los servicios, la red, el volumen y el healthcheck.
- `.env.example`: plantilla de las variables de entorno.
- `.gitignore`: archivos que no deben subirse al repositorio.
- `initdb/01_esquema.sql`: creación de la tabla.
- `initdb/02_datos.sql`: inserción de los ocho albergues iniciales.
- `README.md`: documentación del proyecto.

## Puesta en marcha

1. Clonar el repositorio de GitHub y entrar en la carpeta del proyecto.

2. Crear el archivo `.env` a partir de la plantilla:

   ```bash
   cp .env.example .env
   ```

   En Windows PowerShell también se puede utilizar:

   ```powershell
   Copy-Item .env.example .env
   ```

3. Editar el archivo `.env` y establecer los valores de `POSTGRES_USER`, `POSTGRES_PASSWORD` y `POSTGRES_DB`. La contraseña debe ser una contraseña propia y no debe publicarse en GitHub.

4. Comprobar la configuración:

   ```bash
   docker compose config --quiet
   ```

5. Arrancar los servicios:

   ```bash
   docker compose up -d
   ```

6. Comprobar el estado de los contenedores:

   ```bash
   docker compose ps
   ```

   El servicio `db` debe aparecer como `healthy` y Adminer debe estar iniciado.

7. Abrir Adminer en el navegador:

   http://localhost:8080

8. Iniciar sesión con los siguientes datos:

   - Motor: PostgreSQL.
   - Servidor: `db`.
   - Usuario: el valor de `POSTGRES_USER` del archivo `.env`.
   - Contraseña: el valor de `POSTGRES_PASSWORD` del archivo `.env`.
   - Base de datos: el valor de `POSTGRES_DB` del archivo `.env`.

Los scripts SQL se ejecutan automáticamente cuando PostgreSQL inicializa una base de datos con un volumen vacío.

## Prueba de persistencia

Para comprobar la persistencia se ha insertado desde Adminer un albergue adicional llamado `Albergue Prueba Persistencia`.

| Paso | Comando o acción | Resultado obtenido |
|---|---|---|
| 1 | `docker compose up -d` | PostgreSQL y Adminer arrancan correctamente. Se muestran los ocho albergues iniciales. |
| 2 | Insertar un albergue nuevo desde Adminer | Se muestran nueve registros. |
| 3 | `docker compose down` y después `docker compose up -d` | Se mantienen los nueve registros, incluido el albergue de prueba. |
| 4 | `docker compose down -v` y después `docker compose up -d` | Desaparece el registro de prueba y vuelven a aparecer los ocho albergues iniciales. |

### ¿Por qué el resultado del paso 4 es diferente?

Al ejecutar `docker compose down`, se eliminan los contenedores, pero se conserva el volumen con los datos de PostgreSQL. Por eso, al volver a arrancar el proyecto, los nueve registros siguen disponibles.

En cambio, `docker compose down -v` elimina también el volumen de datos del proyecto. Cuando se vuelve a ejecutar `docker compose up -d`, PostgreSQL inicializa una base de datos nueva y ejecuta los scripts SQL de `initdb`, creando de nuevo la tabla e insertando los ocho albergues iniciales.

Por tanto, los volúmenes permiten conservar los datos aunque se eliminen los contenedores. Si se elimina el volumen, los datos guardados en él se pierden y la base de datos se vuelve a inicializar.

## Detener el proyecto

Para detener y eliminar los contenedores sin borrar los datos persistentes:

```bash
docker compose down
```

Para eliminar también el volumen de datos:

```bash
docker compose down -v
```

**Advertencia:** el segundo comando elimina los datos almacenados en el volumen del proyecto.

## Seguridad

El archivo `.env` contiene las credenciales locales y está excluido del repositorio mediante `.gitignore`. El archivo `.env.example` se incluye como plantilla para facilitar la configuración del proyecto.
