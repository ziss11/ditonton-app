import 'package:core/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:tv_series/presentation/pages/home_tv_series_page.dart';
import 'package:watchlist/watchlist.dart';

class CustomDrawer extends StatefulWidget {
  final Widget content;

  const CustomDrawer({
    Key? key,
    required this.content,
  }) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (_animationController.isDismissed) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          double slide = 255 * _animationController.value;
          double scale = 1 - (_animationController.value * 0.3);

          return Stack(
            children: [
              _buildDrawer(context),
              Transform(
                transform: Matrix4.identity()
                  ..translate(slide)
                  ..scale(scale),
                alignment: Alignment.centerLeft,
                child: widget.content,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return SizedBox(
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
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.tv_rounded),
            title: const Text('Tv Series'),
            onTap: () {
              Navigator.pushNamed(
                context,
                HomeTvSeriesPage.routeName,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.save_alt),
            title: const Text('Watchlist'),
            onTap: () {
              Navigator.pushNamed(context, WatchlistPage.routeName);
            },
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, aboutRoute);
            },
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
          ),
        ],
      ),
    );
  }
}
