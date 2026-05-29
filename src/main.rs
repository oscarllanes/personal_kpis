use axum::{
    extract::{State, Json}, 
    routing::{get, post}, 
    Router, 
    response::IntoResponse, 
    http::StatusCode
};
use sqlx::postgres::{PgPool, PgPoolOptions};
use serde::{Serialize, Deserialize};
use chrono::NaiveDate;
use std::env;
use tower_http::services::{ServeDir, ServeFile};
use std::collections::HashMap;

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct DailyLog {
    pub date: NaiveDate,
    pub weight: Option<f64>,
    pub over_consumption: bool,
    pub screen_time: bool,
    pub alcohol: bool,
    pub mindfulness: bool,
    pub exercise: bool,
    pub active_discernment: bool,
    pub energy_level: bool,
    pub pristine_respect: bool,
}

#[derive(Clone)]
struct AppState { pool: PgPool }

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    dotenvy::dotenv().ok();
    let db_url = env::var("DATABASE_URL").expect("DATABASE_URL debe estar definida");
    let pool = PgPoolOptions::new().max_connections(5).connect(&db_url).await?;
    let state = AppState { pool };

    let app = Router::new()
        .fallback_service(ServeDir::new("public").fallback(ServeFile::new("public/index.html")))
        .route("/api/logs", get(list_logs).post(create_log))
        .with_state(state);

    let listener = tokio::net::TcpListener::bind("127.0.0.1:3000").await?;
    println!("🚀 SaaS Operational Center activo en http://127.0.0.1:3000");
    axum::serve(listener, app).await?;
    Ok(())
}

async fn create_log(State(state): State<AppState>, Json(p): Json<DailyLog>) -> impl IntoResponse {
    let user_id = 1;
    let kpis = vec![
        ("over_consumption", p.over_consumption.to_string()),
        ("screen_time", p.screen_time.to_string()),
        ("alcohol", p.alcohol.to_string()),
        ("mindfulness", p.mindfulness.to_string()),
        ("exercise", p.exercise.to_string()),
        ("active_discernment", p.active_discernment.to_string()),
        ("energy_level", p.energy_level.to_string()),
        ("pristine_respect", p.pristine_respect.to_string()),
    ];

    let mut tx = state.pool.begin().await.expect("Error iniciando transacción");
    for (name, val) in kpis {
        // Validación contra schema kpis
        sqlx::query!(
            "INSERT INTO kpis.kpi_logs (user_id, definition_id, entry_date, value) 
             VALUES ($1, (SELECT id FROM kpis.kpi_definitions WHERE name = $2), $3, $4) 
             ON CONFLICT (user_id, entry_date, definition_id) DO UPDATE SET value = $4",
            user_id, name, p.date, val
        ).execute(&mut *tx).await.expect("Error insertando KPI");
    }
    if let Some(w) = p.weight {
        // Validación contra schema kpis
        sqlx::query!(
            "INSERT INTO kpis.kpi_logs (user_id, definition_id, entry_date, value) 
             VALUES ($1, (SELECT id FROM kpis.kpi_definitions WHERE name = 'weight'), $2, $3) 
             ON CONFLICT (user_id, entry_date, definition_id) DO UPDATE SET value = $3",
            user_id, p.date, w.to_string()
        ).execute(&mut *tx).await.expect("Error insertando peso");
    }
    tx.commit().await.expect("Error al confirmar transacción");
    StatusCode::CREATED
}

async fn list_logs(State(state): State<AppState>) -> impl IntoResponse {
    // Validación contra schema kpis
    let rows = sqlx::query!(
        "SELECT entry_date, name, value 
         FROM kpis.kpi_logs l 
         JOIN kpis.kpi_definitions d ON l.definition_id = d.id 
         WHERE l.user_id = 1 ORDER BY entry_date DESC"
    ).fetch_all(&state.pool).await.expect("Error consultando logs");

    let mut logs: HashMap<NaiveDate, DailyLog> = HashMap::new();
    for row in rows {
        let entry = logs.entry(row.entry_date).or_insert(DailyLog {
            date: row.entry_date, weight: None, over_consumption: false, screen_time: false, alcohol: false, mindfulness: false, exercise: false, active_discernment: false, energy_level: false, pristine_respect: false
        });
        match row.name.as_str() {
            "weight" => entry.weight = row.value.parse().ok(),
            "over_consumption" => entry.over_consumption = row.value == "true",
            "screen_time" => entry.screen_time = row.value == "true",
            "alcohol" => entry.alcohol = row.value == "true",
            "mindfulness" => entry.mindfulness = row.value == "true",
            "exercise" => entry.exercise = row.value == "true",
            "active_discernment" => entry.active_discernment = row.value == "true",
            "energy_level" => entry.energy_level = row.value == "true",
            "pristine_respect" => entry.pristine_respect = row.value == "true",
            _ => {}
        }
    }
    let mut sorted_logs: Vec<DailyLog> = logs.into_values().collect();
    sorted_logs.sort_by(|a, b| b.date.cmp(&a.date));
    Json(sorted_logs)
}