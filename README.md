# MLXTranslate
On-device high speed text translation for macOS and iOS running local LLM using Apple's MLX for Apple Silicon 

## Alpha
This is very much alpha or beta software at best.  Use at your own risk.

## Environment
Building and running with Xcode 16.2 on a 2024 M4 Max MBP in March 2025

## Set up


```swift
.package(url: "https://github.com/drewster99/MLXTranslate", branch: "main")
```

Then add the library to your target as a dependency:

```swift
.target(
    name: "YourTargetName",
    dependencies: [
        .product(name: "MLXTranslate", package: "MLXTranslate")
    ]),
```

## Using MLXTranslate

```swift
import MLXTranslate

// use from async context
let text = "How was your day?"
let sourceLang = "English"
let targetLang = "French"

let translatedText = try await MLXTranslate.translate(text,
                                                      from: sourceLang,
                                                      to: targetLang)
                                                      
print("\"\(text)\" (\(sourceLang)) ----> (\(targetLang)) \"\(translatedText)\"")
// Prints:

```
