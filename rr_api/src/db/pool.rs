use anyhow::Context;

pub struct ConnPool;

impl ConnPool {
    pub async fn new(path: &str, run_migrations: bool) -> anyhow::Result<sqlx::postgres::PgPool> {
        let pool = sqlx::postgres::PgPoolOptions::new()
            .max_connections(5)
            .connect(path)
            .await
            .context("Failed to connect to database")?;

        if run_migrations {
            tracing::info!("Running migrations");
            sqlx::migrate!("./migrations")
                .run(&pool)
                .await
                .context("Failed to run migrations")?;
        }
        Ok(pool)
    }
}
