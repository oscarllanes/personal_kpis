# ETAPA 1: Construcción (Entorno completo de Rust)
FROM rust:1.95-slim-bookworm AS builder

# Instalamos dependencias de sistema para enlazar con Postgres y SSL
RUN apt-get update && apt-get install -y pkg-config libpq-dev libssl-dev && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copiamos archivos de configuración de dependencias primero
COPY Cargo.toml Cargo.lock ./

# Copiamos los recursos críticos para la validación y compilación
COPY src ./src
COPY .sqlx ./.sqlx
# Opcional: COPY .env ./.env (Si tu app necesita variables fijas al compilar)

# Compilamos el binario en modo release
# El flag --offline asegura que usemos el contrato .sqlx que ya validamos
RUN SQLX_OFFLINE=true cargo build --release --bin personal_kpis

# ETAPA 2: Ejecución (Imagen ultraligera de producción)
FROM debian:bookworm-slim

# Instalamos librerías necesarias para el runtime (OpenSSL y certificados)
RUN apt-get update && apt-get install -y libssl-dev ca-certificates && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/bin

# Copiamos únicamente el binario compilado de la etapa anterior
COPY --from=builder /app/target/release/personal_kpis .

# Exponemos el puerto de tu aplicación
EXPOSE 3000

# Comando de ejecución
CMD ["./personal_kpis"]