pub mod db;
pub mod endpoints;
pub mod models;

use tracing;

#[tokio::main]
async fn main() -> tide::Result<()> {
    tracing_subscriber::fmt::init();
    tracing::info!("Starting server.");
    let mut app = tide::new();
    app.at("/").get(endpoints::select);
    app.listen("localhost:8080").await?;
    tracing::info!("Server ended.");
    // let res = db::pg::test_db().await;
    // println!("{:?}", res);
    Ok(())
}
