#!/bin/bash
set -e

# Ścieżka do katalogu BIN z plikami do przetworzenia
BIN_DIR="BIN"

# Ścieżka do katalogu, w którym będą przechowywane pliki binarne w pakiecie
TARGET_DIR="SPK_AP_TEMPLATE/pakiet/bin"

# Sprawdzanie, czy katalog BIN istnieje
if [ ! -d "$BIN_DIR" ]; then
    echo "ℹ Katalog BIN nie istnieje. Upewnij się, że pliki są dostępne w $BIN_DIR."
    exit 1
fi

# Iterowanie po plikach w katalogu BIN
for file in "$BIN_DIR"/*; do
    echo "ℹ Sprawdzam plik: $file"  # Debugowanie
    # Sprawdzenie, czy plik jest rzeczywiście plikiem (pomijamy katalogi)
    if [ -f "$file" ]; then
        # Wydobycie nazwy architektury z nazwy pliku
        arch=$(basename "$file" | sed 's/.*-\(.*\)/\1/')
        
        # Kopiowanie pliku binarnego i zmiana nazwy
        echo "ℹ Przetwarzam plik: $file"
        cp "$file" "$TARGET_DIR/playit-linux"
        echo "ℹ Plik playit-linux skopiowany do $TARGET_DIR/playit-linux"

        # Uruchamianie procesu budowy pakietu SPK
        echo "ℹ Uruchamiam skrypt build_spk.sh..."
        bash ./build_spk.sh
        
        # Sprawdzanie, czy build_spk.sh zakończył działanie pomyślnie
        if [ $? -eq 0 ]; then
            echo "ℹ Skrypt build_spk.sh zakończył się pomyślnie."
        else
            echo "⚠ Skrypt build_spk.sh zakończył się z błędem."
            exit 1
        fi
        
        # Zmiana nazwy pliku .spk na odpowiednią końcówkę
        spk_file=$(ls playitGG.spk)  # Zmieniamy na konkretną nazwę pliku .spk, jeśli jest znana
        echo "ℹ Znalazłem plik .spk: $spk_file"  # Debugowanie
        
        if [ -f "$spk_file" ]; then
            new_spk_name="playitGG-${arch}.spk"
            mv "$spk_file" "$new_spk_name"
            echo "ℹ Zmieniono nazwę pakietu na: $new_spk_name"
        else
            echo "⚠ Nie znaleziono pliku .spk. Sprawdź, czy skrypt build_spk.sh działa poprawnie."
        fi
    else
        echo "ℹ Pomiń plik, ponieważ nie jest plikiem: $file"  # Debugowanie
    fi
done

echo "✅ Wszystkie pliki zostały przetworzone."




