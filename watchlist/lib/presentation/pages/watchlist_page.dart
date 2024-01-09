import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/widget/movie_card_list.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/presentation/widget/tv_card_list.dart';
import 'package:watchlist/presentation/cubit/watchlist_cubit.dart';

class WatchlistPage extends StatefulWidget {
  static const routeName = '/watchlist';

  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () {
        context.read<WatchlistCubit>().fetchWatchlist();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistCubit, WatchlistState>(
          builder: (context, watchlist) {
            if (watchlist is WatchlistInitial) {
              return SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: const Center(
                  key: Key('empty_message'),
                  child: Text(
                    'Watchlist is Empty',
                  ),
                ),
              );
            } else if (watchlist is WatchlistLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (watchlist is WatchlistLoaded) {
              if (watchlist.watchlist.isNotEmpty) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final data = watchlist.watchlist[index];
                    final tvWatchlist = TvSeries.watchlist(
                      id: data.id,
                      overview: data.overview,
                      posterPath: data.posterPath,
                      title: data.title,
                      type: data.type,
                    );
                    if (data.type == 'Movie') {
                      return MovieCard(movie: data);
                    } else {
                      return TvCard(tvSeries: tvWatchlist);
                    }
                  },
                  itemCount: watchlist.watchlist.length,
                );
              } else {
                return const Center(
                  key: Key('empty_message'),
                  child: Text(
                    'Watchlist is Empty',
                  ),
                );
              }
            } else if (watchlist is WatchlistMessage) {
              return SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: Center(
                  key: const Key('error_message'),
                  child: Text(
                    watchlist.watchlistMessage,
                  ),
                ),
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
