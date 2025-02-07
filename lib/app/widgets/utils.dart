import 'package:flutter/material.dart';
import 'package:hpi_flutter/core/localizations.dart';

Widget buildAppBarTitle({@required Widget title, Widget subtitle}) {
  assert(title != null);

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      title,
      subtitle,
    ],
  );
}

Widget buildLoadingErrorScaffold(
    BuildContext context, AsyncSnapshot<dynamic> snapshot,
    {bool appBarElevated = false, String loadingTitle}) {
  assert(context != null);
  assert(snapshot != null);
  assert(appBarElevated != null);

  return Scaffold(
    appBar: AppBar(
      elevation: appBarElevated ? null : 0,
      backgroundColor: appBarElevated ? Theme.of(context).cardColor : null,
      title: Text(snapshot.hasError
          ? HpiL11n.get(context, 'error')
          : (loadingTitle ?? HpiL11n.get(context, 'loading'))),
    ),
    body: Center(
      child: snapshot.hasError
          ? Text(snapshot.error.toString())
          : CircularProgressIndicator(),
    ),
  );
}

Widget buildLoadingErrorSliver(AsyncSnapshot<dynamic> snapshot) {
  assert(snapshot != null);

  return SliverFillRemaining(
    child: Center(
      child: snapshot.hasError
          ? Text(snapshot.error.toString())
          : CircularProgressIndicator(),
    ),
  );
}
