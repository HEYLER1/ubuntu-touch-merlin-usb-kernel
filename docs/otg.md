# Diagnóstico OTG: límites y resultados

La detección OTG y la enumeración de un periférico ocurren antes de cargar su controlador específico. Añadir ath9k_htc no corrige la negociación USB-C.

## Evidencia de la unidad probada

El controlador WUSB3801 responde a I2C. Se observaron eventos `OTG Plug in`, petición `source vbus = 5000mv`, y `OTG Plug out` entre aproximadamente 0,04 y 0,33 segundos después, sin enumeración estable del periférico. La petición de 5 V es un mensaje del controlador: no constituye una medición eléctrica del puerto.

También falló un mouse. Apagar y volver a encender, restablecer el control del fabricante `reverse_chg_otg` a 0 y probar el kernel original de Ubuntu Touch no solucionaron el fallo. Tras esa comparación se restauró el kernel con los controladores añadidos.

La integridad binaria de boot se comprobó, pero eso no demuestra ausencia de defectos de software. Los atributos dual_role informaron `none` incluso con ADB funcional: no deben usarse solos para diagnosticar el enlace. El usuario informó que en ocasiones reconoce dispositivos; no hay una prueba controlada que permita atribuir definitivamente la causa al puerto, firmware o port.

El issue UBports #2072 corresponde a **Redmi Note 9 Pro**, no a merlin, y no es evidencia de una corrección aplicable a este dispositivo. No se aplicaron parches especulativos al controlador USB-C ni se forzó VBUS mientras estaba conectado a un ordenador.
