import 'package:about/about_page.dart';
import 'package:core/core.dart';
import 'package:core/presentation/cubit/watchlist_cubit.dart';
import 'package:core/presentation/pages/watchlist_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:movie/presentation/cubit/movie_detail_cubit.dart';
import 'package:movie/presentation/cubit/movie_now_playing_cubit.dart';
import 'package:movie/presentation/cubit/movie_popular_cubit.dart';
import 'package:movie/presentation/cubit/movie_top_rated_cubit.dart';
import 'package:movie/presentation/pages/home_movie_page.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';
import 'package:provider/provider.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:search/search.dart';
import 'package:tv_series/presentation/cubit/episode_cubit.dart';
import 'package:tv_series/presentation/cubit/tv_series_detail_cubit.dart';
import 'package:tv_series/presentation/cubit/tv_series_now_playing_cubit.dart';
import 'package:tv_series/presentation/cubit/tv_series_popular_cubit.dart';
import 'package:tv_series/presentation/cubit/tv_series_top_rated_cubit.dart';
import 'package:tv_series/presentation/pages/home_tv_series_page.dart';
import 'package:tv_series/presentation/pages/now_playing_tv_series_page.dart';
import 'package:tv_series/presentation/pages/popular_tv_series_page.dart';
import 'package:tv_series/presentation/pages/top_rated_tv_series_page.dart';
import 'package:tv_series/presentation/pages/tv_series_detail_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  di.init(await getHttpClient());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<EpisodeCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieNowPlayingCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MoviePopularCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieTopRatedCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieDetailCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvSeriesDetailCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvSeriesNowPlayingCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvSeriesPopularCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvSeriesTopRatedCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchTvSeriesBloc>(),
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
