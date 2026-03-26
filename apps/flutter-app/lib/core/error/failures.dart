import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

final class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Ha ocurrido un error en el servidor']);
}

final class InsufficientBalanceFailure extends Failure {
  const InsufficientBalanceFailure([
    super.message = 'No tiene saldo disponible para vincularse al fondo',
  ]);
}

final class AlreadySubscribedFailure extends Failure {
  const AlreadySubscribedFailure([
    super.message = 'Ya se encuentra vinculado a este fondo',
  ]);
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Recurso no encontrado']);
}
