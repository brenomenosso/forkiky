import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

final class Messages {
  static void showError(String message, BuildContext context) {
    showTopSnackBar(Overlay.of(context), CustomSnackBar.error(message: message));
  }

  static void showInfo(String message, BuildContext context) {
    showTopSnackBar(Overlay.of(context), CustomSnackBar.info(message: message));
  }
  
  static void showSucess(String message, BuildContext context) {
    showTopSnackBar(Overlay.of(context), CustomSnackBar.success(message: message));
  }
}

mixin MessageStateMixin {
  final Signal<String?> _errorMessage = signal(null);
  String? get errorMessage => _errorMessage();

  final Signal<String?> _inforMessage = signal(null);
  String? get infoMessage => _inforMessage();

  final Signal<String?> _sucessMessage = signal(null);
  String? get sucessMessage => _sucessMessage();

  void clearError() => _errorMessage.value = null;
  void clearInfo() => _inforMessage.value = null;
  void clearSucess() => _sucessMessage.value = null;

  void showError(String message) {
    untracked(() => clearError());
    _errorMessage.value = message;
  }

  void showInfo(String message) {
    untracked(() => clearInfo());
    _inforMessage.value = message;
  }

  void showSucess(String message) {
    untracked(() => clearSucess());
    _sucessMessage.value = message;
  }

  void clearAllMessages() {
    untracked(() {
      clearError();
      clearInfo();
      clearSucess();
    });
  }
}

mixin MessageViewMixin<T extends StatefulWidget> on State<T> {

  void messageListener(MessageStateMixin state) {
    effect(() {
      switch (state) {
        case MessageStateMixin(: final errorMessage?):
          Messages.showError(errorMessage, context);
        case MessageStateMixin(: final infoMessage?):
          Messages.showError(infoMessage, context);
        case MessageStateMixin(: final sucessMessage?):
          Messages.showError(sucessMessage, context);
      }
    });
  }
}
