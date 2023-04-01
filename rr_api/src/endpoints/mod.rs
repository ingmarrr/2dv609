use crate::db::store::Store;
use anyhow::Context;
use axum::http::HeaderValue;

pub mod scenario_eps;
pub mod user_eps;

pub struct RRouter;

impl RRouter {
    pub async fn serve(port: u32, cors_origin: &str, store: Store) -> anyhow::Result<()> {
        let router = axum::Router::new()
            .nest("/rr", user_eps::UsersRouter::new(store.clone()))
            .layer(
                tower_http::cors::CorsLayer::new()
                    .allow_origin(cors_origin.parse::<HeaderValue>().unwrap())
                    .allow_methods([
                        axum::http::method::Method::GET,
                        axum::http::method::Method::PUT,
                    ]),
            );

        let addr = format!("127.0.0.1:{}", port);
        tracing::info!("Starting server on port: {}", port);
        axum::Server::bind(&addr.parse().unwrap())
            .serve(router.into_make_service())
            .await
            .context("Error while starting server")?;

        Ok(())
    }
}
