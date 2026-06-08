import 'package:flutter/material.dart';

import '../data/local/story_pack_catalog.dart';
import '../l10n/genre_localizer.dart';
import '../theme/proto_category_palette.dart';

class StoryPackTile extends StatelessWidget {
  const StoryPackTile({
    super.key,
    required this.pack,
    required this.contentLanguage,
    required this.onTap,
    this.compact = false,
  });

  final StoryPackOption pack;
  final String contentLanguage;
  final VoidCallback onTap;
  final bool compact;

  String _titleForPack() {
    if (pack.id == StoryPackCatalog.moreTile.id) {
      return contentLanguage == 'en' ? pack.englishTitle : pack.nativeTitle;
    }
    return GenreLocalizer.getName(pack.id, contentLanguage);
  }

  @override
  Widget build(BuildContext context) {
    final isMore = pack.id == StoryPackCatalog.moreTile.id;
    final title = _titleForPack();
    final subtleTitle = pack.englishTitle;
    final bg = isMore ? null : ProtoCategoryPalette.bg(pack.id);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: isMore
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF463520), Color(0xFF1B1610)],
                  )
                : null,
            color: isMore ? null : bg,
            boxShadow: [
              BoxShadow(
                color: (bg ?? const Color(0xFF463520)).withValues(alpha: 0.18),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: Colors.white.withValues(alpha: isMore ? 0.16 : 0.10),
            ),
          ),
          padding: EdgeInsets.all(compact ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pack.emoji,
                    style: TextStyle(fontSize: compact ? 22 : 28, height: 1),
                  ),
                  const Spacer(),
                  if (!isMore)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        pack.daysLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    )
                  else
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                ],
              ),
              SizedBox(height: compact ? 10 : 14),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: compact ? 14 : 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.15,
                  height: 1.1,
                ),
              ),
              if (!isMore &&
                  contentLanguage != 'en' &&
                  subtleTitle != title) ...[
                const SizedBox(height: 3),
                Text(
                  subtleTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.74),
                    fontSize: compact ? 10 : 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              if (!compact) ...[
                const SizedBox(height: 8),
                Text(
                  isMore ? pack.summary : pack.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.76),
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ] else if (isMore) ...[
                const Spacer(),
                Text(
                  pack.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.74),
                    fontSize: 11,
                    height: 1.25,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
