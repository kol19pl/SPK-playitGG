#!/bin/bash
set -e

# Katalog roboczy dla budowy pakietu (tymczasowy)
workDir=$(pwd)/_build
rm -rf "$workDir"
mkdir -p "$workDir"

# Check if SPK_AP_TEMPLATE exists
if [ ! -d "SPK_AP_TEMPLATE" ]; then
    echo "ℹ SPK_AP_TEMPLATE folder not found. Please create it with the required INFO file."
    exit 1
fi

# Read package name from INFO file
packageName=$(grep '^package=' "SPK_AP_TEMPLATE/INFO" | cut -d'=' -f2 | sed 's/"//g' | tr -d ' ')

# Copy necessary files
echo "ℹ Skrypty startowe skopiowane"
cp -R SPK_AP_TEMPLATE/{INFO,service-cfg,scripts,WIZARD_UIFILES,conf} "$workDir/" || { echo "⚠ Error copying necessary files."; exit 1; }

# Copy icons if they exist
for icon in SPK_AP_TEMPLATE/PACKAGE_ICON*.PNG; do
    if [ -f "$icon" ]; then
        cp "$icon" "$workDir/" || { echo "⚠ Error copying icon: $icon."; exit 1; }
    fi
done

# Copy install.sh to the package structure
if [ -f "SPK_AP_TEMPLATE/install.sh" ]; then
    cp "SPK_AP_TEMPLATE/install.sh" "$workDir/" || { echo "⚠ Error copying install.sh."; exit 1; }
    echo "ℹ Plik install.sh skopiowany do struktury pakietu."
    # Set executable permission for install.sh
    chmod +x "$workDir/install.sh"
    echo "ℹ Ustawiono uprawnienia do wykonywania dla install.sh."
else
    echo "⚠ Plik install.sh nie znaleziony! Upewnij się, że plik jest obecny w katalogu SPK_AP_TEMPLATE."
fi

# Create package structure
mkdir -p "$workDir/package"
cp -r SPK_AP_TEMPLATE/pakiet/. "$workDir/package" || { echo "⚠ Error copying package content."; exit 1; }





# Create package.tgz
echo "📦 Tworzenie archiwum package.tgz..."
echo "Zawartość $workDir/package przed pakowaniem:"
ls -la "$workDir/package"
cd "$workDir/package"
tar -czf "$workDir/package.tgz" *
cd .. || { echo "⚠ Error navigating back to the work directory."; exit 1; }
cd ..
# Create final .spk package
outputFile=$(pwd)/${packageName}.spk
echo "📦 Tworzenie pakietu .spk: $outputFile"

cd "$workDir"
tar -cf "$outputFile" INFO service-cfg package.tgz scripts/ WIZARD_UIFILES/ conf/   $(ls PACKAGE_ICON*.PNG 2>/dev/null)

echo "✅ Pakiet utworzony: $outputFile"

# Clean up
#rm -rf "$workDir"
echo "🧹 Usunięto katalog roboczy: $workDir"
