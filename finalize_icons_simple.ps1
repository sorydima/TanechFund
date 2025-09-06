# Finalize Custom Icons for REChain VC Lab
Write-Host "Finalizing Custom Icons for REChain VC Lab" -ForegroundColor Green
Write-Host "=" * 50

# Check if all required files exist
$requiredFiles = @(
    "assets/icons/rechain_vc_lab_icon.svg",
    "icon_converter.html",
    "CUSTOM_ICONS_README.md"
)

$missingFiles = @()
foreach ($file in $requiredFiles) {
    if (-not (Test-Path $file)) {
        $missingFiles += $file
    }
}

if ($missingFiles.Count -gt 0) {
    Write-Host "Missing required files:" -ForegroundColor Red
    foreach ($file in $missingFiles) {
        Write-Host "   - $file" -ForegroundColor Red
    }
    exit 1
}

Write-Host "All required files present" -ForegroundColor Green

# Clean up temporary files
Write-Host "Cleaning up temporary files..." -ForegroundColor Blue
$tempFiles = @(
    "generate_icons.py",
    "generate_icons.ps1",
    "create_icon_structure.ps1"
)

foreach ($file in $tempFiles) {
    if (Test-Path $file) {
        Remove-Item $file -Force
        Write-Host "   Removed: $file" -ForegroundColor Gray
    }
}

# Create final summary
Write-Host "Custom Icons Setup Complete!" -ForegroundColor Green
Write-Host "=" * 50
Write-Host "Master SVG icon created: assets/icons/rechain_vc_lab_icon.svg" -ForegroundColor Green
Write-Host "Online converter created: icon_converter.html" -ForegroundColor Green
Write-Host "Documentation created: CUSTOM_ICONS_README.md" -ForegroundColor Green
Write-Host "Icon structure prepared for all platforms" -ForegroundColor Green
Write-Host "Configuration files updated" -ForegroundColor Green

Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Open icon_converter.html in your browser" -ForegroundColor White
Write-Host "2. Download all icon sizes" -ForegroundColor White
Write-Host "3. Replace placeholder files with downloaded PNG files" -ForegroundColor White
Write-Host "4. Run 'flutter clean' and rebuild your app" -ForegroundColor White
Write-Host "5. Test icons on all target platforms" -ForegroundColor White

Write-Host "For detailed instructions, see: CUSTOM_ICONS_README.md" -ForegroundColor Cyan
Write-Host "For icon generation, open: icon_converter.html" -ForegroundColor Cyan

Write-Host "Custom icons setup completed successfully!" -ForegroundColor Green
