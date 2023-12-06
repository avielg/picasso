![image](https://github.com/avielg/picasso/actions/workflows/ios.yml/badge.svg) (currently using Xcode Cloud)
# Picasso

JSON → Native SwiftUI 🎉

Eventually also:
1. Swift on the server → Native SwiftUI
2. JSON or Swift on the server → Jetpack Compose

<img width="200" alt="image" src="https://github.com/avielg/picasso/assets/5012557/a65ec658-9132-4262-8c17-d353ad670b6a">

---

## Getting Started

Views:
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
- [ ] Somehow single pass on the JSON?
- [ ] Eventually split ``Parser/modifiers(from:)`` to categories: text, etc.
- [ ] Add MessagePack with perf tests against JSON
- [ ] Remove the SwiftUI.View conformance from the types, make it separate (to later compile on Linux)

