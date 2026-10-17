<#
.SYNOPSIS
    Install the commit-msg skill for Claude Code / Qoder / DeepSeek Harness.

.DESCRIPTION
    Copies SKILL.md from the repo into the target skill directory.

.PARAMETER Force
    Overwrite the target SKILL.md if it already exists. Short form: -f.

.PARAMETER Target
    Which tool to install for: "claude" (default), "qoder", or "dsh"
    (DeepSeek Harness). Short form: -t.

.PARAMETER Help
    Show usage information and exit. Short form: -h.

.EXAMPLE
    .\install.ps1
    Install to ~/.claude/skills/commit-msg/

.EXAMPLE
    .\install.ps1 -Force -Target qoder
    Force install to ~/.qoder/skills/commit-msg/

.EXAMPLE
    .\install.ps1 -Target dsh
    Install to $DSH_HOME/skills/commit-msg/ (defaults to ~/.dsh/skills/commit-msg/)

.EXAMPLE
    .\install.ps1 -h
    Show usage information.
#>

[CmdletBinding()]
param(
    [Alias('f')]
    [switch]$Force,
    [Alias('t')]
    [ValidateSet('claude', 'qoder', 'dsh')]
    [string]$Target = 'claude',
    [Alias('h')]
    [switch]$Help
)

$ErrorActionPreference = 'Stop'

$SKILL_NAME = 'commit-msg'
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path

function Show-Usage {
    @"
Usage: .\install.ps1 [-f|-Force] [-t|-Target <claude|qoder|dsh>] [-h|-Help]

Install the $SKILL_NAME skill into a tool's skills directory.

Options:
  -f, -Force           Overwrite the target SKILL.md if it already exists
  -t, -Target <tool>   Which tool to install for: claude (default), qoder, or dsh
  -h, -Help            Show this help message and exit

Examples:
  .\install.ps1                        Install to ~/.claude/skills/$SKILL_NAME/
  .\install.ps1 -t dsh                 Install to `$DSH_HOME/skills/$SKILL_NAME/
  .\install.ps1 -f -t qoder            Force install to ~/.qoder/skills/$SKILL_NAME/
"@
}

if ($Help) {
    Show-Usage
    exit 0
}

# DeepSeek Harness scans <dshHome>/skills, where dshHome is $DSH_HOME or ~/.dsh
$DSH_HOME = if ($env:DSH_HOME) { $env:DSH_HOME } else { Join-Path $HOME '.dsh' }

$TARGET_DIR = switch ($Target) {
    'claude' { Join-Path $HOME ".claude\skills\$SKILL_NAME" }
    'qoder'  { Join-Path $HOME ".qoder\skills\$SKILL_NAME" }
    'dsh'    { Join-Path $DSH_HOME "skills\$SKILL_NAME" }
}

$TARGET_FILE = Join-Path $TARGET_DIR 'SKILL.md'
$SOURCE_FILE = Join-Path $SCRIPT_DIR 'SKILL.md'

# Guard: refuse to overwrite unless -Force
if ((Test-Path $TARGET_FILE) -and -not $Force) {
    Write-Error "$TARGET_FILE already exists. Use -Force to overwrite."
    exit 1
}

# Ensure target directory exists
New-Item -ItemType Directory -Force -Path $TARGET_DIR | Out-Null

Copy-Item -Path $SOURCE_FILE -Destination $TARGET_FILE -Force

Write-Host "Installed $SKILL_NAME ($Target) -> $TARGET_FILE"
