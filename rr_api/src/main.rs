pub mod db;
pub mod endpoints;
pub mod errors;
pub mod models;

use anyhow::Context;
use tracing;
use tracing_subscriber::{prelude::__tracing_subscriber_SubscriberExt, util::SubscriberInitExt};

#[tokio::main]
async fn main() -> tide::Result<()> {
    // println!("cargo:rerun-if-changed=migrations");
    tracing_subscriber::registry()
        .with(tracing_subscriber::EnvFilter::new(
            "sqlx=debug,tower_http=debug,rr_api=info",
        ))
        .with(tracing_subscriber::fmt::layer())
        .init();

    let url = "postgres://postgres:root@localhost:5432/sandbox";
    let port = 8080;
    let cors_origin = "http://localhost:3000";
    let pool = db::pool::ConnPool::new(url, false).await?;
    let store = db::store::Store::new(pool);

    tracing::info!("Starting server.");
    endpoints::RRouter::serve(port, cors_origin, store)
        .await
        .context("Error while starting server")?;

    Ok(())
}
