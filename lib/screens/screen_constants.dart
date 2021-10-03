class ScreenConstants {
  static ScreenModel planner = ScreenModel('Ny madplan', '/planner');
  static ScreenModel list = ScreenModel('Indkøbsliste', '/list');
  static ScreenModel database = ScreenModel('Mine retter', '/dishes');
}

class ScreenModel {
  String title;
  String route;

  ScreenModel(this.title, this.route);
}
