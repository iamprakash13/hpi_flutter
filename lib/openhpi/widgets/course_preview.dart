import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/course.dart';

@immutable
class OpenHpiCoursePreview extends StatelessWidget {
  OpenHpiCoursePreview(this.course) : assert(course != null);

  final OpenHpiCourse course;

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      CachedNetworkImage(imageUrl: course.imageUrl.toString()),
      Positioned.fill(
        child: _buildScrim(
          child: _buildLaunchable(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    course.title,
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .copyWith(color: Colors.white),
                    maxLines: 3,
                  ),
                  Text(
                    DateFormat.yMMMd().format(course.startAt),
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: Colors.white),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  Widget _buildScrim({Widget child}) {
    assert(child != null);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black45],
        ),
      ),
      child: child,
    );
  }

  Widget _buildLaunchable({Widget child}) {
    assert(child != null);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => launch(course.link.toString()),
        child: child,
      ),
    );
  }
}
