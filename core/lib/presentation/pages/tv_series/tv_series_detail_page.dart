import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie/genre.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:core/domain/entities/tv_series/tv_series.dart';
import 'package:core/domain/entities/tv_series/tv_series_detail.dart';
import 'package:core/presentation/provider/movie/movie_detail_notifier.dart';
import 'package:core/presentation/provider/tv_series/tv_series_detail_notifier.dart';
import 'package:core/presentation/provider/watchlist_notifier.dart';
import 'package:core/presentation/widgets/episode_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

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
          Provider.of<TvSeriesDetailNotifier>(context, listen: false)
              .fetchTvSeriesDetail(widget.id);
          Provider.of<MovieDetailNotifier>(context, listen: false)
              .loadWatchlistStatus(widget.id);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Consumer<TvSeriesDetailNotifier>(
        builder: (context, provider, child) {
          if (provider.tvSeriesState == RequestState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (provider.tvSeriesState == RequestState.loaded) {
            final tv = provider.tvSeriesDetail;
            final isAddedToWatchlist =
                Provider.of<MovieDetailNotifier>(context).isAddedToWatchlist;
            return SafeArea(
              child: DetailTvContent(
                tv: tv,
                recommendations: provider.recomendedTvSeries,
                isAddedWatchlist: isAddedToWatchlist,
              ),
            );
          } else {
            return Text(provider.message);
          }
        },
      ),
    );
  }
}

class DetailTvContent extends StatefulWidget {
  final TvSeriesDetail tv;
  final List<TvSeries> recommendations;
  final bool isAddedWatchlist;

  const DetailTvContent({
    Key? key,
    required this.tv,
    required this.recommendations,
    required this.isAddedWatchlist,
  }) : super(key: key);

  @override
  State<DetailTvContent> createState() => _DetailTvContentState();
}

class _DetailTvContentState extends State<DetailTvContent>
    with SingleTickerProviderStateMixin {
  late TabController tabController = TabController(
    length: widget.tv.seasons!.length,
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
                                  await Provider.of<MovieDetailNotifier>(
                                          context,
                                          listen: false)
                                      .addWatchlist(tv)
                                      .whenComplete(
                                        () => Provider.of<WatchlistNotifier>(
                                                context,
                                                listen: false)
                                            .fetchWatchlist(),
                                      );
                                } else {
                                  await Provider.of<MovieDetailNotifier>(
                                          context,
                                          listen: false)
                                      .deleteWatchlist(widget.tv.id)
                                      .whenComplete(
                                        () => Provider.of<WatchlistNotifier>(
                                                context,
                                                listen: false)
                                            .fetchWatchlist(),
                                      );
                                }
                                final message =
                                    Provider.of<MovieDetailNotifier>(context,
                                            listen: false)
                                        .watchlistMessage;

                                if (message ==
                                        MovieDetailNotifier
                                            .watchlistAddSuccessMessage ||
                                    message ==
                                        MovieDetailNotifier
                                            .watchlistRemoveSuccessMessage) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(message)));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(message),
                                        );
                                      });
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
                              tabs: widget.tv.seasons!
                                  .map((season) => Text(season.name))
                                  .toList(),
                            ),
                            SizedBox(
                              height: 120,
                              child: TabBarView(
                                controller: tabController,
                                children: widget.tv.seasons!.map((season) {
                                  return Consumer<TvSeriesDetailNotifier>(
                                    builder: (context, episode, child) {
                                      return EpisodeCardList(
                                        id: widget.tv.id,
                                        season: season.seasonNumber,
                                      );
                                    },
                                  );
                                }).toList(),
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
                            Consumer<TvSeriesDetailNotifier>(
                              builder: (context, data, child) {
                                if (data.recommendedState ==
                                    RequestState.loading) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      key: Key('recommended_loading'),
                                    ),
                                  );
                                } else if (data.recommendedState ==
                                    RequestState.error) {
                                  return Text(
                                    data.message,
                                    key: const Key('recommended_error'),
                                  );
                                } else if (data.recommendedState ==
                                    RequestState.loaded) {
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      key: const Key('recommended_list'),
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final tv =
                                            widget.recommendations[index];
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
                                      itemCount: widget.recommendations.length,
                                    ),
                                  );
                                } else {
                                  return Container();
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
              onPressed: () => Navigator.pop(context),
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
