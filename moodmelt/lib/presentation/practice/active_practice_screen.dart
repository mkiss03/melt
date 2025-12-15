import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/repositories/practice_repository.dart';
import '../../domain/providers/practice_provider.dart';

class ActivePracticeScreen extends ConsumerStatefulWidget {
  final String practiceId;

  const ActivePracticeScreen({super.key, required this.practiceId});

  @override
  ConsumerState<ActivePracticeScreen> createState() =>
      _ActivePracticeScreenState();
}

class _ActivePracticeScreenState extends ConsumerState<ActivePracticeScreen> {
  Timer? _timer;
  int _currentStepIndex = 0;
  int _remainingSeconds = 0;
  int _totalElapsedSeconds = 0;
  bool _isPaused = false;
  String? _sessionId;

  @override
  void initState() {
    super.initState();
    _initPractice();
  }

  void _initPractice() async {
    final practice = PracticeRepository().getPracticeById(widget.practiceId);
    if (practice == null) return;

    // Start session
    await ref.read(practiceSessionProvider.notifier).startSession(
          practiceId: practice.id,
          practiceName: practice.name,
          type: practice.type,
        );

    // Get the session ID from the latest session
    final sessions = ref.read(practiceSessionProvider);
    if (sessions.isNotEmpty) {
      _sessionId = sessions.last.id;
    }

    // Start first step
    _remainingSeconds = practice.steps[0].durationSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          _remainingSeconds--;
          _totalElapsedSeconds++;

          if (_remainingSeconds <= 0) {
            _nextStep();
          }
        });
      }
    });
  }

  void _nextStep() {
    final practice = PracticeRepository().getPracticeById(widget.practiceId);
    if (practice == null) return;

    if (_currentStepIndex < practice.steps.length - 1) {
      setState(() {
        _currentStepIndex++;
        _remainingSeconds = practice.steps[_currentStepIndex].durationSeconds;
      });
    } else {
      _completePractice();
    }
  }

  void _completePractice() async {
    _timer?.cancel();

    if (_sessionId != null) {
      await ref.read(practiceSessionProvider.notifier).completeSession(
            sessionId: _sessionId!,
            durationSeconds: _totalElapsedSeconds,
          );
    }

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Gratulálok! 🎉'),
          content: const Text(
            'Elvégezted a gyakorlatot! Remélhetőleg jobban érzed magad.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.go('/home');
              },
              child: const Text('Kész'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final practice = PracticeRepository().getPracticeById(widget.practiceId);
    if (practice == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Practice not found')),
      );
    }

    final currentStep = practice.steps[_currentStepIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(practice.name),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            _showExitDialog();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Progress indicator
              LinearProgressIndicator(
                value: (_currentStepIndex + 1) / practice.steps.length,
                backgroundColor: AppColors.textHint.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
              const SizedBox(height: 16),
              Text(
                'Lépés ${_currentStepIndex + 1}/${practice.steps.length}',
                style: AppTextStyles.caption,
              ),
              const Spacer(),
              // Timer circle
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary,
                    width: 8,
                  ),
                ),
                child: Center(
                  child: Text(
                    '$_remainingSeconds',
                    style: AppTextStyles.h1.copyWith(fontSize: 48),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Instruction
              Text(
                currentStep.instruction,
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              // Pause/Resume button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      _isPaused ? Icons.play_arrow : Icons.pause,
                      size: 48,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPaused = !_isPaused;
                      });
                    },
                  ),
                  const SizedBox(width: 24),
                  IconButton(
                    icon: const Icon(Icons.skip_next, size: 48),
                    onPressed: _nextStep,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Biztosan kilépnél?'),
        content: const Text('A gyakorlat nem lesz elmentve.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Mégse'),
          ),
          TextButton(
            onPressed: () {
              _timer?.cancel();
              context.go('/home');
            },
            child: const Text('Kilépés'),
          ),
        ],
      ),
    );
  }
}
