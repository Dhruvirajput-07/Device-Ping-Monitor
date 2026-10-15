<#
=====================================================================
 Device Monitor Script
 - CSV headers: sr.no, device name, ip address, email address
 - Pings every device every 10 seconds
 - Ignores first 4 losses, alerts on 5th consecutive loss
 - Sends DOWN email, then UP email when it recovers
 - Only sends on state transitions (no duplicate alerts)
 - All times shown in IST (time only, no date)
=====================================================================
#>

# ----------------------- CONFIGURATION -----------------------
$CsvPath            = "C:\Users\skillsync\Desktop\devicess.csv"
$SenderEmail        = "YOUR_SENDERMAIL@GMAIL.COM"
$SenderAppPassword  = "YOUR_GMAIL_APP_PASSWORD"       # Gmail App Password
$SmtpServer         = "smtp.gmail.com"
$SmtpPort           = 587
$PingIntervalSec    = 10
$FailureThreshold   = 5
$LogFile            = "C:\Users\skillsync\Desktop\DeviceMonitor.log"

# ----------------------- SETUP -----------------------
$ErrorActionPreference = "Stop"

function Write-Log {
    param([string]$Message)
    $ts = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    "$ts  $Message" | Out-File -FilePath $LogFile -Append -Encoding UTF8
}

# --- Time formatter: returns "hh:mm:ss AM/PM" in IST ---
function Get-IST-TimeOnly {
    param([datetime]$UtcTime = (Get-Date).ToUniversalTime())
    if ($null -eq $UtcTime) { $UtcTime = (Get-Date).ToUniversalTime() }
    try   { $istZone = [System.TimeZoneInfo]::FindSystemTimeZoneById("India Standard Time") }
    catch { $istZone = [System.TimeZoneInfo]::FindSystemTimeZoneById("Asia/Kolkata") }
    $ist = [System.TimeZoneInfo]::ConvertTimeFromUtc($UtcTime, $istZone)
    return [string]$ist.ToString("hh:mm:ss tt")
}

function Send-AlertEmail {
    param([string]$To, [string]$Subject, [string]$Body)
    try {
        $securePass = ConvertTo-SecureString $SenderAppPassword -AsPlainText -Force
        $cred = New-Object System.Management.Automation.PSCredential ($SenderEmail, $securePass)
        Send-MailMessage -From $SenderEmail -To $To -Subject $Subject -Body $Body `
                         -SmtpServer $SmtpServer -Port $SmtpPort -UseSsl `
                         -Credential $cred -Encoding UTF8
        Write-Log "EMAIL SENT -> $To | $Subject"
    } catch {
        Write-Log "EMAIL FAILED -> $To | $Subject | Error: $($_.Exception.Message)"
    }
}

# ----------------------- LOAD CSV -----------------------
if (-not (Test-Path $CsvPath)) {
    Write-Host "CSV not found: $CsvPath" -ForegroundColor Red
    exit 1
}

$rows = Import-Csv -Path $CsvPath

# --- Validate headers ---
$required = @("device name", "ip address", "email address")
$have     = $rows[0].PSObject.Properties.Name
$missing  = $required | Where-Object { $have -notcontains $_ }
if ($missing) {
    Write-Host "CSV is missing column(s): $($missing -join ', ')" -ForegroundColor Red
    Write-Host "Found columns: $($have -join ' | ')" -ForegroundColor Yellow
    Write-Host "Expected: sr.no, device name, ip address, email address" -ForegroundColor Yellow
    exit 1
}

# --- Build device list ---
$devices = @()
foreach ($r in $rows) {
    $name  = ("$($r.'device name')").Trim()
    $ip    = ("$($r.'ip address')").Trim()
    $email = ("$($r.'email address')").Trim()

    if ([string]::IsNullOrWhiteSpace($ip) -or [string]::IsNullOrWhiteSpace($email)) {
        Write-Host "Skipping '$name' - missing IP or email" -ForegroundColor Yellow
        continue
    }

    $devices += [PSCustomObject]@{
        DeviceName = $name
        IPAddress  = $ip
        Email      = $email
    }
}

if ($devices.Count -eq 0) {
    Write-Host "No valid devices found in CSV." -ForegroundColor Red
    exit 1
}

# ----------------------- STATE -----------------------
$state = @{}
foreach ($d in $devices) {
    $key = "$($d.DeviceName)|$($d.IPAddress)"
    $state[$key] = [PSCustomObject]@{
        DeviceName   = $d.DeviceName
        IPAddress    = $d.IPAddress
        Email        = $d.Email
        ConsecFail   = 0
        IsDown       = $false
        DownSinceUTC = $null
    }
}

Write-Host "Monitoring $($devices.Count) device(s). Log: $LogFile" -ForegroundColor Green
Write-Log "===== Device Monitor started. Monitoring $($devices.Count) device(s). ====="

# ----------------------- MAIN LOOP -----------------------
while ($true) {

    foreach ($key in $state.Keys) {

        $dev  = $state[$key]
        $ping = $false
        try {
            $ping = Test-Connection -ComputerName $dev.IPAddress -Count 1 -Quiet -ErrorAction SilentlyContinue
        } catch {
            $ping = $false
        }

        if ($ping) {
            # ================== DEVICE UP ==================
            if ($dev.IsDown) {
                $nowUtc    = (Get-Date).ToUniversalTime()
                $downSince = $dev.DownSinceUTC
                $downtime  = $nowUtc - $downSince

                # Downtime without days
                $durText = "{0} hrs {1} mins {2} secs" -f `
                           $downtime.Hours, $downtime.Minutes, $downtime.Seconds

                # Time only (no date) in IST
                $downSinceIST = Get-IST-TimeOnly $downSince
                $backUpIST    = Get-IST-TimeOnly $nowUtc

                $body = @"
Hello Team!

The following device has successfully re-established its connection:

Device Name: $($dev.DeviceName)
Device IP: $($dev.IPAddress)
Total Downtime: $durText
Down Since: $downSinceIST
Back UP At: $backUpIST
"@

                Send-AlertEmail -To $dev.Email `
                    -Subject "Device UP – $($dev.DeviceName) – $($dev.IPAddress)" `
                    -Body $body

                Write-Log "UP: $($dev.DeviceName) [$($dev.IPAddress)] recovered. Downtime: $durText"

                $dev.IsDown       = $false
                $dev.DownSinceUTC = $null
            }
            $dev.ConsecFail = 0
        }
        else {
            # ================== DEVICE DOWN ==================
            $dev.ConsecFail++

            if (-not $dev.IsDown -and $dev.ConsecFail -ge $FailureThreshold) {
                $dev.IsDown       = $true
                $dev.DownSinceUTC = (Get-Date).ToUniversalTime()

                # Time only (no date) in IST
                $downTimeIST = Get-IST-TimeOnly $dev.DownSinceUTC

                $body = @"
Hello Team!

The following device has lost its connection:

Device Name: $($dev.DeviceName)
Device IP: $($dev.IPAddress)
Down Time: $downTimeIST
"@

                Send-AlertEmail -To $dev.Email `
                    -Subject "Device Down – $($dev.DeviceName) – $($dev.IPAddress)" `
                    -Body $body

                Write-Log "DOWN: $($dev.DeviceName) [$($dev.IPAddress)] after $FailureThreshold consecutive failures."
            }
        }
    }

    Start-Sleep -Seconds $PingIntervalSec
}