class MonthPredict {
  int? month;


  MonthPredict(
      {this.month,
      });

  MonthPredict.fromJson(Map<String, dynamic> json) {
    month = json['Month'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Month'] = this.month;
    return data;
  }
}
