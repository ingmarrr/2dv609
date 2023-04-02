use crate::db::pg::{Deletable, PgQuery, Selectable};

pub type PgUserQueryAs<'a> =
    sqlx::query::QueryAs<'a, sqlx::Postgres, User, sqlx::postgres::PgArguments>;

#[derive(sqlx::Type, sqlx::FromRow, serde::Deserialize, serde::Serialize, Debug)]
pub struct CreateUser {
    pub username: String,
    pub email: String,
    pub password: String,
}

#[derive(sqlx::Type, sqlx::FromRow, Default, serde::Deserialize, serde::Serialize, Debug)]
pub struct UpdateUser {
    pub username: Option<String>,
    pub email: Option<String>,
    pub password: Option<String>,
    #[serde(rename = "fullName")]
    pub full_name: Option<String>,
    pub phone: Option<String>,
}

#[derive(sqlx::Type, sqlx::FromRow, Default, serde::Deserialize, serde::Serialize, Debug)]
pub struct GetUsers {
    username: Option<String>,
    email: Option<String>,
    limit: Option<i64>,
    offset: Option<i64>,
}

#[derive(sqlx::FromRow, Default, serde::Deserialize, serde::Serialize)]
pub struct UsersResponse {
    pub users: Vec<User>,
    pub total: i64,
}

impl From<Vec<User>> for UsersResponse {
    fn from(users: Vec<User>) -> Self {
        let total = users.len() as i64;
        UsersResponse { users, total }
    }
}

#[derive(sqlx::Type, sqlx::FromRow, serde::Deserialize, serde::Serialize, Debug)]
pub struct LoginUser {
    #[serde(rename = "usernameOrEmail")]
    pub username_or_email: String,
    pub password: String,
}

#[derive(sqlx::Type, sqlx::FromRow, Default, serde::Deserialize, serde::Serialize, Debug)]
pub struct User {
    pub id: i64,
    pub username: String,
    pub password: String,
    #[serde(rename = "fullName")]
    pub full_name: String,
    pub email: String,
    pub phone: String,
    #[serde(rename = "createdAt")]
    pub created_at: sqlx::types::chrono::DateTime<sqlx::types::chrono::Utc>,
    #[serde(rename = "updatedAt")]
    pub updated_at: sqlx::types::chrono::DateTime<sqlx::types::chrono::Utc>,
}

impl User {
    pub fn new(
        id: i64,
        username: impl Into<String>,
        password: impl Into<String>,
        full_name: impl Into<String>,
        email: impl Into<String>,
        phone: impl Into<String>,
        created_at: impl Into<String>,
        updated_at: impl Into<String>,
    ) -> User {
        User {
            id,
            username: username.into(),
            password: password.into(),
            full_name: full_name.into(),
            email: email.into(),
            phone: phone.into(),
            created_at: sqlx::types::chrono::DateTime::parse_from_rfc3339(&created_at.into())
                .unwrap()
                .with_timezone(&sqlx::types::chrono::Utc),
            updated_at: sqlx::types::chrono::DateTime::parse_from_rfc3339(&updated_at.into())
                .unwrap()
                .with_timezone(&sqlx::types::chrono::Utc),
        }
    }
}

pub enum UserIdent {
    Id(i64),
    Username(String),
    Email(String),
    UsernameOrEmail(String),
}

impl Selectable for UserIdent {
    type Output = User;

    fn select<'a>(&self) -> PgUserQueryAs<'a> {
        match self {
            UserIdent::Id(id) => {
                sqlx::query_as::<_, User>("SELECT * FROM users WHERE id = $1").bind(id.clone())
            }
            UserIdent::Username(username) => {
                sqlx::query_as::<_, User>("SELECT * FROM users WHERE username = $1::varchar")
                    .bind(username.clone())
            }
            UserIdent::Email(email) => {
                sqlx::query_as::<_, User>("SELECT * FROM users WHERE email = $1::varchar")
                    .bind(email.clone())
            }
            UserIdent::UsernameOrEmail(username_or_email) => sqlx::query_as::<_, User>(
                "SELECT * FROM users WHERE username = $1::varchar OR email = $1::varchar",
            )
            .bind(username_or_email.clone()),
        }
    }
}

impl Deletable for UserIdent {
    fn delete(&self) -> PgQuery {
        match self {
            UserIdent::Id(id) => sqlx::query("DELETE FROM users WHERE id = $1").bind(id.clone()),
            UserIdent::Username(username) => {
                sqlx::query("DELETE FROM users WHERE username = $1::varchar").bind(username.clone())
            }
            UserIdent::Email(email) => {
                sqlx::query("DELETE FROM users WHERE email = $1::varchar").bind(email.clone())
            }
            UserIdent::UsernameOrEmail(username_or_email) => {
                sqlx::query("DELETE FROM users WHERE username = $1::varchar OR email = $1::varchar")
                    .bind(username_or_email.clone())
            }
        }
    }
}
