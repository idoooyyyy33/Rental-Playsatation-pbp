abstract class BaseModel {
  List<Object?> get props;

  // Polymorphism: abstract method to be implemented by subclasses
  String getSummary();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BaseModel &&
      runtimeType == other.runtimeType &&
      _equals(props, other.props);

  @override
  int get hashCode => _hash(props);

  static bool _equals(List<Object?> a, List<Object?> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  static int _hash(List<Object?> list) {
    int hash = 0;
    for (final item in list) {
      hash = 31 * hash + (item?.hashCode ?? 0);
    }
    return hash;
  }

  @override
  String toString() => '$runtimeType(${props.map((e) => '$e').join(', ')})';
}
