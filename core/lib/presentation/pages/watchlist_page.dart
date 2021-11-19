import 'package:core/core.dart';
import 'package:core/domain/entities/tv_series/tv_series.dart';
import 'package:core/presentation/provider/watchlist_notifier.dart';
import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistPage extends StatefulWidget {
  static const routeName = '/watchlist';

  const WatchlistPage({Key? key}) : super(key: key);

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () {
        Provider.of<WatchlistNotifier>(context, listen: false).fetchWatchlist();
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
        child: Consumer<WatchlistNotifier>(
          builder: (context, data, child) {
            if (data.watchlistState == RequestState.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.watchlistState == RequestState.loaded) {
              if (data.watchlist.isNotEmpty) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final watchlist = data.watchlist[index];
                    final tvWatchlist = TvSeries.watchlist(
                      id: watchlist.id,
                      overview: watchlist.overview,
                      posterPath: watchlist.posterPath,
                      title: watchlist.title,
                      type: watchlist.type,
                    );
                    if (watchlist.type == 'Movie') {
                      return MovieCard(movie: watchlist);
                    } else {
                      return TvCard(tvSeries: tvWatchlist);
                    }
                  },
                  itemCount: data.watchlist.length,
                );
              } else {
                return SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: const Center(
                    key: Key('empty_message'),
                    child: Text(
                      'Wathlist is Empty',
                    ),
                  ),
                );
              }
            } else {
              return Center(
                key: const Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}
