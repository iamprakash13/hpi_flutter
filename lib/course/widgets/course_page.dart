import 'package:flutter/material.dart' hide Route;
import 'package:hpi_flutter/app/widgets/app_bar.dart';
import 'package:hpi_flutter/app/widgets/main_scaffold.dart';
import 'package:hpi_flutter/app/widgets/utils.dart';
import 'package:hpi_flutter/core/localizations.dart';
import 'package:hpi_flutter/core/widgets/utils.dart';
import 'package:hpi_flutter/course/data/bloc.dart';
import 'package:hpi_flutter/route.dart';
import 'package:kt_dart/collection.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';

import '../data/course.dart';
import '../utils.dart';

@immutable
class CoursePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProxyProvider<Uri, CourseBloc>(
      builder: (_, serverUrl, __) => CourseBloc(serverUrl),
      child: MainScaffold(
        body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                child: HpiSliverAppBar(
                  floating: true,
                  pinned: true,
                  forceElevated: innerBoxIsScrolled,
                  title: Text(HpiL11n.get(context, 'course')),
                  bottom: TabBar(
                    indicatorColor: Theme.of(context).primaryColor,
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Theme.of(context)
                        .textTheme
                        .body2
                        .color
                        .withOpacity(0.7),
                    tabs: [
                      Tab(text: HpiL11n.get(context, 'course/tab.current')),
                      Tab(text: HpiL11n.get(context, 'course/tab.all')),
                    ],
                  ),
                ),
              )
            ],
            body: TabBarView(
              children: KtList.from([
                KtPair('tab:course', CourseList()),
                KtPair('tab:courseSeries', CourseSeriesList()),
              ])
                  .mapIndexed((index, tab) => SafeArea(
                        top: false,
                        bottom: false,
                        child: Builder(
                          builder: (context) => CustomScrollView(
                            key: PageStorageKey(tab.first),
                            slivers: <Widget>[
                              SliverOverlapInjector(
                                handle: NestedScrollView
                                    .sliverOverlapAbsorberHandleFor(context),
                              ),
                              tab.second,
                            ],
                          ),
                        ),
                      ))
                  .asList(),
            ),
          ),
        ),
      ),
    );
  }
}

class CourseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<KtList<Course>>(
      stream: Provider.of<CourseBloc>(context).getCourses(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return buildLoadingErrorSliver(snapshot);

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              var course = snapshot.data[index];

              return StreamBuilder<CourseSeries>(
                stream: Provider.of<CourseBloc>(context)
                    .getCourseSeries(course.courseSeriesId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return ListTile(
                      title: Text(snapshot.hasError
                          ? snapshot.error.toString()
                          : HpiL11n.get(context, 'loading')),
                    );

                  return ListTile(
                    title: Text(snapshot.data.title),
                    subtitle: Text(course.lecturer),
                    onTap: () {
                      Navigator.of(context).pushNamed(Route.coursesDetail.name,
                          arguments: course.id);
                    },
                  );
                },
              );
            },
            childCount: snapshot.data.size,
          ),
        );
      },
    );
  }
}

class CourseSeriesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<KtList<CourseSeries>>(
      stream: Provider.of<CourseBloc>(context).getAllCourseSeries(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return buildLoadingErrorSliver(snapshot);

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              var courseSeries = snapshot.data[index];

              return ExpansionTile(
                key: PageStorageKey(courseSeries.id),
                title: Text(courseSeries.title),
                children: <Widget>[
                  ListTile(
                    leading: Icon(OMIcons.info),
                    title: Text(
                      HpiL11n.get(
                        context,
                        'course/course.details',
                        args: [courseSeries.ects, courseSeries.hoursPerWeek],
                      ),
                    ),
                    subtitle: Text(courseSeries.types
                        .map((t) => courseTypeToString(context, t))
                        .joinToString(separator: ' · ')),
                  ),
                  ListTile(
                    leading: Icon(OMIcons.language),
                    title: Text(getLanguage(context, courseSeries.language)),
                  ),
                ],
              );
            },
            childCount: snapshot.data.size,
          ),
        );
      },
    );
  }
}
