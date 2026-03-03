[CmdletBinding()]
param(
    [Parameter(Position=0)]
    [string]$PayloadJson = ""
)

$ErrorActionPreference = "Stop"
$baseScript = Join-Path $PSScriptRoot 'notify.ps1'
if (-not (Test-Path $baseScript)) {
    exit 0
}

$type = "agent-turn-complete"
$message = "Tache terminee."

if (-not [string]::IsNullOrWhiteSpace($PayloadJson)) {
    try {
        $payload = $PayloadJson | ConvertFrom-Json -ErrorAction Stop
        if ($payload.type) {
            $type = [string]$payload.type
        }
        $last = $payload.'last-assistant-message'
        if (-not [string]::IsNullOrWhiteSpace([string]$last)) {
            $message = [string]$last
        }
    } catch {
        # Keep defaults if payload parsing fails.
    }
}

switch ($type) {
    'approval-requested' {
        & $baseScript -Event PermissionRequest -Title 'Codex' -Message 'Permission requise pour continuer.'
    }
    default {
        & $baseScript -Event Stop -Title 'Codex' -Message $message
    }
}
