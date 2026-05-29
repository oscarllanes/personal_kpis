-- 1. La tabla de "Datos Duros" (Tu bitácora operativa)
CREATE TABLE IF NOT EXISTS daily_logs (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL DEFAULT CURRENT_DATE UNIQUE,
    over_consumption BOOLEAN NOT NULL DEFAULT FALSE,
    screen_time_goal BOOLEAN NOT NULL DEFAULT FALSE,
    alcohol_free BOOLEAN NOT NULL DEFAULT FALSE,
    mindfulness_achieved BOOLEAN NOT NULL DEFAULT FALSE,
    exercise_achieved BOOLEAN NOT NULL DEFAULT FALSE,
    active_discernment BOOLEAN NOT NULL DEFAULT FALSE,
    weight_kg NUMERIC(5,2),
    energy_level_high BOOLEAN NOT NULL DEFAULT FALSE,
    pristine_respect BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. La tabla de "Análisis Cualitativo" (Tu diario de externalización)
CREATE TABLE IF NOT EXISTS daily_reflections (
    id SERIAL PRIMARY KEY,
    log_id INTEGER NOT NULL REFERENCES daily_logs(id) ON DELETE CASCADE,
    reflection_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);