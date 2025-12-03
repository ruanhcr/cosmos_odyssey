import 'package:cached_network_image/cached_network_image.dart';
import 'package:cosmos_odyssey/core/ui/styles/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/astronomy_picture.dart';
import '../bloc/apod_bloc.dart';
import '../bloc/apod_event.dart';
import '../bloc/apod_state.dart';

class ApodPage extends StatelessWidget {
  const ApodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ApodBloc>()..add(const ApodRequested()),
      child: const ApodView(),
    );
  }
}

class ApodView extends StatelessWidget {
  const ApodView({super.key});

  @override
  Widget build(BuildContext context) {
    final typography = getIt<AppTypography>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<ApodBloc, ApodState>(
        builder: (context, state) {
          return switch (state) {
            ApodInitial() || ApodLoading() => const Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: Colors.white,
              ),
            ),
            ApodFailure(message: var msg) => _buildError(
              context,
              msg,
              typography,
            ),
            ApodSuccess(astronomyPicture: var picture) => _buildSuccess(
              picture,
              typography,
            ),
          };
        },
      ),
    );
  }

  Widget _buildError(
    BuildContext context,
    String message,
    AppTypography typography,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(
            message,
            style: typography.body(fontSize: 16, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          TextButton(
            onPressed: () {
              context.read<ApodBloc>().add(const ApodRequested());
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccess(AstronomyPicture picture, AppTypography typography) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          expandedHeight: 400.0,
          stretch: true,
          backgroundColor: Colors.transparent,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const [
              StretchMode.zoomBackground,
              StretchMode.blurBackground,
            ],
            title: Text(
              textAlign: TextAlign.center,
              picture.title,
              style: typography.heading(fontSize: 12.0, color: Colors.white),
            ),
            centerTitle: true,
            background: Stack(
              fit: StackFit.expand,
              children: [
                if (picture.isImage)
                  CachedNetworkImage(
                    imageUrl: picture.url,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(color: Colors.grey[900]),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image, color: Colors.white),
                  )
                else
                  Container(
                    color: Colors.black,
                    child: Center(
                      child: Text(
                        'Video Content Available on Web',
                        style: typography.body(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black54,
                        Colors.black,
                      ],
                      stops: [0.5, 0.8, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEEE, MMMM d, yyyy').format(picture.date),
                  style: typography.heading(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  picture.explanation,
                  style: typography.body(
                    fontSize: 16,
                    color: Colors.white70,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 48),
                Center(
                  child: Text(
                    'NASA API © ${DateTime.now().year}',
                    style: typography.heading(
                      fontSize: 10,
                      color: Colors.white24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
