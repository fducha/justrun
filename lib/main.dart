import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import 'core/localization/app_localization.dart';
import 'features/justrun/data/repositories/repository_impl.dart';
import 'features/justrun/domain/pure_models/training_model.dart';
import 'features/justrun/domain/repositories/repository.dart';
import 'features/justrun/ui/pages/training_page.dart';

void main() {
  runApp(JustRunApp(
    repository: RepositoryImpl(),
  ));
}

class JustRunApp extends StatelessWidget {
  final Repository repository;

  const JustRunApp({Key key, @required this.repository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Injector(
      inject: [
        Inject(() => TrainingModel(repository: repository)),
      ],
      builder: (context) => MaterialApp(
        supportedLocales: [
          Locale('en'),
          Locale('ru'),
        ],
        localizationsDelegates: [
          AppLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supLocale in supportedLocales) {
            if (supLocale.languageCode == locale.languageCode) return supLocale;
          }
          return supportedLocales.first;
        },
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StateBuilder<TrainingModel>(
          models: [Injector.getAsReactive<TrainingModel>()],
          initState: (context, rxTrainingModel) =>
              rxTrainingModel.setState((s) async => await s.fetch()),
          builder: (context, rxTrainingModel) =>
              rxTrainingModel.whenConnectionState(
            onIdle: () => EmptyScaffold(child: Text('nothing\'s happening')),
            onWaiting: () => EmptyScaffold(child: CircularProgressIndicator()),
            onError: (error) => EmptyScaffold(child: Text(error.toString())),
            onData: (_) => TrainingPage(),
          ),
        ),
      ),
    );
  }
}

class EmptyScaffold extends StatelessWidget {
  final Widget child;

  const EmptyScaffold({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.of(context).appTitle),
        centerTitle: true,
      ),
      body: Center(
        child: child,
      ),
    );
  }
}
