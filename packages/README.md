# Home Assistant Packages Structure

This repository uses a **modular packages structure** for organized configuration management. Each feature/domain is self-contained with its own automations, helpers, entities, and sensors.

## Structure

Each package follows this consistent pattern:

```
packages/
  {package_name}/
    main.yaml              ← Package manifest (includes all subfolders)
    automations/           ← One automation per file
      {automation_name}.yaml
    helpers/               ← One helper per file (input_number, input_button, etc)
      {helper_name}.yaml
    entities/              ← One entity per file (template sensors)
      {entity_name}.yaml
    sensors/               ← One sensor per file (history_stats, etc)
      {sensor_name}.yaml
    scripts/               ← One script per file (optional)
      {script_name}.yaml
```

## Active Packages

### spa/
**Spa automation suite** - Manages sanitizer scheduling, solar-powered operation, and post-usage sanitization.

**Files:**
- `automations/solar_check.yaml` - Runs sanitizer when solar power exceeds threshold
- `automations/hygiene_guarantee.yaml` - Evening safety net ensures minimum daily runtime
- `automations/usage_boost.yaml` - Manual button trigger for post-usage sanitization
- `helpers/target_hours.yaml` - Daily target runtime (0-8 hours, default 3h)
- `helpers/solar_threshold.yaml` - Solar export trigger threshold (-2500 to 0W, default -100W)
- `helpers/usage_complete.yaml` - Button to trigger usage boost
- `entities/sanitizer_runtime_today.yaml` - Template sensor converting minutes to hours
- `sensors/runtime_minutes.yaml` - History stats tracking daily runtime in minutes

### heating/
**Heating automation suite** - Presence-based main heating + kids room scheduled heating.

**Files:**
- `automations/heating.yaml` - Presence-based heating control
- `automations/kids_room.yaml` - Schedule-based kids room heating (19:00-07:00)

### air_purifier/
**Air purifier automation** - Evening/sleep schedule.

**Files:**
- `automations/air_purifier.yaml` - 20:00 ON, 22:00 OFF

### electrical_blanket/
**Electrical blanket automation** - Scheduled activation with auto-shutoff.

**Files:**
- `automations/electrical_blanket.yaml` - 21:00 activation (if cold)
- `scripts/turn_off_after_30_minutes.yaml` - Auto-shutoff timer

## Adding a New Package

1. Create a new directory: `packages/{feature_name}/`
2. Create `main.yaml` with includes for your subfolders
3. Create subfolders as needed (automations/, helpers/, entities/, sensors/, scripts/)
4. Create one file per entity/automation/helper
5. Add to `configuration.yaml` under `homeassistant.packages:`

Example main.yaml:
```yaml
---
# My Feature package

automation: !include_dir_merge_list automations/
input_number: !include_dir_merge_named helpers/
sensor: !include_dir_merge_list sensors/
```

## Enabling/Disabling

Comment out or remove the package line in `configuration.yaml` to disable all configs for that feature:
```yaml
homeassistant:
  packages:
    # spa: !include packages/spa/main.yaml      # Disabled
    heating: !include packages/heating/main.yaml
```

## Notes

- **Modern Template Syntax**: Template entities use modern YAML structure
- **History Stats**: Sensor type `time` outputs in hours; `ratio` outputs as percentage; `count` outputs integer
- **One File Per Entity**: Ensures modularity and easy maintenance
- **Consistent Naming**: `{feature}_{entity_type}.yaml` pattern (e.g., `sanitizer_runtime_today.yaml`)
