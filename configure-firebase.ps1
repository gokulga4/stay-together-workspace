$ErrorActionPreference = "Stop"

$envFile = Join-Path $PSScriptRoot ".env"
if (-not (Test-Path -LiteralPath $envFile)) {
    throw "Missing .env file. Copy .env.example to .env and add your Firebase web configuration."
}

$values = @{}
foreach ($line in Get-Content -LiteralPath $envFile) {
    $trimmed = $line.Trim()
    if (-not $trimmed -or $trimmed.StartsWith("#")) {
        continue
    }

    if ($trimmed -notmatch '^([A-Z0-9_]+)=(.*)$') {
        throw "Invalid .env entry: $trimmed"
    }

    $values[$Matches[1]] = $Matches[2].Trim().Trim('"').Trim("'")
}

$fields = [ordered]@{
    apiKey            = "VITE_FIREBASE_KEY"
    authDomain        = "VITE_FIREBASE_AUTH_DOMAIN"
    projectId         = "VITE_FIREBASE_PROJECT_ID"
    storageBucket     = "VITE_FIREBASE_STORAGE_BUCKET"
    messagingSenderId = "VITE_FIREBASE_MESSAGING_SENDER_ID"
    appId             = "VITE_FIREBASE_APP_ID"
    measurementId     = "VITE_FIREBASE_MEASUREMENT_ID"
}

$config = [ordered]@{}
foreach ($field in $fields.GetEnumerator()) {
    $value = $values[$field.Value]
    if ([string]::IsNullOrWhiteSpace($value) -or $value -eq "YOUR_API_KEY" -or $value.StartsWith("replace-with-")) {
        throw "Set $($field.Value) to a value from your Firebase web app configuration."
    }

    $config[$field.Key] = $value
}

$json = ConvertTo-Json -InputObject $config -Compress
$outputPath = Join-Path $PSScriptRoot "assets\public\firebase-config.js"
$output = "globalThis.__FIREBASE_CONFIG__ = $json;`n"
[System.IO.File]::WriteAllText($outputPath, $output, [System.Text.UTF8Encoding]::new($false))
Write-Output "Wrote Firebase runtime configuration to assets\public\firebase-config.js (ignored by Git)."
