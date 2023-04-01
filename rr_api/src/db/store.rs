use std::sync::Arc;

use super::repos::{
    scenario_repo::{DynScenarioRepo, PgScenarioRepo, ScenarioRepo},
    user_repo::{DynUserRepo, PgUserRepo, UserRepo},
};

#[derive(Clone)]
pub struct Store {
    pub users: DynUserRepo,
    pub scenario: DynScenarioRepo,
}

impl Store {
    pub fn new(client: sqlx::postgres::PgPool) -> Self {
        tracing::info!("Initializing store.");
        Self {
            users: Arc::new(PgUserRepo::new(client.clone())) as DynUserRepo,
            scenario: Arc::new(PgScenarioRepo::new(client)) as DynScenarioRepo,
        }
    }
}
