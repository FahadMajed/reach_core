abstract class BaseUseCase<T> {
  BaseUseCase();
}

abstract class UseCase<T, P> extends BaseUseCase<T> {
  UseCase();

  Future<T> call(P request);
}

abstract class NoRequestUseCase<T> extends BaseUseCase<T> {
  NoRequestUseCase();

  Future<T> call();
}
