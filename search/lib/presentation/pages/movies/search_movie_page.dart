import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/widget/movie_card_list.dart';
import 'package:provider/provider.dart';
import 'package:search/presentation/bloc/movies/search_movies_bloc.dart';
import 'package:search/search.dart';

class SearchMoviePage extends StatelessWidget {
  static const routeName = '/movie-search';

  const SearchMoviePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              key: const Key('query_input'),
              onChanged: (query) {
                context.read<SearchMoviesBloc>().add(OnChangeMovieQuery(query));
              },
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            BlocBuilder<SearchMoviesBloc, SearchMoviesState>(
              builder: (context, movie) {
                if (movie is SearchMoviesLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (movie is SearchMoviesHasData) {
                  return Expanded(
                    child: ListView.builder(
                      key: const Key('search_list'),
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        return MovieCard(
                          movie: movie.result[index],
                        );
                      },
                      itemCount: movie.result.length,
                    ),
                  );
                } else if (movie is SearchMoviesError) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Center(
                      key: const Key('error_message'),
                      child: Text(movie.message),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
