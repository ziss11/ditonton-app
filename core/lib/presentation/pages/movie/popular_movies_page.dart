import 'package:core/core.dart';
import 'package:core/presentation/cubit/movie/movie_now_playing_cubit.dart';
import 'package:core/presentation/cubit/movie/movie_popular_cubit.dart';
import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class PopularMoviesPage extends StatefulWidget {
  static const routeName = '/popular-movie';

  const PopularMoviesPage({Key? key}) : super(key: key);

  @override
  _PopularMoviesPageState createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<MoviePopularCubit>().fetchPopularMovie(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<MoviePopularCubit, MoviePopularState>(
          builder: (context, popular) {
            if (popular is MoviePopularLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (popular is MoviePopularLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return MovieCard(movie: popular.popularMovie[index]);
                },
                itemCount: popular.popularMovie.length,
              );
            } else if (popular is MoviePopularError) {
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
