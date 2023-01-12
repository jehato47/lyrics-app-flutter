import 'package:flutter/material.dart';
import 'providers/auth.dart';
import 'providers/search.dart';
import 'screens/splash_screen.dart';
import 'helpers/custom_route.dart';
import 'package:provider/provider.dart';
import 'screens/song_detail_screen.dart';
import 'screens/song_overview_screen.dart';
import 'screens/add_song_screen.dart';
import 'screens/search_song_screen.dart';
import 'screens/searched_detail_screen.dart';
import 'screens/auth_screen.dart';
import 'providers/song.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, SongListP>(
          builder: (ctx, auth, previousSLP) => SongListP(
            auth.token,
            auth.userId,
            previousSLP == null ? [] : previousSLP.songs,
          ),
        ),
        ChangeNotifierProvider(
          builder: (ctx) => SearchProvider(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Lyrics App',
          theme: ThemeData(
            hintColor: Colors.white54,
            appBarTheme: AppBarTheme(),

            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.redAccent,
            ),
            errorColor: Colors.white,
            fontFamily: "JetBrains",
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
              },
            ),
            primarySwatch: Colors.amber,
            // primaryColor: Colors.black,
          ),
          routes: {
            "/": (ctx) => auth.isAuth
                ? SongOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen(
                              snapshot.error != null
                                  ? (snapshot.error as String)
                                  : (null as String),
                            )
                          : AuthScreen();
                    }),
            SongDetailScreen.url: (ctx) => SongDetailScreen(),
            AddSongScreen.url: (ctx) => AddSongScreen(),
            SearchSongScreen.url: (ctx) => SearchSongScreen(),
            SearchedDetailScreen.url: (ctx) => SearchedDetailScreen(),
            AuthScreen.url: (ctx) => AuthScreen(),
          },
        ),
      ),
    );
  }
}
