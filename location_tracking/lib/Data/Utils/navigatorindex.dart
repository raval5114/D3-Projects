class NavigatorIndex {
  static final NavigatorIndex _instance = NavigatorIndex._internal();
  int _index = 0;

  factory NavigatorIndex() {
    return _instance;
  }

  NavigatorIndex._internal();

  int get index => _index;

  set index(int newIndex) {
    _index = newIndex;
  }
}
