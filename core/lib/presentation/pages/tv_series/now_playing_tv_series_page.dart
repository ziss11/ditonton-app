import 'package:core/presentation/provider/tv_series/tv_series_list_notifier.dart';
import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NowPlayingTvPage extends StatefulWidget {
  static const routeName = '/now-playing-tv';
  const NowPlayingTvPage({Key? key}) : super(key: key);

  @override
  _NowPlayingTvPageState createState() => _NowPlayingTvPageState();
}

class _NowPlayingTvPageState extends State<NowPlayingTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<TvSeriesListNotifier>(context, listen: false)
            .fetchNowPlayingTvSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TvSeriesListNotifier>(
          builder: (context, data, child) {
            if (data.nowPlayingState == RequestState.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.nowPlayingState == RequestState.loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return TvCard(tvSeries: data.popularTvSeriess[index]);
                },
                itemCount: data.nowPlayingTvSeriess.length,
              );
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
