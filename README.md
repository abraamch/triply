# Triply 🌴 - El Sistema Operativo del Viaje Grupal

> **"Mandanos todo lo de tu viaje. Nosotros lo organizamos."**

Triply es una plataforma multiplataforma (iOS, Android y Web responsive) diseñada para centralizar itinerarios, reservas, votaciones, división de gastos y recuerdos colaborativos de viajes en grupo, asistida por Inteligencia Artificial contextual.

---

## 🚀 Arquitectura y Plataformas

* **Frontend**: Flutter & Dart (Arquitectura Feature-First + Clean Architecture pragmática).
* **Navegación**: `GoRouter` con navegación adaptativa (`AdaptiveScaffold`: Bottom Navigation Bar de 5 pestañas en móvil y Sidebar expandido en Web).
* **Gestión de Estado**: `flutter_riverpod` (StateNotifiers & Providers inmutables).
* **Backend & DB**: Supabase (PostgreSQL con UUID, Row Level Security, Auth y Realtime).
* **IA**: Abstracción de proveedor (`AiProvider`) para Gemini / OpenAI.
* **CI/CD Cloud**: Compilación automática en la nube mediante **GitHub Actions** (sin necesidad de instalar gigabytes de SDKs localmente).

---

## 📁 Estructura del Proyecto

```text
lib/
├── app/
│   ├── app.dart                    # MaterialApp.router y configuración global
│   ├── config/                     # Variables de entorno (env.dart) y temas
│   └── routes/                     # Definición de rutas GoRouter
├── core/
│   ├── widgets/                    # Widgets adaptativos (AdaptiveScaffold, AppButton)
│   └── utils/                      # Formateadores y utilidades
├── features/
│   ├── landing/                    # Landing page premium (desktop y mobile)
│   ├── auth/                       # Supabase Auth, login, registro y sesiones
│   └── trip/                       # Creación de viaje, Dashboard y Modo Demo
└── supabase/
    └── schema.sql                  # Script SQL completo (15 tablas + RLS + Triggers)
```

---

## 🗄️ Base de Datos y Supabase

Para conectar tu instancia de Supabase:

1. Creá un proyecto en [Supabase](https://supabase.com).
2. Abrí el **SQL Editor** en el dashboard de Supabase.
3. Copiá y pegá el contenido de [`supabase/schema.sql`](supabase/schema.sql) y ejecutalo.
4. Configurá tus variables de entorno al compilar o en tu pipeline de CI/CD:
   ```bash
   --dart-define=SUPABASE_URL=https://tu-proyecto.supabase.co \
   --dart-define=SUPABASE_ANON_KEY=tu-llave-anonima
   ```

---

## ☁️ Compilación y Despliegue en la Nube (GitHub Actions)

El repositorio incluye un workflow en [`.github/workflows/deploy.yml`](.github/workflows/deploy.yml) que se dispara con cada `push`:
* Ejecuta el análisis estático (`flutter analyze`).
* Ejecuta los tests unitarios (`flutter test`).
* Compila la versión Web (`flutter build web --release`).
* Genera el artefacto web listo para desplegar en Vercel, Firebase Hosting o GitHub Pages.
