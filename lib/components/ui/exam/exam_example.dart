import 'package:flutter/material.dart';
import 'package:entrance_tricks/models/models.dart';
import 'package:entrance_tricks/components/ui/exam/question_card.dart';
import 'package:entrance_tricks/components/ui/exam/choice_card.dart';

class ExamExample extends StatefulWidget {
  const ExamExample({super.key});

  @override
  State<ExamExample> createState() => _ExamExampleState();
}

class _ExamExampleState extends State<ExamExample> {
  int? selectedChoiceId;
  bool showAnswers = false;

  // Example question with LaTeX and rich text
  final Question exampleQuestion = Question(
    id: 1,
    content: '''
What is the derivative of **f(x) = \$x^2 + 3x - 5\$**?

The function contains both *quadratic* and linear terms. Use the power rule: \$\\frac{d}{dx}[x^n] = nx^{n-1}\$.

For the constant term, remember that \$\\frac{d}{dx}[c] = 0\$ where `c` is a constant.
    ''',
    image: 'https://example.com/math-graph.png', // Replace with actual image URL
    choices: [
      Choice(id: 1, content: 'f\'(x) = \$2x + 3\$'),
      Choice(id: 2, content: 'f\'(x) = \$x^2 + 3\$'),
      Choice(id: 3, content: 'f\'(x) = \$2x - 5\$'),
      Choice(id: 4, content: 'f\'(x) = \$x + 3\$'),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exam Components Example'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                showAnswers = !showAnswers;
              });
            },
            icon: Icon(showAnswers ? Icons.visibility_off : Icons.visibility),
            tooltip: showAnswers ? 'Hide Answers' : 'Show Answers',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Card
            QuestionCard(
              question: exampleQuestion,
              questionNumber: 1,
              totalQuestions: 10,
              onImageTap: () {
                _showImageDialog(context, exampleQuestion.image!);
              },
            ),

            SizedBox(height: 24),

            // Choices
            Text(
              'Select your answer:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 16),

            ChoiceList(
              choices: exampleQuestion.choices,
              selectedChoiceId: selectedChoiceId,
              correctChoiceId: 1, // The correct answer is choice A
              showAnswers: showAnswers,
              onChoiceSelected: (choice) {
                setState(() {
                  selectedChoiceId = choice.id;
                });
              },
              isInteractive: !showAnswers,
            ),

            SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: selectedChoiceId != null
                        ? () {
                            setState(() {
                              showAnswers = true;
                            });
                          }
                        : null,
                    child: Text('Submit Answer'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        selectedChoiceId = null;
                        showAnswers = false;
                      });
                    },
                    child: Text('Reset'),
                  ),
                ),
              ],
            ),

            SizedBox(height: 32),

            // Usage Instructions
            _buildUsageInstructions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageInstructions(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Usage Instructions',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'This example demonstrates the comprehensive question and choice cards with the following features:',
            style: theme.textTheme.bodyMedium,
          ),
          SizedBox(height: 8),
          _buildFeatureItem(theme, '• LaTeX rendering for mathematical expressions'),
          _buildFeatureItem(theme, '• Rich text formatting (bold, italic, code)'),
          _buildFeatureItem(theme, '• Image support with tap to view'),
          _buildFeatureItem(theme, '• Interactive choice selection'),
          _buildFeatureItem(theme, '• Answer validation and feedback'),
          _buildFeatureItem(theme, '• Responsive design with proper theming'),
          SizedBox(height: 12),
          Text(
            'LaTeX Syntax:',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4),
          _buildFeatureItem(theme, '• Inline math: \$x^2\$'),
          _buildFeatureItem(theme, '• Display math: \$\$\\frac{a}{b}\$\$'),
          _buildFeatureItem(theme, '• Rich text: **bold**, *italic*, `code`'),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(ThemeData theme, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: theme.textTheme.bodySmall,
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                title: Text('Question Image'),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              Expanded(
                child: InteractiveViewer(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image, size: 64),
                            SizedBox(height: 16),
                            Text('Failed to load image'),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
