import 'package:reach_core/core/core.dart';

class StackList<E> extends Equatable {
  final _list = <E>[];

  void push(E value) => _list.add(value);

  E pop() => _list.removeLast();

  E get peek => _list.last;

  bool get isEmpty => _list.isEmpty;
  bool get isNotEmpty => _list.isNotEmpty;
  bool isLast(E element) => _list.first == element;
  @override
  String toString() => _list.toString();

  void pushAll(List<E> list) {
    for (final e in list) {
      push(e);
    }
  }

  List<E> iterable() => List.from(_list.reversed);

  E firstWhere(bool Function(E element) test) => _list.firstWhere(test);

  @override
  List<Object?> get props => [_list];
}
