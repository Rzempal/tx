# deploy_template.ps1
# Generic Deployment Script (Build + Copy + Versioning + Upload)
# Usage: .\scripts\deploy_template.ps1 [-SkipBuild] [-SkipUpload] [-Channel internal|production]

param(
    [switch]$SkipBuild,
    [switch]$SkipUpload = $false,
    [string]$Channel = "production"
)

$SCRIPT_VERSION = "v1.0-generic"
$ErrorActionPreference = "Stop"

# === Configuration ===

$PROJECT_ROOT = Split-Path -Parent $PSScriptRoot
# TODO: Adjust these paths for your project
$BUILD_OUTPUT_DIR = Join-Path $PROJECT_ROOT "dist" 
$RELEASES_DIR = Join-Path $PROJECT_ROOT "releases"
$ARTIFACT_NAME_PATTERN = "app-release.zip" 

function Print-Info($msg) { Write-Host $msg -ForegroundColor Cyan }
function Print-Success($msg) { Write-Host $msg -ForegroundColor Green }
function Print-Warn($msg) { Write-Host $msg -ForegroundColor Yellow }
function Print-Error($msg) { Write-Host $msg -ForegroundColor Red }

function Load-Env {
    $envFile = Join-Path $PROJECT_ROOT ".env"
    if (Test-Path $envFile) {
        Get-Content $envFile | ForEach-Object {
            if ($_ -match "^\s*([^#=]+)=(.*)$") {
                [Environment]::SetEnvironmentVariable($matches[1].Trim(), $matches[2].Trim(), "Process")
            }
        }
        Print-Success "Loaded configuration from .env"
    }
    else {
        Print-Warn ".env file not found!"
    }
}

function Get-WinSCP {
    if ($env:WINSCP_PATH -and (Test-Path $env:WINSCP_PATH)) { return $env:WINSCP_PATH }
    if (Get-Command "winscp.com" -ErrorAction SilentlyContinue) { return "winscp.com" }
    
    $paths = @(
        "$env:ProgramFiles(x86)\WinSCP\WinSCP.com",
        "$env:ProgramFiles\WinSCP\WinSCP.com",
        "$env:LocalAppData\Programs\WinSCP\WinSCP.com"
    )
    foreach ($path in $paths) {
        if (Test-Path $path) { return $path }
    }
    return $null
}

# === Start Script ===

$startTime = [System.Diagnostics.Stopwatch]::StartNew()

Print-Info "=== Generic Deploy Script $SCRIPT_VERSION ==="
Load-Env

$DEPLOY_HOST = if ($env:DEPLOY_HOST) { $env:DEPLOY_HOST } else { "" }
$DEPLOY_USER = if ($env:DEPLOY_USER) { $env:DEPLOY_USER } else { "" }
$DEPLOY_PASS = if ($env:DEPLOY_PASS) { $env:DEPLOY_PASS } else { "" }
$DEPLOY_PROTOCOL = if ($env:DEPLOY_PROTOCOL) { $env:DEPLOY_PROTOCOL } else { "sftp" }
$DEPLOY_REMOTE_PATH = if ($env:DEPLOY_REMOTE_PATH) { $env:DEPLOY_REMOTE_PATH } else { "/public_html/" }
$DEPLOY_KEY_PATH = if ($env:DEPLOY_KEY_PATH) { $env:DEPLOY_KEY_PATH } else { "" }

# ========================================
# Versioning Logic (Date based)
# ========================================
$Date = Get-Date
$TIMESTAMP = $Date.ToString("yyMMddHHmm")
$VERSION_NAME = "1.0.$TIMESTAMP" # TODO: Read real version from package.json/pubspec.yaml
$ARTIFACT_NAME = "release_$VERSION_NAME.zip" # TODO: Customize artifact name

Print-Info "Version: $VERSION_NAME"
Print-Info "Artifact: $ARTIFACT_NAME"

# 1. Build
if (-not $SkipBuild) {
    Print-Warn "[1/4] Building..."
    
    # TODO: INSERT YOUR BUILD COMMAND HERE
    # Example: npm run build
    # Example: dotnet publish -c Release
    
    Write-Host "TODO: Configure build command in script!" -ForegroundColor Magenta
    # Start-Process "npm" -ArgumentList "run build" -Wait -NoNewWindow
    
    Print-Success "[1/4] Build complete (Simulated)"
}

# 2. Copy to releases
Print-Warn "[2/4] Archiving/Copying to releases..."
if (-not (Test-Path $RELEASES_DIR)) { New-Item -ItemType Directory -Path $RELEASES_DIR | Out-Null }
# TODO: Actually copy your build artifacts here
# Compress-Archive -Path $BUILD_OUTPUT_DIR -DestinationPath (Join-Path $RELEASES_DIR $ARTIFACT_NAME) -Force

Print-Success "[2/4] Artifact prepared: $ARTIFACT_NAME"

# 3. Upload
if (-not $SkipUpload) {
    Print-Warn "[4/4] Uploading to server..."
    
    if (-not $DEPLOY_HOST -or -not $DEPLOY_USER) {
        Print-Error "ERROR: Missing Host or User in .env!"
        exit 1
    }

    $winScp = Get-WinSCP
    if (-not $winScp) {
        Print-Error "WinSCP not found!"
        exit 1
    }

    $tempScript = Join-Path $env:TEMP "winscp_deploy_$TIMESTAMP.txt"
    
    "option batch on" | Out-File $tempScript -Encoding UTF8
    "option confirm off" | Out-File $tempScript -Append -Encoding UTF8
    
    $userEncoded = [Uri]::EscapeDataString($DEPLOY_USER)
    $switchString = "-hostkey=*"
    
    if ($DEPLOY_KEY_PATH) {
        $switchString += " -privatekey=""$DEPLOY_KEY_PATH"""
        $openCmd = "open {0}://{1}@{2}/ {3}" -f $DEPLOY_PROTOCOL, $userEncoded, $DEPLOY_HOST, $switchString
    }
    else {
        $passEncoded = [Uri]::EscapeDataString($DEPLOY_PASS)
        $openCmd = "open {0}://{1}:{2}@{3}/ {4}" -f $DEPLOY_PROTOCOL, $userEncoded, $passEncoded, $DEPLOY_HOST, $switchString
    }
    
    $openCmd | Out-File $tempScript -Append -Encoding UTF8
    "put ""$(Join-Path $RELEASES_DIR $ARTIFACT_NAME)"" ""$DEPLOY_REMOTE_PATH""" | Out-File $tempScript -Append -Encoding UTF8
    "exit" | Out-File $tempScript -Append -Encoding UTF8

    # Executing WinSCP
    # & $winScp /script="$tempScript" /log="$RELEASES_DIR\winscp_log.xml" /loglevel=0
    
    Print-Success "[4/4] Upload complete (Simulated - Uncomment WinSCP execution)"
    Remove-Item $tempScript -ErrorAction SilentlyContinue
}

$startTime.Stop()
Print-Success "=== Deployment Finished in $($startTime.Elapsed.ToString('mm\:ss')) ==="
