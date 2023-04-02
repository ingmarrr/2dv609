use std::sync::Arc;

use super::{
    scenario_repo::{DynScenarioRepo, PgScenarioRepo},
    user_repo::{DynUserRepo, PgUserRepo},
};

#[derive(Clone)]
pub struct Store {
    pub users: DynUserRepo,
    pub scenarios: DynScenarioRepo,
}

impl Store {
    pub fn new(client: sqlx::postgres::PgPool) -> Self {
        tracing::info!("Initializing store.");
        Self {
            users: Arc::new(PgUserRepo::new(client.clone())) as DynUserRepo,
            scenarios: Arc::new(PgScenarioRepo::new(client)) as DynScenarioRepo,
        }
    }
}
