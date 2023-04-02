use std::sync::Arc;

use crate::{
    db::pg::Selectable,
    models::scenario::{CreateScenario, Scenario, ScenarioIdent, ScenariosIdent, UpdateScenario},
};

pub type DynScenarioRepo = Arc<dyn ScenarioRepo + Send + Sync>;

#[async_trait::async_trait]
pub trait ScenarioRepo {
    async fn get_scenario(&self, id: i64) -> anyhow::Result<Option<Scenario>>;
    async fn get_scenarios(&self, selection: ScenariosIdent) -> anyhow::Result<Vec<Scenario>>;
    async fn create_scenario(&self, scenario: CreateScenario) -> anyhow::Result<Scenario>;
    async fn update_scenario(&self, id: i64, data: UpdateScenario) -> anyhow::Result<Scenario>;
    async fn delete_scenario(&self, id: i64) -> anyhow::Result<()>;
}

pub struct PgScenarioRepo {
    client: sqlx::postgres::PgPool,
}

impl PgScenarioRepo {
    pub fn new(client: sqlx::postgres::PgPool) -> Self {
        Self { client }
    }
}

#[async_trait::async_trait]
impl ScenarioRepo for PgScenarioRepo {
    async fn get_scenario(&self, id: i64) -> anyhow::Result<Option<Scenario>> {
        let scenario = ScenarioIdent(id)
            .select()
            .fetch_optional(&self.client)
            .await?;
        Ok(scenario)
    }

    async fn get_scenarios(&self, selection: ScenariosIdent) -> anyhow::Result<Vec<Scenario>> {
        let scenarios = selection.select_all().fetch_all(&self.client).await?;
        Ok(scenarios)
    }

    async fn create_scenario(&self, scenario: CreateScenario) -> anyhow::Result<Scenario> {
        let scenario = sqlx::query_as::<_, Scenario>(
            "INSERT INTO scenarios (name, category, description, keywords, instructions) VALUES ($1::varchar, $2::varchar, $3::varchar, $4::varchar, $5::varchar) RETURNING *;"
        )
        .bind(scenario.name)
        .bind(scenario.category)
        .bind(scenario.description)
        .bind(scenario.keywords)
        .bind(scenario.instructions)
        .fetch_one(&self.client)
        .await?;
        Ok(scenario)
    }

    async fn update_scenario(&self, id: i64, data: UpdateScenario) -> anyhow::Result<Scenario> {
        let scenario = ScenarioIdent(id)
            .select()
            .fetch_optional(&self.client)
            .await?;
        if let Some(s) = scenario {
            let out = sqlx::query_as::<_, Scenario>(
                "UPDATE scenarios SET name = $1, category = $2, description = $3, keywords = $4, instructions = $5 WHERE id = $6 RETURNING *;"
            )
            .bind(data.name.unwrap_or(s.name))
            .bind(data.category.unwrap_or(s.category))
            .bind(data.description.unwrap_or(s.description))
            .bind(data.keywords.unwrap_or(s.keywords))
            .bind(data.instructions.unwrap_or(s.instructions))
            .bind(s.id)
            .fetch_one(&self.client)
            .await?;
            Ok(out)
        } else {
            Err(anyhow::anyhow!("Scenario not found"))
        }
    }

    async fn delete_scenario(&self, id: i64) -> anyhow::Result<()> {
        let scenario = ScenarioIdent(id)
            .select()
            .fetch_optional(&self.client)
            .await?;
        if let Some(s) = scenario {
            sqlx::query("DELETE FROM scenarios WHERE id = $1")
                .bind(s.id)
                .execute(&self.client)
                .await?;
            Ok(())
        } else {
            Err(anyhow::anyhow!("Scenario not found"))
        }
    }
}
