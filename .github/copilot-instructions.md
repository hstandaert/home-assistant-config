## Guidance for AI coding agents working on this repository

This repository is a Home Assistant YAML configuration. The goal of any change is to be safe, minimal, and explicit: add new YAML files under the right directory, keep ids/aliases stable, and keep CI green.

- Big picture

  - Root config: `configuration.yaml` bootstraps the system and delegates by including files and directories (e.g. `!include_dir_list automation`).
  - Automations: stored under `automation/` (each file is a YAML automation). The repo also has `automations.yaml` used by the frontend — prefer adding files under `automation/` and keep `automations.yaml` untouched unless explicitly necessary.
  - Entities / integrations: reusable entity definitions live under `entities/` (e.g. `entities/switches/*`), and are included from `integrations/*` (see `integrations/switch.yaml` which uses `!include_dir_list ../entities/switches`).
  - Deploy: docker-compose is used for local runtime (`docker-compose.yml` mounts `./` to `/config`). CI/CD deploys via SSH and restarts the remote Docker/Home Assistant instance (`.github/workflows/cd.yaml`).

- Conventions and patterns to follow

  - Automations always include both `alias:` and `id:` keys (keep `id` stable; it is used for tracking). Example: `automation/heating.yaml` contains `alias: Heating` and `id: heating`.
  - Use `mode:` when needed (this repo uses `mode: single` in automations).
  - Use `action:` instead of `service:` for calling services (modern Home Assistant convention).
  - For multi-trigger automations, use trigger IDs and template conditions to distinguish between triggers (see `automation/heating_kids_room.yaml` which uses `trigger.id == 'turn_on'`).
  - For climate control, call `climate.set_hvac_mode` first, then `climate.set_temperature` in separate steps (some devices require this order).
  - Use `numeric_state` condition for zone occupancy checks (e.g., `zone.home` above 0).
  - Template files use Jinja2 expressions (see `entities/switches/switch.do_not_disturb.yaml`); follow the same templating style and indentation.
  - Add new switches/entities by creating a new file under `entities/<domain>/` and let the integration include it via `!include_dir_list`.

- Linting / CI expectations

  - CI runs two checks: `yamllint` and the Home Assistant configuration check (see `.github/workflows/ci.yaml`).
  - The repo provides `.yamllint` rules — adhere to those spacing/line rules and the ignore list (several frontend-managed files are ignored).
  - The CI action for Home Assistant uses `secrets.default.yaml` as the secrets stub — do not commit real secrets; use `secrets.default.yaml` for CI-compatible dummy values.

- Developer workflows (what an agent may suggest or edit)

  - Local run: the repo includes `docker-compose.yml` which starts the Home Assistant container (image set by `$HOME_ASSISTANT_VERSION`) with `./` mounted to `/config`.
  - Validate changes via the same checks CI runs: run `yamllint -c .yamllint <file or dir>` locally and prefer running the official Home Assistant configuration check (the CI uses `frenck/action-home-assistant`).
  - For small edits: create a new YAML under the appropriate directory (`automation/`, `entities/`, `scenes/`, `scripts/`) following existing file examples.

- Examples (copy these patterns)

  - Add a template switch: create `entities/switches/my_switch.yaml` with a `- platform: template` block following `switch.do_not_disturb.yaml`.
  - Add an automation: create `automation/my_new_automation.yaml` with `alias:`, `id:`, `trigger:`, `condition:` (optional), `action:`, and `mode:` if needed.
  - Multi-trigger automation: use trigger IDs in the trigger definitions, then use template conditions like `{{ trigger.id == 'my_trigger_id' }}` in `choose` blocks (see `automation/heating_kids_room.yaml`).
  - Climate control: call `climate.set_hvac_mode` first to set mode (e.g., `heat` or `off`), then call `climate.set_temperature` to set the target temperature.
  - Conditional actions based on input_boolean: use `condition: state` with `entity_id: input_boolean.my_boolean` and `state: "on"` before executing actions.
  - Reference existing entities by their full entity_id (e.g. `climate.woonkamer`, `climate.heating_boys`, `notify.mobile_app_sm_s928b`), as used in `automation/heating.yaml` and `automation/heating_kids_room.yaml`.

- Safe-edit rules (strict, actionable)

  - Never add secrets to the repo. If a secret is needed for CI, add it to `secrets.default.yaml` with dummy values only.
  - Keep changes minimal and isolated: add files rather than editing many existing ones, and prefer creating new entities/automations rather than in-place edits unless the change is small and well-tested.
  - Preserve formatting consistent with `.yamllint`. The repo uses a Prettier config at `.prettierrc.yaml` for formatting preferences — be cautious: YAML lint rules are the authoritative CI gate.

- Where to look for more context
  - Entry points: `configuration.yaml`, `.github/workflows/ci.yaml`, `docker-compose.yml`.
  - Examples to copy: `automation/heating.yaml`, `automation/heating_kids_room.yaml`, `entities/switches/switch.do_not_disturb.yaml`, `integrations/switch.yaml`.

If anything above is unclear or you want me to expand examples (new automation template, a template switch, or a short checklist for PR reviewers), tell me which example and I'll add it.
