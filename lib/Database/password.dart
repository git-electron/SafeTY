class Password {
  int id;
  String _title;
  String _pass;
  String _name;
  String _link;
  String _sortDate;

  Password(this._title, this._pass, this._name, this._link, this._sortDate);

  Password.map(dynamic obj) {
    this._title = obj["title"];
    this._pass = obj["pass"];
    this._name = obj["name"];
    this._link = obj["link"];
    this._sortDate = obj["sortDate"];
  }

  String get title => _title;

  String get pass => _pass;

  String get name => _name;

  String get link => _link;

  String get sortDate => _sortDate;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map["title"] = _title;
    map["pass"] = _pass;
    map["name"] = _name;
    map["link"] = _link;
    map["sortDate"] = _sortDate;

    return map;
  }

  void setPassId(int id) {
    this.id = id;
  }
}