<#
.SYNOPSIS
    Install the commit-msg skill for Claude Code / Qoder / DeepSeek Harness.

.DESCRIPTION
    Copies SKILL.md from the repo into the target skill directory.

.PARAMETER Force
    Overwrite the target SKILL.md if it already exists.

.PARAMETER Target
    Which tool to install for: "claude" (default), "qoder", or "dsh"
    (DeepSeek Harness).

.EXAMPLE
    .\install.ps1
    Install to ~/.claude/skills/commit-msg/

.EXAMPLE
    .\install.ps1 -Force -Target qoder
    Force install to ~/.qoder/skills/commit-msg/

.EXAMPLE
    .\install.ps1 -Target dsh
    Install to $DSH_HOME/skills/commit-msg/ (defaults to ~/.dsh/skills/commit-msg/)
#>

[CmdletBinding()]
param(
    [switch]$Force,
    [ValidateSet('claude', 'qoder', 'dsh')]
    [string]$Target = 'claude'
)

$ErrorActionPreference = 'Stop'

$SKILL_NAME = 'commit-msg'
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path

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
