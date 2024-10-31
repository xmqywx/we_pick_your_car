class Stats {
  ForRecyclingCars? forRecyclingCars;
  ForPartsCars? forPartsCars;
  AllCars? allCars;

  Stats({this.forRecyclingCars, this.forPartsCars, this.allCars});

  Stats.fromJson(Map<String, dynamic> json) {
    forRecyclingCars = json['forRecyclingCars'] != null
        ? ForRecyclingCars?.fromJson(json['forRecyclingCars'])
        : null;
    forPartsCars = json['forPartsCars'] != null
        ? ForPartsCars?.fromJson(json['forPartsCars'])
        : null;
    allCars =
        json['allCars'] != null ? AllCars?.fromJson(json['allCars']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (forRecyclingCars != null) {
      data['forRecyclingCars'] = forRecyclingCars?.toJson();
    }
    if (forPartsCars != null) {
      data['forPartsCars'] = forPartsCars?.toJson();
    }
    if (allCars != null) {
      data['allCars'] = allCars?.toJson();
    }
    return data;
  }
}

class ForRecyclingCars {
  int? total;
  int? disassembled;
  Parts? parts;

  ForRecyclingCars({this.total, this.disassembled, this.parts});

  ForRecyclingCars.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    disassembled = json['disassembled'];
    parts = json['parts'] != null ? Parts?.fromJson(json['parts']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['total'] = total;
    data['disassembled'] = disassembled;
    if (parts != null) {
      data['parts'] = parts?.toJson();
    }
    return data;
  }
}

class Parts {
  int? total;
  int? dismentaled;

  Parts({this.total, this.dismentaled});

  Parts.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    dismentaled = json['dismentaled'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['total'] = total;
    data['dismentaled'] = dismentaled;
    return data;
  }
}

class ForPartsCars {
  int? total;
  int? disassembled;
  Parts? parts;

  ForPartsCars({this.total, this.disassembled, this.parts});

  ForPartsCars.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    disassembled = json['disassembled'];
    parts = json['parts'] != null ? Parts?.fromJson(json['parts']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['total'] = total;
    data['disassembled'] = disassembled;
    if (parts != null) {
      data['parts'] = parts?.toJson();
    }
    return data;
  }
}

class AllCars {
  int? total;
  int? disassembled;
  Parts? parts;

  AllCars({this.total, this.disassembled, this.parts});

  AllCars.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    disassembled = json['disassembled'];
    parts = json['parts'] != null ? Parts?.fromJson(json['parts']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['total'] = total;
    data['disassembled'] = disassembled;
    if (parts != null) {
      data['parts'] = parts?.toJson();
    }
    return data;
  }
}
