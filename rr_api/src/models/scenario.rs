use crate::db::pg::Selectable;
use sqlx::{postgres::PgHasArrayType, Row};

pub type PgScenarioQueryAs<'a> =
    sqlx::query::QueryAs<'a, sqlx::Postgres, Scenario, sqlx::postgres::PgArguments>;

#[derive(sqlx::Type, sqlx::FromRow, serde::Deserialize, Debug)]
pub struct CreateScenario {
    pub name: String,
    pub category: String,
    pub description: String,
    pub keywords: Vec<String>,
    pub instructions: String,
}

#[derive(sqlx::Type, sqlx::FromRow, serde::Deserialize, Default)]
pub struct UpdateScenario {
    pub name: Option<String>,
    pub category: Option<String>,
    pub description: Option<String>,
    pub keywords: Option<Vec<String>>,
    pub instructions: Option<String>,
}

#[derive(sqlx::FromRow, serde::Deserialize, Debug)]
pub struct GetScenarios {
    pub name: Option<String>,
    pub category: Option<String>,
    pub limit: Option<i64>,
    pub offset: Option<i64>,
}

#[derive(sqlx::FromRow, serde::Deserialize, serde::Serialize, Debug)]
pub struct ScenariosResponse {
    pub scenarios: Vec<Scenario>,
    pub total: i64,
}

impl From<Vec<Scenario>> for ScenariosResponse {
    fn from(scenarios: Vec<Scenario>) -> Self {
        let total = scenarios.len() as i64;
        ScenariosResponse { scenarios, total }
    }
}

#[derive(sqlx::Type, sqlx::FromRow, serde::Deserialize, serde::Serialize, Debug)]
pub struct Scenario {
    pub id: i64,
    pub name: String,
    pub category: String,
    pub description: String,
    pub keywords: Vec<String>,
    pub instructions: String,
    #[serde(rename = "createdAt")]
    pub created_at: sqlx::types::chrono::DateTime<sqlx::types::chrono::Utc>,
    #[serde(rename = "updatedAt")]
    pub updated_at: sqlx::types::chrono::DateTime<sqlx::types::chrono::Utc>,
}

impl TryFrom<sqlx::postgres::PgRow> for Scenario {
    type Error = anyhow::Error;

    fn try_from(row: sqlx::postgres::PgRow) -> Result<Self, Self::Error> {
        let id = row.try_get("id")?;
        let name = row.try_get("name")?;
        let category = row.try_get("category")?;
        let description = row.try_get("description")?;
        let keywords = row.try_get("keywords")?;
        let instructions = row.try_get("instructions")?;
        let created_at = row.try_get("created_at")?;
        let updated_at = row.try_get("updated_at")?;

        Ok(Scenario {
            id,
            name,
            category,
            description,
            keywords,
            instructions,
            created_at,
            updated_at,
        })
    }
}

pub struct ScenarioIdent(pub i64);

impl Selectable for ScenarioIdent {
    type Output = Scenario;

    fn select<'a>(&self) -> PgScenarioQueryAs<'a> {
        sqlx::query_as::<_, Scenario>("SELECT * FROM scenarios WHERE id = $1").bind(self.0)
    }
}

#[derive(sqlx::FromRow)]
pub struct Scenarios(Vec<Scenario>);

impl PgHasArrayType for Scenarios {
    fn array_type_info() -> sqlx::postgres::PgTypeInfo {
        sqlx::postgres::PgTypeInfo::with_name("scenarios")
    }
}

pub enum ScenariosIdent {
    Category(String),
    Name(String),
    Keywords(Vec<String>),
    Downloadable,
    All,
}

impl<'a> ScenariosIdent {
    pub fn select_all(&self) -> PgScenarioQueryAs<'a> {
        match self {
            Self::Category(category) => {
                sqlx::query_as::<_, Scenario>("SELECT * FROM scenarios WHERE category = $1")
                    .bind(category.to_string().clone())
            }
            Self::Name(name) => {
                sqlx::query_as::<_, Scenario>("SELECT * FROM scenarios WHERE name = $1").bind(name.clone())
            }
            Self::Keywords(keywords) => sqlx::query_as::<_, Scenario>(
                "SELECT * FROM scenarios WHERE $1::text[] && keywords AND keywords = ANY($2::text[])",
            )
            .bind(keywords.clone()),
            Self::All => sqlx::query_as::<_, Scenario>("SELECT * FROM scenarios"),
            Self::Downloadable => sqlx::query_as::<_, Scenario>("SELECT * FROM scenarios WHERE level = 'additional'"),
        }
    }
}
