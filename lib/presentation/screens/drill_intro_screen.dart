import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/drill.dart';
import '../../providers/training_provider.dart';
import '../widgets/app_button.dart';
import '../widgets/badge_tag.dart';
import '../widgets/section_title.dart';
import '../widgets/skill_intro_screen.dart';
import '../widgets/warmup_overlay_screen.dart';
import 'premium_training_session_screen.dart';

/// Professional AI Sports Coaching Drill Overview Screen
class DrillIntroScreen extends StatefulWidget {
  const DrillIntroScreen({
    super.key,
    required this.drill,
  });

  final Drill drill;

  @override
  State<DrillIntroScreen> createState() => _DrillIntroScreenState();
}

class _DrillIntroScreenState extends State<DrillIntroScreen> {
  late String _selectedDifficulty;

  @override
  void initState() {
    super.initState();
    _selectedDifficulty = widget.drill.difficulty;
    if (_selectedDifficulty != 'Beginner' &&
        _selectedDifficulty != 'Intermediate' &&
        _selectedDifficulty != 'Advanced') {
      _selectedDifficulty = 'Intermediate';
    }
  }

  Drill get _activeDrill => widget.drill.getAdjustedDrillForDifficulty(_selectedDifficulty);

  @override
  Widget build(BuildContext context) {
    final drill = _activeDrill;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Drill Overview',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        actions: [
          Consumer<TrainingProvider>(
            builder: (context, provider, child) {
              final isFav = drill.isFavorite;
              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: isFav ? AppColors.red : Colors.white,
                ),
                tooltip: isFav ? 'Remove from favorites' : 'Add to favorites',
                onPressed: () {
                  provider.toggleFavorite(drill.id);
                },
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. SESSION SUMMARY & DIFFICULTY SELECTOR
              _buildSessionSummaryCard(drill),

              const SizedBox(height: 16),

              // DIFFICULTY SELECTOR BAR
              _buildDifficultySelectorBar(),

              const SizedBox(height: 20),

              // 4. AI COACH PREVIEW (BRIEFING)
              _buildAiCoachBriefingCard(drill),

              const SizedBox(height: 20),

              // 5. PERFORMANCE TARGETS
              _buildPerformanceTargetsCard(drill),

              const SizedBox(height: 24),

              // 3. PROFESSIONAL SESSION TIMELINE
              _buildSessionTimeline(drill),

              const SizedBox(height: 24),

              // 2. ROUND CARDS (CLICKABLE FOR DETAILED POPUP)
              _buildRoundCardsSection(drill),

              const SizedBox(height: 24),

              // SKILLS DEVELOPED & EQUIPMENT
              _buildSkillsAndEquipmentSection(drill),

              const SizedBox(height: 24),

              // 6. PRACTICAL COACHING TIPS
              _buildCoachingTipsSection(drill),

              const SizedBox(height: 24),

              // 7. COMMON MISTAKES TO AVOID
              _buildCommonMistakesSection(drill),

              const SizedBox(height: 24),

              // 8. MOTIVATION SECTION
              _buildMotivationCard(drill),
              const SizedBox(height: 32),

              if (drill.progression.isNotEmpty) ...[
                _buildBwfProgressionSection(drill),
                const SizedBox(height: 32),
              ],
              if (drill.completionCriteria.isNotEmpty) ...[
                _buildCompletionCriteriaSection(drill),
                const SizedBox(height: 32),
              ],
            ],
          ),
        ),
      ),
      // 10. STICKY / PINNED BOTTOM ACTION BAR
      bottomNavigationBar: _buildStickyBottomBar(context, drill),
    );
  }

  // ==========================================
  // DIFFICULTY SELECTOR BAR
  // ==========================================
  Widget _buildDifficultySelectorBar() {
    final levels = ['Beginner', 'Intermediate', 'Advanced'];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: levels.map((lvl) {
          final isSelected = _selectedDifficulty == lvl;
          Color activeColor;
          switch (lvl) {
            case 'Advanced':
              activeColor = AppColors.red;
              break;
            case 'Intermediate':
              activeColor = AppColors.cyan;
              break;
            default:
              activeColor = AppColors.primaryGreen;
          }

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDifficulty = lvl;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? activeColor.withValues(alpha: 0.22) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(color: activeColor, width: 1.5)
                      : Border.all(color: Colors.transparent),
                ),
                child: Text(
                  lvl,
                  style: GoogleFonts.poppins(
                    color: isSelected ? activeColor : Colors.white60,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==========================================
  // 1. SESSION SUMMARY CARD
  // ==========================================
  Widget _buildSessionSummaryCard(Drill drill) {
    Color difficultyColor;
    switch (drill.difficulty) {
      case 'Advanced':
        difficultyColor = AppColors.red;
        break;
      case 'Intermediate':
        difficultyColor = AppColors.cyan;
        break;
      default:
        difficultyColor = AppColors.primaryGreen;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF131F37), Color(0xFF1B2B4A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppColors.primaryGreen.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 54,
                width: 54,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primaryGreen.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(drill.emoji, style: const TextStyle(fontSize: 28)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        drill.categoryName.toUpperCase(),
                        style: GoogleFonts.poppins(
                          color: AppColors.electricGreen,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      drill.title,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // BADGE TAGS WRAP
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              BadgeTag(
                label: drill.difficulty,
                color: difficultyColor,
                icon: Icons.bar_chart_rounded,
              ),
              BadgeTag(
                label: drill.duration,
                color: AppColors.orange,
                icon: Icons.timer_outlined,
              ),
              BadgeTag(
                label: '+${drill.xpReward} XP',
                color: AppColors.purple,
                icon: Icons.stars_rounded,
              ),
              BadgeTag(
                label: drill.computedEnergyLevel,
                color: AppColors.electricGreen,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // TRAINING OBJECTIVE CONTAINER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.track_changes_rounded,
                      color: AppColors.electricGreen,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'DRILL OBJECTIVE',
                      style: GoogleFonts.poppins(
                        color: AppColors.electricGreen,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  drill.objective,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // AI COACH PREVIEW (BRIEFING)
  // ==========================================
  Widget _buildAiCoachBriefingCard(Drill drill) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            AppColors.purple.withValues(alpha: 0.18),
            const Color(0xFF171B38),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppColors.purple.withValues(alpha: 0.4),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.purple.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.psychology_rounded,
                  color: Color(0xFFA29BFE),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI COACH BRIEFING',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFA29BFE),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Text(
                    'BWF Level 3 Coach Guidance',
                    style: GoogleFonts.poppins(
                      color: Colors.white54,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.only(left: 12),
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Color(0xFFA29BFE),
                  width: 3,
                ),
              ),
            ),
            child: Text(
              '"${drill.computedAiBriefing}"',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 13,
                fontStyle: FontStyle.italic,
                height: 1.45,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // PERFORMANCE TARGETS
  // ==========================================
  Widget _buildPerformanceTargetsCard(Drill drill) {
    final targets = drill.computedPerformanceTargets;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: "Today's Performance Targets"),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            children: targets.map((target) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.electricGreen.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.electricGreen,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        target,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // PROFESSIONAL SESSION TIMELINE
  // ==========================================
  Widget _buildSessionTimeline(Drill drill) {
    final List<Map<String, dynamic>> timelineSteps = [
      {'name': 'Warm-up', 'type': 'prep', 'time': '30s', 'icon': Icons.accessibility_new_rounded},
    ];

    if (drill.phases.isNotEmpty) {
      for (int i = 0; i < drill.phases.length; i++) {
        final phase = drill.phases[i];
        if (phase.type == PhaseType.rest) {
          timelineSteps.add({
            'name': 'Rest',
            'type': 'rest',
            'time': phase.formattedDuration,
            'icon': Icons.self_improvement_rounded,
          });
        } else if (phase.type == PhaseType.finalChallenge) {
          timelineSteps.add({
            'name': 'Challenge',
            'type': 'challenge',
            'time': phase.formattedDuration,
            'icon': Icons.local_fire_department_rounded,
          });
        } else if (phase.type == PhaseType.work) {
          timelineSteps.add({
            'name': phase.title.contains('Round') ? phase.title.split('–').first.trim() : 'Round ${i ~/ 2 + 1}',
            'type': 'work',
            'time': phase.formattedDuration,
            'icon': Icons.directions_run_rounded,
          });
        }
      }
    } else {
      timelineSteps.addAll([
        {'name': 'Round 1', 'type': 'work', 'time': '45s', 'icon': Icons.directions_run_rounded},
        {'name': 'Rest', 'type': 'rest', 'time': '20s', 'icon': Icons.self_improvement_rounded},
        {'name': 'Round 2', 'type': 'work', 'time': '45s', 'icon': Icons.directions_run_rounded},
        {'name': 'Rest', 'type': 'rest', 'time': '20s', 'icon': Icons.self_improvement_rounded},
        {'name': 'Round 3', 'type': 'work', 'time': '60s', 'icon': Icons.directions_run_rounded},
        {'name': 'Challenge', 'type': 'challenge', 'time': '45s', 'icon': Icons.local_fire_department_rounded},
      ]);
    }

    timelineSteps.addAll([
      {'name': 'Cool-down', 'type': 'prep', 'time': '30s', 'icon': Icons.air_rounded},
      {'name': 'Complete', 'type': 'finish', 'time': 'Done', 'icon': Icons.emoji_events_rounded},
    ]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Professional Session Timeline'),
        const SizedBox(height: 6),
        Text(
          'Mental preparation flow for this session',
          style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: timelineSteps.length,
            separatorBuilder: (context, index) {
              return Container(
                width: 24,
                alignment: Alignment.center,
                child: const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: AppColors.primaryGreen,
                        thickness: 2,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 14,
                      color: AppColors.primaryGreen,
                    ),
                  ],
                ),
              );
            },
            itemBuilder: (context, index) {
              final step = timelineSteps[index];
              Color stepColor;
              switch (step['type']) {
                case 'work':
                  stepColor = AppColors.primaryGreen;
                  break;
                case 'challenge':
                  stepColor = AppColors.orange;
                  break;
                case 'rest':
                  stepColor = AppColors.cyan;
                  break;
                case 'finish':
                  stepColor = AppColors.purple;
                  break;
                default:
                  stepColor = Colors.white70;
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: stepColor.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                      border: Border.all(color: stepColor.withValues(alpha: 0.5)),
                    ),
                    child: Icon(
                      step['icon'] as IconData,
                      color: stepColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    step['name'] as String,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    step['time'] as String,
                    style: GoogleFonts.poppins(
                      color: AppColors.textMuted,
                      fontSize: 9.5,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 2 & 3. ROUND CARDS (CLICKABLE FOR POPUP)
  // ==========================================
  Widget _buildRoundCardsSection(Drill drill) {
    final phasesToDisplay = drill.phases.isNotEmpty
        ? drill.phases.where((p) => p.type != PhaseType.rest).toList()
        : drill.getPhasesForDifficulty(_selectedDifficulty).where((p) => p.type != PhaseType.rest).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Round-by-Round Breakdown'),
        const SizedBox(height: 6),
        Text(
          'Tap any round card for full coaching details and movement pattern',
          style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12),
        ),
        const SizedBox(height: 12),
        ...phasesToDisplay.asMap().entries.map((entry) {
          final index = entry.key;
          final phase = entry.value;

          Color phaseBadgeColor;
          String roundLabel;
          if (phase.type == PhaseType.explanation) {
            phaseBadgeColor = AppColors.cyan;
            roundLabel = 'WARM-UP';
          } else if (phase.type == PhaseType.finalChallenge) {
            phaseBadgeColor = AppColors.orange;
            roundLabel = 'CHALLENGE ROUND';
          } else {
            phaseBadgeColor = AppColors.primaryGreen;
            roundLabel = 'ROUND ${index + 1}';
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => _showRoundDetailModal(context, phase, index + 1, drill),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: phaseBadgeColor.withValues(alpha: 0.35),
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ROUND HEADER & TIME
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BadgeTag(
                            label: roundLabel,
                            color: phaseBadgeColor,
                            icon: Icons.fitness_center_rounded,
                          ),
                          Row(
                            children: [
                              BadgeTag(
                                label: phase.formattedDuration,
                                color: Colors.white70,
                                icon: Icons.timer_outlined,
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                Icons.open_in_full_rounded,
                                size: 16,
                                color: phaseBadgeColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        phase.title,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 15.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        phase.description,
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 12.5,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.track_changes_rounded,
                            color: AppColors.electricGreen,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Goal: ${phase.displayObjective}',
                              style: GoogleFonts.poppins(
                                color: AppColors.electricGreen,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  // ==========================================
  // 4. DETAILED ROUND POPUP MODAL
  // ==========================================
  void _showRoundDetailModal(BuildContext context, DrillPhase phase, int roundNumber, Drill drill) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: const Color(0xFF131D31),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(
              color: AppColors.primaryGreen.withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // MODAL HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BadgeTag(
                        label: 'ROUND $roundNumber • DETAILS',
                        color: AppColors.primaryGreen,
                        icon: Icons.info_outline_rounded,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white70),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    phase.title,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, color: AppColors.orange, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Duration: ${phase.formattedDuration}',
                        style: GoogleFonts.poppins(
                          color: AppColors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  Divider(color: Colors.white.withValues(alpha: 0.12), height: 1),
                  const SizedBox(height: 14),

                  // ROUND OBJECTIVE
                  _buildModalSection(
                    icon: Icons.track_changes_rounded,
                    iconColor: AppColors.electricGreen,
                    title: 'ROUND OBJECTIVE',
                    content: phase.displayObjective,
                  ),

                  const SizedBox(height: 12),

                  // DETAILED INSTRUCTIONS
                  _buildModalSection(
                    icon: Icons.directions_run_rounded,
                    iconColor: AppColors.cyan,
                    title: 'DETAILED INSTRUCTIONS',
                    content: phase.displayInstructions,
                  ),

                  const SizedBox(height: 12),

                  // MOVEMENT PATTERN
                  _buildModalSection(
                    icon: Icons.swap_calls_rounded,
                    iconColor: AppColors.purple,
                    title: 'MOVEMENT PATTERN',
                    content: 'Base Center ➔ ${drill.title.contains('Front') ? 'Net Corners' : 'Boundary Corners'} ➔ Base Reset',
                  ),

                  const SizedBox(height: 12),

                  // COACH FOCUS & FOCUS CUES (MAX 2)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.primaryGreen.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.tips_and_updates_rounded,
                              color: AppColors.electricGreen,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'COACH FOCUS',
                              style: GoogleFonts.poppins(
                                color: AppColors.electricGreen,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          phase.displayCoachFocus,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 12.5,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Short Focus Cues:',
                          style: GoogleFonts.poppins(
                            color: AppColors.electricGreen,
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ...drill.shortFocusCues.map((cue) => Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Row(
                                children: [
                                  const Icon(Icons.circle, color: AppColors.electricGreen, size: 6),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      cue,
                                      style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // MISTAKES TO AVOID (MAX 2)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.red.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.red.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.warning_amber_rounded,
                              color: AppColors.red,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'MISTAKES TO AVOID',
                              style: GoogleFonts.poppins(
                                color: AppColors.red,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ...drill.shortMistakesToAvoid.map((mistake) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• ', style: TextStyle(color: AppColors.red, fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                      mistake,
                                      style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'GOT IT',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModalSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 16),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: iconColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12.5,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  // ==========================================
  // SKILLS DEVELOPED & EQUIPMENT
  // ==========================================
  Widget _buildSkillsAndEquipmentSection(Drill drill) {
    final skills = drill.skillsImproved;
    final equipment = drill.effectiveEquipment;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (skills.isNotEmpty) ...[
          const SectionTitle(title: 'Skills Developed'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills.map((skill) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.electricGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.electricGreen.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, color: AppColors.electricGreen, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      skill,
                      style: GoogleFonts.poppins(
                        color: AppColors.electricGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],

        const SectionTitle(title: 'Equipment & Space Required'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...equipment.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.cyan.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.cyan.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.inventory_2_rounded, color: AppColors.cyan, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      item,
                      style: GoogleFonts.poppins(
                        color: AppColors.cyan,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.purple.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.purple.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.square_foot_rounded, color: AppColors.purple, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    drill.computedRecommendedSpace,
                    style: GoogleFonts.poppins(
                      color: AppColors.purple,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // PRACTICAL COACHING TIPS
  // ==========================================
  Widget _buildCoachingTipsSection(Drill drill) {
    final tips = drill.effectiveCoachingTips;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Practical Coaching Tips'),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primaryGreen.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: tips.map((tip) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.verified_rounded,
                      color: AppColors.electricGreen,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        tip,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12.5,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // COMMON MISTAKES TO AVOID
  // ==========================================
  Widget _buildCommonMistakesSection(Drill drill) {
    final mistakes = drill.effectiveCommonMistakes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Common Mistakes to Avoid'),
        const SizedBox(height: 10),
        Column(
          children: mistakes.map((mistake) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.red.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      mistake,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ==========================================
  // MOTIVATION SECTION
  // ==========================================
  Widget _buildMotivationCard(Drill drill) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            AppColors.orange.withValues(alpha: 0.15),
            const Color(0xFF231B15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppColors.orange.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.orange.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              color: AppColors.orange,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'COACH MOTIVATION',
                  style: GoogleFonts.poppins(
                    color: AppColors.orange,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '"${drill.computedMotivationQuote}"',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12.5,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // BWF PROGRESSION SECTION
  // ==========================================
  Widget _buildBwfProgressionSection(Drill drill) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'BWF Coaching Progression'),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cyan.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.trending_up_rounded, color: AppColors.cyan, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  drill.progression,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, height: 1.4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // COMPLETION CRITERIA SECTION
  // ==========================================
  Widget _buildCompletionCriteriaSection(Drill drill) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Mastery Completion Criteria'),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.verified_user_rounded, color: AppColors.electricGreen, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  drill.completionCriteria,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, height: 1.4, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // STICKY / PINNED BOTTOM ACTION BAR
  // ==========================================
  Widget _buildStickyBottomBar(BuildContext context, Drill drill) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.95),
        border: const Border(
          top: BorderSide(color: Colors.white10, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOTAL SESSION',
                  style: GoogleFonts.poppins(
                    color: AppColors.textMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  '${drill.duration} • +${drill.xpReward} XP',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppButton(
                text: 'START WORKOUT',
                icon: Icons.play_arrow_rounded,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (warmupContext) => WarmupOverlayScreen(
                        allowSkip: true,
                        onWarmupComplete: () {
                          Navigator.pushReplacement(
                            warmupContext,
                            MaterialPageRoute(
                              builder: (skillContext) => SkillIntroScreen(
                                drill: drill,
                                onContinue: () {
                                  Navigator.pushReplacement(
                                    skillContext,
                                    MaterialPageRoute(
                                      builder: (_) => PremiumTrainingSessionScreen(drill: drill),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

