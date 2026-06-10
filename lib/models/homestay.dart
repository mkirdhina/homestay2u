class Homestay {
  int? id;
  String? name;
  String? state;
  String? district;
  String? description;
  String? price;
  String? imageUrl;

  Homestay({
    this.id,
    this.name,
    this.state,
    this.district,
    this.description,
    this.price,
    this.imageUrl,
  });

  Homestay.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id'].toString());

    name = json['name']?.toString() ?? 'No name';
    state = json['state']?.toString() ?? 'No state';
    district = json['district']?.toString() ?? 'No district';

    description = json['description']?.toString() ??
        json['details']?.toString() ??
        'No description';

    price = json['price']?.toString() ??
        json['rate']?.toString() ??
        json['price_per_night']?.toString() ??
        json['daily_rate']?.toString() ??
        json['rental_price']?.toString() ??
        json['fee']?.toString() ??
        json['min_price']?.toString() ??
        json['price_range']?.toString() ??
        'Not stated';

    imageUrl = json['image_url']?.toString() ??
        json['image']?.toString() ??
        json['photo']?.toString() ??
        json['thumbnail']?.toString() ??
        '';
  }
}