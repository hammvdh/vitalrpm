import 'package:flutter/material.dart';
import 'package:vitalrpm/const/color_const.dart';

class LoadingOverlay {
  LoadingOverlay._create(this._context);

  factory LoadingOverlay.of(BuildContext context) {
    return LoadingOverlay._create(context);
  }

  BuildContext _context;

  void hide() {
    Navigator.of(_context).pop();
  }

  void show() {
    showDialog(
      barrierDismissible: false,
      context: _context,
      useSafeArea: false,
      builder: (BuildContext context) {
        return _FullScreenLoader();
      },
    );
  }

  Future<T> during<T>(Future<T> future) {
    show();
    return future.whenComplete(() => hide());
  }
}

class _FullScreenLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: AppColors.darkBlue.withOpacity(0.2),
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.textWhite,
        ),
      ),
    );
  }
}
