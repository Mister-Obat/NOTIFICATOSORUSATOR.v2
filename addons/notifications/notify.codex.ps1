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

# Codex integrations may provide payload through argv, stdin, or env vars depending on runtime.
if ([string]::IsNullOrWhiteSpace($PayloadJson)) {
    try {
        if ($MyInvocation.ExpectingInput) {
            $stdinPayload = [Console]::In.ReadToEnd()
            if (-not [string]::IsNullOrWhiteSpace($stdinPayload)) {
                $PayloadJson = $stdinPayload.Trim()
            }
        }
    } catch {
        # Keep default when stdin is unavailable.
    }
}

if ([string]::IsNullOrWhiteSpace($PayloadJson)) {
    foreach ($envName in @("CODEX_NOTIFY_PAYLOAD", "CODEX_NOTIFICATION_PAYLOAD", "NOTIFY_PAYLOAD_JSON")) {
        $envValue = [Environment]::GetEnvironmentVariable($envName)
        if (-not [string]::IsNullOrWhiteSpace($envValue)) {
            $PayloadJson = $envValue.Trim()
            break
        }
    }
}

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
        & $baseScript -Event PermissionRequest -Title 'Codex' -Message 'Permission command requise pour continuer.'
    }
    default {
        & $baseScript -Event Stop -Title 'Codex' -Message $message
    }
}
