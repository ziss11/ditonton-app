import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/cubit/movie_top_rated_cubit.dart';
import 'package:movie/presentation/widget/movie_card_list.dart';

class TopRatedMoviesPage extends StatefulWidget {
  static const routeName = '/top-rated-movie';

  const TopRatedMoviesPage({Key? key}) : super(key: key);

  @override
  _TopRatedMoviesPageState createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<MovieTopRatedCubit>().fetchTopRatedMovie(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<MovieTopRatedCubit, MovieTopRatedState>(
          builder: (context, popular) {
            if (popular is MovieTopRatedLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (popular is MovieTopRatedLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return MovieCard(movie: popular.topRatedMovie[index]);
                },
                itemCount: popular.topRatedMovie.length,
              );
            } else if (popular is MovieTopRatedError) {
              return Center(
                key: const Key('error_message'),
                child: Text(popular.message),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
