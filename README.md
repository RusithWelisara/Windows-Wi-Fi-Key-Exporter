# Wi‑Fi profile export (Windows)

Small Windows helpers that use **`netsh wlan`** to list saved Wi‑Fi profiles and optionally export each profile’s **Key Content** (the stored password) to a text file.

## Requirements

- Windows with Wi‑Fi and saved wireless profiles  
- **PowerShell** (included with Windows) for the key export  
- **Run as Administrator** when exporting keys if **Key Content** lines are missing or show the fallback message (Windows often restricts `key=clear` without elevation)

## Repository layout

| File | Purpose |
|------|--------|
| `save-wlan-profiles.bat` | Runs `netsh wlan show profile` and saves the full listing to **`wlan_profiles.txt`**. |
| `export-wlan-keys.bat` | Launches the PowerShell script with `-ExecutionPolicy Bypass`. |
| `export-wlan-keys.ps1` | Enumerates profiles, runs `netsh wlan show profile name="…" key=clear` for each, parses **Key Content**, writes **`wlan_keys.txt`**. |
| `wlan_keys.sample.txt` | Example of the export format (fake data only; safe to commit). |

Output files are created **next to the scripts** (same folder). The real **`wlan_keys.txt`** is gitignored; **`wlan_keys.sample.txt`** shows the same layout with fictional values.

## How to run

### List profiles only (no passwords)

Double‑click **`save-wlan-profiles.bat`**, or from a command prompt:

```bat
save-wlan-profiles.bat
```

Output: **`wlan_profiles.txt`**.

### Export profile names and Key Content

1. Right‑click **`export-wlan-keys.bat`** → **Run as administrator** (recommended).  
2. Or open **PowerShell (Admin)** and run:

```powershell
Set-Location "path\to\this\repo"
.\export-wlan-keys.ps1
```

Output: **`wlan_keys.txt`**.

### Sample output

See **`wlan_keys.sample.txt`** for the same layout with **fictional** SSIDs and keys (nothing real; intended for README / GitHub browsing).

## Security and privacy

- **`wlan_keys.txt` contains plaintext Wi‑Fi passwords.** Treat it like a secret: do not commit it, do not share it casually, and delete it when you are done.  
- Use these tools **only on PCs you own or are authorized to administer**.  
- This repo includes **`.gitignore`** entries for **`wlan_profiles.txt`** and **`wlan_keys.txt`** so those exports are not committed by mistake.

## Troubleshooting

- **Key Content is always “none” or empty** — Run the key export from an **elevated** (Administrator) session.  
- **Script execution is blocked** — Use **`export-wlan-keys.bat`**, which passes `-ExecutionPolicy Bypass`, or set execution policy for your user scope as appropriate for your organization’s policy.

## License

[MIT](LICENSE)
