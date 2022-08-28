import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie/domain/entities/genre.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/presentation/cubit/movie_detail_cubit.dart';
import 'package:watchlist/watchlist.dart';

class MovieDetailPage extends StatefulWidget {
  static const routeName = '/movie-detail';

  final int id;
  const MovieDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MovieDetailCubit>().fetchMovieDetail(widget.id);
      context.read<WatchlistCubit>().loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WatchlistCubit, WatchlistState>(
      listenWhen: (context, state) => state is WatchlistMessage,
      listener: (context, message) {
        if (message is WatchlistMessage) {
          if (message.watchlistMessage == WatchlistCubit.addWatchlistMessage ||
              message.watchlistMessage ==
                  WatchlistCubit.removeWatchlistMessage) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message.watchlistMessage),
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(message.watchlistMessage),
                );
              },
            );
          }
        }
      },
      child: Scaffold(
        body: BlocBuilder<MovieDetailCubit, MovieDetailState>(
          builder: (context, detail) {
            return BlocBuilder<WatchlistCubit, WatchlistState>(
              builder: (context, status) {
                if (detail is MovieDetailLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (detail is MovieDetailLoaded &&
                    status is WatchlistStatus) {
                  return SafeArea(
                    child: DetailContent(
                      movie: detail.detailMovie,
                      isAddedWatchlist: status.isAddedToWatchlist,
                    ),
                  );
                } else if (detail is MovieDetailError) {
                  return Text(
                    detail.message,
                  );
                } else {
                  return const SizedBox();
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final MovieDetail movie;
  final bool isAddedWatchlist;

  const DetailContent({
    Key? key,
    required this.movie,
    required this.isAddedWatchlist,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                final data = Movie.watchlist(
                                  id: movie.id,
                                  overview: movie.overview,
                                  posterPath: movie.posterPath,
                                  title: movie.title,
                                  type: movie.type,
                                );
                                if (!isAddedWatchlist) {
                                  context.read<WatchlistCubit>()
                                    ..addWatchlist(data)
                                    ..fetchWatchlist();
                                } else {
                                  context.read<WatchlistCubit>()
                                    ..deleteWatchlist(data.id)
                                    ..fetchWatchlist();
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? const Icon(Icons.check)
                                      : const Icon(Icons.add),
                                  const Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(movie.genres),
                            ),
                            Text(
                              _showDuration(movie.runtime),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: movie.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${movie.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              movie.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<MovieDetailCubit, MovieDetailState>(
                              builder: (context, recommendation) {
                                if (recommendation
                                    is MovieRecommendationLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (recommendation
                                    is MovieRecommendationError) {
                                  return Text(
                                    recommendation.message,
                                  );
                                } else if (recommendation
                                    is MovieDetailLoaded) {
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      key: const Key('recommended_list'),
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final movie = recommendation
                                            .recomendationMovie[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                MovieDetailPage.routeName,
                                                arguments: movie.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: Image.network(
                                                  '$baseImageUrl${movie.posterPath}'),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: recommendation
                                          .recomendationMovie.length,
                                    ),
                                  );
                                } else {
                                  return const Center();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              key: const Key('back_from_detail'),
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                context.read<WatchlistCubit>().fetchWatchlist();
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
