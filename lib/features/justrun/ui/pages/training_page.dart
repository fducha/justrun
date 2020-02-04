import 'package:flutter/material.dart';
import 'package:justrun/common/localization/app_localization.dart';
import 'package:justrun/common/utils/utils.dart';
import 'package:justrun/features/justrun/models/entities/exercise.dart';
import 'package:justrun/features/justrun/models/entities/task.dart';

class TrainingPage extends StatelessWidget {
  TrainingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double itemHeight = MediaQuery.of(context).size.height / 10;
    double itemWidth = MediaQuery.of(context).size.width - 16.0;

    final running = Exercise(
      title: AppLocalization.of(context).normalRunTitle,
      color: Colors.green[500],
    );
    final walking = Exercise(
      title: AppLocalization.of(context).walkingTitle,
      color: Colors.pink[300],
    );
    final List<Task> _tasks = [
      Task(exercise: running, duration: 60),
      Task(exercise: walking, duration: 60),
      Task(exercise: running, duration: 60),
      Task(exercise: walking, duration: 60),
      Task(exercise: running, duration: 60),
      Task(exercise: walking, duration: 60),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.of(context).appTitle),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          return index == 0
              ? _buildCurrentItem(
                  _tasks[index],
                  index,
                  itemHeight * 2,
                  itemWidth,
                  Theme.of(context).textTheme.body1.copyWith(
                        fontSize: 48,
                        color: Colors.white,
                      ),
                )
              : _buildItem(
                  _tasks[index],
                  index,
                  itemHeight,
                  Theme.of(context).textTheme.body1.copyWith(
                        fontSize: 26,
                        color: Colors.white,
                      ),
                );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(
          Icons.play_arrow,
          size: 36.0,
        ),
        onPressed: () {},
        label: Text(
          'Start',
          style: Theme.of(context)
              .textTheme
              .body1
              .copyWith(fontSize: 28.0, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildItem(Task task, int index, double height, TextStyle style) {
    return Card(
      color: task.exercise.color,
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 36.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              task.exercise.title,
              style: style,
            ),
            Text(
              timeToString(task.duration),
              style: style,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentItem(
      Task task, int index, double height, double width, TextStyle style) {
    return Card(
      color: task.exercise.color,
      child: Container(
        padding: EdgeInsets.all(0.0),
        height: height,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  task.exercise.title,
                  style: style.copyWith(
                    fontSize: 28.0,
                  ),
                ),
              ),
            ),
            Align(
              child: Text(
                timeToString(task.duration),
                style: style,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: height / 4,
                color: Colors.green[300],
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                height: height / 4,
                width: width * 0.67,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
