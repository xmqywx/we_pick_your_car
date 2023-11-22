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
  // final void Function(Map<String, dynamic> values) onSubmit;

  DynamicForm(
      {required this.formFields,
      // required this.onSubmit,
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
            String label = field['label'];
            dynamic value = field['value'];
            Map<String, dynamic> component = field['component'];
            List<dynamic> rules = field['rules'];
            bool disabled = field['disabled'] ?? false;
            bool hidden = field['hidden'] ?? false;
            String prop = field['prop'] ?? label;

            Future myValidator(value, validatorMsg, validator) async {
              field['validatorMsg'] = null;

              // 进行异步验证
              bool isValid = await validator(value);

              if (!isValid) {
                field['validatorMsg'] = validatorMsg;
                formKey.currentState!.validate();
              }
            }

            Function triggeredOnChange = field['triggeredOnChange'] ??
                (value) {
                  print(value);
                };
            if (hidden) {
              return SizedBox.shrink();
            }

            Widget formField;

            if (component['type'] == 'input') {
              formField = TextFormField(
                initialValue: value,
                enabled: !disabled,
                decoration: InputDecoration(
                  labelText: label,
                  hintText: component['placeholder'],
                ),
                style: TextStyle(fontFamily: 'Roboto-Medium'),
                validator: (value) {
                  if (field['validatorMsg'] != null) {
                    String msg = field['validatorMsg'];
                    field['validatorMsg'] = null;
                    return msg;
                  }
                  // 遍历rules进行校验
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
                      myValidator(formData[prop], rule['message'], validator);
                    }
                  }
                  return null;
                },
                onChanged: (value) {
                  formValues[prop] = value;
                  formDataChange(prop, value);
                  triggeredOnChange(value);
                },
              );
            } else if (component['type'] == 'select') {
              List<Map<String, dynamic>> options = component['options'];

              formField = AbsorbPointer(
                absorbing: disabled,
                child: DropdownButtonFormField<String>(
                  value: value,
                  onChanged: disabled
                      ? null
                      : (newValue) {
                          formValues[prop] = newValue;
                          formDataChange(prop, value);
                          triggeredOnChange(value);
                        },
                  items: options.map((option) {
                    return DropdownMenuItem<String>(
                      value: option['value'],
                      child: Text(option['label']),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: label,
                  ),
                ),
              );
            } else if (component['type'] == 'datepicker') {
              Widget datePickerField = InkWell(
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
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
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      datePickerField,
                      if (state.errorText != null)
                        Text(
                          state.errorText!,
                          style: TextStyle(color: Colors.red),
                        ),
                    ],
                  );
                },
                validator: (value) {
                  if (field['validatorMsg'] != null) {
                    String msg = field['validatorMsg'];
                    field['validatorMsg'] = null;
                    return msg;
                  }
                  // 遍历rules进行校验
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
                      myValidator(formData[prop], rule['message'], validator);
                    }
                  }
                  return null;
                },
              );
            } else if (component['type'] == 'checkbox') {
              formField = Row(
                children: [
                  SizedBox(
                    child: MyParagraph(
                      text: label,
                    ),
                  ),
                  Checkbox(
                    value: !!formData[prop],
                    onChanged: disabled
                        ? null
                        : (newValue) {
                            formValues[prop] = newValue;
                            formDataChange(prop, newValue);
                            triggeredOnChange(value);
                          },
                  ),
                  SizedBox(width: 8), // 设置合适的间距
                ],
              );
            } else if (component['type'] == 'textarea') {
              formField = TextFormField(
                initialValue: value,
                enabled: !disabled,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: label,
                  hintText: component['placeholder'],
                ),
                style: TextStyle(fontFamily: 'Roboto-Medium'),
                validator: (value) {
                  // Validation logic
                },
                onChanged: (value) {
                  formValues[prop] = value;
                  formDataChange(prop, value);
                  triggeredOnChange(value);
                },
              );
            } else if (component['type'] == 'uploadImage') {
              List<String> imagesFile;
              if (formData[prop] != null) {
                List cloneData = [];
                cloneData = json
                    .decode(formData[prop])
                    .map((e) => e.toString())
                    .toList();
                imagesFile = cloneData.cast<String>().toList();
              } else {
                imagesFile = <String>[];
              }

              formField = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: ScreenAdapter.width(15)),
                    child: MyParagraph(
                      text: label,
                    ),
                  ),
                  ImagePickerWidget(
                    onImagesChanged: (list) {
                      print(list);
                      formValues[prop] = json.encode(list);
                      formDataChange(prop, formValues[prop]);
                    },
                    images: imagesFile,
                    isEditable: !disabled,
                  ),
                ],
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
