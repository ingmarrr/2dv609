use crate::db::pg::Selectable;
use sqlx::{postgres::PgHasArrayType, Row};

pub type PgScenarioQueryAs<'a> =
    sqlx::query::QueryAs<'a, sqlx::Postgres, Scenario, sqlx::postgres::PgArguments>;

#[derive(sqlx::Type, sqlx::FromRow)]
pub struct CreateScenario {
    pub name: String,
    pub category: Category,
    pub description: String,
    pub keywords: Vec<String>,
    pub instructions: String,
}

#[derive(sqlx::Type, sqlx::FromRow, Default)]
pub struct UpdateScenario {
    pub name: Option<String>,
    pub category: Option<Category>,
    pub description: Option<String>,
    pub keywords: Option<Vec<String>>,
    pub instructions: Option<String>,
}

#[derive(sqlx::Type, sqlx::FromRow, Default, serde::Deserialize, serde::Serialize, Debug)]
pub struct Scenario {
    pub id: i64,
    pub name: String,
    pub category: Category,
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

#[derive(sqlx::Type, Default, serde::Deserialize, serde::Serialize, Debug)]
pub enum Category {
    Allergies,
    Burns,
    Choking,
    Dehydration,
    Drowning,
    ElectricShock,
    EyeInjuries,
    FracturesAndSprains,
    HeadInjuries,
    HeartAttack,
    Hypothermia,
    InsectBitesAndStings,
    Poisoning,
    Seizures,
    Shock,
    Stroke,
    Trauma,
    Unconsciousness,
    WoundsAndBleeding,
    CarbonmonoxidePoisoning,
    #[default]
    Undefined,
}

impl std::fmt::Display for Category {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let category = match self {
            Category::Allergies => "Allergies",
            Category::Burns => "Burns",
            Category::Choking => "Choking",
            Category::Dehydration => "Dehydration",
            Category::Drowning => "Drowning",
            Category::ElectricShock => "ElectricShock",
            Category::EyeInjuries => "EyeInjuries",
            Category::FracturesAndSprains => "FracturesAndSprains",
            Category::HeadInjuries => "HeadInjuries",
            Category::HeartAttack => "HeartAttack",
            Category::Hypothermia => "Hypothermia",
            Category::InsectBitesAndStings => "InsectBitesAndStings",
            Category::Poisoning => "Poisoning",
            Category::Seizures => "Seizures",
            Category::Shock => "Shock",
            Category::Stroke => "Stroke",
            Category::Trauma => "Trauma",
            Category::Unconsciousness => "Unconsciousness",
            Category::WoundsAndBleeding => "WoundsAndBleeding",
            Category::CarbonmonoxidePoisoning => "CarbonmonoxidePoisoning",
            Category::Undefined => "Undefined",
        };
        write!(f, "{}", category)
    }
}

#[derive(sqlx::FromRow)]
pub struct Scenarios(Vec<Scenario>);

impl PgHasArrayType for Scenarios {
    fn array_type_info() -> sqlx::postgres::PgTypeInfo {
        sqlx::postgres::PgTypeInfo::with_name("scenarios")
    }
}

pub enum SelectScenariosBy {
    Category(Category),
    Name(String),
    Keywords(Vec<String>),
}

impl<'a> SelectScenariosBy {
    pub fn select_all(&self) -> PgScenarioQueryAs<'a> {
        match self {
            SelectScenariosBy::Category(category) => {
                sqlx::query_as::<_, Scenario>("SELECT * FROM scenarios WHERE category = $1")
                    .bind(category.to_string().clone())
            }
            SelectScenariosBy::Name(name) => {
                sqlx::query_as::<_, Scenario>("SELECT * FROM scenarios WHERE name = $1").bind(name.clone())
            }
            SelectScenariosBy::Keywords(keywords) => sqlx::query_as::<_, Scenario>(
                "SELECT * FROM scenarios WHERE $1::text[] && keywords AND keywords = ANY($2::text[])",
            )
            .bind(keywords.clone()),
        }
    }
}
