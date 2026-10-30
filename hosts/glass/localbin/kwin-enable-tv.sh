#!/bin/sh
# Re-enable the HDMI-A-2 TV a few seconds after the Plasma session starts.
# Rationale: NVIDIA cannot complete the simultaneous atomic modeset of all 4
# outputs at startup, but adding the TV incrementally to an already-running
# session succeeds. The TV is left disabled at boot (see the plasma-workspace
# shutdown hook); this restores it once the 3 DP monitors are up.
# See ~/.claude/plans/ and the graphics-investigation CLAUDE.md for the full story.
sleep 6
exec kscreen-doctor output.HDMI-A-2.enable
