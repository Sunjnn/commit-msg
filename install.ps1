<#
.SYNOPSIS
    Install the commit-msg skill for Claude Code / Qoder.

.DESCRIPTION
    Copies SKILL.md from the repo into the target skill directory.

.PARAMETER Force
    Overwrite the target SKILL.md if it already exists.

.PARAMETER Target
    Which tool to install for: "claude" (default) or "qoder".

.EXAMPLE
    .\install.ps1
    Install to ~/.claude/skills/commit-msg/

.EXAMPLE
    .\install.ps1 -Force -Target qoder
    Force install to ~/.qoder/skills/commit-msg/
#>

[CmdletBinding()]
param(
    [switch]$Force,
    [ValidateSet('claude', 'qoder')]
    [string]$Target = 'claude'
)

$ErrorActionPreference = 'Stop'

$SKILL_NAME = 'commit-msg'
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path

$TARGET_DIR = switch ($Target) {
    'claude' { Join-Path $HOME ".claude\skills\$SKILL_NAME" }
    'qoder'  { Join-Path $HOME ".qoder\skills\$SKILL_NAME" }
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
