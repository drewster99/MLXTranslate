import Foundation

import Testing
@testable import MLXTranslate

// TODO: Tests need to actually #expect something

//let serialQueue = DispatchQueue(label: "SerialQueue")
// TODO: Tests can't run in parallel because LLMEvaluator can only do 1 thing at a time.
//
//@Test func exampleFromREADME() async throws {
////    serialQueue.sync {
//        let text = "How was your day?"
//        let sourceLang = "English"
//        let targetLang = "French"
//
//        let translatedText = try await MLXTranslate.translate(text,
//                                                              from: sourceLang,
//                                                              to: targetLang)
//
//        print("\"\(text)\" (\(sourceLang)) ----> (\(targetLang)) \"\(translatedText)\"")
//        // Prints:
////    }
//}
@Test func example() async throws {
//    serialQueue.sync {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        
        struct Input {
            let from: String
            let to: String
            let text: String
        }
        
        let inputs: [Input] = [
            .init(from: "English", to: "Spanish", text: "hello"),
            .init(from: "English", to: "Spanish", text: "one"),
            .init(from: "English", to: "Spanish", text: "two"),
            .init(from: "English", to: "Spanish", text: "tomorrow"),
            .init(from: "English", to: "Spanish", text: "Where is the bathroom?"),
            .init(from: "Spanish", to: "English", text: "¿Dónde está el baño?"),
            .init(from: "English", to: "Spanish", text: "I love you!"),
            .init(from: "Spanish", to: "English", text: "¡Te amo!"),
            .init(from: "English", to: "Spanish", text: "Goodnight"),
            .init(from: "Russian", to: "English", text: "эта игра действительно отстой и не приносит удовольствия. мне больше нравилась старая версия - единственное, что в ней было нормально - это уровень с едой 😀 но в остальном это полный отстой 💩💀"),
            .init(from: "Arabic", to: "English", text: "أنا آكل الحبوب في وجبة الإفطار! 😊"),
            .init(from: "English", to: "French", text: "garblejork spunwoin carmellamoid 4everyone"),
            .init(from: "DEU", to: "USA", text: "Lässt sich auch in der Freien Version erträglich spielen."),
            .init(from: "DNK", to: "USA", text: "Titlen siger det hele... Der er alt for mange reklamer. Nærmest hver 30 sekunder du har spillet, skal du se en 30 sekunders reklame. Spild af min og derfor også jeres tid. Download det venligst ikke")
        ]
        
        let start = Date()
        for input in inputs {
            let inputStart = Date()
            var resultText = ""
            do {
                let result = try await MLXTranslate.translate(input.text,
                                                              from: input.from,
                                                              to: input.to)

                resultText = "\(input.text) ---> \(result)"
            } catch {
                resultText = "\(input.text) ERROR: \(error)"
            }
            let elapsed = Date().timeIntervalSince(inputStart)
            let elapsedText = String(format: "%.2f", elapsed)
            print("(\(elapsedText) seconds)   \(resultText)")
        }
        let elapsed = Date().timeIntervalSince(start)
        print("Tests completed in (\(elapsed) seconds)")
//    }
}
