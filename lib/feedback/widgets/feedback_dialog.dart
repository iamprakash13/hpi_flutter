import 'package:flutter/material.dart';
import 'package:hpi_flutter/core/localizations.dart';

class FeedbackDialog extends StatefulWidget {
  static void show(BuildContext context,
      {String title = 'Feedback', String feedbackType}) {
    assert(context != null);

    showModalBottomSheet(
      context: context,
      builder: (context) => FeedbackDialog(
        title: title,
        feedbackType: feedbackType,
      ),
    );
  }

  const FeedbackDialog({Key key, this.title = 'Feedback', this.feedbackType})
      : assert(title != null),
        super(key: key);

  final String title;
  final String feedbackType;

  @override
  _FeedbackDialogState createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog>
    with TickerProviderStateMixin {
  bool includeContact = false;
  bool sendLogs = false;
  bool isSending = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.title,
            style: Theme.of(context).textTheme.display1,
          ),
          SizedBox(height: 16),
          TextField(
            minLines: 4,
            maxLines: 8,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: HpiL11n.of(context)['yourMessage'],
            ),
          ),
          SizedBox(height: 16),
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(HpiL11n.of(context)['includeContactDetails']),
            subtitle: Text(HpiL11n.of(context)['includeContactDetailsInfo']),
            value: includeContact,
            onChanged: (checked) => setState(() {
              includeContact = checked;
            }),
          ),
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(HpiL11n.of(context)['includeLogs']),
            subtitle: Text(HpiL11n.of(context)['includeLogsInfo']),
            value: sendLogs,
            onChanged: (checked) => setState(() {
              sendLogs = checked;
            }),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: RaisedButton(
              color: Theme.of(context).primaryColor,
              child: !isSending
                  ? Text(HpiL11n.of(context)['submit'],
                      style: TextStyle(color: Colors.white))
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('Sending…', style: TextStyle(color: Colors.white)),
                      ],
                    ),
              onPressed: isSending
                  ? null
                  : () => setState(() {
                        isSending = true;
                        Future.delayed(Duration(seconds: 2))
                            .then((_) => Navigator.pop(context));
                      }),
            ),
          )
        ],
      ),
    );
  }
}
