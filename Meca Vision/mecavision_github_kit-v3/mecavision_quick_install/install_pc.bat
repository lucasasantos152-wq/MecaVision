@echo off
echo ========================================================
echo   MecaVision - Instalador Rapido de Dependencias PC
echo ========================================================
echo.

python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERRO] Python nao encontrado no sistema!
    echo Instale o Python 3.7-3.9 em https://www.python.org/downloads/
    echo Certifique-se de marcar a opcao "Add Python to PATH" na instalacao.
    pause
    exit /b 1
)

echo [1/3] Criando ambiente virtual (venv)...
python -m venv venv
call venv\Scripts\activate

echo [2/3] Atualizando o pip...
python -m pip install --upgrade pip

echo [3/3] Instalando bibliotecas necessarias (OpenCV, PySerial, RubikTwoPhase)...
pip install -r requirements.txt

echo.
echo ========================================================
echo   Instalacao concluida com sucesso!
echo   Para iniciar o MecaVision, execute:
echo   venv\Scripts\activate ^&^& python Cubotino_GUI.py
echo ========================================================
pause
