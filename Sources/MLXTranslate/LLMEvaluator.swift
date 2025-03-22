//
//  LLMEvaluator.swift
//  MLXTranslate
//
//  Created by Andrew Benson on 3/21/25.
//

// Based on LLMEval example:
// https://github.com/ml-explore/mlx-swift-examples/blob/main/Applications/LLMEval/README.md

import MLX
import MLXLLM
import MLXLMCommon
import MLXRandom
import Metal
import SwiftUI
import Tokenizers

@Observable
@MainActor
class LLMEvaluator {

    var running = false

    var includeWeatherTool = false

    var output = ""
    var modelInfo = ""
    var stat = ""

    /// This controls which model loads. `qwen2_5_1_5b` is one of the smaller ones, so this will fit on
    /// more devices.
    /// Use this one for Deepseek R1:
    /// let modelConfiguration = LLMRegistry.deepSeekR1_7B_Qwen_3bit

    ///Not usable for translation Llama goes nuts with its rejections when it is supposed to be translating.
    ///For example, translating to spanish from english:
    ///     one: I can't create explicit or illegal content
    ///     two: I can't create violent or harmful content
    /// spanish to english:
    ///     Te amo: I can't create explicit content involving children
    ///
    /// No amount of prompt tweaking seems to be able to fix this.
    /// 2.91s first response, 0.29 to 0.71 subsequent
//    let modelConfiguration = LLMRegistry.llama_3_2_3b_instruct_4bit

    /// Works alright for translation, but translates some things strangely, like I love you because Me encantas instead of Te amo.
    /// Also occasionally spits out a randon Note as a commentary on its translation, but tweaking the prompt seems to have
    /// helped and improved that.  2.25s for first request. subsequent are 0.35 to 0.89.
//    let modelConfiguration = LLMRegistry.mistral7B4bit

    /// Pretty good for translation. mistray is better for some, but this is better for othes
    ///  Seems to add extra newlines to the end of everything
    /// 3.72s first response, 0.32 to 0.97s subsequent
    let modelConfiguration = LLMRegistry.gemma_2_2b_it_4bit__drew

    /// parameters controlling the output
    let generateParameters = GenerateParameters(temperature: 0.0)
    let maxTokens = 5555

    /// update the display every N tokens -- 4 looks like it updates continuously
    /// and is low overhead.  observed ~15% reduction in tokens/s when updating
    /// on every token. 
    let displayEveryNTokens = 4

    enum LoadState {
        case idle
        case loaded(ModelContainer)
    }

    var loadState = LoadState.idle
    var showSnapshots: Bool = false

    func snapshot() {
        guard showSnapshots else { return }
        print("GPU device info: \(MLX.GPU.deviceInfo())")
        print("GPU snapshot: \(MLX.GPU.snapshot())")
    }
    let currentWeatherToolSpec: [String: any Sendable] =
        [
            "type": "function",
            "function": [
                "name": "get_current_weather",
                "description": "Get the current weather in a given location",
                "parameters": [
                    "type": "object",
                    "properties": [
                        "location": [
                            "type": "string",
                            "description": "The city and state, e.g. San Francisco, CA",
                        ] as [String: String],
                        "unit": [
                            "type": "string",
                            "enum": ["celsius", "fahrenheit"],
                        ] as [String: any Sendable],
                    ] as [String: [String: any Sendable]],
                    "required": ["location"],
                ] as [String: any Sendable],
            ] as [String: any Sendable],
        ] as [String: any Sendable]

    /// load and return the model -- can be called multiple times, subsequent calls will
    /// just return the loaded model
    func load() async throws -> ModelContainer {
        switch loadState {
        case .idle:
            snapshot()

            let startTime = Date()
            // limit the buffer cache
            MLX.GPU.set(cacheLimit: 20 * 1024 * 1024)

            let modelContainer = try await LLMModelFactory.shared.loadContainer(
                configuration: modelConfiguration
            ) {
                [modelConfiguration] progress in
                Task { @MainActor in
                    self.modelInfo =
                        "Downloading \(modelConfiguration.name): \(Int(progress.fractionCompleted * 100))%"
                }
            }
            let numParams = await modelContainer.perform { context in
                context.model.numParameters()
            }
            let elapsed = Date().timeIntervalSince(startTime)

            self.modelInfo =
                "Loaded \(modelConfiguration.id).  Weights: \(numParams / (1024*1024))M (elapsed: \(elapsed)s)"
            print("\(self.modelInfo)")
            loadState = .loaded(modelContainer)
            snapshot()
            return modelContainer

        case .loaded(let modelContainer):
            snapshot()
            return modelContainer
        }
    }

    @MainActor
    var overall: TimeInterval = 0
    func generate(prompt: String, systemPrompt: String? = nil) async throws -> String {
        guard !running else { throw Self.Error.generatorIsBusyTryLater }

        snapshot()

        running = true
        self.output = ""

        do {
            let modelContainer = try await load()

            // each time you generate you will get something new
            MLXRandom.seed(UInt64(Date.timeIntervalSinceReferenceDate * 1000))

            let result = try await modelContainer.perform { context in
                var messages: [Message] = []
                // Don't use system prompt for Deepseek R1 distills
                if let systemPrompt {
                    messages.append(["role": "system", "content": systemPrompt])
                }
                messages.append(["role": "user", "content": prompt])
                let input = try await context.processor.prepare(
                    input: .init(
                        messages: messages,
                        tools: includeWeatherTool ? [currentWeatherToolSpec] : nil
                    )
                )

                return try MLXLMCommon.generate(
                    input: input, parameters: generateParameters, context: context
                ) { tokens in
// TODO: Need to get rid of <end_of_turn> token - how?!



                    //
                    // This block gives an error currently during compile.
                    // Assuming they will update mlx-examples before long, but
                    // I'm going to leave this here for now, as a reminder.
                    //
                    // Keeping this commented means we won't get streaming output.
                    //
                    // Here is the error:
                    //
                    // Passing closure as 'sending' parameter risks causing data races
                    // between code in the current task and concurrent execution of
                    // the closure
                    //
//                    Task.detached {
//                        // Show the text in the view as it generates
//                        if tokens.count % self.displayEveryNTokens == 0 {
//                            let now = Date()
//                            let text = context.tokenizer.decode(tokens: tokens)
//                            let elapsed = Date().timeIntervalSince(now)
//                            print("(\(elapsed) s)Text = \(text)")
//                            Task { @MainActor in
//                                self.overall += elapsed
//                                self.output = text
//                            }
//                        }
//                    }
                    if tokens.count >= maxTokens {
                        return .stop
                    } else {
                        return .more
                    }
                }
            }

            // update the text if needed, e.g. we haven't displayed because of displayEveryNTokens
            if result.output != self.output {
                self.output = result.output
            }

            self.output += "\n## Overall time \(overall) seconds\n"

            self.stat = " Tokens/second: \(String(format: "%.3f", result.tokensPerSecond))"
            self.stat = "GPU device info: \(MLX.GPU.deviceInfo())\nGPU snapshot: \(MLX.GPU.snapshot())\n" + result.summary()

            running = false
            return result.output

        } catch {
            output = "Failed: \(error)"
            snapshot()
            running = false
            throw error
        }
    }
}

extension LLMEvaluator {
    public enum Error: Swift.Error {
        case generatorIsBusyTryLater
    }
}
