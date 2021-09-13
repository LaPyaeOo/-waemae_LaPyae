import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'MyHomePage.dart';
import 'constants/colors.dart';

void main() async {
  /***************************************************
      You can either add some code below or
      create a new file.
   ***************************************************/
  await initHiveForFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  final HttpLink link = HttpLink('https://9aa7-128-199-112-22.ngrok.io/');
  ValueNotifier<GraphQLClient>client = ValueNotifier(
    GraphQLClient(link: link,cache:GraphQLCache(store: HiveStore())),
  );
  runApp(MyApp(client: client,));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.client});
  final ValueNotifier<GraphQLClient> client;

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: MaterialApp(
          title: 'Waemae Jobs Finder',
          theme: ThemeData(
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: BgColor
          ),
          debugShowCheckedModeBanner: false,
          home: MyHomePage(client: client,),
        ),
      ),
    );
  }
}