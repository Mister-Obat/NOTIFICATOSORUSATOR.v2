param([string]$PayloadJson='')
$log = Join-Path $env:TEMP 'codex-notify-probe.log'
$stdin=''
try { if ($MyInvocation.ExpectingInput) { $stdin=[Console]::In.ReadToEnd() } } catch {}
$entry = "`n=== $(Get-Date -Format o) ===`nARGV:$PayloadJson`nSTDIN:$stdin`n"
Add-Content -Path $log -Value $entry -Encoding UTF8
