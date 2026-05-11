# House Modes Package

Centralized logic for managing house operational modes and their associated automations.

## Current Modes

### Night Mode
- **Helper**: `input_boolean.house_mode_night`
- **Automation**: `bedtime_reset`
  - Turns off all lights
  - Triggers electrical blanket 30-min off script
  - Turns off bedroom air purifier
  - Triggers manually or auto-triggers at midnight
  - Condition: Someone must be home

### Guest Mode
- **Helper**: `input_boolean.house_mode_guest`
- Indicates guest(s) staying over - for future guest-specific automations

### Girls Mode
- **Helper**: `input_boolean.house_mode_girls`
- Girls' room mode - for room-specific automations

### Boys Mode
- **Helper**: `input_boolean.house_mode_boys`
- Boys' room mode - for room-specific automations

## Future Expansion

- Add automations for `house_mode_guest`, `house_mode_girls`, `house_mode_boys`
- Add `input_boolean.house_mode_away` for vacation/away automations
- Add `input_boolean.house_mode_cleaning` for scheduled cleanups
- Consider `input_select.house_mode` for mutually-exclusive modes with a single selector
