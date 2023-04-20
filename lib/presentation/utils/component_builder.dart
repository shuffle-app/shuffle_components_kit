import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart' as kit;

Future<dynamic> buildComponent(BuildContext context, BaseModel configuration, Widget child) {
  //TODO romancores: add later flavors
  if (kDebugMode) {
    SnackBarUtils.show(
        message: 'version ${configuration.version}', context: context);
  }
  switch (configuration.pageBuilderType) {
    case PageBuilderType.modalBottomSheet:
      return kit.showUiKitGeneralFullScreenDialog(context, child: child);

    case PageBuilderType.page:
      return context.push(child);
  }
}
