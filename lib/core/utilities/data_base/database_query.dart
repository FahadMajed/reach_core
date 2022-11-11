import 'package:reach_core/core/core.dart';

class DatabaseQuery<T> {
  final List<Where>? clauses;
  final int? limit;
  final String? orderBy;
  final bool descending;
  DatabaseQuery(
    this.clauses, {
    this.limit,
    this.orderBy,
    this.descending = false,
  });

  Query<T> parseAsFirestore(CollectionReference<T> collection) {
    Query<T> query = collection;

    for (final Where clause in clauses ?? []) {
      query = query.where(
        clause.field,
        isEqualTo: clause.isEqualTo,
        isGreaterThan: clause.isGreaterThan,
        isGreaterThanOrEqualTo: clause.isGreaterThanOrEqualTo,
        isLessThan: clause.isLessThan,
        isLessThanOrEqualTo: clause.isLessThanOrEqualTo,
        isNotEqualTo: clause.isNotEqualTo,
        whereIn: clause.whereIn,
        whereNotIn: clause.whereNotIn,
        arrayContains: clause.arrayContains,
        arrayContainsAny: clause.arrayContainsAny,
      );
    }
    if (limit != null) {
      query = query.limit(limit!);
    }
    if (orderBy != null) {
      query = query.orderBy(orderBy!, descending: descending);
    }

    return query;
  }

  @override
  String toString() {
    return 'DatabaseQuery(clauses: $clauses, limit: $limit, orderBy: $orderBy, descending: $descending)';
  }
}

class Where {
  final String field;
  final Object? arrayContains;
  final List<Object?>? arrayContainsAny;
  final Object? isEqualTo;
  final Object? isGreaterThan;
  final Object? isGreaterThanOrEqualTo;
  final Object? isLessThan;
  final Object? isLessThanOrEqualTo;
  final Object? isNotEqualTo;
  final bool? isNull;
  final List<Object?>? whereIn;
  final List<Object?>? whereNotIn;

  Where(
    this.field, {
    this.arrayContains,
    this.arrayContainsAny,
    this.isEqualTo,
    this.isGreaterThan,
    this.isGreaterThanOrEqualTo,
    this.isLessThan,
    this.isLessThanOrEqualTo,
    this.isNotEqualTo,
    this.isNull,
    this.whereIn,
    this.whereNotIn,
  });

  @override
  String toString() {
    return 'Where(field: $field, arrayContains: $arrayContains, arrayContainsAny: $arrayContainsAny, isEqualTo: $isEqualTo, isGreaterThan: $isGreaterThan, isGreaterThanOrEqualTo: $isGreaterThanOrEqualTo, isLessThan: $isLessThan, isLessThanOrEqualTo: $isLessThanOrEqualTo, isNotEqualTo: $isNotEqualTo, isNull: $isNull, whereIn: $whereIn, whereNotIn: $whereNotIn)';
  }
}
