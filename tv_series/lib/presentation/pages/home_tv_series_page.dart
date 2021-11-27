import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/presentation/pages/watchlist_page.dart';
import 'package:core/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/pages/home_movie_page.dart';
import 'package:provider/provider.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/presentation/cubit/tv_series_now_playing_cubit.dart';
import 'package:tv_series/presentation/cubit/tv_series_popular_cubit.dart';
import 'package:tv_series/presentation/cubit/tv_series_top_rated_cubit.dart';
import 'package:tv_series/presentation/pages/popular_tv_series_page.dart';
import 'package:tv_series/presentation/pages/top_rated_tv_series_page.dart';
import 'package:tv_series/presentation/pages/tv_series_detail_page.dart';

import 'now_playing_tv_series_page.dart';

class HomeTvSeriesPage extends StatefulWidget {
  static const routeName = '/home-tvseries';

  const HomeTvSeriesPage({Key? key}) : super(key: key);

  @override
  _HomeTvSeriesPageState createState() => _HomeTvSeriesPageState();
}

class _HomeTvSeriesPageState extends State<HomeTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvSeriesNowPlayingCubit>().fetchNowPlayingTv();
      context.read<TvSeriesPopularCubit>().fetchPopularTv();
      context.read<TvSeriesTopRatedCubit>().fetchTopRatedTv();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: const Icon(Icons.movie),
              title: const Text('Movies'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  HomeMoviePage.routeName,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.tv_rounded),
              title: const Text('Tv Series'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  WatchlistPage.routeName,
                );
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  aboutRoute,
                );
              },
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Ditonton'),
        actions: [
          IconButton(
            key: const Key('search_icon'),
            onPressed: () {
              Navigator.pushNamed(context, searchTvSeriesRoute);
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
              _buildSubHeading(
                title: 'Now Playing',
                onTap: () => Navigator.pushNamed(
                  context,
                  NowPlayingTvPage.routeName,
                ),
              ),
              BlocBuilder<TvSeriesNowPlayingCubit, TvSeriesNowPlayingState>(
                  builder: (context, nowPlaying) {
                if (nowPlaying is TvSeriesNowPlayingLoading) {
                  return const Center(
                    key: Key('center_progressbar'),
                    child: CircularProgressIndicator(),
                  );
                } else if (nowPlaying is TvSeriesNowPlayingLoaded) {
                  return TvSeriesList(
                    key: const Key('now_playing_list'),
                    tvSeries: nowPlaying.nowPlayingTvSeries,
                  );
                } else {
                  return const Text('Failed');
                }
              }),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularTvSeriesPage.routeName),
              ),
              BlocBuilder<TvSeriesPopularCubit, TvSeriesPopularState>(
                  builder: (context, popular) {
                if (popular is TvSeriesPopularLoading) {
                  return const Center(
                    key: Key('center_progressbar'),
                    child: CircularProgressIndicator(),
                  );
                } else if (popular is TvSeriesPopularLoaded) {
                  return TvSeriesList(
                    key: const Key('popular_list'),
                    tvSeries: popular.popularTvSeries,
                  );
                } else {
                  return const Text('Failed');
                }
              }),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () => Navigator.pushNamed(
                    context, TopRatedTvSeriesPage.routeName),
              ),
              BlocBuilder<TvSeriesTopRatedCubit, TvSeriesTopRatedState>(
                  builder: (context, top) {
                if (top is TvSeriesTopRatedLoading) {
                  return const Center(
                    key: Key('center_progressbar'),
                    child: CircularProgressIndicator(),
                  );
                } else if (top is TvSeriesTopRatedLoaded) {
                  return TvSeriesList(
                    key: const Key('top_rated_list'),
                    tvSeries: top.topRatedTv,
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
              children: const [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class TvSeriesList extends StatelessWidget {
  final List<TvSeries> tvSeries;

  const TvSeriesList({Key? key, required this.tvSeries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvSeries[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvSeriesDetailPage.routeName,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${tv.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvSeries.length,
      ),
    );
  }
}
