![image](https://github.com/avielg/picasso/actions/workflows/ios.yml/badge.svg) (currently using Xcode Cloud)
# Picasso

JSON → Native SwiftUI 🎉

Eventually also:
1. Swift on the server → Native SwiftUI
2. JSON or Swift on the server → Jetpack Compose

<img width="200" alt="image" src="https://github.com/avielg/picasso/assets/5012557/a65ec658-9132-4262-8c17-d353ad670b6a">

---

## Usage

1. Clone or download the repo.
2. Run `./build_framework.sh`
3. Grab the framework from `_build_framework/PicassoKit.xcframework` and drag into your Xcode project.
4. Add [AnyCodable](`https://github.com/Flight-School/AnyCodable`) as a dependency to your target.

### Getting Started

1. `import PicassoKit`
2. Provide an encoder and decoder: `Parser.shared = Parser(encoder: ..., decoder: ...)`. Picasso is tested on 3 options:
    1. [ZippyJSON](https://github.com/michaeleisel/ZippyJSON) for decoding (pair with Apple's `JSONEncoder`).
    2. Apple's `JSONDecoder` and `JSONEncoder`.
    3. [MessagePacker](https://github.com/hirotakan/MessagePacker) for [MessagePack](https://msgpack.org) support.
3. Create a `PicassoView` anywhere in your SwiftUI code:

    ```swift
    struct MyCoolView: View {
        var body: some View {
          VStack {
            Text("Hello!")
            PicassoView(URL("my.server.com/picasso/coolcontent")!) // <--
          }
        }
    }
    ```

## Building Payload

Instead of typing the view hierarchy in JSON yourself (or if you want to use MessagePack), construct your UI from various PC views (`PCStack`, `PCText` etc.) and encode the main view:
```swift
func someView() -> PCStackView {
  PCStackView(...)
}

let view = someView()
let data = try someEncoder.encode(view)
let json = String(data: data, encoding: .utf8)
// upload the result json to your backend etc.
```


## JSON Syntax

While not a comprehensive guide, this should provide an idea of how the JSON syntax looks like:
```json
{
  "VStack": [
    {
      "text": "Hello!",
      "modifiers": {
        "font": { "weight": "bold", "style": "title" },
        "padding": { "top": 30, "leading": 100 }
      }
    },
    {
      "HStack": [...other views...],
      "alignment": "bottomTrailing",
      "modifiers": {
        "overlay": {
          "alignment": "bottom",
          "content": {...some view...}
        }
      }
    },
    {
      "optional": {
        "content": { "text": "Hi there! :)" },
        "presentationFlag": "show-text" }
    },
    {
      "button": "Toggle Hidden Text",
      "toggleFlag": "show-text",
    },
    {
      "image": "https://picsum.photos/200/400",
      "scale": 2
    }
  ]
}
```

---

### ToDo/Reminders
(beyond the obvious missing stuff...)
- [ ] Eventually split ``Parser/modifiers(from:)`` to categories: text, etc.
- [ ] Remove the SwiftUI.View conformance from the types, make it separate (to later compile on Linux)
- [x] Find a way to type erase the modifiers like `AnyPCView`?
- [x] Somehow single pass on the JSON?
- [x] Fix the `.indices` in containers body (stack and scrollview)
- [x] Add MessagePack with perf tests against JSON
- [x] ~Figure out the crash in msgpack-swift when trying to parse modifiers~ (bug in the library)

