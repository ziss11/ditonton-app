import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie/domain/entities/genre.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';
import 'package:tv_series/presentation/cubit/tv_series_detail_cubit.dart';
import 'package:tv_series/presentation/widget/episode_card_list.dart';
import 'package:watchlist/watchlist.dart';

class TvSeriesDetailPage extends StatefulWidget {
  static const routeName = '/tv-series-detail';

  final int id;
  const TvSeriesDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  State<TvSeriesDetailPage> createState() => _TvSeriesDetailPageState();
}

class _TvSeriesDetailPageState extends State<TvSeriesDetailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () {
        Future.microtask(() {
          context.read<TvSeriesDetailCubit>().fetchDetailTv(widget.id);
          context.read<WatchlistCubit>().loadWatchlistStatus(widget.id);
        });
      },
    );
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
        key: _scaffoldKey,
        body: BlocBuilder<TvSeriesDetailCubit, TvSeriesDetailState>(
          builder: (context, detail) {
            return BlocBuilder<WatchlistCubit, WatchlistState>(
              builder: (context, status) {
                if (detail is TvSeriesDetailLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (detail is TvSeriesDetailLoaded &&
                    status is WatchlistStatus) {
                  return SafeArea(
                    child: DetailTvContent(
                      tv: detail.tvSeriesDetail,
                      isAddedWatchlist: status.isAddedToWatchlist,
                    ),
                  );
                } else if (detail is TvSeriesDetailError) {
                  return Text(detail.message);
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

class DetailTvContent extends StatefulWidget {
  final TvSeriesDetail tv;
  final bool isAddedWatchlist;

  const DetailTvContent({
    Key? key,
    required this.tv,
    required this.isAddedWatchlist,
  }) : super(key: key);

  @override
  State<DetailTvContent> createState() => _DetailTvContentState();
}

class _DetailTvContentState extends State<DetailTvContent>
    with SingleTickerProviderStateMixin {
  late TabController tabController = TabController(
    length: widget.tv.seasons.length,
    vsync: this,
  );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${widget.tv.posterPath}',
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
                              widget.tv.title!,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final tv = Movie.watchlist(
                                  id: widget.tv.id,
                                  overview: widget.tv.overview,
                                  posterPath: widget.tv.posterPath,
                                  title: widget.tv.title,
                                  type: widget.tv.type,
                                );
                                if (!widget.isAddedWatchlist) {
                                  context.read<WatchlistCubit>()
                                    ..addWatchlist(tv)
                                    ..fetchWatchlist();
                                } else {
                                  context.read<WatchlistCubit>()
                                    ..deleteWatchlist(tv.id)
                                    ..fetchWatchlist();
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  widget.isAddedWatchlist
                                      ? const Icon(Icons.check)
                                      : const Icon(Icons.add),
                                  const Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(widget.tv.genres!),
                            ),
                            Text(
                              _showDuration(widget.tv.episodeRunTime[0]),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: widget.tv.voteAverage! / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${widget.tv.voteAverage}')
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            TabBar(
                              controller: tabController,
                              isScrollable: true,
                              indicatorColor: kMikadoYellow,
                              labelPadding: const EdgeInsets.all(5),
                              padding: const EdgeInsets.all(5),
                              tabs: widget.tv.seasons
                                  .map((season) => Text(season.name))
                                  .toList(),
                            ),
                            SizedBox(
                              height: 120,
                              child: TabBarView(
                                controller: tabController,
                                children: widget.tv.seasons.map(
                                  (season) {
                                    return EpisodeCardList(
                                      id: widget.tv.id,
                                      season: season.seasonNumber,
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              widget.tv.overview!,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<TvSeriesDetailCubit,
                                TvSeriesDetailState>(
                              builder: (context, recommendations) {
                                if (recommendations
                                    is TvSeriesRecommendationLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      key: Key('recommended_loading'),
                                    ),
                                  );
                                } else if (recommendations
                                    is TvSeriesRecommendationError) {
                                  return Text(
                                    recommendations.message,
                                    key: const Key('recommended_error'),
                                  );
                                } else if (recommendations
                                    is TvSeriesDetailLoaded) {
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      key: const Key('recommended_list'),
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final tv = recommendations
                                            .recommendationTv[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                TvSeriesDetailPage.routeName,
                                                arguments: tv.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: Image.network(
                                                '$baseImageUrl${tv.posterPath}',
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: recommendations
                                          .recommendationTv.length,
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
              key: const Key('back_from_tv_detail'),
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
      return '${hours}h ${minutes}m / episode';
    } else {
      return '${minutes}m / episode';
    }
  }
}
