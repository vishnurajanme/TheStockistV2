/// FeedbackForm is a data class which stores data fields of Feedback.
class FeedbackForm {
  String name;
  String purchase;
  String sale;
  String remark;
  String date;
  String profit;
  String net;

  FeedbackForm(this.name, this.purchase, this.sale, this.remark, this.date, this.profit, this.net);

  factory FeedbackForm.fromJson(dynamic json) {
    return FeedbackForm(
        "${json['name']}",
        "${json['purchase']}",
        "${json['sale']}",
        "${json['remark']}",
      "${json['date']}",
      "${json['profit']}",
      "${json['net']}"
    );
  }

  // Method to make GET parameters.
  Map toJson() => {
        'name': name,
        'purchase': purchase,
        'sale': sale,
        'remark': remark,
    'date': date,
    'profit': profit,
    'net': net

      };
}
