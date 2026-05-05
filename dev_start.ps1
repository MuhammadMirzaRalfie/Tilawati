# ============================================================
#  dev_start.ps1  –  Tilawati Dev Launcher
#  Jalankan: .\dev_start.ps1
# ============================================================

$ADB = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"
$BACKEND_DIR = "$PSScriptRoot\backend"
$FRONTEND_DIR = "$PSScriptRoot\frontend"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Tilawati Dev Launcher" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# ----------------------------------------------------------
# 1. Cek ADB tersedia
# ----------------------------------------------------------
if (-not (Test-Path $ADB)) {
    Write-Host "[ERROR] adb.exe tidak ditemukan di: $ADB" -ForegroundColor Red
    exit 1
}

# ----------------------------------------------------------
# 2. Tunggu device Android terhubung
# ----------------------------------------------------------
Write-Host "[1/3] Menunggu Android device..." -ForegroundColor Yellow
$timeout = 30
$elapsed = 0
do {
    $devices = & $ADB devices | Select-String -Pattern "device$"
    if ($devices) { break }
    Start-Sleep -Seconds 2
    $elapsed += 2
    if ($elapsed -ge $timeout) {
        Write-Host "      Tidak ada device terdeteksi. Lanjut tanpa adb reverse..." -ForegroundColor DarkYellow
        break
    }
} while ($true)

# ----------------------------------------------------------
# 3. Jalankan adb reverse
# ----------------------------------------------------------
if ($devices) {
    Write-Host "[2/3] Menjalankan adb reverse tcp:8000 tcp:8000..." -ForegroundColor Yellow
    & $ADB reverse tcp:8000 tcp:8000 | Out-Null
    Write-Host "      OK - localhost:8000 di device → PC port 8000" -ForegroundColor Green
} else {
    Write-Host "[2/3] Lewati adb reverse (tidak ada device)" -ForegroundColor DarkYellow
}

# ----------------------------------------------------------
# 4. Jalankan Backend Docker di terminal baru
# ----------------------------------------------------------
Write-Host "[3/3] Memulai backend Docker..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", `
    "Set-Location '$BACKEND_DIR'; Write-Host 'Backend Docker' -ForegroundColor Cyan; docker compose up"

Start-Sleep -Seconds 3

# ----------------------------------------------------------
# 5. Jalankan Flutter di terminal saat ini
# ----------------------------------------------------------
Write-Host ""
Write-Host "Memulai Flutter app..." -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Set-Location $FRONTEND_DIR
flutter run
