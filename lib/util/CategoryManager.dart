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
    return ["1", "2", "3", "4", "5", "6", "7", "8"];
  }
}
