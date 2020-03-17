extension DateToString on DateTime {
  String toDateString() {
    return "${this.year}.${this.month}月${this.day}日 - ${this.hour}时${this.minute}分";
  }
}
