import 'dart:async';
import 'dart:math';

import 'package:car_wrecker/app/color/colors.dart';
import 'package:car_wrecker/app/services/screen_adapter.dart';
import 'package:car_wrecker/app/text/paragraph.dart';
import 'package:flutter/material.dart';
import '../services/format_date.dart';
import './upload_image.dart';
import 'dart:convert';

class DynamicForm extends StatelessWidget {
  final List<Map<String, dynamic>> formFields;
  final Map<String, dynamic> formData;
  final void Function(String key, dynamic value) formDataChange;
  final GlobalKey<FormState> formKey;
  Map<String, dynamic> formRules;
  // final void Function(Map<String, dynamic> values) onSubmit;

  DynamicForm(
      {required this.formFields,
      // required this.onSubmit,
      this.formRules = const {},
      required this.formKey,
      required this.formData,
      required this.formDataChange});

  @override
  Widget build(BuildContext context) {
    final formValues = _getInitialFormValues();
    return Form(
      key: formKey,
      child: Column(
        children: [
          ...formFields.map((field) {
            String label = field['label'] ?? ''; // string
            dynamic value =
                formData[field['prop']]; //field['value'] ?? ''; // any
            value ??= field['value'] ?? '';
            //dynamic value = field['value'] ?? ''; // any
            Map<String, dynamic> component =
                field['component'] ?? {}; // type,fieldType,
            List<dynamic> rules = field['rules'] ?? [];
            bool disabled = field['disabled'] ?? false;
            bool hidden = field['hidden'] ?? false;
            String prop = field['prop'] ?? label;
            Widget fieldTop = field['fieldTop'] ?? const SizedBox();
            Widget fieldBottom = field['fieldBottom'] ?? const SizedBox();
            Widget fieldRight = field['fieldRight'] ?? const SizedBox();
            Widget widget = field['widget'] ?? const SizedBox();
            var fieldKey = field['fieldKey'] ?? ObjectKey(value);
            Future myValidator(value, validator, fieldKey) async {
              field['validatorMsg'] = null;

              // 进行异步验证
              String? errMsg = await validator(value);

              if (errMsg != null) {
                field['validatorMsg'] = errMsg;
                if (fieldKey is GlobalKey<FormFieldState>) {
                  fieldKey.currentState!.validate();
                } else {
                  formKey.currentState!.validate();
                }
              }
            }

            String? inputValidator(String? value) {
              if (field['validatorMsg'] != null) {
                String msg = field['validatorMsg'];
                field['validatorMsg'] = null;
                return msg;
              }

              if (formRules[prop] != null) {
                if (formRules[prop]['judge']) {
                  return formRules[prop]['message'];
                }
              }

              // 遍历rules进行校验
              for (var rule in rules) {
                // require pattern min,max validator
                if (rule.containsKey('require') && rule['require'] == true) {
                  if (formData[prop] == '' || formData[prop] == null) {
                    return rule['message'];
                  }
                  if (component['fieldType'] == 'number') {
                    if (formData[prop] == null) {
                      return rule['message'];
                    }
                  }
                }
                if (rule.containsKey('min') && rule.containsKey('max')) {
                  int min = rule['min'];
                  int max = rule['max'];
                  if (formData[prop] != null &&
                      (formData[prop].toString().length < min ||
                          formData[prop].toString().length > max)) {
                    return rule['message'];
                  }
                }
                if (rule.containsKey('pattern')) {
                  if (formData[prop] == '' || formData[prop] == null)
                    return null;
                  if (!RegExp(rule['pattern'])
                      .hasMatch(formData[prop].toString())) {
                    return rule['message'];
                  }
                }
                if (rule.containsKey('judge')) {
                  print("${formData[prop]} ==================");
                  if (rule['judge']) {
                    return rule['message'];
                  }
                }

                if (rule.containsKey('validator')) {
                  Function validator = rule['validator'];
                  myValidator(formData[prop], validator, fieldKey);
                }
              }
              return null;
            }

            AutovalidateMode trigger = AutovalidateMode.disabled;
            if (component['trigger'] == 'change') {
              trigger = AutovalidateMode.onUserInteraction;
            }
            Function triggeredOnChange = field['triggeredOnChange'] ??
                (value) {
                  print(value);
                };
            if (hidden) {
              return SizedBox.shrink();
            }

            Widget formField;
            if (component['type'] == 'widget') {
              formField = widget;
            } else if (component['type'] == 'input') {
              value ??= "";
              if (value == 'null') {
                value = '';
              }
              formField = Column(
                children: [
                  fieldTop,
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: TextFormField(
                            autovalidateMode: trigger,
                            initialValue:
                                '${component['fieldType'] == 'number' ? (value == null ? '' : value.toString()) : value}',
                            enabled: !disabled,
                            key: fieldKey,
                            keyboardType: component['fieldType'] == 'number'
                                ? TextInputType.number
                                : TextInputType.text,
                            decoration: InputDecoration(
                              labelText: label,
                              hintText: component['placeholder'],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.3),
                                    width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.3),
                                    width: 1),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.3),
                                    width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                    color: AppColors.primary.withOpacity(0.5),
                                    width: 1.5),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              labelStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                            style: TextStyle(
                                fontFamily: 'Roboto-Medium', fontSize: 16),
                            validator: inputValidator,
                            onChanged: (value) {
                              if (component['fieldType'] == 'number') {
                                if (value == '') {
                                  formValues[prop] = null;
                                  formDataChange(prop, null);
                                } else {
                                  if (double.tryParse(value) == null) {
                                    field['validatorMsg'] =
                                        'Please enter the correct number.';
                                  }
                                  formValues[prop] = num.parse(value);
                                  formDataChange(prop, num.parse(value));
                                }
                              } else {
                                formValues[prop] = value;
                                formDataChange(prop, value);
                              }
                              triggeredOnChange(value);
                            },
                            onFieldSubmitted: (value) {
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                      ),
                      fieldRight
                    ],
                  ),
                  fieldBottom
                ],
              );
            } else if (component['type'] == 'select') {
              List<Map<String, dynamic>> options = component['options'];

              formField = Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  // boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.grey.withOpacity(0.2),
                  //         spreadRadius: 1,
                  //         blurRadius: 6,
                  //         offset: Offset(0, 3),
                  //       ),
                  //     ],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: AbsorbPointer(
                  absorbing: disabled,
                  child: DropdownButtonFormField<String>(
                    value: formData[prop] == '' ? null : formData[prop],
                    onChanged: disabled
                        ? null
                        : (newValue) {
                            formValues[prop] = newValue;
                            formDataChange(prop, formValues[prop]);
                            triggeredOnChange(newValue);
                          },
                    items: options.map((option) {
                      return DropdownMenuItem<String>(
                        value: option['value'],
                        child: Container(
                          width: 200, // Adjusted width to make dropdown smaller
                          child: Text(
                            option['label'],
                            style: TextStyle(
                              fontFamily: 'Roboto-Medium',
                              fontSize:
                                  16, // Adjusted font size to match input fields
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: label,
                      hintText: component['placeholder'],

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.3),
                            width: 1), // Added light grey border
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.3),
                            width:
                                1), // Added light grey border for enabled state
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.3),
                            width:
                                1), // Added light grey border for enabled state
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                            color: AppColors.primary.withOpacity(0.5),
                            width:
                                1.5), // Added slightly darker grey border for focused state
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical:
                              10), // Adjusted padding to match input fields
                      labelStyle: TextStyle(
                        color: Colors
                            .grey, // Adjusted label color to match input fields
                        fontFamily: 'Roboto-Medium',
                        fontSize:
                            16, // Adjusted font size to match input fields
                      ),
                      hintStyle: TextStyle(
                        fontFamily: 'Roboto-Medium',
                        fontSize:
                            16, // Adjusted font size to match input fields
                      ),
                    ),
                    isExpanded:
                        false, // Adjusted to reduce the width of the dropdown
                  ),
                ),
              );
            } else if (component['type'] == 'datepicker') {
              Widget datePickerField = InkWell(
                onTap: () async {
                  await showDatePicker(
                    context: context,
                    initialDate: handleParse(date: formData[prop]),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  ).then((value) {
                    if (value == null) return;
                    formValues[prop] =
                        handleFormat(date: value, format: "dd-MM-yyyy");
                    formDataChange(prop, formValues[prop]);
                    triggeredOnChange(value);
                  }).catchError((e) {
                    print(e);
                  });
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: label,
                    labelStyle: TextStyle(fontFamily: 'Roboto-Medium'),
                    hintText: component['placeholder'],
                  ),
                  child: MyParagraph(text: formData[prop] ?? ''),
                ),
              );

              formField = FormField<DateTime?>(
                builder: (FormFieldState<DateTime?> state) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.grey.withOpacity(0.2),
                      //     spreadRadius: 1,
                      //     blurRadius: 6,
                      //     offset: Offset(0, 3),
                      //   ),
                      // ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  await showDatePicker(
                                    context: context,
                                    initialDate:
                                        handleParse(date: formData[prop]),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  ).then((value) {
                                    if (value == null) return;
                                    formValues[prop] = handleFormat(
                                        date: value, format: "dd-MM-yyyy");
                                    formDataChange(prop, formValues[prop]);
                                    triggeredOnChange(value);
                                  }).catchError((e) {
                                    print(e);
                                  });
                                },
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: label,
                                    hintText: component['placeholder'],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                          color: Colors.grey.withOpacity(0.3),
                                          width: 1), // Added light grey border
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                          color: Colors.grey.withOpacity(0.3),
                                          width:
                                              1), // Added light grey border for enabled state
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                          color: Colors.grey.withOpacity(0.3),
                                          width:
                                              1), // Added light grey border for enabled state
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                          color: AppColors.primary
                                              .withOpacity(0.5),
                                          width:
                                              1.5), // Added slightly darker grey border for focused state
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    labelStyle: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Roboto-Medium',
                                      fontSize: 16,
                                    ),
                                    hintStyle: TextStyle(
                                      fontFamily: 'Roboto-Medium',
                                      fontSize: 16,
                                    ),
                                  ),
                                  child: MyParagraph(
                                      text: formData[prop] ??
                                          component['placeholder']),
                                ),
                              ),
                            ),
                            // IconButton(
                            //   icon: Icon(Icons.calendar_today),
                            //   onPressed: () async {
                            //     await showDatePicker(
                            //       context: context,
                            //       initialDate: handleParse(date: formData[prop]),
                            //       firstDate: DateTime(2000),
                            //       lastDate: DateTime(2100),
                            //     ).then((value) {
                            //       if (value == null) return;
                            //       formValues[prop] =
                            //           handleFormat(date: value, format: "dd-MM-yyyy");
                            //       formDataChange(prop, formValues[prop]);
                            //       triggeredOnChange(value);
                            //     }).catchError((e) {
                            //       print(e);
                            //     });
                            //   },
                            // ),
                          ],
                        ),
                        if (state.errorText != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              state.errorText!,
                              style: TextStyle(color: Colors.red, fontSize: 14),
                            ),
                          ),
                      ],
                    ),
                  );
                },
                validator: (value) {
                  if (field['validatorMsg'] != null) {
                    String msg = field['validatorMsg'];
                    field['validatorMsg'] = null;
                    return msg;
                  }
                  for (var rule in rules) {
                    if (rule.containsKey('require') &&
                        rule['require'] == true) {
                      if (formData[prop] == null) {
                        return rule['message'];
                      }
                    }
                    if (rule.containsKey('min') && rule.containsKey('max')) {
                      int min = rule['min'];
                      int max = rule['max'];
                      if (formData[prop] != null &&
                          (formData[prop].toString().length < min ||
                              formData[prop].toString().length > max)) {
                        return rule['message'];
                      }
                    }
                    if (rule.containsKey('validator')) {
                      Function validator = rule['validator'];
                      myValidator(formData[prop], validator, formKey);
                    }
                  }
                  return null;
                },
              );
            } else if (component['type'] == 'checkbox') {
              formField = Container(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontFamily: 'Roboto-Bold',
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: 1.5,
                      child: Checkbox(
                        value: formData[prop] ?? false,
                        onChanged: disabled
                            ? null
                            : (newValue) {
                                formValues[prop] = newValue;
                                formDataChange(prop, newValue);
                                triggeredOnChange(value);
                              },
                        activeColor: AppColors.primary,
                        checkColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (component['type'] == 'textarea') {
              formField = Container(
                // padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.withOpacity(0.2),
                  //     spreadRadius: 1,
                  //     blurRadius: 6,
                  //     offset: Offset(0, 3),
                  //   ),
                  // ],
                ),
                child: TextFormField(
                  initialValue: value,
                  enabled: !disabled,
                  maxLines: null,
                  key: fieldKey,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: label,
                    hintText: component['placeholder'],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.3),
                          width: 1), // Added light grey border
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.3),
                          width:
                              1), // Added light grey border for enabled state
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.3),
                          width:
                              1), // Added light grey border for enabled state
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: AppColors.primary.withOpacity(0.5),
                          width:
                              1.5), // Added slightly darker grey border for focused state
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10), // Adjusted vertical padding
                    labelStyle: TextStyle(
                      color: Colors.grey, // Adjusted label color
                      fontSize: 16, // Adjusted font size
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Roboto-Medium',
                  ),
                  onChanged: (value) {
                    formValues[prop] = value;
                    formDataChange(prop, value);
                    triggeredOnChange(value);
                  },
                ),
              );
            } else if (component['type'] == 'uploadImage') {
              List<String> imagesFile;
              if (formData[prop] != null) {
                try {
                  List cloneData = [];
                  cloneData = json
                      .decode(formData[prop])
                      .map((e) => e.toString())
                      .toList();
                  imagesFile = cloneData.cast<String>().toList();
                } catch (e) {
                  imagesFile = <String>[];
                }
              } else {
                imagesFile = <String>[];
              }

              formField = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: MyParagraph(
                        text: label,
                        // contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10), // Adjusted vertical padding
                        color: Colors.grey, // Adjusted label color
                        // fontSize: 16,
                        fontFamily: 'Roboto-Medium'),
                  ),
                  ImagePickerWidget(
                      onImagesChanged: (list) {
                        formValues[prop] = json.encode(list);
                        formDataChange(prop, formValues[prop]);
                        triggeredOnChange(formValues[prop]);
                      },
                      images: imagesFile,
                      isEditable: !disabled,
                      isOnlyCamera: component['isOnlyCamera']),
                  SizedBox(
                    height: 10,
                  )
                ],
              );
            } else if (component['type'] == 'switch') {
              formField = SwitchFormField(
                initialValue: !!(formData[prop] == 1),
                onSaved: (newValue) {
                  print(newValue);
                  formValues[prop] = newValue;
                  formDataChange(prop, newValue);
                  triggeredOnChange(value);
                },
                disabled: disabled,
                title: MyParagraph(
                  text: label,
                  fontSize: 55,
                  color: AppColors.themeTextColor4,
                ),
              );
            } else {
              formField = SizedBox.shrink();
            }

            return formField;
          }).toList(),
        ],
      ),
    );
  }

  Map<String, dynamic> _getInitialFormValues() {
    Map<String, dynamic> initialValues = {};
    formFields.forEach((field) {
      bool hidden = field['hidden'] ?? false;
      if (!hidden) {
        String label = field['label'];
        dynamic value = field['value'];
        String prop = field['prop'] ?? label;
        initialValues[prop] = value;
      }
    });
    return initialValues;
  }
}

class SwitchFormField extends FormField<bool> {
  SwitchFormField({
    Key? key,
    required Widget title,
    bool initialValue = false,
    bool disabled = false,
    FormFieldSetter<bool>? onSaved,
  }) : super(
          key: key,
          initialValue: initialValue,
          enabled: !disabled,
          onSaved: onSaved,
          builder: (FormFieldState<bool> state) {
            return ListTile(
              title: title,
              contentPadding: EdgeInsets.zero,
              trailing: disabled
                  ? (initialValue
                      ? MyParagraph(text: "YES")
                      : MyParagraph(text: "NO"))
                  : Switch(
                      value: state.value!,
                      onChanged: disabled
                          ? null
                          : (value) {
                              state.didChange(value);
                              onSaved!(value);
                            },
                      // inactiveThumbColor: AppColors.dark,
                      // inactiveTrackColor: Colors.grey[300],
                    ),
            );
          },
        );
}
