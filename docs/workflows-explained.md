# GitHub Actions workflows explained

## Why workflows must be under `.github/workflows`

GitHub discovers workflow YAML only in this directory. A valid YAML file elsewhere is ordinary repository content and will never execute.

## Validation workflow

| Section | Why it exists |
|---|---|
| `pull_request` | Validate infrastructure before merge |
| `push` to `main` | Reconfirm the merged state |
| `workflow_dispatch` | Allow a learner to run validation manually |
| `paths` | Avoid runs for unrelated documentation changes |
| `contents: read` | Least permission needed for checkout |
| `concurrency` | Cancel stale validation on the same ref |
| `timeout-minutes` | Prevent a stuck job from consuming runners indefinitely |
| `az bicep lint` | Apply Bicep lint rules |
| `az bicep build` | Compile the main template |
| `build-params` loop | Compile every environment parameter file |

The Bash options `set -euo pipefail` cause failures, undefined variables, and failed pipeline commands to stop the step. `nullglob` prevents an unmatched wildcard from being treated as a filename.

## Deployment workflow

`workflow_dispatch` collects two inputs:

- `environment`: selects the GitHub Environment and `.bicepparam` file.
- `operation`: selects preview-only or deployment.

Two safety gates are intentional:

1. `ENABLE_AZURE_DEPLOYMENT` must equal `true`.
2. The user must select `deploy`; the default is `what-if`.

`id-token: write` does not grant Azure permission by itself. It allows GitHub to request an OIDC token, which Entra validates against the federated credential.

The flow is:

1. Resolve the resource group from the selected environment.
2. Authenticate with OIDC.
3. Verify the resource group.
4. Run Azure server-side validation.
5. Run What-If.
6. Deploy only if requested.

## Important GitHub expressions

| Expression | Meaning |
|---|---|
| `${{ inputs.environment }}` | Manual environment selection |
| `${{ vars.NAME }}` | Repository/Environment variable |
| `${{ github.run_number }}` | Incrementing workflow run number |
| `${{ steps.target.outputs.resource_group }}` | Value written to `$GITHUB_OUTPUT` |

`$GITHUB_OUTPUT` passes a value to later steps. `$GITHUB_STEP_SUMMARY` creates a readable summary on the run page.

