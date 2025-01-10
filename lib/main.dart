
import 'package:check/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:check/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:check/features/daily_news/presentation/pages/home/daily_news.dart';
import 'package:check/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await intilizeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<RemoteArticleBloc>(
      create: (context)=>sl()..add(const GetArticles()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const DailyNews(),
      ),
    );
  }
}

