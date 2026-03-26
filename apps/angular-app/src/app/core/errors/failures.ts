export abstract class Failure {
  constructor(public readonly message: string) {}
}

export class ServerFailure extends Failure {
  constructor(message: string = 'Error del servidor. Intente nuevamente.') {
    super(message);
  }
}

export class NetworkFailure extends Failure {
  constructor(message: string = 'Error de conexion. Verifique su internet.') {
    super(message);
  }
}

export class InsufficientBalanceFailure extends Failure {
  constructor(fundName: string, minAmount: number) {
    super(`No tiene saldo suficiente para vincularse al fondo ${fundName}. Monto minimo: $${minAmount.toLocaleString('es-CO')}`);
  }
}

export class AlreadySubscribedFailure extends Failure {
  constructor(fundName: string) {
    super(`Ya se encuentra vinculado al fondo ${fundName}`);
  }
}

export class NotFoundFailure extends Failure {
  constructor(message: string = 'Recurso no encontrado.') {
    super(message);
  }
}

export class ValidationFailure extends Failure {
  constructor(message: string) {
    super(message);
  }
}
