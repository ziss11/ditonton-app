import 'package:about/about_page.dart';
import 'package:core/core.dart';
import 'package:ditonton/injection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:movie/movie.dart';
import 'package:search/search.dart';
import 'package:tv_series/tv_series.dart';
import 'package:watchlist/watchlist.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await dotenv.load(fileName: '.env');

  Injection.init(await getHttpClient());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GetIt.I<EpisodeCubit>(),
        ),
        BlocProvider(
          create: (_) => GetIt.I<MovieNowPlayingCubit>(),
        ),
        BlocProvider(
          create: (_) => GetIt.I<MoviePopularCubit>(),
        ),
        BlocProvider(
          create: (_) => GetIt.I<MovieTopRatedCubit>(),
        ),
        BlocProvider(
          create: (_) => GetIt.I<MovieDetailCubit>(),
        ),
        BlocProvider(
          create: (_) => GetIt.I<WatchlistCubit>(),
        ),
        BlocProvider(
          create: (_) => GetIt.I<TvSeriesDetailCubit>(),
        ),
        BlocProvider(
          create: (_) => GetIt.I<TvSeriesNowPlayingCubit>(),
        ),
        BlocProvider(
          create: (_) => GetIt.I<TvSeriesPopularCubit>(),
        ),
        BlocProvider(
          create: (_) => GetIt.I<TvSeriesTopRatedCubit>(),
        ),
        BlocProvider(
          create: (_) => GetIt.I<SearchMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => GetIt.I<SearchTvSeriesBloc>(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          colorScheme: kColorScheme.copyWith(secondary: kMikadoYellow),
        ),
        home: HomeMoviePage(),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case HomeMoviePage.routeName:
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case PopularMoviesPage.routeName:
              return MaterialPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.routeName:
              return MaterialPageRoute(builder: (_) => TopRatedMoviesPage());
            case TopRatedTvSeriesPage.routeName:
              return MaterialPageRoute(builder: (_) => TopRatedTvSeriesPage());
            case MovieDetailPage.routeName:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SearchMoviePage.routeName:
              return MaterialPageRoute(builder: (_) => SearchMoviePage());
            case SearchTvSeriesPage.routeName:
              return MaterialPageRoute(builder: (_) => SearchTvSeriesPage());
            case WatchlistPage.routeName:
              return MaterialPageRoute(builder: (_) => WatchlistPage());
            case HomeTvSeriesPage.routeName:
              return MaterialPageRoute(builder: (_) => HomeTvSeriesPage());
            case NowPlayingTvPage.routeName:
              return MaterialPageRoute(builder: (_) => NowPlayingTvPage());
            case TvSeriesDetailPage.routeName:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvSeriesDetailPage(id: id),
                settings: settings,
              );
            case PopularTvSeriesPage.routeName:
              return MaterialPageRoute(builder: (_) => PopularTvSeriesPage());
            case AboutPage.routeName:
              return MaterialPageRoute(builder: (_) => AboutPage());
            default:
              return MaterialPageRoute(
                builder: (_) {
                  return Scaffold(
                    body: Center(
                      child: Text('Page not found :('),
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
