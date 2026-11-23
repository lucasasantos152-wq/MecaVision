@echo off
chcp 65001 >nul
color 0A
title MecaVision - Download e Instalacao Automatica de Todos os Apps e Dependencias

echo ============================================================================
echo   MECAVISION - INSTALADOR UNICO AUTOMATICO (APPS + CODIGO + ESP32)
echo ============================================================================
echo   Este script vai baixar e instalar automaticamente:
echo   [1] Python 3.9 (64-bit)
echo   [2] Thonny IDE (para programar e transferir arquivos para a ESP32)
echo   [3] Drivers USB-Serial (CP210x e CH340) para reconhecimento da ESP32
echo   [4] Codigo-fonte completo do projeto e dependencias Python (OpenCV, etc.)
echo   [5] Firmware oficial MicroPython (.bin) + gravacao na memoria da ESP32
echo ============================================================================
echo.
pause

:: Criar pasta de trabalho para downloads temporarios
if not exist "downloads_mecavision" mkdir downloads_mecavision

:: ----------------------------------------------------------------------------
:: PASSO 1: BAIXAR E INSTALAR PYTHON 3.9
:: ----------------------------------------------------------------------------
echo.
echo [1/6] Verificando / Baixando Python 3.9...
py -3.9 --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Tentando instalar Python 3.9 via Winget...
    winget install --id Python.Python.3.9 -e --source winget --accept-package-agreements --accept-source-agreements
    if %errorlevel% neq 0 (
        echo Baixando instalador oficial do Python 3.9.13 diretamente do python.org...
        powershell -Command "Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.9.13/python-3.9.13-amd64.exe' -OutFile 'downloads_mecavision\python-3.9.13-amd64.exe'"
        echo Instalando Python 3.9 silenciosamente (aguarde)...
        start /wait "" "downloads_mecavision\python-3.9.13-amd64.exe" /quiet InstallAllUsers=1 PrependPath=1 Include_test=0
    )
) else (
    echo [OK] Python 3.9 ja esta instalado no sistema.
)

:: ----------------------------------------------------------------------------
:: PASSO 2: BAIXAR E INSTALAR THONNY IDE
:: ----------------------------------------------------------------------------
echo.
echo [2/6] Verificando / Baixando Thonny IDE...
if not exist "%LOCALAPPDATA%\Programs\Thonny\thonny.exe" (
    if not exist "C:\Program Files (x86)\Thonny\thonny.exe" (
        echo Tentando instalar Thonny IDE via Winget...
        winget install --id AivarAnnamaa.Thonny -e --source winget --accept-package-agreements --accept-source-agreements
        if %errorlevel% neq 0 (
            echo Baixando instalador oficial do Thonny IDE...
            powershell -Command "Invoke-WebRequest -Uri 'https://github.com/thonny/thonny/releases/download/v4.1.4/thonny-4.1.4.exe' -OutFile 'downloads_mecavision\thonny-4.1.4.exe'"
            echo Instalando Thonny IDE silenciosamente (aguarde)...
            start /wait "" "downloads_mecavision\thonny-4.1.4.exe" /VERYSILENT /NORESTART
        )
    ) else (
        echo [OK] Thonny IDE ja esta instalado.
    )
) else (
    echo [OK] Thonny IDE ja esta instalado.
)

:: ----------------------------------------------------------------------------
:: PASSO 3: BAIXAR DRIVERS USB DA ESP32 (CP210x e CH340)
:: ----------------------------------------------------------------------------
echo.
echo [3/6] Baixando pacotes de drivers USB-Serial (CP210x e CH340) para ESP32...
powershell -Command "Invoke-WebRequest -Uri 'https://www.silabs.com/documents/public/software/CP210x_Universal_Windows_Driver.zip' -OutFile 'downloads_mecavision\Driver_CP210x_Windows.zip'"
powershell -Command "Invoke-WebRequest -Uri 'https://www.wch-ic.com/downloads/file/65.html' -OutFile 'downloads_mecavision\Driver_CH340_Windows.zip'"
echo [OK] Drivers salvos na pasta 'downloads_mecavision' (instale caso a porta COM nao apareca).

:: ----------------------------------------------------------------------------
:: PASSO 4: BAIXAR CODIGO-FONTE BASE DO REPOSITORIO OFICIAL
:: ----------------------------------------------------------------------------
echo.
echo [4/6] Baixando codigo-fonte completo (PC + ESP32)...
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/AndreaFavero71/CUBOTino_base_version/archive/refs/heads/main.zip' -OutFile 'downloads_mecavision\codigo_fonte.zip'"
powershell -Command "Expand-Archive -Path 'downloads_mecavision\codigo_fonte.zip' -DestinationPath 'codigo_mecavision' -Force"
echo [OK] Arquivos extraidos na pasta 'codigo_mecavision'.

:: ----------------------------------------------------------------------------
:: PASSO 5: CRIAR AMBIENTE VIRTUAL PYTHON E INSTALAR BIBLIOTECAS
:: ----------------------------------------------------------------------------
echo.
echo [5/6] Criando ambiente virtual (venv) e instalando bibliotecas Python...
py -3.9 -m venv venv 2>nul
if %errorlevel% neq 0 (
    python -m venv venv
)
call venv\Scripts\activate
python -m pip install --upgrade pip
pip install "opencv-python>=4.5.5.64" "pyserial>=3.5" "numpy>=1.21.6" "RubikTwoPhase>=1.1.1" "Pillow>=9.0.0" "esptool>=4.7.0" "mpremote>=1.22.0"
echo [OK] Todas as bibliotecas Python foram instaladas com sucesso!

:: ----------------------------------------------------------------------------
:: PASSO 6: BAIXAR FIRMWARE MICROPYTHON E GRAVAR NA MEMORIA DA ESP32
:: ----------------------------------------------------------------------------
echo.
echo [6/6] Baixando Firmware MicroPython oficial para ESP32...
powershell -Command "Invoke-WebRequest -Uri 'https://micropython.org/resources/firmware/ESP32_GENERIC-20240602-v1.23.0.bin' -OutFile 'downloads_mecavision\esp32_micropython.bin'"

echo.
echo ============================================================================
echo   GRAVACAO DO FIRMWARE E CODIGO NA MEMORIA DA ESP32
echo ============================================================================
set /p GRAVAR="Conecte a ESP32 no USB agora. Deseja gravar a memoria da ESP32? (S/N): "
if /I "%GRAVAR%"=="S" (
    echo Portas COM detectadas no computador:
    powershell -Command "Get-WmiObject Win32_SerialPort | Select-Object DeviceID, Description | Format-Table -AutoSize"
    set /p PORTA="Digite a porta COM da ESP32 (ex: COM3): "
    echo Apagando memoria flash antiga da ESP32...
    python -m esptool --chip esp32 --port %PORTA% erase_flash
    echo Gravando novo firmware MicroPython na ESP32...
    python -m esptool --chip esp32 --port %PORTA% --baud 460800 write_flash -z 0x1000 downloads_mecavision\esp32_micropython.bin
    echo [OK] Firmware MicroPython gravado com sucesso na ESP32!
)

:: Criar atalho rapido para executar o MecaVision no dia a dia
(
echo @echo off
echo title MecaVision - Execucao
echo call venv\Scripts\activate
echo cd codigo_mecavision\CUBOTino_base_version-main
echo python Cubotino_GUI.py
echo pause
) > iniciar_mecavision.bat

echo.
echo ============================================================================
echo   TUDO PRONTO!
echo   1. Manual completo em Word: MecaVision_Manual_Completo_Editavel.docx
echo   2. Para abrir o Thonny IDE: procure "Thonny" no Menu Iniciar
echo   3. Para iniciar o programa MecaVision: execute "iniciar_mecavision.bat"
echo ============================================================================
pause
