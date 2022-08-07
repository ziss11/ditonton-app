import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/search.dart';
import 'package:tv_series/presentation/widget/tv_card_list.dart';

class SearchTvSeriesPage extends StatelessWidget {
  static const routeName = '/tv-search';

  const SearchTvSeriesPage({Key? key}) : super(key: key);

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
                context.read<SearchTvSeriesBloc>().add(OnChangeTvQuery(query));
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
            BlocBuilder<SearchTvSeriesBloc, SearchTvSeriesState>(
              builder: (context, state) {
                if (state is SearchTvSeriesLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is SearchTvSeriesHasData) {
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        return TvCard(
                          tvSeries: state.result[index],
                        );
                      },
                      itemCount: state.result.length,
                    ),
                  );
                } else if (state is SearchTvSeriesError) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: const Center(
                      key: Key('error_message'),
                      child: Text(
                        'Search Not Found',
                      ),
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
