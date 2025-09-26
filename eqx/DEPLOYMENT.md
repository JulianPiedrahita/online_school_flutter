# 🚀 Deployment Setup - Flutter Web to Vercel

Este proyecto está configurado para desplegarse automáticamente en Vercel usando GitHub Actions.

## 📋 Configuración Inicial

### 1. Crear cuenta en Vercel
1. Ve a [vercel.com](https://vercel.com)
2. Regístrate con tu cuenta de GitHub
3. Conecta tu repositorio

### 2. Obtener tokens de Vercel
Ejecuta estos comandos en tu terminal local:

```bash
# Instalar Vercel CLI
npm install -g vercel

# Login a Vercel
vercel login

# En el directorio del proyecto, ejecutar:
vercel

# Seguir las instrucciones y obtener:
# - VERCEL_ORG_ID
# - VERCEL_PROJECT_ID
```

### 3. Configurar Secrets en GitHub

Ve a tu repositorio en GitHub → Settings → Secrets and variables → Actions

Agrega estos secrets:

| Secret Name | Descripción | Donde obtenerlo |
|-------------|-------------|-----------------|
| `VERCEL_TOKEN` | Token de acceso de Vercel | [Vercel Tokens](https://vercel.com/account/tokens) |
| `VERCEL_ORG_ID` | ID de tu organización | Archivo `.vercel/project.json` después de ejecutar `vercel` |
| `VERCEL_PROJECT_ID` | ID del proyecto | Archivo `.vercel/project.json` después de ejecutar `vercel` |

### 4. Estructura de archivos creados

```
.github/
  workflows/
    deploy-vercel.yml          # Workflow principal (único necesario)
vercel.json                    # Configuración de Vercel
.vercelignore                  # Archivos a ignorar en deployment
scripts/
  build-web.sh                 # Script de build para Linux/Mac
  build-web.ps1                # Script de build para Windows
DEPLOYMENT.md                  # Este archivo
```

## 🔧 Workflow de Deployment

### Características del workflow único
- ✅ **Trigger automático** en push a main
- ✅ **Trigger manual** disponible en GitHub Actions
- ✅ **Flutter 3.35.4** con cache habilitado
- ✅ **Análisis de código** obligatorio
- ✅ **Tests** opcionales (continúa si fallan)
- ✅ **Build optimizado** con CanvasKit renderer
- ✅ **Deploy directo** a Vercel
- ✅ **Logging claro** con emojis para fácil seguimiento

## 🌐 Características del Deployment

### Optimizaciones Web
- **Canvas Kit Renderer**: Mejor rendimiento
- **Cache Headers**: Assets optimizados
- **SPA Routing**: Rutas de Flutter funcionando
- **Security Headers**: Protección básica

### Firebase Integration
- ✅ **Firebase Auth REST API** configurado
- ✅ **Project ID**: database-jvs-cloud
- ✅ **API Key**: Configurado en el código
- ✅ **CORS**: Habilitado para dominios de Vercel

## 🚦 Proceso de Deployment

1. **Push to main** → Trigger automático del workflow
2. **Build Flutter Web** → Compilación optimizada
3. **Run Tests** → Validación de código
4. **Deploy to Vercel** → Publicación automática
5. **Live URL** → Tu app disponible globalmente

## 🔍 Monitoreo

### GitHub Actions
- Ve a **Actions** en tu repositorio
- Monitorea el progreso del deployment
- Revisa logs en caso de errores

### Vercel Dashboard
- [vercel.com/dashboard](https://vercel.com/dashboard)
- Analytics de performance
- Logs de deployment
- Configuración de dominio

## 🐛 Troubleshooting

### Error: "VERCEL_TOKEN not found"
```bash
# Verificar que el secret esté configurado en GitHub
# Settings → Secrets → VERCEL_TOKEN
```

### Error: "Build failed"
```bash
# Verificar localmente:
flutter build web --release
# Si funciona local, revisar logs de GitHub Actions
```

### Error: "Firebase CORS"
```bash
# Agregar dominio de Vercel a Firebase Console:
# Authentication → Settings → Authorized domains
# Agregar: tu-app.vercel.app
```

## 📱 URLs de la Aplicación

Después del primer deployment:
- **Production**: `https://tu-proyecto.vercel.app`
- **Preview**: Automático en cada PR
- **Development**: `http://localhost:58000` (local)

## 🔒 Consideraciones de Seguridad

- ✅ Headers de seguridad configurados
- ✅ Firebase API Key limitado por dominio
- ✅ Secrets protegidos en GitHub
- ✅ HTTPS automático en Vercel

---

¡Tu aplicación Flutter Web está lista para production! 🎉