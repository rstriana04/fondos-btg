export class Left<L> {
  readonly tag = 'left';
  constructor(public readonly value: L) {}

  isLeft(): this is Left<L> {
    return true;
  }

  isRight(): this is never {
    return false;
  }

  fold<T>(onLeft: (l: L) => T, _onRight: (r: never) => T): T {
    return onLeft(this.value);
  }

  map<R2>(_fn: (r: never) => R2): Either<L, R2> {
    return this as unknown as Either<L, R2>;
  }

  flatMap<R2>(_fn: (r: never) => Either<L, R2>): Either<L, R2> {
    return this as unknown as Either<L, R2>;
  }

  getOrElse<R>(defaultValue: R): R {
    return defaultValue;
  }
}

export class Right<R> {
  readonly tag = 'right';
  constructor(public readonly value: R) {}

  isLeft(): this is never {
    return false;
  }

  isRight(): this is Right<R> {
    return true;
  }

  fold<T>(_onLeft: (l: never) => T, onRight: (r: R) => T): T {
    return onRight(this.value);
  }

  map<R2>(fn: (r: R) => R2): Either<never, R2> {
    return new Right(fn(this.value));
  }

  flatMap<L, R2>(fn: (r: R) => Either<L, R2>): Either<L, R2> {
    return fn(this.value);
  }

  getOrElse(_defaultValue: R): R {
    return this.value;
  }
}

export type Either<L, R> = Left<L> | Right<R>;

export function left<L, R = never>(value: L): Either<L, R> {
  return new Left(value);
}

export function right<R, L = never>(value: R): Either<L, R> {
  return new Right(value);
}

// Convenience type for domain results
import { Failure } from './failures';

export type Result<T> = Either<Failure, T>;
