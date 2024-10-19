class Event {
  String? title;
  String? time;
  String? sport;
  int? price;
  String? gender;
  String? location;
  String? description;
  int? numberOfPeopleSignedUp;
  int? maxNumberOfPeople;
  String? key;

  Event({
    this.title,
    this.time,
    this.sport,
    this.price,
    this.gender,
    this.location,
    this.description,
    this.numberOfPeopleSignedUp,
    this.maxNumberOfPeople,
    this.key,
  });

  //JSON map => Event object
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'],
      time: json['time'],
      sport: json['sport'],
      price: json['price'],
      gender: json['gender'],
      location: json['location'],
      description: json['description'],
      numberOfPeopleSignedUp: json['numberOfPeopleSignedUp'],
      maxNumberOfPeople: json['maxNumberOfPeople'],
      key: json['key'],
    );
  }

  //Event object => JSON map
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'time': time,
      'sport': sport,
      'price': price,
      'gender': gender,
      'location': location,
      'description': description,
      'numberOfPeopleSignedUp': numberOfPeopleSignedUp,
      'maxNumberOfPeople': maxNumberOfPeople,
    };
  }
}
