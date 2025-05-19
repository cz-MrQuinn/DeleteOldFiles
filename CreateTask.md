PowerShell skript, který vytvoří naplánovanou úlohu ve Windows Task Scheduleru pro pravidelné spouštění vašeho skriptu `DeleteOldFiles.ps1`:

---

### ✅ **Skript: `Create-DeleteOldFilesTask.ps1`**

Tento skript vytvoří úlohu, která se spustí **každý týden v pondělí v 9:55**.

```powershell
# Nastavení proměnných
$scriptPath = "C:\scripts\DeleteOldFiles\DeleteOldFiles.ps1"
$taskName = "DeleteOldFiles_Task"
$description = "Smaže staré soubory podle konfiguračního souboru."
$triggerTime = "09:55"

# Smazání staré úlohy, pokud existuje
if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
    Write-Host "Předchozí úloha '$taskName' byla odstraněna."
}

# Trigger – každý týden v pondělí v 9:55 (např. první pondělí v měsíci)
$trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday -WeeksInterval 1 -At $triggerTime

# Akce – spuštění PowerShell skriptu
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$scriptPath`""

# ✅ Vytvoření úlohy bez explicitního principal – použije aktuálního uživatele
Register-ScheduledTask -TaskName $taskName -Trigger $trigger -Action $action -Description $description -Force

Write-Host "Naplánovaná úloha '$taskName' byla vytvořena."

```

---

### ✅ **Jak spustit skript pro vytvoření úlohy**

1. Uložte skript např. jako `Create-DeleteOldFilesTask.ps1`.
2. Spusťte PowerShell jako **správce**.
3. Spusťte skript:

   ```powershell
   powershell.exe -ExecutionPolicy Bypass -File "C:\scripts\DeleteOldFiles\Create-DeleteOldFilesTask.ps1"
   ```

---

