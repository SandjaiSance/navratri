# Script om bestanden van de afgelopen week te kopiëren
# Gebruik: .\copy_recent_files.ps1

param(
    [Parameter(Mandatory=$false)]
    [int]$Days = 7
)

# Definieer de mappenparen
$CopyPairs = @(
    @{
        Source = "D:\GIT\delphi_oracle\delphidba\Unittest_package_bodies"
        Destination = "D:\GithubCopilotWS\Package_bodies"
    },
    @{
        Source = "D:\GIT\delphi_oracle\delphidba\Unittest_packages"
        Destination = "D:\GithubCopilotWS\Packages"
    }
)

# Bereken de datum vanaf wanneer we zoeken
$DateFrom = (Get-Date).AddDays(-$Days)

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Kopiëren bestanden van de afgelopen $Days dagen" -ForegroundColor Cyan
Write-Host "Sinds: $($DateFrom.ToString('dd-MM-yyyy HH:mm:ss'))" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Totaal tellers
$TotalFiles = 0
$TotalCopied = 0

# Loop door elk mappenpaar
foreach ($Pair in $CopyPairs) {
    $SourcePath = $Pair.Source
    $DestinationPath = $Pair.Destination
    
    Write-Host "Bronmap: $SourcePath" -ForegroundColor Yellow
    Write-Host "Doelmap: $DestinationPath`n" -ForegroundColor Yellow
    
    # Controleer of bronmap bestaat
    if (-not (Test-Path $SourcePath)) {
        Write-Host "[WAARSCHUWING] Bronmap bestaat niet: $SourcePath`n" -ForegroundColor Red
        continue
    }
    
    # Maak doelmap aan als deze niet bestaat
    if (-not (Test-Path $DestinationPath)) {
        New-Item -ItemType Directory -Path $DestinationPath -Force | Out-Null
        Write-Host "Doelmap aangemaakt: $DestinationPath" -ForegroundColor Green
    }
    
    # Zoek alle bestanden die in de afgelopen week zijn gewijzigd
    $RecentFiles = Get-ChildItem -Path $SourcePath -File -Recurse | 
        Where-Object { $_.LastWriteTime -ge $DateFrom }
    
    if ($RecentFiles.Count -eq 0) {
        Write-Host "Geen recente bestanden gevonden.`n" -ForegroundColor Gray
        continue
    }
    
    Write-Host "Gevonden: $($RecentFiles.Count) bestand(en)" -ForegroundColor Green
    $TotalFiles += $RecentFiles.Count
    
    # Teller voor gekopieerde bestanden
    $CopiedCount = 0
    
    # Kopieer elk bestand met behoud van mapstructuur
    foreach ($File in $RecentFiles) {
        # Bereken het relatieve pad ten opzichte van de bronmap
        $RelativePath = $File.FullName.Substring($SourcePath.Length).TrimStart('\')
        $DestFile = Join-Path $DestinationPath $RelativePath
        
        # Maak subdirectories aan indien nodig
        $DestDir = Split-Path $DestFile -Parent
        if (-not (Test-Path $DestDir)) {
            New-Item -ItemType Directory -Path $DestDir -Force | Out-Null
        }
        
        # Kopieer het bestand
        try {
            Copy-Item -Path $File.FullName -Destination $DestFile -Force
            Write-Host "[OK] $RelativePath" -ForegroundColor Green
            Write-Host "     Gewijzigd: $($File.LastWriteTime.ToString('dd-MM-yyyy HH:mm:ss'))" -ForegroundColor Gray
            $CopiedCount++
            $TotalCopied++
        }
        catch {
            Write-Host "[FOUT] $RelativePath - $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    
    Write-Host "Gekopieerd: $CopiedCount van de $($RecentFiles.Count) bestanden`n" -ForegroundColor Green
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "TOTAAL: $TotalCopied van de $TotalFiles bestanden gekopieerd." -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan
