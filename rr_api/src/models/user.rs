use crate::db::pg::{Deletable, PgQuery, PgQueryAs, Selectable};

pub type PgUserQueryAs<'a> =
    sqlx::query::QueryAs<'a, sqlx::Postgres, User, sqlx::postgres::PgArguments>;

#[derive(sqlx::Type, sqlx::FromRow)]
pub struct CreateUser {
    pub username: String,
    pub email: String,
    pub password: String,
}

#[derive(sqlx::Type, sqlx::FromRow, Default)]
pub struct UpdateUser {
    pub username: Option<String>,
    pub email: Option<String>,
    pub password: Option<String>,
    pub full_name: Option<String>,
    pub phone: Option<String>,
}

#[derive(sqlx::Type, sqlx::FromRow, Default)]
pub struct User {
    pub id: i32,
    pub username: String,
    pub password: String,
    pub full_name: String,
    pub email: String,
    pub phone: String,
    pub created_at: String,
    pub updated_at: String,
}

impl User {
    pub fn new(
        id: i32,
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
            created_at: created_at.into(),
            updated_at: updated_at.into(),
        }
    }
}

pub enum UserIdent {
    Id(i32),
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
