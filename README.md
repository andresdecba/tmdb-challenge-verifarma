# Flutter Movies app (TMDB API)
App creada para el challenge de Verifarma
4 de julio de 2023
Dev: Andrés Pugliese
Mail: andrésdecba@gmail.com
Cel: 351 6 639258
Linked in: https://www.linkedin.com/in/andres-pugliese/
Mi playstore: https://play.google.com/store/apps/details?id=site.thisweek 

## Levantar app
1- clonar el repositorio
2- ejecutar flutter pub get
3- para el login:
    user: user@user.com
    pass: 123456
4- si abren la consola cuando esta obteniendo datos se puede ver un log tiempo real (muy útil para debugear)

## Características de usabilidad
- Pantalla de loguin (dummy)
- 4 Pantallas con las diferentes listas que ofrece TMDB
- Scroll infinito
- Búsqueda por título (por falta de tiempo no incluí la busqueda por categorias)
- Pantalla con el detalle de la película
- Agregar a favoritos
- Persistencia de datos
- Animaciones en los widgets

## Características técnicas
- Arquitectura limpia (CORE -> DOMAIN -> DATA -> USE_CASES -> PRESENTATION)
- Implementación del manejo de errores y excepciones (ver en core/netwoork/ exceptions)
    incluí algunos codigos de TMDB sólo como muestra, se puede provocar una excepción cambiando el "api key"
- Gestor de estado: Riverpod
- Manejo de rutas: Go_router
- Para la persistencia de datos: Hive
- Paqute HTTTP: dio
- Para ver la interacción con el servidor en tiempo real (en la consola) se usa Pretty dio

## Paquetes usados
- Flutter_riverpod
- Equatable
- Dio
- Pretty dio logger
- Go_router
- Dartz
- Otros...

## Notas
- Segun el pdf del challenge Faltó incluir:
    - Buscar por categoría, actores, año de lanzamiento
    - accesibilidad para personas con discapacidades visuales

- Por falta de tiempo no llegué a terminar con esas características, pero por como está armada la app, son falcilmente agregables.
- Hice enfasis en la estética, la reusabilidad del código y en una arquitectura sólida y escalable.
- Cualquier consulta quedo a dispocisión, espero les guste la app, gracias y saludos !

