#!/bin/bash
echo "========================================================"
echo "  MecaVision - Instalador Rapido de Dependencias PC"
echo "========================================================"
echo ""

if ! command -v python3 &> /dev/null
then
    echo "[ERRO] Python 3 nao encontrado!"
    echo "Instale o Python 3.7-3.9 antes de continuar."
    exit 1
fi

echo "[1/3] Criando ambiente virtual (venv)..."
python3 -m venv venv
source venv/bin/activate

echo "[2/3] Atualizando o pip..."
pip install --upgrade pip

echo "[3/3] Instalando bibliotecas necessarias (OpenCV, PySerial, RubikTwoPhase)..."
pip install -r requirements.txt

echo ""
echo "========================================================"
echo "  Instalacao concluida com sucesso!"
echo "  Para iniciar o MecaVision, execute:"
echo "  source venv/bin/activate && python Cubotino_GUI.py"
echo "========================================================"
