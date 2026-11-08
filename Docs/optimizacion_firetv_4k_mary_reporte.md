# Reporte de Optimización: Amazon Fire TV Stick 4K (de Mary)

Informe técnico de la ejecución de la suite **FireTV-Reloaded** sobre el segundo dispositivo del hogar, adaptado para la arquitectura de **Fire OS 6** (Android 7.1.2).

---

## 📱 Ficha Técnica del Dispositivo
- **Nombre:** Fire TV Stick 4K de Mary
- **Modelo:** AFTMM (`mantis` - 1ª Generación)
- **Sistema Operativo:** Fire OS `6.7.1.1` (NS6711/5908)
- **Almacenamiento total:** 5.34 GB útiles
- **Dirección IP local:** `10.10.10.21`

---

## 🚀 Resultados de la Optimización

### 1. Desinstalación Limpia de Aplicaciones No Deseadas
Se detectaron y purgaron de raíz los 5 paquetes solicitados:
- ✅ **Supercleaner:** `co.si.du.supercleaner` (Desinstalado)
- ✅ **Screen Mirror:** `de.twokit.screen.mirror` (Desinstalado)
- ✅ **Pley:** `com.cvnet.pley` (Desinstalado)
- ✅ **TVee:** `com.vectormax.tv.viginet` (Desinstalado)
- ✅ **Magma Player:** `com.magmaplayer` (Desinstalado)

### 2. Recuperación de Almacenamiento Interno
- **Estado Inicial:** 2.86 GB usados / 2.47 GB disponibles.
- **Estado Final:** 2.40 GB usados / **2.90 GB disponibles**.
- **Espacio Útil Recuperado:** **+430 MB netos** liberados inmediatamente en un almacenamiento crítico de 5 GB.

### 3. Debloat de Telemetría y Erradicación de Anuncios
- 9 paquetes comerciales y de telemetría desactivados con `pm disable-user --user 0`:
  - `com.amazon.shoptv.firetv.client` (Shop on Amazon)
  - `com.amazon.shoptv.client`
  - `com.amazon.hybridadidservice` (Servicio de perfilado de anuncios)
  - `com.amazon.whad` (Whisper Ads)
  - `com.amazon.ods.kindleconnect`
  - `com.amazon.device.sale.service`
  - `com.amazon.tahoe`
  - `com.amazon.bueller.music`
  - `com.amazon.bueller.photos`
- **Opt-Out forzado de anuncios:** `advertising_id_opt_out = 1`, `ad_tracking_enabled = 0`, `limit_ad_tracking = 1`.
- **Apagado de video y audio automático en banners:** `featured_item_video_enabled = 0`.

### 4. Aceleración de la Interfaz al 200%
- Escalas de animación ajustadas de `1.0x` a `0.5x` (Ventana, Transición y Animador).
- Navegación ultra fluida con el mando a distancia sin congelamientos.

### 5. Memoria RAM y Procesos Secundarios
- Se cerraron forzosamente 12 procesos en segundo plano.
- Memoria RAM disponible estabilizada en más de **416 MB libres**.
