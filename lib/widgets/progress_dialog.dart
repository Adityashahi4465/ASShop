import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

void showProgress(BuildContext context) {
  ProgressDialog progress = ProgressDialog(context: context);
  progress.show(max: 100, msg: 'please wait..', progressBgColor: Colors.red);
}

void hideProgress(BuildContext context) {
  ProgressDialog progress = ProgressDialog(context: context);
  progress.close();
}
