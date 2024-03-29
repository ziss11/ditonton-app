import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/presentation/cubit/tv_series_now_playing_cubit.dart';
import 'package:tv_series/presentation/widget/tv_card_list.dart';

class NowPlayingTvPage extends StatefulWidget {
  static const routeName = '/now-playing-tv';
  const NowPlayingTvPage({super.key});

  @override
  State<NowPlayingTvPage> createState() => _NowPlayingTvPageState();
}

class _NowPlayingTvPageState extends State<NowPlayingTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<TvSeriesNowPlayingCubit>().fetchNowPlayingTv(),
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
        child: BlocBuilder<TvSeriesNowPlayingCubit, TvSeriesNowPlayingState>(
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
