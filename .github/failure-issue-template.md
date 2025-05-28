---
title: "CI Workflow Failure: ${{ github.workflow }} - Run ${{ github.run_id }}"
labels: "CI-Failure, bug"
---

A failure occurred in the CI workflow.

**Workflow:** `${{ github.workflow }}`
**Run ID:** `${{ github.run_id }}`
**Run Number:** `${{ github.run_number }}`
**Triggered by:** `${{ github.actor }}` (Event: `${{ github.event_name }}`)
**Commit:** `${{ github.sha }}` (Branch: `${{ github.ref }}`)

Please [review the workflow run logs](https://github.com/${{ github.repository }}/actions/runs/${{ github.run_id }}) for details.
