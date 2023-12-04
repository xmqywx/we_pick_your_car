import 'package:car_wrecker/app/color/colors.dart';
import 'package:get/get.dart';
import '../../../api/driver.dart';
import '../../../api/order.dart';
import '../../../models/customer_model.dart';
import '../../../models/secondary_person_model.dart';
import 'package:flutter/material.dart';
import '../../../models/order_model.dart';
import '../../../models/car_model.dart';
import '../../../models/job_model.dart';
import '../../../services/screen_adapter.dart';
import '../../../widget/generate_signature.dart';
import '../../../services/format_date.dart';
import '../../../services/handle_status.dart';
import '../../../widget/toast.dart';
import '../../../text/paragraph.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/src/core.dart';
import 'dart:async';
import 'dart:math';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import '../templates/JobFormContainer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

const apiKey = 'AIzaSyD_Mb2rL5VtaxB0ah1atdqgrwqyaUNU3u4';

class JobDetailsController extends GetxController
    with GetSingleTickerProviderStateMixin, WidgetsBindingObserver {
  RxBool isKeyboardOpen = false.obs;
  //TODO: Implement JobDetailsController
  RxMap arguments = {}.obs;
  RxBool isEdit = false.obs;
  RxBool hasError = false.obs;
  ScrollController listScrollController = ScrollController();
  late TabController tabController;
  RxString currentStatus = "".obs;
  // order =======
  RxMap<String, dynamic> orderInfoForm = RxMap<String, dynamic>({});
  var orderInfo = Order().obs;
  orderFormDataChange(key, value) {
    orderInfoForm.value[key] = value;
    orderInfoForm.refresh();
  }

  // job =======
  RxList otherJobs = [].obs;
  var jobInfo = Job().obs;
  RxMap<String, dynamic> jobInfoForm = RxMap<String, dynamic>({});
  jobFormDataChange(key, value) {
    jobInfoForm.value[key] = value;
    jobInfoForm.refresh();
  }

  // payment =======
  final paymentFormKey = GlobalKey<FormState>();
  RxList<Map<String, dynamic>> paymentFormList =
      RxList<Map<String, dynamic>>([]);
  final fieldQuoteKey = GlobalKey<FormFieldState>();
  RxBool isBankDetailShow = false.obs;
  setPaymentFormList() {
    bool depositDisabled =
        !isEdit.value || isNegative(orderInfoForm.value['actualPaymentPrice']);
    bool depositPMHidden = isNegative(orderInfoForm.value['deposit']);
    bool deductionDisabled =
        !isEdit.value || isNegative(orderInfoForm.value['actualPaymentPrice']);
    orderInfoForm.value['totalAmount'] =
        formatterToNum(orderInfoForm.value['actualPaymentPrice']) -
            formatterToNum(orderInfoForm.value['deduction']) -
            formatterToNum(orderInfoForm.value['deposit']);
    orderInfo.value.totalAmount = orderInfoForm.value['totalAmount'].toString();

    void calculateGST() {
      double price =
          double.tryParse(orderInfoForm.value['totalAmount'].toString()) ?? 0;
      String gstStatus = orderInfoForm.value['gstStatus'] ?? '';
      double priceExGST, priceIncGST, gst;

      if (gstStatus == 'inc') {
        priceExGST = double.parse((price / 1.1).toStringAsFixed(2));
        gst = double.parse((price - priceExGST).toStringAsFixed(2));
        priceIncGST = price;
        orderInfoForm.value['gstAmount'] = priceIncGST;
        orderInfoForm.value['priceExGST'] = priceExGST;
        orderInfoForm.value['gst'] = gst;
      } else if (gstStatus == 'ex') {
        priceExGST = price;
        gst = double.parse((price * 0.1).toStringAsFixed(2));
        priceIncGST = double.parse((price * 1.1).toStringAsFixed(2));
        orderInfoForm.value['gstAmount'] = priceIncGST;
        orderInfoForm.value['priceExGST'] = priceExGST;
        orderInfoForm.value['gst'] = gst;
      }
    }

    calculateGST();
    paymentFormList.value = [
      {
        "label": "Payment Method",
        "prop": "payMethod",
        "disabled": !isEdit.value,
        "value": orderInfo.value.payMethod ?? "",
        "component": {
          "type": "select",
          "options": [
            {"label": "Cheque", "value": "Cheque"},
            {"label": "Cash", "value": "Cash"},
            {"label": "Direct Credit", "value": "Direct Credit"}
          ],
          "placeholder": "Please input the payment method."
        },
        "rules": [
          // {"require": true, "message": "Payment Method cannot be empty."}
        ],
        "triggeredOnChange": (data) {
          setPaymentFormList();
          print(paymentFormList.value[2]);
        }
      },
      {
        "label": "Quote",
        "prop": "actualPaymentPrice",
        "disabled": !isEdit.value ||
            (orderInfoForm.value['payMethod'] == null ||
                orderInfoForm.value['payMethod'] == ''),
        "value": orderInfo.value.actualPaymentPrice ?? "",
        "component": {
          "type": "input",
          "fieldType": "number",
          "trigger": "change",
          "placeholder": "Please input the quote."
        },
        "fieldKey": fieldQuoteKey,
        "rules": [
          {"require": true, "message": "Quote cannot be empty."},
          // if (isEdit.value)
          //   {
          //     "validator": (quote) async {
          //       String? valid = validateNegativeValue(quote, 'Quote');
          //       print(valid);
          //       if (valid != null) return valid;
          //     },
          //     "message": "The container number has already been used.",
          //   },
          {
            "pattern": r'^[0-9]*\.?[0-9]+$',
            "message": "Quote cannot be negative."
          }
        ],
        "triggeredOnChange": (data) {
          setPaymentFormList();
        }
      },
      {
        "label": "Deposit",
        "prop": "deposit",
        "disabled": depositDisabled,
        "value": orderInfo.value.deposit ?? "",
        "component": {
          "type": "input",
          "fieldType": "number",
          "trigger": "change",
          "placeholder": "Please input the deposit."
        },
        "rules": [
          // {"require": true, "message": "Deposit cannot be empty."},
          // if (!isEdit.value)
          //   {
          //     "validator": (deposit) async {
          //       if (deposit == '' || deposit == null) {
          //         return null;
          //       }
          //     },
          //     "message": "The container number has already been used.",
          //   },
          {
            "pattern": r'^[0-9]*\.?[0-9]+$',
            "message": "Deposit cannot be negative."
          },
          {
            "judge": formatterToNum(orderInfoForm.value['deposit']) +
                    formatterToNum(orderInfoForm.value['deduction']) >
                formatterToNum(orderInfoForm.value['actualPaymentPrice']),
            "message": "Deposit cannot be greater than quote."
          },
        ],
        "triggeredOnChange": (data) {
          setPaymentFormList();
        },
      },
      {
        "label": "Deposit Payment Method",
        "prop": "depositPayMethod",
        "disabled": !isEdit.value,
        "hidden": depositPMHidden,
        "value": orderInfo.value.depositPayMethod ?? "",
        "component": {
          "type": "select",
          "options": [
            {"label": "Cheque", "value": "Cheque"},
            {"label": "Cash", "value": "Cash"},
            {"label": "Direct Credit", "value": "Direct Credit"}
          ],
          "placeholder": "Please input the deposit payment method."
        },
        "rules": [
          {
            "require": true,
            "message": "Deposit Payment Method cannot be empty."
          }
        ]
      },
      {
        "label": "Deduction",
        "prop": "deduction",
        "disabled": deductionDisabled,
        "value": orderInfo.value.deduction ?? "",
        "component": {
          "type": "input",
          "trigger": "change",
          "fieldType": "number",
          "placeholder": "Please input the deduction."
        },
        "rules": [
          // {"require": true, "message": "Deduction cannot be empty."},
          {
            "pattern": r'^[0-9]*\.?[0-9]+$',
            "message": "Deduction cannot be negative."
          },
          {
            "judge": formatterToNum(orderInfoForm.value['deposit']) +
                    formatterToNum(orderInfoForm.value['deduction']) >
                formatterToNum(orderInfoForm.value['actualPaymentPrice']),
            "message": "Deposit cannot be greater than quote."
          },
        ],
        "triggeredOnChange": (data) {
          setPaymentFormList();
        },
      },
      {
        "label": "Amount",
        "prop": "totalAmount",
        "disabled": true,
        "value": orderInfo.value.totalAmount ?? "",
        "component": {
          "type": "input",
          "placeholder": "Please input the amount."
        },
        "rules": [
          {"require": true, "message": "Amount cannot be empty."}
        ]
      },
      {
        "label": "GST status",
        "prop": "gstStatus",
        "disabled": !isEdit.value,
        "value": orderInfo.value.gstStatus ?? "",
        "component": {
          "type": "select",
          "options": [
            {"label": "Price includes GST", "value": "inc"},
            {"label": "Price excludes GST", "value": "ex"}
          ],
          "placeholder": "Please input the GST status."
        },
        "rules": [
          {"require": true, "message": "GST status cannot be empty."}
        ],
        "triggeredOnChange": (data) {
          setPaymentFormList();
        },
      },
      {
        "label": "GST Results",
        "component": {"type": "widget"},
        "widget": Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: ScreenAdapter.width(35)),
            padding: EdgeInsets.all(ScreenAdapter.width(25)),
            decoration: BoxDecoration(
                border: Border.all(
              width: ScreenAdapter.width(1),
            )),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyParagraph(text: 'Price(ex GST)'),
                    MyParagraph(text: '${orderInfoForm.value["priceExGST"]}'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyParagraph(text: 'GST'),
                    MyParagraph(text: '${orderInfoForm.value["gst"]}'),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyParagraph(text: 'Price(inc GST)'),
                    MyParagraph(text: '${orderInfoForm.value["gstAmount"]}'),
                  ],
                ),
              ],
            ))
      },
      {
        "label": "Add Banking Details",
        "component": {"type": "widget"},
        "hidden": !isEdit.value,
        "widget": InkWell(
          child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: ScreenAdapter.width(35)),
              child: MyParagraph(
                text: isBankDetailShow.value
                    ? 'Close Banking Details'
                    : 'Add Banking Details',
                color: AppColors.themeTextColor4,
                align: TextAlign.right,
              )),
          onTap: toChangeBankShow,
        )
      },
      {
        "label": "Customer Name",
        "prop": "customerName",
        "disabled": !isEdit.value,
        "hidden": !isBankDetailShow.value,
        "value": orderInfo.value.customerName ?? "",
        "component": {
          "type": "input",
          "placeholder": "Please input the customer name."
        },
        "rules": [
          {"require": true, "message": "Customer Name cannot be empty."}
        ]
      },
      {
        "label": "Bank Name",
        "prop": "bankName",
        "disabled": !isEdit.value,
        "hidden": !isBankDetailShow.value,
        "value": orderInfo.value.bankName ?? "",
        "component": {
          "type": "input",
          "placeholder": "Please input the bank name."
        },
        "rules": [
          {"require": true, "message": "Bank Name cannot be empty."}
        ]
      },
      {
        "label": "BSB No",
        "prop": "bsbNo",
        "disabled": !isEdit.value,
        "hidden": !isBankDetailShow.value,
        "value": orderInfo.value.bsbNo,
        "component": {
          "type": "input",
          "fieldType": "number",
          "placeholder": "Please input the BSB No."
        },
        "rules": [
          {"require": true, "message": "BSB No cannot be empty."}
        ]
      },
      {
        "label": "Accounts No",
        "prop": "accountsNo",
        "disabled": !isEdit.value,
        "hidden": !isBankDetailShow.value,
        "value": orderInfo.value.accountsNo,
        "component": {
          "type": "input",
          "fieldType": "number",
          "placeholder": "Please input the Accounts No."
        },
        "rules": [
          {"require": true, "message": "BSB No cannot be empty."}
        ]
      }
    ];
    paymentFormList.refresh();
  }

  bool isNegative(dynamic value) {
    if (value is num) {
      return value <= 0;
    } else if (value is String) {
      double? parsedValue = double.tryParse(value);
      return parsedValue != null && parsedValue <= 0;
    } else {
      return true; // 其他类型默认返回 true
    }
  }

  String? validateNegativeValue(dynamic value, String label) {
    if (value != null && value is num && value < 0) {
      return '$label cannot be negative.';
    }

    if (value is String) {
      double? parsedValue = double.tryParse(value);
      if (parsedValue != null && parsedValue < 0) {
        return '$label cannot be negative.';
      }
    }

    return null;
  }

  num formatterToNum(value) {
    if (value is num) return value;
    if (value is String) {
      return double.parse(value);
    }
    return 0;
  }

  toChangeBankShow() {
    isBankDetailShow.value = !isBankDetailShow.value;
    if (isBankDetailShow.value == false) {
      // customerName bankName bsbNo accountsNo
      orderInfoForm.value['customerName'] = '';
      orderInfo.value.customerName = '';
      orderInfoForm.value['bankName'] = '';
      orderInfo.value.bankName = '';
      orderInfoForm.value['bsbNo'] = null;
      orderInfo.value.bsbNo = null;
      orderInfoForm.value['accountsNo'] = null;
      orderInfo.value.accountsNo = null;
    }
    setPaymentFormList();
  }

  // questionnaire =======
  final questionnaireFormKey = GlobalKey<FormState>();
  RxList<Map<String, dynamic>> questionnaireFormList =
      RxList<Map<String, dynamic>>([]);

  bool isOther(String value, List<String> radioScope) {
    if (radioScope.contains(value)) {
      return false;
    } else {
      return true;
    }
  }

  setQuestionnaireFormList() {
    questionnaireFormList.value = [
      {
        "label": "Have you got the Registration Papers?",
        "prop": "gotPapers",
        "disabled": !isEdit.value,
        "value": orderInfo.value.gotPapers ?? 0,
        "component": {
          "type": "switch",
          "placeholder": "Please input if you have the Registration Papers."
        },
        "rules": [
          {"require": true, "message": "Registration Papers cannot be empty."}
        ]
      },
      {
        "label": "Have you got your License?",
        "prop": "gotLicense",
        "disabled": !isEdit.value,
        "value": orderInfo.value.gotLicense ?? 0,
        "component": {
          "type": "switch",
          "placeholder": "Please input if you have your License."
        },
        "rules": [
          {"require": true, "message": "License cannot be empty."}
        ]
      },
      {
        "label": "Have you got the Key?",
        "prop": "gotKey",
        "disabled": !isEdit.value,
        "value": orderInfo.value.gotKey ?? 0,
        "component": {
          "type": "switch",
          "placeholder": "Please input if you have the Key."
        },
        "rules": [
          {"require": true, "message": "Key cannot be empty."}
        ]
      },
      {
        "label": "Are you the Registered Owner?",
        "prop": "gotOwner",
        "disabled": !isEdit.value,
        "value": orderInfo.value.gotOwner ?? 0,
        "component": {
          "type": "switch",
          "placeholder": "Please input if you are the Registered Owner."
        },
        "rules": [
          {"require": true, "message": "Registered Owner cannot be empty."}
        ]
      },
      {
        "label": "Is the vehicle Running?",
        "prop": "gotRunning",
        "disabled": !isEdit.value,
        "value": orderInfo.value.gotRunning ?? 0,
        "component": {
          "type": "switch",
          "placeholder": "Please input if the vehicle is Running."
        },
        "rules": [
          {"require": true, "message": "Running status cannot be empty."}
        ]
      },
      {
        "label": "Is the vehicle in an Easy Position to pick up?",
        "prop": "gotEasy",
        "disabled": !isEdit.value,
        "value": orderInfo.value.gotEasy ?? 0,
        "component": {
          "type": "switch",
          "placeholder":
              "Please input if the vehicle is in an Easy Position to pick up."
        },
        "rules": [
          {"require": true, "message": "Easy position status cannot be empty."}
        ]
      },
      {
        "label": "Busy Traffic Road?",
        "prop": "gotBusy",
        "disabled": !isEdit.value,
        "value": orderInfo.value.gotBusy ?? 0,
        "component": {
          "type": "switch",
          "placeholder": "Please input if the Traffic Road is busy."
        },
        "rules": [
          {
            "require": true,
            "message": "Busy Traffic Road status cannot be empty."
          }
        ]
      },
      {
        "label": "Any Flat Tires?",
        "prop": "gotFlat",
        "disabled": !isEdit.value,
        "value": orderInfo.value.gotFlat ?? 0,
        "component": {
          "type": "switch",
          "placeholder": "Please input if there are any Flat Tires."
        },
        "rules": [
          {"require": true, "message": "Flat Tires status cannot be empty."}
        ]
      },
      {
        "label": "Source",
        "prop": "source",
        "disabled": !isEdit.value,
        "value": orderInfo.value.source ?? "",
        "component": {
          "type": "select",
          "options": [
            {'label': 'Phone Call', 'value': 'Phone Call'},
            {'label': 'Message', 'value': 'Message'},
            {'label': 'Email', 'value': 'Email'},
            {'label': 'Facebook', 'value': 'Facebook'},
            {'label': 'Gumtree', 'value': 'Gumtree'},
            {'label': 'Other', 'value': 'Other'},
          ],
          "placeholder": "Please input the deposit payment method."
        },
        "rules": [
          {
            "require": true,
            "message": "Deposit Payment Method cannot be empty."
          }
        ]
      },
      {
        "label": "Comments",
        "prop": "commentText",
        "disabled": !isEdit.value,
        "value": orderInfo.value.commentText ?? '',
        "component": {
          "type": "textarea",
          "placeholder": "Please input the comments."
        },
        "rules": []
      },
      {
        "label": "How much are you expecting for the car?",
        "prop": "askingPrice",
        "disabled": !isEdit.value,
        "value": orderInfo.value.askingPrice,
        "component": {
          "type": "input",
          "fieldType": "number",
          "placeholder": "Please input the price."
        },
        "rules": []
      },
    ];
    questionnaireFormList.refresh();
  }

  // attachments =======
  final attachmentsFormKey = GlobalKey<FormState>();
  RxList<Map<String, dynamic>> attachmentsFormList =
      RxList<Map<String, dynamic>>([]);
  setAttachmentsFormList() {
    attachmentsFormList.value = [
      {
        "label": "Vehicle",
        "prop": "imageFileDir",
        "disabled": currentStatus.value == 'Complete',
        "value": orderInfo.value.imageFileDir ?? '[]',
        "component": {
          "type": "uploadImage",
        },
        "rules": [],
        "triggeredOnChange": (data) {
          toUpdateFile();
        }
      },
      {
        "label": "Payment remittance",
        "prop": "paymentRemittance",
        "disabled": currentStatus.value == 'Complete',
        "value": orderInfo.value.paymentRemittance ?? '[]',
        "component": {
          "type": "uploadImage",
        },
        "rules": [],
        "triggeredOnChange": (data) {
          toUpdateFile();
        }
      },
      {
        "label": "Driver License",
        "prop": "driverLicense",
        "disabled": currentStatus.value == 'Complete',
        "value": orderInfo.value.driverLicense ?? '[]',
        "component": {
          "type": "uploadImage",
        },
        "rules": [],
        "triggeredOnChange": (data) {
          toUpdateFile();
        }
      },
      {
        "label": "Registration paper",
        "prop": "registrationDoc",
        "disabled": currentStatus.value == 'Complete',
        "value": orderInfo.value.registrationDoc ?? '[]',
        "component": {
          "type": "uploadImage",
        },
        "rules": [],
        "triggeredOnChange": (data) {
          toUpdateFile();
        }
      }
    ];
    attachmentsFormList.refresh();
  }

  // schedule =======
  final scheduleFormKey = GlobalKey<FormState>();
  RxList<Map<String, dynamic>> scheduleFormList =
      RxList<Map<String, dynamic>>([]);
  setScheduleFormList() {
    scheduleFormList.value = [
      {
        "label": "Pickup Address",
        "prop": "pickupAddress",
        "disabled": !isEdit.value,
        "value": orderInfo.value.pickupAddress ?? '',
        "component": {
          "type": "widget",
          "placeholder": "Please input the pickup address."
        },
        "rules": [
          {"require": true, "message": "Pickup address cannot be empty."}
        ],
        "widget": InkWell(
          onTap: isEdit.value
              ? googleAutoCompleteOnTap
              : () {
                  if (orderInfoForm.value['pickupAddress'] != null)
                    tapToViewMap(orderInfoForm.value['pickupAddress']);
                },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: "Pickup Address",
              labelStyle: TextStyle(fontFamily: 'Roboto-Medium'),
              hintText: "Please input the pickup address.",
            ),
            child:
                MyParagraph(text: orderInfoForm.value['pickupAddress'] ?? ''),
          ),
        )
      },
      // {
      //   "label": "Preferred Pick Up Time",
      //   "prop": "expectedDate",
      //   "disabled": true,
      //   "hidden": orderInfo.value.expectedDate == null,
      //   "value": orderInfo.value.expectedDate ?? '',
      //   "component": {
      //     "type": "datepicker",
      //     "placeholder": "Please input the Preferred Pick Up Time."
      //   },
      //   "rules": [
      //     {
      //       "require": true,
      //       "message": "Preferred Pick Up Time cannot be empty."
      //     }
      //   ]
      // },
      {
        "label": "Schedule date time range",
        "prop": "scheduleDateTimeRange",
        "disabled": true,
        "value": handleTimeRange(),
        "component": {
          "type": "input",
          "placeholder": "Please input the Preferred Pick Up Time."
        },
        "rules": [
          {
            "require": true,
            "message": "Preferred Pick Up Time cannot be empty."
          }
        ]
      }
    ];
    scheduleFormList.refresh();
  }

  googleAutoCompleteOnTap() async {
    // 设置自动完成选项
    if (Get.context != null) {
      var prediction = await PlacesAutocomplete.show(
        offset: 0,
        radius: 1000,
        types: [],
        strictbounds: false,
        region: "ar",
        context: Get.context!,
        apiKey: apiKey, // 替换为您的Google Maps API密钥
        mode: Mode.overlay, // 显示在覆盖层上方
        language: 'en', // 设置所需的语言
        components: [Component(Component.country, 'au')], // 限制AU
      );

      if (prediction != null) {
        // 提取所需的位置信息，如地址、经纬度等
        GoogleMapsPlaces _places = GoogleMapsPlaces(
          apiKey: apiKey,
          apiHeaders: await GoogleApiHeaders().getHeaders(),
        );
        orderInfoForm.value['pickupAddress'] = prediction.description;
        if (prediction.placeId != null) {
          PlacesDetailsResponse detail =
              await _places.getDetailsByPlaceId(prediction.placeId ?? '');
          // detail.result.
          orderInfoForm.value['pickupAddressLat'] =
              detail.result.geometry?.location.lat.toString();
          orderInfoForm.value['pickupAddressLng'] =
              detail.result.geometry?.location.lng.toString();
          setScheduleFormList();
        }

        // 在此处处理选中的位置信息
      }
    }

    // 处理选中的位置
  }

  String handleTimeRange() {
    return '${handleFormatDateEEEEMMMMdyat(jobInfo.value.schedulerStart)}${handleFormathmma(jobInfo.value.schedulerStart)}-${handleFormathmma(jobInfo.value.schedulerEnd)}';
  }

  // customer =======
  final customerFormKey = GlobalKey<FormState>();
  RxList<Map<String, dynamic>> customerFormList =
      RxList<Map<String, dynamic>>([]);
  RxMap<String, dynamic> customerInfoForm = RxMap<String, dynamic>({});
  var customerInfo = Customer().obs;
  setCustomerFormList() {
    customerFormList.value = [
      {
        "label": "Full Name",
        "prop": "firstName",
        "disabled": !isEdit.value,
        "value": customerInfo.value.firstName ?? "",
        "component": {
          "type": "input",
          "placeholder": "Please input the full name."
        },
        "rules": [
          {"require": true, "message": "Full name cannot be empty."}
        ]
      },
      {
        "label": "Phone Number",
        "prop": "phoneNumber",
        "disabled": !isEdit.value,
        "value": customerInfo.value.phoneNumber ?? "",
        "component": {
          "type": "input",
          "trigger": "change",
          "fieldType": "number",
          "placeholder": "Please input the phone number."
        },
        "rules": [
          {"require": true, "message": "Phone number cannot be empty."}
        ]
      },
      {
        "label": "Secondary Phone Number",
        "prop": "secNumber",
        "disabled": !isEdit.value,
        "value": customerInfo.value.secNumber ?? "",
        "component": {
          "type": "input",
          "trigger": "change",
          "fieldType": "number",
          "placeholder": "Please input the secondary phone number."
        },
        "rules": [
          // {
          //   "require": true,
          //   "message": "Secondary phone number cannot be empty."
          // }
        ]
      },
      {
        "label": "Email",
        "prop": "emailAddress",
        "disabled": !isEdit.value,
        "value": customerInfo.value.emailAddress ?? "",
        "component": {
          "type": "input",
          "trigger": "change",
          "placeholder": "Please input the email."
        },
        "rules": [
          {
            "pattern": r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
            "message": "Please enter the correct email format."
          }
        ]
      },
      {
        "label": "Residential Address",
        "prop": "address",
        "disabled": !isEdit.value,
        "value": customerInfo.value.address ?? "",
        "component": {
          "type": "textarea",
          "placeholder": "Please input the residential address."
        },
        "rules": [
          // {"require": true, "message": "Residential address cannot be empty."}
        ]
      },
      {
        "label": "Driver Licence / Photo ID",
        "prop": "licence",
        "disabled": !isEdit.value,
        "value": customerInfo.value.licence ?? "",
        "component": {
          "type": "input",
          "placeholder": "Please input the driver licence / photo ID."
        },
        "rules": [
          {
            "require": true,
            // "message": "Driver licence / photo ID cannot be empty."
          }
        ]
      },
      {
        "label": "ABN",
        "prop": "abn",
        "disabled": !isEdit.value,
        "value": customerInfo.value.abn ?? "",
        "component": {"type": "input", "placeholder": "Please input the ABN."},
        "rules": [
          // {"require": true, "message": "ABN cannot be empty."}
        ]
      },
      {
        "label": "Workshop or House?",
        "prop": "workLocation",
        "disabled": !isEdit.value,
        "value": customerInfo.value.workLocation ?? "",
        "component": {
          "type": "input",
          "placeholder": "Please input the workshop or house."
        },
        "rules": [
          // {"require": true, "message": "Workshop or house cannot be empty."}
        ]
      }
    ];
    customerFormList.refresh();
  }

  customerFormDataChange(key, value) {
    customerInfoForm.value[key] = value;
    customerInfoForm.refresh();
  }

  toChangeIsAddSecondaryPerson() {
    isAddSecondaryPerson.value = !isAddSecondaryPerson.value;
    if (isAddSecondaryPerson.value == false) {}
    setSecondaryPersonFormList();
  }

  // secondary person =======
  final secondaryPersonFormKey = GlobalKey<FormState>();
  RxList<Map<String, dynamic>> secondaryPersonFormList =
      RxList<Map<String, dynamic>>([]);
  RxMap<String, dynamic> secondaryPersonInfoForm = RxMap<String, dynamic>({});
  var secondaryPersonInfo = SecondaryPerson().obs;
  RxBool isAddSecondaryPerson = false.obs;
  setSecondaryPersonFormList() {
    secondaryPersonFormList.value = [
      {
        "label": "Full Name",
        "prop": "personName",
        "disabled": !isEdit.value,
        "value": secondaryPersonInfo.value.personName ?? "",
        "component": {
          "type": "input",
          "placeholder": "Please input the full name."
        },
        "rules": [
          {"require": true, "message": "Full name cannot be empty."}
        ]
      },
      {
        "label": "Phone Number",
        "prop": "personPhone",
        "disabled": !isEdit.value,
        "value": secondaryPersonInfo.value.personPhone ?? "",
        "component": {
          "type": "input",
          "trigger": "change",
          "fieldType": "number",
          "placeholder": "Please input the phone number."
        },
        "rules": [
          {"require": true, "message": "Phone number cannot be empty."}
        ]
      },
      {
        "label": "Secondary Phone Number",
        "prop": "personSecNumber",
        "disabled": !isEdit.value,
        "value": secondaryPersonInfo.value.personSecNumber ?? "",
        "component": {
          "type": "input",
          "trigger": "change",
          "fieldType": "number",
          "placeholder": "Please input the secondary phone number."
        },
        "rules": [
          // {
          //   "require": true,
          //   "message": "Secondary phone number cannot be empty."
          // }
        ]
      },
      {
        "label": "Email",
        "prop": "personEmail",
        "disabled": !isEdit.value,
        "value": secondaryPersonInfo.value.personEmail ?? "",
        "component": {
          "type": "input",
          "trigger": "change",
          "placeholder": "Please input the email."
        },
        "rules": [
          {
            "pattern": r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
            "message": "Please enter the correct email format."
          }
        ]
      },
      {
        "label": "Residential Address",
        "prop": "personAddress",
        "disabled": !isEdit.value,
        "value": secondaryPersonInfo.value.personAddress ?? "",
        "component": {
          "type": "textarea",
          "placeholder": "Please input the residential address."
        },
        "rules": [
          // {"require": true, "message": "Residential address cannot be empty."}
        ]
      },
      {
        "label": "Driver Licence / Photo ID",
        "prop": "personLicense",
        "disabled": !isEdit.value,
        "value": secondaryPersonInfo.value.personLicense ?? "",
        "component": {
          "type": "input",
          "placeholder": "Please input the driver licence / photo ID."
        },
        "rules": [
          {
            "require": true,
            // "message": "Driver licence / photo ID cannot be empty."
          }
        ]
      },
      {
        "label": "ABN",
        "prop": "personABN",
        "disabled": !isEdit.value,
        "value": secondaryPersonInfo.value.personABN ?? "",
        "component": {"type": "input", "placeholder": "Please input the ABN."},
        "rules": [
          // {"require": true, "message": "ABN cannot be empty."}
        ]
      },
      {
        "label": "Workshop or House?",
        "prop": "personLocation",
        "disabled": !isEdit.value,
        "value": secondaryPersonInfo.value.personLocation ?? "",
        "component": {
          "type": "input",
          "placeholder": "Please input the workshop or house."
        },
        "rules": [
          // {"require": true, "message": "Workshop or house cannot be empty."}
        ]
      }
    ];
    customerFormList.refresh();
  }

  secondaryPersonFormDataChange(key, value) {
    secondaryPersonInfoForm.value[key] = value;
    secondaryPersonInfoForm.refresh();
  }

  // car =======
  final carFormKey = GlobalKey<FormState>();
  RxList<Map<String, dynamic>> carFormList = RxList<Map<String, dynamic>>([]);
  RxMap<String, dynamic> carInfoForm = RxMap<String, dynamic>({});
  var carInfo = Car().obs;
  setCarFormList() {
    carFormList.value = [
      {
        "label": "REGO",
        "prop": "registrationNumber",
        "disabled": !isEdit.value,
        "value": carInfo.value.registrationNumber ?? "",
        "component": {"type": "input", "placeholder": "Please input the REGO."},
        "rules": [
          // {"require": true, "message": "REGO cannot be empty."}
        ]
      },
      {
        "label": "State",
        "prop": "state",
        "disabled": !isEdit.value,
        "value": carInfo.value.state ?? "",
        "component": {
          "type": "select",
          "options": [
            {'label': 'NSW', 'value': 'NSW'},
            {'label': 'VIC', 'value': 'VIC'},
            {'label': 'QLD', 'value': 'QLD'},
            {'label': 'SA', 'value': 'SA'},
            {'label': 'ACT', 'value': 'ACT'},
            {'label': 'NT', 'value': 'NT'},
            {'label': 'WA', 'value': 'WA'},
            {'label': 'TAS', 'value': 'TAS'},
          ],
          "placeholder": "Please input the State."
        },
        "rules": [
          // {"require": true, "message": "State cannot be empty."}
        ]
      },
      {
        "label": "Kilometers of the car",
        "prop": "kilometers",
        "disabled": !isEdit.value,
        "value": orderInfo.value.kilometers,
        "component": {
          "type": "input",
          "fieldType": "number",
          "placeholder": "Please input the Kilometers of the car."
        },
        "rules": [
          // {"require": true, "message": "Kilometers cannot be empty."}
        ]
      },
      {
        "label": "Brand",
        "prop": "brand",
        "disabled": !isEdit.value,
        "value": carInfo.value.brand ?? "",
        "component": {
          "type": "input",
          "placeholder": "Please input the Brand."
        },
        "rules": [
          {"require": true, "message": "Brand cannot be empty."}
        ]
      },
      {
        "label": "Model",
        "prop": "model",
        "disabled": !isEdit.value,
        "value": carInfo.value.model ?? "",
        "component": {
          "type": "input",
          "placeholder": "Please input the Model."
        },
        "rules": [
          {"require": true, "message": "Model cannot be empty."}
        ]
      },
      {
        "label": "Year",
        "prop": "year",
        "disabled": !isEdit.value,
        "value": carInfo.value.year,
        "component": {
          "type": "input",
          "fieldType": "number",
          "placeholder": "Please input the Year."
        },
        "rules": [
          {"require": true, "message": "Year cannot be empty."}
        ]
      },
      {
        "label": "Series",
        "prop": "series",
        "disabled": !isEdit.value,
        "value": carInfo.value.series ?? "",
        "component": {
          "type": "input",
          "placeholder": "Please input the Series."
        },
        "rules": [
          // {"require": true, "message": "Series cannot be empty."}
        ]
      },
      {
        "label": "Engine",
        "prop": "engine",
        "disabled": !isEdit.value,
        "value": carInfo.value.engine ?? "",
        "component": {
          "type": "input",
          "placeholder": "Please input the Engine."
        },
        "rules": [
          // {"require": true, "message": "Engine cannot be empty."}
        ]
      },
      {
        "label": "Colour",
        "prop": "colour",
        "disabled": !isEdit.value,
        "value": carInfo.value.colour ?? "",
        "component": {
          "type": "input",
          "placeholder": "Please input the Colour."
        },
        "rules": [
          {"require": true, "message": "Colour cannot be empty."}
        ]
      },
      {
        "label": "Body Style",
        "prop": "bodyStyle",
        "disabled": !isEdit.value,
        "value": carInfo.value.bodyStyle ?? "",
        "component": {
          "type": "input",
          "placeholder": "Please input the Body Style."
        },
        "rules": [
          // {"require": true, "message": "Body Style cannot be empty."}
        ]
      },
      {
        "label": "Vin Number",
        "prop": "vinNumber",
        "disabled": !isEdit.value,
        "value": carInfo.value.vinNumber ?? "",
        "component": {
          "type": "input",
          "placeholder": "Please input the Vin Number."
        },
        "rules": [
          // {"require": true, "message": "Vin Number cannot be empty."}
        ]
      },
    ];
    carFormList.refresh();
  }

  carFormDataChange(key, value) {
    if (key == 'kilometers') {
      orderFormDataChange(key, value);
      return;
    }
    carInfoForm.value[key] = value;
    carInfoForm.refresh();
  }

  //=======
  toGetJobAll() async {
    var res = await handleApi({
      "api": apiGetJobAll,
      "payload": {"jobID": arguments['id'], "orderID": arguments['orderID']}
    });
    if (res != null) {
      if (res['otherJobs'] != null) {
        otherJobs.value = res['otherJobs'];
      }
      if (res['customerDetail'] != null) {
        customerInfo.value = Customer.fromJson(res['customerDetail']);
        customerInfoForm.value = {
          "id": customerInfo.value.id,
          "firstName": customerInfo.value.firstName,
          "phoneNumber": customerInfo.value.phoneNumber,
          "secNumber": customerInfo.value.secNumber,
          "emailAddress": customerInfo.value.emailAddress,
          "address": customerInfo.value.address,
          "licence": customerInfo.value.licence,
          "abn": customerInfo.value.abn,
          "workLocation": customerInfo.value.workLocation,
        };
        customerInfo.refresh();
      }
      if (res['secondaryPersonDetail'] != null) {
        secondaryPersonInfo.value =
            SecondaryPerson.fromJson(res['secondaryPersonDetail']);
        secondaryPersonInfoForm.value = {
          "id": secondaryPersonInfo.value.id,
          "personName": secondaryPersonInfo.value.personName,
          "personPhone": secondaryPersonInfo.value.personPhone,
          "personSecNumber": secondaryPersonInfo.value.personSecNumber,
          "personEmail": secondaryPersonInfo.value.personEmail,
          "personAddress": secondaryPersonInfo.value.personAddress,
          "personLicense": secondaryPersonInfo.value.personLicense,
          "personABN": secondaryPersonInfo.value.personABN,
          "personLocation": secondaryPersonInfo.value.personLocation,
        };
        isAddSecondaryPerson.value = true;
        secondaryPersonInfo.refresh();
      } else {
        isAddSecondaryPerson.value = false;
      }
      if (res['jobDetail'] != null) {
        jobInfo.value = Job.fromJson(res['jobDetail']);
        jobInfoForm.value = {
          "id": jobInfo.value.id,
          "schedulerStart": jobInfo.value.schedulerStart,
          "schedulerEnd": jobInfo.value.schedulerEnd,
        };
        currentStatus.value = handleStatus(jobInfo.value.status);
        if (currentStatus.value == 'Complete') {
          isEdit.value = false;
        } else if (currentStatus.value == 'Waiting') {}
      }
      if (res['orderDetail'] != null) {
        orderInfo.value = Order.fromJson(res['orderDetail']);
        orderInfoForm.value = {
          // payment
          "id": orderInfo.value.id,
          "payMethod": orderInfo.value.payMethod,
          "actualPaymentPrice": orderInfo.value.actualPaymentPrice,
          "deposit": orderInfo.value.deposit,
          "depositPayMethod": orderInfo.value.depositPayMethod,
          "totalAmount": orderInfo.value.totalAmount,
          "gstStatus": orderInfo.value.gstStatus,
          "deduction": orderInfo.value.deduction,
          "gstAmount": orderInfo.value.gstAmount,
          "priceExGST": orderInfo.value.priceExGST,
          "gst": orderInfo.value.gst,
          "customerName": orderInfo.value.customerName,
          "bankName": orderInfo.value.bankName,
          "bsbNo": orderInfo.value.bsbNo,
          "accountsNo": orderInfo.value.accountsNo,
          // questionnaire
          "gotPapers": orderInfo.value.gotPapers,
          "gotLicense": orderInfo.value.gotLicense,
          "gotKey": orderInfo.value.gotKey,
          "gotOwner": orderInfo.value.gotOwner,
          "gotRunning": orderInfo.value.gotRunning,
          "gotEasy": orderInfo.value.gotEasy,
          "gotBusy": orderInfo.value.gotBusy,
          "gotFlat": orderInfo.value.gotFlat,
          "commentText": orderInfo.value.commentText,
          "askingPrice": orderInfo.value.askingPrice,
          //Attachments
          "imageFileDir": orderInfo.value.imageFileDir ?? '[]',
          "paymentRemittance": orderInfo.value.paymentRemittance ?? '[]',
          "driverLicense": orderInfo.value.driverLicense ?? '[]',
          "registrationDoc": orderInfo.value.registrationDoc ?? '[]',
          "signature": orderInfo.value.signature,
          // car
          "kilometers": orderInfo.value.kilometers,
          // schedule
          "pickupAddress": orderInfo.value.pickupAddress,
          "pickupAddressState": orderInfo.value.pickupAddressState,
          "pickupAddressLat": orderInfo.value.pickupAddressLat,
          "pickupAddressLng": orderInfo.value.pickupAddressLng,
          "expectedDate": orderInfo.value.expectedDate,
          "scheduleDateTimeRange": handleTimeRange(),
        };
        if (orderInfo.value.bankName != null &&
            orderInfo.value.bankName != '' &&
            orderInfo.value.customerName != null &&
            orderInfo.value.customerName != '') {
          isBankDetailShow = true.obs;
        } else {
          isBankDetailShow = false.obs;
        }
      }
      if (res['carDetail'] != null) {
        carInfo.value = Car.fromJson(res['carDetail']);
        carInfoForm.value = {
          "id": carInfo.value.id,
          "registrationNumber": carInfo.value.registrationNumber,
          "state": carInfo.value.state,
          "brand": carInfo.value.brand,
          "model": carInfo.value.model,
          "year": carInfo.value.year,
          "series": carInfo.value.series,
          "engine": carInfo.value.engine,
          "colour": carInfo.value.colour,
          "bodyStyle": carInfo.value.bodyStyle,
          "vinNumber": carInfo.value.vinNumber,
        };
      }
    }
  }

  changeToNew() {
    jobInfo.value = Job();
    jobInfoForm.value = {};
    carInfo.value = Car();
    carInfoForm.value = {};
    customerInfo.value = Customer();
    customerInfoForm.value = {};
    secondaryPersonInfo.value = SecondaryPerson();
    secondaryPersonInfoForm.value = {};
    orderInfo.value = Order();
    orderInfo.refresh();
    orderInfoForm.value = {};
    orderInfoForm.refresh();
  }

  // to submit updates
  /* 
  {
    "jobDetail": jobInfoForm,
    "orderDetail": orderInfoForm,
  }
   */
  toUpdate(data) async {
    return await handleApi({"api": apiUpdateJobAll, "payload": data});
  }

  toUpdateFile() async {
    var res = await toUpdate({
      "orderDetail": {
        "id": orderInfoForm.value['id'],
        "imageFileDir": orderInfoForm.value['imageFileDir'],
        "paymentRemittance": orderInfoForm.value['paymentRemittance'],
        "driverLicense": orderInfoForm.value['driverLicense'],
        "signature": orderInfoForm.value['signature'],
        "registrationDoc": orderInfoForm.value['registrationDoc'],
      },
    });
    if (res != null) {
      showCustomSnackbar(message: 'Successfully updated.', status: '1');
      await handleRefresh();
      setForms();
    }
  }

  getCopy() {
    var jobInfoFormCopy = Map.from(jobInfoForm.value);
    var orderInfoFormCopy = Map.from(orderInfoForm.value);
    var customerInfoFormCopy = Map.from(customerInfoForm.value);
    var carInfoFormCopy = Map.from(carInfoForm.value);
    return {
      "jobInfoFormCopy": jobInfoFormCopy,
      "orderInfoFormCopy": orderInfoFormCopy,
      "customerInfoFormCopy": customerInfoFormCopy,
      "carInfoFormCopy": carInfoFormCopy
    };
  }

  validateForm() {
    if (carFormKey.currentState != null) {
      if (!carFormKey.currentState!.validate()) {
        tabController.animateTo(1);
        return false;
      }
    }
    if (customerFormKey.currentState != null) {
      if (!customerFormKey.currentState!.validate()) {
        tabController.animateTo(3);
        return false;
      }
    }
    if (paymentFormKey.currentState != null) {
      if (!paymentFormKey.currentState!.validate()) {
        tabController.animateTo(4);
        return false;
      }
    }
    return true;
  }

  toUpdateJobForm() async {
    if (validateForm()) {
      var copys = getCopy();
      copys['orderInfoFormCopy'].remove('scheduleDateTimeRange');
      print(copys);
      var res = await toUpdate({
        "jobDetail": jobInfoForm.value,
        "orderDetail": copys['orderInfoFormCopy'],
        "customerDetail": customerInfoForm.value,
        "carDetail": carInfoForm.value,
        "secondaryPersonDetail": isAddSecondaryPerson.value
            ? secondaryPersonInfoForm.value
            : {'clear': true}
      });
      if (res != null) {
        showCustomSnackbar(message: 'Successfully updated.', status: '1');
        await handleRefresh();
        isEdit.value = false;
        setForms();
      }
    }
  }

  // to change edit
  toChangeEdit() {
    isEdit.value = !isEdit.value;
    setForms();
  }

  toCancel() async {
    await changeToNew();
    // setForms();
    await toGetJobAll();
    isEdit.refresh();
    toChangeEdit();
  }

  // to complete job
  endCurrentTask() async {
    return await toUpdate({
      "jobDetail": {"id": jobInfoForm.value['id'], "status": 4}
    });
  }

  Future<void> alertEndDialog() async {
    var result = await Get.dialog(
        AlertDialog(
          title: const Text("Prompt information!"),
          content: const Text("Are you sure you want to end this job now?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Get.back(result: 'Cancel');
              },
            ),
            TextButton(
              child: const Text("Ok"),
              onPressed: () {
                Get.back(result: 'Ok');
              },
            )
          ],
        ),
        barrierDismissible: false);
    if (result == 'Ok') {
      var res = await endCurrentTask();
      if (res != null) {
        // showCustomSnackbar(message: "The current job has ended.");
        await handleRefresh();
        if (arguments.value['refresh'] != null) {
          arguments.value['refresh']();
        }
        showCustomPrompt(
          duration: null,
          tipWidget: Container(
            // height: 200,

            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.all(
                    Radius.circular(ScreenAdapter.fontSize(20))),
                border: Border.all(color: AppColors.accent)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Transform(
                        transform: Matrix4.skew(-0.4, 0),
                        child: Container(
                          height: ScreenAdapter.width(20),
                          width: ScreenAdapter.width(600),
                          color: AppColors.accent,
                        ))
                  ],
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(ScreenAdapter.width(35)),
                  child: MyParagraph(
                    text:
                        'The current job has ended.what do you want to do next?',
                    fontSize: 60,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          print(Get.isSnackbarOpen);
                          if (Get.isSnackbarOpen) {
                            Get.closeAllSnackbars();
                          }
                          Timer(Duration(milliseconds: 300), () {
                            Get.until((route) => Get.currentRoute == '/tabs');
                          });
                        },
                        child: Row(
                          children: [
                            Icon(Icons.arrow_back_sharp),
                            MyParagraph(text: "Back")
                          ],
                        )),
                    TextButton(
                        onPressed: otherJobs.value.length > 0
                            ? () {
                                if (Get.isSnackbarOpen) {
                                  Get.closeAllSnackbars();
                                }
                                // print(otherJobs.value[0]);
                                changeToNew();
                                arguments.value = {
                                  ...arguments.value,
                                  ...otherJobs.value[0],
                                };
                                handleRefresh();
                              }
                            : null,
                        child: Row(
                          children: [
                            MyParagraph(text: "Next"),
                            Icon(Icons.arrow_forward)
                          ],
                        )),
                  ],
                )
              ],
            ),
          ),
        );
      }
    }
  }

  // send invoice
  sendInvoice() {}

  Future<void> alertSendInvoiceDialog() async {
    var result = await Get.dialog(
        AlertDialog(
          title: const Text("Prompt information!"),
          content: const Text("Are you sure you want to send invoice?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Get.back(result: 'Cancel');
              },
            ),
            TextButton(
              child: const Text("Ok"),
              onPressed: () {
                Get.back(result: 'Ok');
              },
            )
          ],
        ),
        barrierDismissible: false);
    if (result == 'Ok') {
      var sendRes = await apiSendInvoice(
          name: orderInfoForm.value['firstName'],
          id: orderInfoForm.value['orderID'],
          price: orderInfoForm.value['actualPaymentPrice'],
          email: orderInfoForm.value['emailAddress']);
      if (sendRes == null) {
        showCustomSnackbar(
            message: 'Send failed, please try again later.', status: '3');
        return;
      }
      if (sendRes.data['message'] == 'success') {
        showCustomSnackbar(message: 'Send successful.');
      } else {
        showCustomSnackbar(
            message: 'Send failed,' + sendRes.data['message'], status: '3');
      }
      // await initDetail();
    }
  }

  Future<void> handleRefresh() async {
    await toGetJobAll();
    isEdit.refresh();
    setForms();
  }

  setForms() {
    setCustomerFormList();
    setPaymentFormList();
    setQuestionnaireFormList();
    setAttachmentsFormList();
    setCarFormList();
    setScheduleFormList();
    setSecondaryPersonFormList();
  }

  // 签名
  // 签名 bottom sheet

  changeSignature(String data) {
    orderInfoForm.value['signature'] = data;
    orderInfoForm.refresh();
    toUpdateFile();
  }

  openBottomSheet() {
    if (isEdit.value) {
      Get.bottomSheet(
        Container(
          height: ScreenAdapter.height(2000),
          // color: Colors.red,
          child: GenerateSignature(
            changeSignature: changeSignature,
          ),
        ),
        enableDrag: false,
        isScrollControlled: true,
      );
    }
  }

  @override
  void onInit() async {
    super.onInit();
    tabController = TabController(length: 6, vsync: this);
    arguments.value = Get.arguments;
    await handleRefresh();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    isKeyboardOpen.value = bottomInset > 0.0;
  }
}

/* 
{
  label
  prop
  value
  hidden
  component
  triggeredOnChange
  rules
}
      {
        "label": "Seal",
        "value": false,
        "prop": "isSeal",
        "hidden": !isEdit.value,
        "component": {
          "type": "checkbox",
          "placeholder": "Please input the container number.",
        },
        "triggeredOnChange": (data) {
          setCustomerFormList();
        },
        "rules": [
          {
            "pattern": r'^[a-zA-Z]+$',
            "errorMessage": "Name should contain only alphabets",
          },
        ],
      },
 */
tapToViewMap(address) async {
  final Uri url = Uri.parse(
      // 'https://maps.google.com/maps/search/?api=1&query=${controller.arguments['pickupAddress']}'
      'https://www.google.com/maps/dir/?api=1&destination=${address}');

  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch $url');
  }
}

tapToCall(phone) async {
  await FlutterPhoneDirectCaller.callNumber(phone);
}
