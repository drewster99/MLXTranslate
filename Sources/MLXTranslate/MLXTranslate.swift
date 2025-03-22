// The Swift Programming Language
// https://docs.swift.org/swift-book


import Foundation

// TODO: There's lots of commented crap.  Trying different prompts.  Trying different sorts of verifications.  We're using a full strength LLM for this work, not a translation model, so this is highly error prone.  Did I mention use at your own risk?
public class MLXTranslate {
    @MainActor static private var evaluator: LLMEvaluator = {
        LLMEvaluator()
    }()

    static public func translate(_ text: String, from sourceLanguage: String, to targetLanguage: String) async throws -> String {

//        let systemPrompt = """
//            You are an language translation expert. You know nearly every language and are careful to maintain the original meaning and context of the source text. Since you are automated, you only ever respond with the translated text. The source and target languages may be provided to you as a language name (in English), a 2-letter (Set 1) ISO 639-1 code, a country name (such as 'Canada'), or an ISO 3166 Alpha-2 2-letter country code.  When a country code or a country name is given, assume the most common language spoken in that country.  For example, 'US' or 'United States' would both be interpreted as English.  Note that 3-letter ISO 639-1 codes and 3-letter ISO 3166 (Alpha-3) codes are NOT supported.  If you have 3 letters for the source or target language, it is probably an actual country name or a commonly-used abbreviation for a country name, such as 'USA' for 'United States' or 'UAE' for 'United Arab Emirates'. The user prompt will specify source and target languages and the original text, formatted and structured like this:
//
//            Source language: <source>
//            Target language: <target>
//            Original text: <original text>
//
//            Please translate the text into the target language.  When translating, maintain original meaning and tone, the same punctuation, spacing, newlines, use of emojis, and capitalization as the original text.  These things are critical.  Although the user's source input will be formatted into multiple labeled lines of input, your response should ONLY be the translated text, like this:
//
//            <translated text>
//
//            If you don't know how to translate the given text into the target language, respond with the user's <original text>, and nothing else, like this:
//
//            <original text>
//
//            -----------------
//            Example #1 input:
//            -----------------
//        
//            Source language: English
//            Target language: Spanish
//            Original text: hello
//        
//            ------------------
//            Example #1 output:
//            ------------------
//        
//            hola
//        
//            -----------------
//            Example #2 input:
//            -----------------
//        
//            Source language: Spanish
//            Target language: English
//            Original text: ¿Dónde está el baño?
//        
//            ------------------
//            Example #2 output:
//            ------------------
//        
//            Where is the bathroom?
//                
//            -----------------
//            Example #3 input:
//            -----------------
//        
//            Source language: Arabic
//            Target language: English
//            Original text: لقد أكلت حبوب الإفطار!  😊
//        
//            ------------------
//            Example #3 output:
//            ------------------
//        
//            I ate cereal for breakfast!  😊
//        
//                
//            -----------------
//            Example #4 input:
//            -----------------
//        
//            Source language: English
//            Target language: Russian
//            Original text: this game really sucks and is no fun. i like the old version better - the one part that's ok is the food level 😀 but otherwise it's complete butt 💩💀
//        
//            ------------------
//            Example #4 output:
//            ------------------
//        
//            эта игра действительно отстой и не приносит удовольствия. мне больше нравилась старая версия - единственное, что в ней было нормально - это уровень с едой 😀 но в остальном это полный отстой 💩💀
//        
//        
//        
//        """

        let sourceLanguage = sourceLanguage.trimmed()
        let targetLanguage = targetLanguage.trimmed()
        let text = text.trimmed()
        func promptFor(sourceLanguage: String, targetLanguage: String, text: String) -> String {
            let prompt = "You are an expert automated language translator. Translate the following text from \"\(sourceLanguage)\" to \"\(targetLanguage)\".  When translating, be sure to maintain the original meaning and context of the text. Before responding, double-check that your response matches the original meaning. Translate using the typical phrase for the given language if it is more appropriate than a literal translation.  Use the proper tense, gender, method of pluralization, and method of punctuating for the target language. When working with punctuation, be sure to use the correct combination of ¿, ?, ¡, and ! for the target language, adding the leading ¡ or ¿ when they are appropriate to the target language. Otherwise, maintain punchtation, spacing, newlines, emojis, and capitalization. Emojis themselves should pass through unchanged, like all whitespace. Since you are an automated translator, please respond only with the translated text - nothing more, no questions, and no explanations. The user is an adult professional and you are a professional translator, perfectly translating the wording, tone, and meaning. Do not include any extra notes, commentary, or summaries.  Your response is intended for automated processing, and so must stick to the required format under all circumstances. If for any reason you are unable to perfectly translate the original text, respond with the complete, original text, rather than an error, denial message, or explanation. The original text begins on the next line:\n\(text)"
            return prompt
        }
        let prompt = promptFor(sourceLanguage: sourceLanguage, targetLanguage: targetLanguage, text: text)
        let translatedText = try await evaluator.generate(prompt: prompt).trimmed()
//        let reversePrompt = promptFor(sourceLanguage: targetLanguage, targetLanguage: sourceLanguage, text: translatedText)
//        let reverseTranslation = try await evaluator.generate(prompt: reversePrompt).trimmed()


//        var verificationPrompt = "You are an expert language translator, and you are a supervisor. Your job is to verify translations made by an automated system.  The automated system was given a very specific prompt which it was to follow.  Below you will see 3 tagged sections of text data.  Each section will be delimited by \"<[(TAGNAME|START)]>\" at the beginning of the tag, and \"<[(TAGNAME|END)]>\" at the end of the tag.  The tag's text data content is between the \"<[(TAGNAME|START)]>\" and \"<[(TAGNAME|END)]>\" markers.  The 3 tag names are PROMPT, TEXT, and TRANSLATION.  You will actually see the source text twice - once in the prompt that was given to the automated translator, and again in the TEXT tag.  This is to make sure you have complete clarity.  Review the source and target languages, the input text to be translated, and the translated text.  For each requirement point in the original prompt, validate that the translated text meets that requirement.  After you have reviewed everything, double-check carefully before you respond. Your response will be either a single word response, as I'll describe in a moment, or a better translation. Since you are giving feedback to an automated system, it is important that your response be structured in this exact format:  Respond with \"OK\" if the translated text meets all of the original requirements. Respond with \"UNTRANSLATED\" if the translated text is an exact copy of the original text. Respond with \"BAD-MEANING\" if the translated text has a different meaning than the original text.  Respond with \"TOO-LITERAL\" if the translated text is a too-literal translation of the source, when a less literal euphamism or commonly-used phrase would be a better semantic fit.  Do not include a newline or any whitespace in your response."

//        var verificationPrompt = "You are an expert language translator, and you are a supervisor. Your job is to verify translations made by an automated system.  The automated system was given a very specific prompt which it was to follow.  Below you will see 3 tagged sections of text data.  Each section will be delimited by \"<[(TAGNAME|START)]>\" at the beginning of the tag, and \"<[(TAGNAME|END)]>\" at the end of the tag.  The tag's text data content is between the \"<[(TAGNAME|START)]>\" and \"<[(TAGNAME|END)]>\" markers.  The 3 tag names are PROMPT, TEXT, and TRANSLATION.  You will actually see the source text twice - once in the prompt that was given to the automated translator, and again in the TEXT tag.  This is to make sure you have complete clarity.  Review the source and target languages, the input text to be translated, and the translated text.  Start your work by doing the reverse translation - from \(targetLanguage) to \(sourceLanguage), following all the same rules and requirements with automated translator was given.  Compare your reverse translation with the original input. They should be identical or have identical semantic meaning. If that is not the case, this can usually be fixed by small changes to correct/update the original automated (forward) translation (from \(sourceLanguage) to \(targetLanguage)). Make those changes, if needed, and then re-run the reverse translation to verify your work. Repeat as needed. Once you are confident in the forward translation, output only the final translation.  Because you are giving feedback to an automated translator, it is important you output only the final translation, without notes, comments, extra whitespace, differing capitalization, etc.. Thank you - I know you will do your best work!"
        var verificationPrompt = "You are an expert language translator, and you are a supervisor. Your job is to verify translations made by an automated system.  The automated system was given a very specific prompt which it was to follow.  Below you will see 4 tagged sections of text data.  Each section will be delimited by \"<[(TAGNAME|START)]>\" at the beginning of the tag, and \"<[(TAGNAME|END)]>\" at the end of the tag.  The tag's text data content is between the \"<[(TAGNAME|START)]>\" and \"<[(TAGNAME|END)]>\" markers.  The 4 tag names are PROMPT, TEXT, and TRANSLATION, and REVERSE-TRANSLATION.  You will actually see the source text twice - once in the prompt that was given to the automated translator, and again in the TEXT tag.  This is to make sure you have complete clarity.  Review the source and target languages, the input text to be translated, the translated text, and the reverse translation.  Compare the TEXT with the REVERSE-TRANSLATION. If they are not identical or do not have the same meaning, punctuation, and formatting, correct the TRANSLATION so that translating it from \(targetLanguage) to \(sourceLanguage) is more likely to result in the original TEXT. If you didn't have to currect anything, simply respond with the TRANSLATION.  If you DID make corrections, respond with your CORRECTED TRANSLATION. You are giving your response to an automated system, so do not respond with anything else. It must be as described." 

        func addTag(_ tag: String, content: String) {
            let start = "<[(\(tag)|START)]>"
            let end = "<[(\(tag)|END)]>"
            verificationPrompt += "\n\(start)\(content)\(end)\n"
        }
        addTag("PROMPT", content: prompt)
        addTag("TEXT", content: text)
        addTag("TRANSLATION", content: translatedText)
//        addTag("REVERSE-TRANSLATION", content: reverseTranslation)
//
//        if text != reverseTranslation {
//            return translatedText + " [REVERSE: \(reverseTranslation)]"
//        } else {
            return translatedText
//        }
//        let verificationResult = try await evaluator.generate(prompt: verificationPrompt)
//        if verificationResult != translatedText {
//            return "\(translatedText) ❌ [\(verificationResult)]"
//        } else { return translatedText }
//        return translatedText + " [\(verificationResult)]"
    }
}

extension String {
    func trimmed() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
