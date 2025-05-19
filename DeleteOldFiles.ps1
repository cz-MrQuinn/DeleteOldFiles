# Skript pro mazání starých souborů na základě konfigurace v JSON formátu
$configPath = "C:\scripts\DeleteOldFiles\DeleteOldFiles_config.json"

# Zkontroluj, zda je PowerShell spuštěn s administrátorskými právy
if (-not (Test-Path $configPath)) {
    Write-Error "Konfigurační soubor nebyl nalezen: $configPath"
    exit 1
}

# Načti konfiguraci z JSON
$configs = Get-Content -Path $configPath | ConvertFrom-Json

# Zkontroluj, zda je JSON validní
foreach ($entry in $configs) {
    if (-not $entry.older_than_days -or -not $entry.filetype -or -not $entry.path) {
        Write-Warning "Některé položky v konfiguraci chybí. Přeskakuji."
        continue
    }

    # Zkontroluj, zda jsou hodnoty platné
    $days = [int]$entry.older_than_days
    $filetype = $entry.filetype.Trim()
    $path = $entry.path.Trim()

    # Zkontroluj, zda je cesta platná
    if (-not (Test-Path $path)) {
        Write-Warning "Adresář '$path' neexistuje. Přeskakuji."
        continue
    }

    # Zkontroluj, zda je souborový typ platný
    $filter = if ($filetype -eq "*") { "*.*" } else { "*.$filetype" }
    $files = Get-ChildItem -Path $path -Filter $filter -File -Recurse -ErrorAction SilentlyContinue
    $threshold = (Get-Date).AddDays(-$days)

    # Zkontroluj, zda jsou soubory k dispozici
    foreach ($file in $files) {
        if ($file.LastWriteTime -lt $threshold) {
            try {
                Remove-Item -Path $file.FullName -Force -Verbose
            } catch {
                Write-Error "Chyba při mazání '$($file.FullName)': $($_.Exception.Message)"
            }
        }
    }
}
