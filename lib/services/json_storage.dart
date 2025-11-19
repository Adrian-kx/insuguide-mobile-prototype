// Encaminha para a implementação correta conforme a plataforma.
import 'json_storage_io.dart'
  if (dart.library.html) 'json_storage_web.dart';

export 'json_storage_io.dart'
  if (dart.library.html) 'json_storage_web.dart';