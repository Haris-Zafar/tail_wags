# 🐾 TailWags

TailWags is a Flutter app built for pet communities to discover local events, vote in community polls, and stay connected.

---

## ✨ Features

- **Event Discovery**: Switch between Calendar and List views, filter events, and add them to your local calendar.
- **Community Polls**: Participate in and create community polls in real time.
- **Favorites**: Save favorite events for quick access.
- **Profile Customization**: Upload profile photos via Cloudinary with a tap-to-zoom fullscreen image viewer.
- **Dark & Light Themes**: Adaptive UI styling across both light and dark modes.

---

## 🛠 Tech Stack

- **Framework**: Flutter (Dart)
- **State Management**: `flutter_riverpod`
- **Routing**: `go_router` (using `StatefulShellRoute` for tab state retention)
- **Backend**: Firebase Authentication & Cloud Firestore
- **Media Storage**: Cloudinary

---

## 💡 Key Learnings

1. **Unsigned Cloudinary Uploads**: Integrated Cloudinary for media uploads (profile pictures, event photos, poll images) as a lightweight, card-free alternative for asset management.
2. **Tab State Preservation**: Implemented `StatefulShellRoute.indexedStack` in GoRouter to retain scroll positions and state when switching between bottom navigation tabs.
3. **Reactive Firestore Integration**: Leveraged Riverpod's `StreamProvider` with Firestore snapshot listeners to keep user profiles, events, and poll votes synchronized in real time.
4. **Centralized Theme System**: Maintained strict design token separation (`AppColors`, `AppTextStyles`, `AppTheme`) to make dark and light mode switching smooth across all screens.

---

## 🚀 Getting Started

```bash
# Get dependencies
flutter pub get

# Run application
flutter run
```
