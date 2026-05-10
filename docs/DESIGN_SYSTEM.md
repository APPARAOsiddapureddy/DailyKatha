# Daily Katha — UI Design System (Flutter)

This document is the **single source of truth** for the current app UI, so you (or a “cloud redesign”) can update the look cleanly without hunting through the codebase.

> Note: this is a Flutter app — there are **no CSS files**. Styling lives in **Dart theme/token files** and widget implementations. This doc lists the *equivalent* of “CSS files” (design tokens + component styles).

## Goals of the current UI

- **Fast first impression**: avoid a “wall of text” on Home.
- **Intent-based reveal**: show 1 clear card per section; blur the rest until user taps.
- **Story-first card design**: full-screen-ish 9:16 cards suitable for WhatsApp status.
- **Editing is explicit**: user taps **Edit** to add photo/caption; then shares.

## App flow (information architecture)

- **Splash** → onboarding
- **Onboarding**: Language → Religion → Interests
- **Home**: section rails (mini-cards)
  - First card in each section is clear
  - Remaining cards are blurred
  - Tap a card → **Section preview** (single full card + blurred list)
  - Tap “Open all” / any quote → **Feed** (vertical scroll of all quotes)
- **Feed**: vertical PageView of full cards
- **Edit**: add photo/caption + Save + Status share

Key routing:
- `mobile/lib/app/router.dart`
- `mobile/lib/features/splash/splash_screen.dart`

## “CSS equivalents” (design tokens + global theme)

If you want to redesign quickly, start here:

### 1) Colors / surfaces / borders

- **File**: `mobile/lib/theme/app_colors.dart`
- **What to change**:
  - Scaffold/surfaces: `scaffoldDark`, `surfaceDark`, `surfaceElevatedDark`, `bottomNavDark`
  - Text hierarchy: `textPrimaryDark`, `textSecondaryDark`, `textTertiaryDark`
  - Accent: `accentGold` + related border/bg variants

### 2) Typography (global Material text)

- **File**: `mobile/lib/theme/app_typography.dart`
- **What to change**:
  - Serif vs sans choices
  - Default weights/sizes for `headlineMedium`, `titleLarge`, `bodyLarge`, etc.

### 3) Global Material theme (buttons, appbar, nav)

- **File**: `mobile/lib/theme/app_theme.dart`
- **What to change**:
  - AppBar defaults (font/size/color)
  - NavigationBar height + colors
  - Button shapes/padding
  - Input decoration (text fields)
  - Snackbar styling

## Card visual system (the “main design”)

The card is the core product surface. It’s composed of:

### Status card component (full card)

- **File**: `mobile/lib/widgets/status_card.dart`
- **What to change**:
  - Layout, spacing, hierarchy (headline, echo line, footer)
  - “DailyKatha” footer placement and any overlays
  - Photo insertion styling (if you want it more “story editor”)

### Per-category palette (editorial dark)

- **File**: `mobile/lib/theme/status_luxe_palette.dart`
- **What to change**:
  - Accent + background colors per interest/category (bhakti, love, motivation, etc.)

### Mood gradients (mini-card light mode)

- **File**: `mobile/lib/theme/card_gradients.dart`
- **What to change**:
  - `paletteFor(mood)` gradients and ink/accent for non-dark surfaces

### Card visual helpers

- **File**: `mobile/lib/widgets/luxe_card_visuals.dart`
- **What**: shared shapes, glow, pill labels, etc. (used by `StatusCard`)

## Home page: sections, blur behavior

- **File**: `mobile/lib/features/home/home_screen.dart`
- **What to change**:
  - Which sections exist and how they filter cards
  - Rail spacing, header copy, “View all” behavior
  - Blur strategy: currently the rail uses `MiniCard(blurred: i != 0)`

### Mini-card (rail preview)

- **File**: `mobile/lib/widgets/mini_card.dart`
- **What to change**:
  - Mini-card design (typography, gradients, border radius)
  - Blur effect: `blurred` boolean applies an `ImageFilter.blur` overlay + lock icon

## Section preview screen (intermediate reveal)

- **File**: `mobile/lib/features/home/section_preview_screen.dart`
- **Args model**: `mobile/lib/models/section_preview_args.dart`
- **What to change**:
  - Hero card size (currently an `AspectRatio(9/16)` with constrained width)
  - How many items are shown unblurred (currently 1)
  - CTA copy (“Open all”)

## Feed screen (vertical quote browsing)

- **File**: `mobile/lib/features/feed/feed_screen.dart`
- **What to change**:
  - Header chrome and padding (to avoid overlap)
  - PageView behavior (vertical)
  - Actions row layout

### Bottom action row

- **File**: `mobile/lib/widgets/action_rail.dart`
- **What to change**:
  - Button labels/icons
  - Tap mapping (currently: Like / Edit / Save / Share)

## Editor (photo + caption + share)

- **File**: `mobile/lib/features/editor/card_editor_screen.dart`
- **What to change**:
  - Editor controls layout
  - Caption style and placement
  - Photo manipulation UI (reset, scaling, rotation)
  - “Status” button behavior (uses `CardShareExport.shareKathaCardAsImage`)

## Save / Share pipeline

### Rendering PNG bytes

- **File**: `mobile/lib/services/card_share_export.dart`
- **What**:
  - Renders `StatusCard` off-screen into a 9:16 PNG at `logicalExportWidth × exportPixelRatio` (currently ~1440×2560; tune `CardShareExport.exportPixelRatio`)
  - Used by Save and Share

### Save to gallery

- **Flutter dependency**: `image_gallery_saver2_fixed`
- **Where used**:
  - `CardShareExport.savePngBytesToGallery(...)`
  - `FeedScreen` Save button
  - `CardEditorScreen` Save button

If you redesign this, keep “render once → save/share multiple ways” as the architecture.

## Assets / content

- **Cards JSON**: `mobile/assets/data/*.json`
- **Card model**: `mobile/lib/models/katha_card.dart`

## Quick “redesign checklist” (what to edit first)

1. **Theme tokens**: `app_colors.dart`, `app_typography.dart`, `app_theme.dart`
2. **Card look**: `status_card.dart` + `status_luxe_palette.dart`
3. **Home rails**: `mini_card.dart` + `home_screen.dart`
4. **Feed chrome**: `feed_screen.dart` + `action_rail.dart`
5. **Editor**: `card_editor_screen.dart`

## Non-goals / constraints (so redesign doesn’t break behavior)

- Keep a **9:16** card export target for WhatsApp status.
- Avoid any UI that requires login/OTP (current product ideology is login-less onboarding).
- Home should remain **lightweight** (limited text, intentional reveal).

