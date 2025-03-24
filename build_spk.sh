
#!/bin/bash
set -e

# Check if SPK_AP_TEMPLATE folder exists
if [ -d "SPK_AP_TEMPLATE" ]; then
    # Use INFO file from SPK_AP_TEMPLATE folder
    cp "SPK_AP_TEMPLATE/INFO" "$workDir/"
    cp -R "SPK_AP_TEMPLATE/scripts" "$workDir/"
    cp -R "SPK_AP_TEMPLATE/WIZARD_UIFILES" "$workDir/"
    cp -R "SPK_AP_TEMPLATE/conf" "$workDir/"
  #  cp -R "SPK_AP_TEMPLATE/ui" "$workDir/"
    
else
    echo "ℹ SPK_AP_TEMPLATE folder not found. Please create it with the required INFO file and re-run this script."
    exit 1
fi

# Read package name from INFO file
packageName=$(grep '^package=' "$workDir/INFO" | cut -d'=' -f2 | sed 's/"//g' | tr -d ' ')

# Katalog roboczy dla budowy pakietu (tymczasowy)
workDir=$(pwd)/_build

# Usunięcie starego katalogu roboczego (jeśli istnieje) i stworzenie nowej struktury
rm -rf "$workDir"
mkdir -p "$workDir"

# Copy INFO file to working directory
cp "SPK_AP_TEMPLATE/INFO" "$workDir/"
cp -R "SPK_AP_TEMPLATE/scripts" "$workDir/"
cp -R "SPK_AP_TEMPLATE/WIZARD_UIFILES" "$workDir/"
cp -R "SPK_AP_TEMPLATE/conf" "$workDir/"
#cp -R "SPK_AP_TEMPLATE/ui" "$workDir/"

echo "ℹ Skrypty startowe skopiowane"

if [ -f "SPK_AP_TEMPLATE/PACKAGE_ICON.PNG" ]; then
cp "SPK_AP_TEMPLATE/PACKAGE_ICON.PNG" "$workDir/"
cp "SPK_AP_TEMPLATE/PACKAGE_ICON_256.PNG" "$workDir/"
echo "ℹ Ikonki skopiowane"
else
    echo "ℹ Brak ikon"
fi


# Tworzenie struktury katalogów
mkdir -p "$workDir/package"


# Klonowanie repozytorium do tymczasowego katalogu roboczego
#repoDir="$workDir/pi-hole-repo"
#echo "⬇ Klonowanie repozytorium $packageName..."
#git clone https://github.com/pi-hole/pi-hole.git "$repoDir"

# Kopiowanie tylko wymaganych plików z repozytorium do katalogu target
echo "📂 Kopiowanie plików do package..."
cp -r "SPK_AP_TEMPLATE/pakiet/" "$workDir/package"





# Ustawienie uprawnień wykonywalności dla skryptów
chmod +x "$workDir/scripts/"

# Tworzenie archiwum .tgz z plikami pakietu
echo "📦 Tworzenie archiwum tar.gz (package.tgz)..."
#cp -R "SPK_AP_TEMPLATE/pakiet" "$workDir/package"
tar -czf "$workDir/package.tgz" -C "$workDir/package" .

# Tworzenie finalnego pliku .spk, zawierającego INFO oraz package.tgz
outputFile=$(pwd)/${packageName}.spk
echo "📦 Tworzenie pakietu .spk: $outputFile"
cd "$workDir"

if [ -f ""$workDir"/PACKAGE_ICON.PNG" ]; then

echo "ℹ Ikonki są"
tar -cf "$outputFile" INFO package.tgz scripts/ WIZARD_UIFILES/ conf/  PACKAGE_ICON.PNG PACKAGE_ICON_256.PNG

else
    echo "ℹ Brak ikon"
    tar -cf "$outputFile" INFO package.tgz scripts/  WIZARD_UIFILES/ conf/
fi



echo "✅ Pakiet utworzony: $outputFile"