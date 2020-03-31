class CategoryManager {
  static CategoryManager _instance;

  CategoryManager._();

  static CategoryManager getInstance() {
    if (_instance == null) {
      _instance = CategoryManager._();
    }
    return _instance;
  }

  Future<List<String>> getAllCategory() async {
    return ["1", "12", "123", "1234", "12345", "123456", "1234567", "12345678"];
  }
}
