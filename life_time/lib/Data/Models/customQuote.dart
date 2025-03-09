import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenAIService {
  final String apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';

  OpenAIService() {
    if (apiKey.isEmpty) {
      throw Exception(
        "OpenAI API key is missing. Please check your .env file.",
      );
    }
    OpenAI.apiKey = apiKey;
  }

  Future<String> generateLifeQuote(int completedDays, int remainingDays) async {
    try {
      final chatCompletion = await OpenAI.instance.chat.create(
        model: "gpt-3.5-turbo",
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.system,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                "You are an AI that generates deep, inspiring, and philosophical life quotes based on the number of days a person has lived and the number of days they have remaining.",
              ),
            ],
          ),
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.user,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                "Create a unique motivational quote for someone who has lived $completedDays days and has $remainingDays days left.",
              ),
            ],
          ),
        ],
        maxTokens: 50,
        temperature: 0.8, // Higher creativity
      );

      return chatCompletion.choices.first.message.content?.first.text ??
          "No quote generated.";
    } catch (e) {
      return "Error: $e";
    }
  }
}

OpenAIService service = OpenAIService();
