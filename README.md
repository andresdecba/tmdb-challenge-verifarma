

*** ARQUITECTURA ***
-> CORE: configuraciones generales
-> DOMAIN:
  -data source: clases abstractas
  -repositorio: clases abstractas (llama al data souce)
  -entidades: modelos del negocio
  -use cases: conecta las clases del repositorio con la UI
-> DATA:
  -data source: implementacion de las clases del data source DOMAIN
  -repositorio: implementacion de las clases del repositorio DOMAIN
  -models: convierte a fromJson/toJson las entidades de DOMAIN
-> PRESENTATION:
  -paginas
  -controladores de estado de las paginas
  -widgets compartidos

*** RIVERPOD ***
/// provider de sólo lectura: ///

provider:
final soloLecturaProvider = Provider<String>((ref) {
  const texto = 'Hola estes es un provider de solo lectura';
  return texto;
});

referencia en el widget:
final soloLectura = ref.read(soloLecturaProvider);
soloLectura.texto;

/// provider que cambia el estado: ///

provider:
final cambiaEstadoProvider = StateNotifierProvider<CambiaEstadoController, String>((ref) {
  return CambiaEstadoController();
});

el controller del provider:
class CambiaEstadoController extends StateNotifier<String> {
  CambiaEstadoController() : super('');
  String miVariable = 'Hola CambiaEstadoController';
}
referencia en el widget:
final cambiaEstado = ref.watch(cambiaEstadoProvider.notifier);
cambiaEstado.miVariable = 'otra cosa';

*** GO ROUTER ***
Leer: https://codewithandrea.com/articles/flutter-navigation-gorouter-go-vs-push/


*** TIDB DOCS ***
buscar por generos: https://developer.themoviedb.org/reference/genre-movie-list
fuente: https://www.themoviedb.org/talk/5daf6eb0ae36680011d7e6ee

