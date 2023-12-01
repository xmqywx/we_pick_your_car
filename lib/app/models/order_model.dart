class Order {
  int? id;
  String? createTime;
  String? updateTime;
  int? carID;
  dynamic yardID;
  String? customerID;
  dynamic driverID;
  int? status;
  dynamic overrideEmailAddress;
  String? pickupAddress;
  String? pickupAddressState;
  String? pickupAddressLat;
  String? pickupAddressLng;
  String? payMethod;
  dynamic overridePhoneNumber;
  String? recommendedPrice;
  String? actualPaymentPrice;
  dynamic expectedDate;
  String? note;
  String? departmentId;
  int? gotPapers;
  int? gotKey;
  int? gotOwner;
  int? gotRunning;
  int? gotLicense;
  int? gotFlat;
  int? gotEasy;
  int? gotBusy;
  String? modelNumber;
  String? carColor;
  String? imageFileDir;
  String? signature;
  dynamic invoice;
  dynamic emailStatus;
  String? aboutUs;
  dynamic deposit;
  String? customerName;
  String? bankName;
  dynamic bsbNo;
  dynamic accountsNo;
  String? totalAmount;
  String? gstAmount;
  dynamic deduction;
  String? comments;
  String? commentText;
  dynamic secondaryID;
  String? gstStatus;
  String? depositPayMethod;
  String? source;
  dynamic askingPrice;
  String? paymentRemittance;
  String? quoteNumber;
  dynamic registrationDoc;
  dynamic driverLicense;
  dynamic vehiclePhoto;
  String? createBy;
  bool? allowUpload;
  dynamic kilometers;
  String? gst;
  String? priceExGST;

  Order(
      {this.id,
      this.createTime,
      this.updateTime,
      this.carID,
      this.yardID,
      this.customerID,
      this.driverID,
      this.status,
      this.overrideEmailAddress,
      this.pickupAddress,
      this.pickupAddressState,
      this.pickupAddressLat,
      this.pickupAddressLng,
      this.payMethod,
      this.overridePhoneNumber,
      this.recommendedPrice,
      this.actualPaymentPrice,
      this.expectedDate,
      this.note,
      this.departmentId,
      this.gotPapers,
      this.gotKey,
      this.gotOwner,
      this.gotRunning,
      this.gotLicense,
      this.gotFlat,
      this.gotEasy,
      this.gotBusy,
      this.modelNumber,
      this.carColor,
      this.imageFileDir,
      this.signature,
      this.invoice,
      this.emailStatus,
      this.aboutUs,
      this.deposit,
      this.customerName,
      this.bankName,
      this.bsbNo,
      this.accountsNo,
      this.totalAmount,
      this.gstAmount,
      this.deduction,
      this.comments,
      this.commentText,
      this.secondaryID,
      this.gstStatus,
      this.depositPayMethod,
      this.source,
      this.askingPrice,
      this.paymentRemittance,
      this.quoteNumber,
      this.registrationDoc,
      this.driverLicense,
      this.vehiclePhoto,
      this.createBy,
      this.allowUpload,
      this.kilometers,
      this.gst,
      this.priceExGST});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    carID = json['carID'];
    yardID = json['yardID'];
    customerID = json['customerID'];
    driverID = json['driverID'];
    status = json['status'];
    overrideEmailAddress = json['overrideEmailAddress'];
    pickupAddress = json['pickupAddress'];
    pickupAddressState = json['pickupAddressState'];
    pickupAddressLat = json['pickupAddressLat'];
    pickupAddressLng = json['pickupAddressLng'];
    payMethod = json['payMethod'];
    overridePhoneNumber = json['overridePhoneNumber'];
    recommendedPrice = json['recommendedPrice'];
    actualPaymentPrice = json['actualPaymentPrice'];
    expectedDate = json['expectedDate'];
    note = json['note'];
    departmentId = json['departmentId'];
    gotPapers = json['gotPapers'];
    gotKey = json['gotKey'];
    gotOwner = json['gotOwner'];
    gotRunning = json['gotRunning'];
    gotLicense = json['gotLicense'];
    gotFlat = json['gotFlat'];
    gotEasy = json['gotEasy'];
    gotBusy = json['gotBusy'];
    modelNumber = json['modelNumber'];
    carColor = json['carColor'];
    imageFileDir = json['imageFileDir'];
    signature = json['signature'];
    invoice = json['invoice'];
    emailStatus = json['emailStatus'];
    aboutUs = json['aboutUs'];
    deposit = json['deposit'];
    customerName = json['customerName'];
    bankName = json['bankName'];
    bsbNo = json['bsbNo'];
    accountsNo = json['accountsNo'];
    totalAmount = json['totalAmount'];
    gstAmount = json['gstAmount'];
    deduction = json['deduction'];
    comments = json['comments'];
    commentText = json['commentText'];
    secondaryID = json['secondaryID'];
    gstStatus = json['gstStatus'];
    depositPayMethod = json['depositPayMethod'];
    source = json['source'];
    askingPrice = json['askingPrice'];
    paymentRemittance = json['paymentRemittance'];
    quoteNumber = json['quoteNumber'];
    registrationDoc = json['registrationDoc'];
    driverLicense = json['driverLicense'];
    vehiclePhoto = json['vehiclePhoto'];
    createBy = json['createBy'];
    allowUpload = json['allowUpload'];
    kilometers = json['kilometers'];
    gst = json['gst'];
    priceExGST = json['priceExGST'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['createTime'] = createTime;
    data['updateTime'] = updateTime;
    data['carID'] = carID;
    data['yardID'] = yardID;
    data['customerID'] = customerID;
    data['driverID'] = driverID;
    data['status'] = status;
    data['overrideEmailAddress'] = overrideEmailAddress;
    data['pickupAddress'] = pickupAddress;
    data['pickupAddressState'] = pickupAddressState;
    data['pickupAddressLat'] = pickupAddressLat;
    data['pickupAddressLng'] = pickupAddressLng;
    data['payMethod'] = payMethod;
    data['overridePhoneNumber'] = overridePhoneNumber;
    data['recommendedPrice'] = recommendedPrice;
    data['actualPaymentPrice'] = actualPaymentPrice;
    data['expectedDate'] = expectedDate;
    data['note'] = note;
    data['departmentId'] = departmentId;
    data['gotPapers'] = gotPapers;
    data['gotKey'] = gotKey;
    data['gotOwner'] = gotOwner;
    data['gotRunning'] = gotRunning;
    data['gotLicense'] = gotLicense;
    data['gotFlat'] = gotFlat;
    data['gotEasy'] = gotEasy;
    data['gotBusy'] = gotBusy;
    data['modelNumber'] = modelNumber;
    data['carColor'] = carColor;
    data['imageFileDir'] = imageFileDir;
    data['signature'] = signature;
    data['invoice'] = invoice;
    data['emailStatus'] = emailStatus;
    data['aboutUs'] = aboutUs;
    data['deposit'] = deposit;
    data['customerName'] = customerName;
    data['bankName'] = bankName;
    data['bsbNo'] = bsbNo;
    data['accountsNo'] = accountsNo;
    data['totalAmount'] = totalAmount;
    data['gstAmount'] = gstAmount;
    data['deduction'] = deduction;
    data['comments'] = comments;
    data['commentText'] = commentText;
    data['secondaryID'] = secondaryID;
    data['gstStatus'] = gstStatus;
    data['depositPayMethod'] = depositPayMethod;
    data['source'] = source;
    data['askingPrice'] = askingPrice;
    data['paymentRemittance'] = paymentRemittance;
    data['quoteNumber'] = quoteNumber;
    data['registrationDoc'] = registrationDoc;
    data['driverLicense'] = driverLicense;
    data['vehiclePhoto'] = vehiclePhoto;
    data['createBy'] = createBy;
    data['allowUpload'] = allowUpload;
    data['kilometers'] = kilometers;
    data['gst'] = gst;
    data['priceExGST'] = priceExGST;
    return data;
  }
}
