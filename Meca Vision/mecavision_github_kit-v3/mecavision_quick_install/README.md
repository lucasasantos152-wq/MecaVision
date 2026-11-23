# MecaVision - Kit de Instalação Rápida & Links Essenciais

Repositório de apoio com os ficheiros de instalação rápida e todos os links oficiais de *software*, *firmware*, drivers e modelos 3D necessários para montar e configurar o sistema **MecaVision**.

---

## 📦 Conteúdo deste Repositório

* `requirements.txt` — Lista exata das bibliotecas Python exigidas pelo código do PC.
* `install_pc.bat` — Script de instalação automática para **Windows**.
* `install_pc.sh` — Script de instalação automática para **Linux / macOS** (cria ambiente virtual `venv`).
* `README.md` — Guia de referência rápida com todos os links essenciais.

---

## 🚀 Instalação Rápida (PC)

1. Certifique-se de que tem o **Python (versão 3.7 a 3.9 recomendada)** instalado.
2. Clone ou descarregue este repositório para a mesma pasta onde estão os ficheiros de execução do **MecaVision** (`Cubotino_GUI.py`, `Cubotino_moves.py`, `Cubotino_webcam.py`).
3. Execute o script correspondente ao seu sistema operativo:
   * **Windows:** Dê um duplo clique em `install_pc.bat`.
   * **Linux / macOS:** Abra o terminal na pasta e execute:
     ```bash
     chmod +x install_pc.sh
     ./install_pc.sh
     ```

---

## 🔗 Links Essenciais (Software, Firmware & Modelos 3D)

### 1. Repositório Base & Ficheiros 3D
* **Repositório Base (Código PC & ESP32):** [GitHub Oficial](https://github.com/AndreaFavero71/CUBOTino_base_version)
* **Ficheiros STL para Impressão 3D (Instructables):** [Modelos 3D no Instructables](https://www.instructables.com/CUBOTino-a-Small-Simple-3D-Printed-Inexpensive-Rub/)
* **Ficheiros STL Alternativos (Thingiverse):** [Modelos 3D no Thingiverse](https://www.thingiverse.com/thing:5414833)

### 2. Ambiente Python no PC
* **Python (Recomendado 3.7 – 3.9):** [python.org/downloads](https://www.python.org/downloads/)
* **Algoritmo de Resolução (Herbert Kociemba):** [PyPI - RubikTwoPhase](https://pypi.org/project/RubikTwoPhase/)
* **Visão Computacional (OpenCV):** [PyPI - opencv-python](https://pypi.org/project/opencv-python/)

### 3. ESP32 & MicroPython
* **Firmware MicroPython para ESP32 (v1.17 ou superior):** [micropython.org/download/esp32](https://micropython.org/download/esp32/)
* **IDE para Gravar Código na ESP32 (Thonny IDE):** [thonny.org](https://thonny.org/)
* **Ferramenta de Flash via Linha de Comandos (esptool):** [PyPI - esptool](https://pypi.org/project/esptool/)

### 4. Drivers USB-Serial para a Placa ESP32
*(Instale o driver correspondente ao chip da sua placa ESP32 para que a porta COM apareça no PC)*
* **Driver CP210x (Silicon Labs):** [Silicon Labs CP210x USB to UART Bridge](https://www.silabs.com/developers/usb-to-uart-bridge-vcp-drivers)
* **Driver CH340 / CH341 (WCH):** [WCH CH341SER Driver](https://www.wch-ic.com/downloads/CH341SER_ZIP.html)

---

## ⚙️ Resumo da Pinagem (ESP32 30 Pinos)

| Pino ESP32 | Função | Componente |
| :--- | :--- | :--- |
| **D22** | Sinal PWM Servo Inferior | *Cube Holder* (Base giratória) |
| **D23** | Sinal PWM Servo Superior | *Top Cover / Lifter* (Tampa e braço) |
| **D32** | Entrada Capacitiva (Touch) | Chapa de alumínio (*STOP* de emergência) |
| **GND** | Terra Comum | Interligado entre a ESP32 e a fonte dos servos |

> **Nota Importante de Energia:** Utilize alimentação separada de **5V (mín. 2A)** para os servomotores (com dois condensadores de 220 µF / 16 V em paralelo) e alimente a placa ESP32 pela sua própria porta Micro-USB, mantendo apenas o **GND** em comum.

---

## 🙏 Créditos
Este projeto é baseado na arquitetura mecânica, eletrónica e de software do **CUBOTino**, originalmente criado e partilhado por **Andrea Favero**.
