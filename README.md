# Ubuntu Touch merlin USB kernel

Configuración y herramientas para compilar el kernel de Ubuntu Touch del Xiaomi Redmi Note 9 **merlin**, con soporte USB Wi-Fi y USB serie. Proyecto comunitario experimental; no es una publicación oficial de Kali, Xiaomi ni UBports.

## Estado comprobado

- Compilación realizada en Kali ARM64 dentro de UTM, usando un contenedor Ubuntu 20.04.
- Kernel `4.14.356-openela-rc1-merlin_ubuntu`, basado en el commit fijado del port UBports.
- La imagen arrancó Ubuntu Touch 24.04.4 / 24.04-1.4; ADB, el servicio gráfico y el Wi-Fi interno funcionaron tras el arranque.
- La lectura de la sección utilizada de `boot` coincidió byte por byte con la imagen instalada.
- El usuario indicó detección ocasional de periféricos. **No se verificó una conexión Wi-Fi sostenida mediante el TP-Link ni la programación de placas por USB.**
- **No corrige el fallo OTG intermitente.** También se reprodujo con un mouse y el kernel original de Ubuntu Touch; consultar [diagnóstico](docs/otg.md).

## Soporte añadido

| Dispositivo/interfaz | Opciones |
|---|---|
| TP-Link TL-WN722N **V1**, Atheros AR9271 | `mac80211`, `ath9k_htc`, firmware 1.4.0 integrado |
| Puentes serie Silicon Labs | `cp210x` |
| Puentes serie WCH | `ch341` |
| Puentes serie FTDI | `ftdi_sio` |
| USB CDC ACM | `cdc_acm` |

Esto no garantiza compatibilidad con todas las placas ESP32 ni todas las versiones de Raspberry Pi. TL-WN722N V2/V3 utiliza otro chipset.

## Compilación

Usar un sistema de archivos Linux sensible a mayúsculas; el árbol del kernel contiene nombres que colisionan en macOS. El procedimiento suministrado está orientado a **Linux ARM64** con Docker. No se ha validado en Linux x86-64.

```bash
git clone --recurse-submodules https://github.com/HEYLER1/ubuntu-touch-merlin-usb-kernel.git
cd ubuntu-touch-merlin-usb-kernel
bash scripts/prepare.sh
sudo docker run --name merlin-usb-build -v "$PWD:/work" ubuntu:20.04 bash /work/scripts/build-in-container.sh
```

Resultado: `out/arch/arm64/boot/Image.gz-dtb`. El script conserva la configuración base, aplica el fragmento, ejecuta `olddefconfig` y comprueba las opciones principales. Usa dos procesos para limitar memoria. Los paquetes de Ubuntu se resuelven al compilar: esto no garantiza reproducibilidad binaria ni el mismo hash entre ejecuciones.

El firmware se descarga de linux-firmware y se verifica con SHA-256. No se redistribuye aquí. El archivo `config/merlin-usb.config` documenta la configuración de la compilación probada.

## Empaquetado y recuperación

`Image.gz-dtb` **no es una imagen boot lista para flashear**. Conservar una copia de la partición boot del propio teléfono y desempaquetarla con las herramientas [mkbootimg de LineageOS](https://github.com/LineageOS/android_system_tools_mkbootimg/tree/lineage-20.0), usadas por las herramientas del port. Reemplazar solamente el kernel y conservar ramdisk, DTB, cabecera, direcciones y cmdline del arranque correspondiente. No usar el boot de MIUI como base para Ubuntu Touch.

En la unidad probada, la cabecera era v2 y el tamaño de página 2048 bytes. No asumir que estos valores aplican a otras imágenes. Verificar el empaquetado y contar con fastboot y una copia original antes de escribir boot. La prueba `fastboot boot` no aplicó el kernel temporal en la unidad probada.

Para restaurar un arranque original **previamente respaldado de esa unidad**, desde fastboot:

```bash
fastboot flash boot boot-original.img
fastboot reboot
```

No se incluyen imágenes del teléfono, particiones de firmware, registros personales ni credenciales. Las actualizaciones OTA pueden reemplazar este kernel.

## Fuentes y licencia

- [Kernel del port UBports](https://gitlab.com/ubports/community-ports/android10/xiaomi-redmi-9/kernel-xiaomi-mt6768), rama `halium-11`, commit `d9180b6f8c846232728d4060d918575e8af1426e`, fijado como submódulo.
- [Herramientas del port](https://gitlab.com/ubports/community-ports/halium-generic-adaptation-build-tools).
- [Dispositivo merlin](https://devices.ubuntu-touch.io/device/merlin/).
- [Controlador ath9k_htc](https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath9k_htc.html).

Se conserva `COPYING` del kernel (GPL-2.0); los archivos upstream mantienen sus licencias. Los scripts y documentación originales de este repositorio se distribuyen bajo GPL-2.0-only. El firmware tiene condiciones propias en linux-firmware.
