class ScrapModel {
  final String? scrap_id;
  final String scrap_ctg;
  final String scrap_sub_ctg;
  // final String sub_ctg_icon;
  // final String scrap_title;
  final String scrap_description;
  final String scrap_weight;
  double scrap_price;
  final String phone_number;
  // final List <XFile>? scrap_images;
  List? scrap_images;
  final String scrap_city;
  final String scrap_address;
  bool is_accepted;
  String status;
  bool is_sold;
  String TimeStamp;

  ScrapModel(
      {required this.scrap_id,
      required this.scrap_ctg,
      required this.scrap_sub_ctg,
      // required this.sub_ctg_icon,
      // required this.scrap_title,
      required this.scrap_description,
      required this.scrap_weight,
      this.scrap_price = 0,
      required this.phone_number,
      required this.scrap_images,
      required this.scrap_city,
      required this.scrap_address,
      this.is_accepted = false,
      this.status = "Under Inspection",
      this.is_sold = false,
      this.TimeStamp = "0000-00-00"});
}
