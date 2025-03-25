#!/bin/bash

# Definicje plików logów
INSTALL_LOG="/volume1/1/playitGG/LOG/package_install.log"
LOG_FILE="/volume1/1/playitGG/LOG/playit.log"

# Zapisujemy rozpoczęcie instalacji
echo "Rozpoczynam instalację..." | tee -a "$INSTALL_LOG" "$LOG_FILE"

# Tworzenie katalogów docelowych, jeśli nie istnieją
echo "Tworzenie katalogów docelowych..." | tee -a "$INSTALL_LOG" "$LOG_FILE"
mkdir -p /var/packages/playitGG/target/bin
mkdir -p /var/packages/playitGG/target/config

# Kopiowanie plików binarnych do katalogu docelowego
echo "Kopiowanie plików binarnych do /var/packages/playitGG/target/bin/..." | tee -a "$INSTALL_LOG" "$LOG_FILE"
cp /tmp/packagedir/bin/* /var/packages/playitGG/target/bin/

# Kopiowanie plików konfiguracyjnych
echo "Kopiowanie plików konfiguracyjnych do /var/packages/playitGG/target/config/..." | tee -a "$INSTALL_LOG" "$LOG_FILE"
cp /tmp/packagedir/config/* /var/packages/playitGG/target/config/

# Ustawianie odpowiednich uprawnień do plików
echo "Ustawianie uprawnień do plików..." | tee -a "$INSTALL_LOG" "$LOG_FILE"
chown -R root:root /var/packages/playitGG/target/
chmod -R 755 /var/packages/playitGG/target/bin
chmod -R 644 /var/packages/playitGG/target/config

# Uruchomienie usługi po instalacji
echo "Uruchamiam usługę..." | tee -a "$INSTALL_LOG" "$LOG_FILE"
# Uruchamiamy binarkę w tle
/var/packages/playitGG/target/bin/playit-linux &

# Opcjonalnie: poczekaj kilka sekund, aby proces mógł się uruchomić
sleep 2

# Sprawdzenie, czy proces się uruchomił
if pgrep -f "playit-linux" > /dev/null; then
    echo "Usługa uruchomiona pomyślnie." | tee -a "$INSTALL_LOG" "$LOG_FILE"
else
    echo "Błąd uruchamiania usługi." | tee -a "$INSTALL_LOG" "$LOG_FILE"
fi

echo "Instalacja zakończona." | tee -a "$INSTALL_LOG" "$LOG_FILE"

