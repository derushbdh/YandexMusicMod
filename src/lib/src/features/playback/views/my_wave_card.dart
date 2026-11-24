import 'dart:async';

import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:yayma/src/features/core/theme/app_tokens.dart';
import 'package:yayma/src/features/playback/providers/playback_provider.dart';
import 'package:yayma/src/features/playback/providers/wave_provider.dart';
import 'package:yayma/src/features/playback/views/wave_view.dart';

/// Interactive "Моя волна" card styled like the official Yandex Music app.
///
/// Features dynamic gradients, active wave vibe indicators, quick play/pause,
/// and direct access to wave customization settings (moods, activities, languages).
class MyWaveCard extends StatelessWidget {
  final VoidCallback? onWaveStarted;

  const MyWaveCard({this.onWaveStarted, super.key});

  static String _getWaveSubtitle({
    required List<String> seeds,
    required bool isWaveActive,
    required bool isPlaying,
  }) {
    if (!isWaveActive) {
      return 'Персональный поток под ваш вкус';
    }
    if (!isPlaying) {
      return 'Волна на паузе';
    }
    if (seeds.contains('personal:collection')) {
      return 'По любимым трекам';
    }
    if (seeds.contains('personal:never-heard')) {
      return 'Незнакомое и редкое';
    }
    if (seeds.contains('personal:hits')) {
      return 'Популярные хиты';
    }
    if (seeds.contains('mood:energetic')) {
      return 'Бодрое настроение';
    }
    if (seeds.contains('mood:happy')) {
      return 'Весёлое настроение';
    }
    if (seeds.contains('mood:calm')) {
      return 'Спокойное настроение';
    }
    if (seeds.contains('mood:sad')) {
      return 'Грустное настроение';
    }
    if (seeds.contains('activity:wake-up')) {
      return 'Занятие: Просыпаюсь';
    }
    if (seeds.contains('activity:road-trip')) {
      return 'Занятие: В дороге';
    }
    if (seeds.contains('activity:work-background')) {
      return 'Занятие: Работаю';
    }
    if (seeds.contains('activity:workout')) {
      return 'Занятие: Тренируюсь';
    }
    if (seeds.contains('activity:fall-asleep')) {
      return 'Занятие: Засыпаю';
    }
    if (seeds.contains('local-language:russian')) {
      return 'Язык: Русский';
    }
    if (seeds.contains('local-language:english')) {
      return 'Язык: Иностранный';
    }
    if (seeds.contains('local-language:instrumental')) {
      return 'Без слов';
    }
    for (final seed in seeds) {
      if (seed.startsWith('track:')) {
        return 'Волна по треку';
      }
      if (seed.startsWith('playlist:')) {
        return 'Волна по плейлисту';
      }
      if (seed.startsWith('artist:')) {
        return 'Волна по исполнителю';
      }
    }
    return 'В потоке вашей музыки';
  }

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) {
        final isWaveActive = isWaveActiveSignal();
        final isPlaying = isPlayingSignal();
        final currentSeeds = currentWaveSeedsSignal();
        final subtitle = _getWaveSubtitle(
          seeds: currentSeeds,
          isWaveActive: isWaveActive,
          isPlaying: isPlaying,
        );

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: [
              BoxShadow(
                color: (isWaveActive && isPlaying
                        ? const Color(0xFFC026D3)
                        : const Color(0xFF4C1D95))
                    .withValues(alpha: isWaveActive && isPlaying ? 0.35 : 0.2),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  if (isWaveActive) {
                    unawaited(PlaybackController.togglePlay());
                  } else {
                    unawaited(WaveController.startMyWave());
                    onWaveStarted?.call();
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    border: Border.all(
                      color: Colors.white.withValues(
                        alpha: isWaveActive && isPlaying ? 0.28 : 0.12,
                      ),
                      width: 1,
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isWaveActive && isPlaying
                          ? const [
                              Color(0xFF38125E),
                              Color(0xFF6B1879),
                              Color(0xFFB820A5),
                              Color(0xFFEA580C),
                            ]
                          : const [
                              Color(0xFF221136),
                              Color(0xFF3B1652),
                              Color(0xFF561A6E),
                              Color(0xFF7E2258),
                            ],
                      stops: const [0.0, 0.35, 0.72, 1.0],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Decorative background wave shape
                      Positioned(
                        right: -20,
                        bottom: -30,
                        child: IgnorePointer(
                          child: Icon(
                            Icons.waves_rounded,
                            size: 160,
                            color: Colors.white.withValues(
                              alpha: isWaveActive && isPlaying ? 0.08 : 0.04,
                            ),
                          ),
                        ),
                      ),
                      // Card contents
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        child: Row(
                          children: [
                            // Left details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Category badge
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.graphic_eq_rounded,
                                        size: 14,
                                        color: isWaveActive && isPlaying
                                            ? const Color(0xFFFFAB91)
                                            : Colors.white70,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'МОЯ ВОЛНА',
                                        style: TextStyle(
                                          color: isWaveActive && isPlaying
                                              ? const Color(0xFFFFAB91)
                                              : Colors.white70,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  // Title
                                  const Text(
                                    'Моя волна',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.5,
                                      height: 1.1,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // Subtitle / vibe status
                                  Row(
                                    children: [
                                      if (isWaveActive && isPlaying) ...[
                                        Container(
                                          width: 7,
                                          height: 7,
                                          margin: const EdgeInsets.only(right: 6),
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFFF7043),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ],
                                      Expanded(
                                        child: Text(
                                          subtitle,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: 0.8,
                                            ),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 14),
                            // Right action buttons
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Tune / settings button
                                Material(
                                  color: Colors.white.withValues(alpha: 0.16),
                                  shape: const CircleBorder(),
                                  clipBehavior: Clip.antiAlias,
                                  child: IconButton(
                                    iconSize: 22,
                                    icon: const Icon(
                                      Icons.tune_rounded,
                                      color: Colors.white,
                                      semanticLabel: 'Настройки волны',
                                    ),
                                    tooltip: 'Настройки волны',
                                    onPressed: () => unawaited(
                                      showWaveSettingsSheet(context),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Large Play/Pause circle button
                                Material(
                                  color: Colors.white,
                                  shape: const CircleBorder(),
                                  elevation: 6,
                                  shadowColor: Colors.black45,
                                  clipBehavior: Clip.antiAlias,
                                  child: InkWell(
                                    onTap: () {
                                      if (isWaveActive) {
                                        unawaited(PlaybackController.togglePlay());
                                      } else {
                                        unawaited(WaveController.startMyWave());
                                        onWaveStarted?.call();
                                      }
                                    },
                                    child: SizedBox(
                                      width: 48,
                                      height: 48,
                                      child: Center(
                                        child: Icon(
                                          isWaveActive && isPlaying
                                              ? Icons.pause_rounded
                                              : Icons.play_arrow_rounded,
                                          size: 30,
                                          color: const Color(0xFF281140),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
