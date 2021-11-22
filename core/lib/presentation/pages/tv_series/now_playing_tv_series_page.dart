import 'package:core/presentation/cubit/tv_series/tv_series_list_cubit.dart';
import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    Future.microtask(
      () => context.read<TvSeriesListCubit>().fetchNowPlayingTv(),
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
        child: BlocBuilder<TvSeriesListCubit, TvSeriesListState>(
          builder: (context, data) {
            if (data is TvSeriesNowPlayingLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (data is TvSeriesNowPlayingLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return TvCard(
                    tvSeries: data.nowPlayingTvSeries[index],
                  );
                },
                itemCount: data.nowPlayingTvSeries.length,
              );
            } else if (data is TvSeriesNowPlayingError) {
              return Center(
                key: const Key('error_message'),
                child: Text(data.message),
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
