//
//  LLMRegistry+drew.swift
//  MLXTranslate
//
//  Created by Andrew Benson on 3/21/25.
//

import Foundation
import MLXLLM
import MLXLMCommon

extension LLMRegistry {

    static public let deepSeekR1_7B_4bit = ModelConfiguration(
        id: "mlx-community/DeepSeek-R1-Distill-Qwen-7B-4bit",
        defaultPrompt: "Is 9.9 greater or 9.11?"
    )

    static public let deepSeekR1_7B_3bit = ModelConfiguration(
        id: "mlx-community/DeepSeek-R1-Distill-Qwen-7B-3bit",
        defaultPrompt: "Is 9.9 greater or 9.11?"
    )

    /*
     Comparison with DeepSeek app

     DeepSeek(R1)
     Prompt "Is 9.9 greater or 9.11?"

     Run #1
     1st token: about 9 seconds
     total think time (hitting send on the message until thinking done): 43.4 seconds
     total time 55.14 seconds

     Run #2 (without quitting app)
     1st token: about 5.5 seconds
     total thinking time: 36.3 seconds
     total time 46.30 seconds


     Prompt "Write a swift function to average an array of numbers"

     Run #1
     Holy crap this was bad
     1st token: about 14 seconds
     totql time thinking: 4 minutes + 38 seconds
     total time: 4:51 -- phenominally terrible

     Run #2 (without quitting the app)
     1st token: about 17 seconds
     total time thinking: 1:29
     total time 1:48

     Run #3 (quit and relaunch app)
     1st token: 9 seconds
     total time thinking 2:37
     total time: 2:58


     */
    // https://github.com/deepseek-ai/DeepSeek-R1?tab=readme-ov-file#usage-recommendations
    //
    // This says -- use temp between 0.5 and 0.7
    // don't include a system prompt
    //
    // Performance with default prompt "Is 9.9 greater or 9.11?",
    // maxTokens 5555, temperature 0.60, displayEvery 4
    //
    //   iOS 18.4.1 on iPhone 15 Pro Max ("applegpu_g16p")
    //      Weights 7262M
    //      GPU snapshot active before prompt 3181M (3272M peak)
    //      Run #1
    //          killed by operating system - used too much memory GPU peak 3181M, cache 1K ?
    //      Run #2
    //          killed by operating system - used too much memory GPU peak 3181M, cache 1K ?
    //      Run #3
    //          Relatively short thinking
    //          GPU snapshot 3212M peak
    //          Cache 20M (why does macOS show almost no cache?)
    //          prompt: 18 tokens, 34.3 tokens/s
    //          generation: 419 tokens, 14.3 tokens/s
    //          total time 29.26 seconds
    //      Run #4
    //          Relatively short thinking
    //          GPU snapshot 3212M peak
    //          Cache 20M
    //          prompt: 18 tokens, 49.3 tokens/s
    //          generation: 341 tokens, 14.4 tokens/s
    //          total time: 23.75 seconds
    //   macOS Sequoia 15.3.1 on MBP M4 Max 48GB ("applegpu_g16s")
    //      Weights 7262M
    //      GPU snapshot 3211M peak
    //      Run #1
    //          prompt: 18 tokens, 253.4 tokens/s
    //          generation: 313 tokens, 124.6 tokens/s
    //          total time 2.51 seconds
    //      Run #2
    //          prompt 18 tokens, 277.7 tokens/s
    //          generation 328 tokens, 101.1 tokens/s
    //          total time 3.24 seconds
    static public let deepSeekR1_7B_Qwen_3bit = ModelConfiguration(
        id: "drewbenson/DeepSeek-R1-Distill-Qwen-7B-3bit-MLX",
        defaultPrompt: "Is 9.9 greater or 9.11?"
    )

    /// R1 option #2 -- for running on-device
    ///
    /// Performance tested March 2025
    ///
    /// Performance with default prompt "Is 9.9 greater or 9.11?",
    /// maxTokens 5555, temperature 0.60, displayEvery 4
    ///
    ///   iOS 18.4.1 on iPhone 15 Pro Max ("applegpu_g16p")
    ///      Weights 7658M
    ///      GPU snapshot active before prompt 3181M (3272M peak)
    ///      Cache 0K
    ///      Run #1
    ///          Cache 20M
    ///          prompt 17 tokens, 19.5 tokens/s
    ///          generation 368 tokens, 10.7 tokens/s
    ///          total time 34.36 seconds
    ///      Run #2
    ///          Cache 20M
    ///          prompt 17 tokens, 22.3 tokens/s
    ///          generation 357 tokens, 10.7 tokens/s
    ///          total time 33.21 seconds
    ///
    ///   macOS Sequoia 15.3.1 on MBP M4 Max 48GB ("applegpu_g16s")
    ///      Weights 7658M
    ///      GPU snapshot 4377M peak
    ///      Cache 20M
    ///      Run #1
    ///          prompt 17 tokens, 35.6 tokens/s
    ///          generation 294 tokens, 99.2 tokens/s
    ///          total time 2.96 seconds
    ///      Run #2
    ///          prompt 17 tokens, 47.1 tokens/s
    ///          generation 430 tokens, 97.6 tokens/s
    ///          total time 4.40 seconds
    static public let deepSeekR1_distill_llama_8B_4bit = ModelConfiguration(
        id: "drewbenson/DeepSeek-R1-Distill-Llama-8B-4bit-MLX",
        defaultPrompt: "Is 9.9 greater or 9.11?"
    )

    /// MLX version of Deepseek R1 distill Llama 8B 3bit
    /// This one can kind of run on a phone.  iPhone 15 Pro, for example.
    ///
    /// R1 option #3 for running on-device.
    ///
    /// Performance notes, tested March 2025
    ///
    /// Performance with default prompt "Is 9.9 greater or 9.11?",
    /// maxTokens 5555, temperature 0.60, displayEvery 4
    ///
    ///   iOS 18.4.1 on iPhone 15 Pro Max ("applegpu_g16p")
    ///   Release mode builds targeting iOS 17.2
    ///      Weights 7658M
    ///      GPU snapshot active before prompt 3181M (3272M peak)
    ///      Cache 0K
    ///      Run #1
    ///          Cache 20M
    ///          GPU peak 3422M
    ///          prompt 17 tokens, 28 tokens/s
    ///          generation 402 tokens, 13.1 tokens/s
    ///          total time 30.61 seconds
    ///      Run #2
    ///          Cache 20M
    ///          GPU peak 3422M
    ///          prompt: 17 tokens, 43.6 tokens/s
    ///          generation: 316 tokens, 11.7 tokens/s
    ///          total time 27.02 seconds
    ///      Run #3
    ///          Cache 20M
    ///          GPU peak 3422M
    ///          prompt 17 tokens, 44.9 tokens/s
    ///          generation: 228 tokens, 13.3 gtokens/s
    ///          total time: 17.19 seconds
    ///
    ///
    ///   macOS Sequoia 15.3.1 on MBP M4 Max 48GB ("applegpu_g16s")
    ///      Weights 7658M
    ///      GPU snapshot 4377M peak
    ///      Cache 20M
    ///      Run #1
    ///          very long thinking
    ///          GPU peak 3657M
    ///          prompt 17 tokens, 202.2 tokens/s
    ///          generation 2236 tokens, 112.1 tokens/s
    ///          total time 19.95 seconds
    ///      Run #2
    ///          wow really short
    ///          GPU peak 3657M
    ///          prompt: 17 tokens, 228.8 tokens/s
    ///          generation: 354 tokens, 117.2 tokens/s
    ///          total time 3.02 seconds
    ///
    ///
    /// Additional performance notes:
    ///
    /// Prompt "Write a swift function to average an array of numbers"
    /// iOS 18.4.1 on iPhone 15 Pro Max ("applegpu_g16p")
    ///     Run #1
    ///         1st token out: < 1 second
    ///         Cache 22M
    ///         GPU peak 3526M
    ///         prompt 15 tokens, 25.5 tokens/s
    ///         generation: 1076 tokens, 10.9 tokens/s
    ///         total time 98.6 seconds (1:38.6)
    ///         total time thinking: 74.75 seconds
    ///
    ///     Run #2 (fresh app launch)
    ///         1st token out: 1 second
    ///         Cache 21M
    ///         GPU peak 3562M
    ///         prompt: 15 tokens, 26.5 tokens/s
    ///         generation: 1428 tok3ns, 9.8 tokens/s
    ///         total time thinking: 2.00 minutes (120 seconds)
    ///         total time: 145.47 seconds (2:25.47)
    ///
    ///     Run #3 (without restarting app)
    ///         1st token out: 1 second
    ///         Cache 21M
    ///         GPU peak 3603M
    ///         prompt: 15 tokens, 39.8 tokens/s
    ///         generation: 1613 tokens, 9.2 tokens/s
    ///         total time thinking 2:45 (165 seconds)
    ///         total time: 175 seconds (2:55.15)
    ///
    ///     Run #4 (turned off all debug checkboxes in Xcode and changed to -Ofast (aggressive optimizations)
    ///         1st token out - immediate
    ///         Cache 21M
    ///         GPU peak 3456M
    ///         prompt: 15 tokens, 25.6 tokens/s
    ///         generation: 551 tokens, 13.3 tokens/s
    ///         total time: 41.45 seconds
    ///
    ///     Run #5 (without restarting app)
    ///         LOTS of thinking
    ///         1st token out: 1 second
    ///         Cache 21M
    ///         prompt: 15 tokens, 39.0 tokens/s
    ///         generation: 2335 tokens, 8.6 tokens/s
    ///         total time: 272.66 seconds
    static public let deepSeekR1_distill_llama_8B_3bit = ModelConfiguration(
        id: "drewbenson/DeepSeek-R1-Distill-Llama-8B-3bit-MLX",
        defaultPrompt: "Is 9.9 greater or 9.11?"
    )


    /// MLX version of Deepseek R1 7B Qwen 2bit
    ///
    /// This 2 bit model was garbage and doesn't work worth a damn.  Just keeping
    /// it in here so we remember not to use it
    static public let deepSeekR1_7B_Qwen_2bit__garbage_do_not_use = ModelConfiguration(
        id: "drewbenson/DeepSeek-R1-Distill-Qwen-7B-2bits-MLX",
        defaultPrompt: "Is 9.9 greater or 9.11?"
    )

    /// MLX Version of Deepseek Coder 6.7B instruct 3bit (this is not R1)
    /// Use this one for regular old deepseek, which is actually a coder alternative
    static public let deepSeek_coder_6_7b_instruct_3bit_mlx = ModelConfiguration(
        id: "drewbenson/deepseek-coder-6.7b-instruct-3bit-mlx",
        defaultPrompt: "Is 9.9 greater or 9.11?"
    )

    /// MLX version of DeepSeek V3 105B 3bit
    static public let deepSeekV3_105B_3bit = ModelConfiguration(
        id: "mlx-community/DeepSeek-V3-3bit",
        defaultPrompt: "Is 9.9 greater or 9.11?"
    )

    /// MLX version of Llama 3.2 3B instruct 4bit
    static public let llama_3_2_3b_instruct_4bit = ModelConfiguration(
        id: "mlx-community/Llama-3.2-3B-Instruct-4bit",
        defaultPrompt: "Is 9.9 greater or 9.11?"
    )


    /// MLX version of Qwen 2.5 1B 5bit
    static public let qwen2_5_1_5b = ModelConfiguration(
        id: "mlx-community/Qwen2.5-1.5B-Instruct-4bit",
        defaultPrompt: "Why is the sky blue?"
    )

}

// MARK: - Model entries to use instead of the build-in ones
extension LLMRegistry {
    /// MLX version of Gemma 2 9B instruct 4bit (drew's config)
    static public let gemma_2_9b_it_4bit__drew = ModelConfiguration(
        id: "mlx-community/gemma-2-9b-it-4bit",
        overrideTokenizer: "PreTrainedTokenizer",
        // https://www.promptingguide.ai/models/gemma
        defaultPrompt: "What is the difference between lettuce and cabbage?",
        extraEOSTokens: [ "<end_of_turn>"]
    )

    /// MLX version of Gemma 2 @B instruct 4bit (drew's config)
    static public let gemma_2_2b_it_4bit__drew = ModelConfiguration(
        id: "mlx-community/gemma-2-2b-it-4bit",
        overrideTokenizer: "PreTrainedTokenizer",
        // https://www.promptingguide.ai/models/gemma
        defaultPrompt: "What is the difference between lettuce and cabbage?",
        extraEOSTokens: [ "<end_of_turn>"]
    )

}
