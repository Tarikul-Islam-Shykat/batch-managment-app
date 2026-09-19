# Structural Documentation

This folder defines the standard feature structure for this GetX codebase.

The goal is not to force heavy clean architecture. The goal is to keep each feature easy to understand, easy to extend, and much cleaner than placing all logic inside one controller.

## What We Want

Each feature should be separated into small parts:

- `model` for API response mapping and plain data objects
- `controller` for state, user actions, API calls, and feature logic
- `view` for UI only
- `widget` for reusable UI pieces inside the feature
- `service` or `helper` only when the logic becomes too large for the controller

This keeps the code readable and prevents the controller from becoming a large mixed file.

## Why This Structure

In the current app, controllers can easily grow too much:

- many API calls
- many helper methods
- pagination logic
- navigation actions
- state variables
- response parsing

That makes a feature hard to debug and hard to extend.

This structure keeps the feature organized while still staying practical for GetX.

## Standard Feature Layout

Every feature should follow a structure similar to this:

```text
lib/features/<feature_name>/
  controller/
    <feature_name>_controller.dart
  model/
    <feature_name>_model.dart
  view/
    <feature_name>_screen.dart
  widget/
    <feature_name>_card.dart
    <feature_name>_shimmer.dart
  service/
    <feature_name>_service.dart
  binding/
    <feature_name>_binding.dart
```

Optional files can be added when needed, but the feature should stay compact.

## Responsibilities

### Model

Use the model for:

- `fromJson` and `toJson`
- basic computed values
- simple copy helpers

Do not put network calls or UI code in the model.

### Controller

Use the controller for:

- fetching data
- updating state
- pagination
- pull to refresh
- handling loading states
- navigation methods
- calling feature services

Try to keep helper methods small and focused.

If the controller gets too large, move repeated or complex logic into a service or helper file.

### View

Use the view for:

- layout
- UI composition
- widgets
- reacting to controller state

The view should not contain API logic, parsing logic, or business rules.

### Widget

Use the widget folder for:

- reusable cards
- section headers
- shimmer components
- buttons used inside the feature

This keeps the main screen file small.

### Service

Use a service file when the controller starts holding too much logic.

Good service examples:

- API request wrappers
- response normalization
- save/unsave sync logic
- image helper logic
- pagination helper logic

## API Pattern

If a feature needs network calls, use a simple pattern:

- controller calls service or `ApiService`
- service handles request details when needed
- model parses the response
- controller updates observables

Avoid scattering API logic across many methods unless that feature truly needs it.

## Controller Cleanliness Rule

If a controller starts containing all of these at once, it should be split:

- more than one API flow
- multiple response formats
- long parsing logic
- many navigation methods
- repeated transformations
- extra business rules

Move that logic into a service or helper file before the controller becomes difficult to read.

## Navigation

Every feature should expose its route cleanly.

Suggested pattern:

- define the screen in the view folder
- register the controller in a binding
- add the route in the app route map

## UI Helper Rule

For consistent UI, feature screens should use shared helpers when possible:

- `custom_text`
- loading widgets
- spacing widgets
- shared image widgets

This keeps the screen code short and consistent.

## Example Feature Flow

When building a feature, use this flow:

1. Create the model
2. Create the controller
3. Create the screen
4. Create feature widgets if needed
5. Add the binding
6. Add the route
7. Add API/service helpers only if the controller starts growing

## What Not To Do

Avoid these patterns:

- putting UI widgets inside the controller
- putting API calls directly inside the screen
- mixing response parsing with layout code
- creating helper methods that are not clearly named
- keeping unrelated logic in one file just because it works

## Prompt Guideline

When generating a new feature, use this style:

- keep the structure simple
- separate UI, logic, and data
- use GetX controller for state and actions
- use models for JSON handling
- use widgets for repeated UI
- use services only when the controller becomes too large

## Target Outcome

The final result should feel like this:

- fast to scaffold
- easy to read
- easy to maintain
- not over-engineered
- clean enough that another developer can understand the feature quickly

