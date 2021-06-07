import 'package:flutter/material.dart';
import 'package:gobz_app/view/components/forms/FormComponent.dart';

class FormPage<T> extends StatelessWidget {
  final FormComponent<T> form;
  final String? title;
  final AppBar? appBar;
  final EdgeInsets padding;

  const FormPage({
    Key? key,
    required this.form,
    this.title,
    this.appBar,
    this.padding = const EdgeInsets.all(12),
  }) : super(key: key);

  static Route<T> route<T>(
    FormComponent<T> form, {
    String? title,
    AppBar? appBar,
    EdgeInsets? padding,
  }) {
    return MaterialPageRoute<T>(
      builder: (_) => FormPage<T>(
        form: form,
        title: title,
        appBar: appBar,
        padding: padding ?? const EdgeInsets.all(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ??
          AppBar(
            title: Text(title ?? ""),
          ),
      body: SingleChildScrollView(
        child: Padding(
          padding: padding,
          child: form,
        ),
      ),
    );
  }
}
