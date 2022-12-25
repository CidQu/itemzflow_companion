import 'package:flutter/services.dart';

class MyInputFormatters {
    static TextInputFormatter ipAddressInputFilter() {
        return FilteringTextInputFormatter.allow(RegExp("[0-9.]"));
    }
}