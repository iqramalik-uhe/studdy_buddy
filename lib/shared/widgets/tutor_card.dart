import 'package:flutter/material.dart';
import '../models/tutor.dart';

class TutorCard extends StatelessWidget {
  const TutorCard({super.key, required this.tutor, this.onTap});

  final Tutor tutor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: scheme.primary.withOpacity(0.12),
                child: Text(
                  tutor.name.substring(0, 1),
                  style: TextStyle(color: scheme.primary, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            tutor.name,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: scheme.tertiary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tutor.mode.toUpperCase(),
                            style: TextStyle(color: scheme.tertiary, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: -6,
                      children: tutor.subjects
                          .map((s) => Chip(label: Text(s), labelPadding: EdgeInsets.zero))
                          .toList(),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star_rounded, color: Colors.amber.shade600, size: 18),
                        const SizedBox(width: 4),
                        Text('${tutor.rating.toStringAsFixed(1)} (${tutor.numReviews})'),
                        const Spacer(),
                        Text('\$${tutor.hourlyRate.toStringAsFixed(0)}/hr',
                            style: const TextStyle(fontWeight: FontWeight.w700)),
                      ],
                    ),
                    if (tutor.city != null || tutor.distanceKm != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.place_rounded, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            [
                              if (tutor.city != null) tutor.city!,
                              if (tutor.distanceKm != null) '${tutor.distanceKm!.toStringAsFixed(1)} km',
                            ].join(' • '),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


