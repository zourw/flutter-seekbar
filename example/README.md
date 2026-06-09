# Example

This app is a manual verification target for the local `seekbar` package.

## Run

```bash
cd example
flutter pub get
flutter run
```

## What To Verify

1. Drag the seek bar and confirm `primary value` changes.
2. Confirm `tracking` switches to `yes` while dragging and back to `no` after release.
3. Confirm `last event` updates for drag start, drag update, drag end, and button actions.
4. Move the `Primary Value` and `Secondary Value` sliders to verify external prop updates repaint the widget.
5. Tap `Reset` to restore the initial values.
