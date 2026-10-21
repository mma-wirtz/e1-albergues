# e1-albergues

Proyecto de Docker Compose para gestionar la información de varios albergues del Camino de Santiago mediante PostgreSQL y Adminer.

## Guía de inicio

Sigue estos pasos para descargar el proyecto y ponerlo en marcha en tu ordenador.

### 1. Clonar el repositorio

```bash
git clone https://github.com/mma-wirtz/e1-albergues.git
cd e1-albergues
```

### 2. Configurar las variables de entorno

Crea el archivo `.env` copiando la plantilla `.env.example`.

En Windows PowerShell:

```powershell
Copy-Item .env.example .env
```

Abre el archivo `.env` y configura el usuario, la contraseña y el nombre de la base de datos. No subas este archivo a GitHub.

### 3. Arrancar los servicios

Ejecuta el siguiente comando desde la carpeta del proyecto:

```bash
docker compose up -d
```

Para comprobar que los servicios están funcionando:

```bash
docker compose ps
```

PostgreSQL debe aparecer como `healthy`. Los scripts SQL se ejecutan automáticamente al inicializar la base de datos por primera vez.

### 4. Acceder a la base de datos

Abre [http://localhost:8080](http://localhost:8080) en el navegador para entrar en Adminer.

Utiliza los siguientes datos para iniciar sesión:

- **Motor:** PostgreSQL
- **Servidor:** `db`
- **Usuario:** el definido en `.env`
- **Contraseña:** la definida en `.env`
- **Base de datos:** `albergues`

La tabla `albergues` contiene el nombre, la dirección, el concello, el camino, el número de plazas y el precio por noche de cada albergue.

## Prueba de persistencia

Para comprobar que los datos se conservan, se ha añadido un albergue de prueba desde Adminer.

| Paso | Comando o acción | Resultado obtenido |
|---|---|---|
| 1 | `docker compose up -d` | Se inicia el proyecto con los 8 albergues iniciales. |
| 2 | Insertar un albergue desde Adminer | La tabla pasa a tener 9 albergues. |
| 3 | `docker compose down` y después `docker compose up -d` | Se mantienen los 9 albergues. |
| 4 | `docker compose down -v` y después `docker compose up -d` | Se vuelve a tener los 8 albergues iniciales. |

### ¿Por qué cambia el resultado del paso 4?

Con `docker compose down` se eliminan los contenedores, pero el volumen conserva los datos de PostgreSQL. Por eso, al volver a arrancar el proyecto, siguen apareciendo los 9 albergues.

En cambio, `docker compose down -v` elimina también el volumen. Al iniciar de nuevo el proyecto, PostgreSQL crea una base de datos vacía y ejecuta los scripts SQL de inicialización, por lo que vuelven a aparecer únicamente los 8 albergues iniciales.

**Importante:** el comando `docker compose down -v` elimina los datos guardados en el volumen del proyecto.

## Detener el proyecto

Para detener los servicios sin eliminar los datos guardados:

```bash
docker compose down
```
