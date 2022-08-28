import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/styles/text_style.dart';
import 'package:core/utils/constants.dart';
import 'package:core/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/presentation/cubit/movie_now_playing_cubit.dart';
import 'package:movie/presentation/cubit/movie_popular_cubit.dart';
import 'package:movie/presentation/cubit/movie_top_rated_cubit.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';

import 'movie_detail_page.dart';

class HomeMoviePage extends StatefulWidget {
  static const routeName = '/home-movies';

  const HomeMoviePage({Key? key}) : super(key: key);

  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MovieNowPlayingCubit>().fetchNowPlayingMovie();
      context.read<MoviePopularCubit>().fetchPopularMovie();
      context.read<MovieTopRatedCubit>().fetchTopRatedMovie();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ditonton'),
        leading: const Icon(Icons.menu),
        actions: [
          IconButton(
            key: const Key('search_icon'),
            onPressed: () {
              Navigator.pushNamed(context, searchMovieRoute);
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Now Playing',
                style: kHeading6,
              ),
              BlocBuilder<MovieNowPlayingCubit, MovieNowPlayingState>(
                  builder: (context, nowPlaying) {
                if (nowPlaying is MovieNowPlayingLoading) {
                  return const Center(
                    key: Key('center_progressbar'),
                    child: CircularProgressIndicator(),
                  );
                } else if (nowPlaying is MovieNowPlayingLoaded) {
                  return MovieList(
                    key: const Key('now_playing_list'),
                    movies: nowPlaying.nowPlayingMovie,
                  );
                } else {
                  return const Text('Failed');
                }
              }),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularMoviesPage.routeName),
              ),
              BlocBuilder<MoviePopularCubit, MoviePopularState>(
                  builder: (context, popular) {
                if (popular is MoviePopularLoading) {
                  return const Center(
                    key: Key('center_progressbar'),
                    child: CircularProgressIndicator(),
                  );
                } else if (popular is MoviePopularLoaded) {
                  return MovieList(
                    key: const Key('popular_list'),
                    movies: popular.popularMovie,
                  );
                } else {
                  return const Text('Failed');
                }
              }),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedMoviesPage.routeName),
              ),
              BlocBuilder<MovieTopRatedCubit, MovieTopRatedState>(
                  builder: (context, top) {
                if (top is MovieTopRatedLoading) {
                  return const Center(
                    key: Key('center_progressbar'),
                    child: CircularProgressIndicator(),
                  );
                } else if (top is MovieTopRatedLoaded) {
                  return MovieList(
                    key: const Key('top_rated_list'),
                    movies: top.topRatedMovie,
                  );
                } else {
                  return const Text('Failed');
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [
                Text('See More'),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie>? movies;

  const MovieList({Key? key, required this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        itemCount: movies!.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies![index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MovieDetailPage.routeName,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  key: Key(movie.title!),
                  imageUrl: '$baseImageUrl${movie.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
