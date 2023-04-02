use crate::{
    db::pg::Selectable,
    models::user::{CreateUser, UpdateUser, User, UserIdent},
};
use std::sync::Arc;

pub type DynUserRepo = Arc<dyn UserRepo + Send + Sync>;

#[async_trait::async_trait]
pub trait UserRepo {
    async fn get_user(&self, by: UserIdent) -> anyhow::Result<Option<User>>;
    async fn get_users(&self) -> anyhow::Result<Vec<User>>; // TODO: Add selection (by username, email, etc.
    async fn create_user(&self, user: CreateUser) -> anyhow::Result<User>;
    async fn update_user(&self, who: UserIdent, data: UpdateUser) -> anyhow::Result<User>;
    async fn delete_user(&self, by: UserIdent) -> anyhow::Result<()>;
    async fn login_user(&self, by: UserIdent, password: String) -> anyhow::Result<Option<User>>;
}

pub struct PgUserRepo {
    client: sqlx::postgres::PgPool,
}

impl PgUserRepo {
    pub fn new(client: sqlx::postgres::PgPool) -> Self {
        Self { client }
    }
}

#[async_trait::async_trait]
impl UserRepo for PgUserRepo {
    async fn get_user(&self, by: UserIdent) -> anyhow::Result<Option<User>> {
        let user = by.select().fetch_optional(&self.client).await?;
        Ok(user)
    }

    async fn get_users(&self) -> anyhow::Result<Vec<User>> {
        let rows = sqlx::query_as::<_, User>("SELECT * FROM users;")
            .fetch_all(&self.client)
            .await?;
        tracing::info!("Found {} users.", rows.len());
        Ok(rows)
    }

    async fn create_user(&self, user: CreateUser) -> anyhow::Result<User> {
        let maybe_username = self
            .get_user(UserIdent::Username(user.username.clone()))
            .await?;
        let maybe_email = self.get_user(UserIdent::Email(user.email.clone())).await?;

        if let Some(_) = maybe_username {
            return Err(anyhow::anyhow!("Username already taken"));
        }

        if let Some(_) = maybe_email {
            return Err(anyhow::anyhow!("Email already taken"));
        }

        let user = sqlx::query_as::<_, User>(
            "INSERT INTO users (username, email, password) VALUES ($1::varchar, $2::varchar, $3::varchar) RETURNING *;"
        )
        .bind(user.username)
        .bind(user.email)
        .bind(user.password)
        .fetch_one(&self.client)
        .await?;
        Ok(user)
    }

    async fn update_user(&self, who: UserIdent, data: UpdateUser) -> anyhow::Result<User> {
        let user = who.select().fetch_optional(&self.client).await?;
        if let Some(u) = user {
            let out = sqlx::query_as::<_, User>(
                "UPDATE users SET username = $1, email = $2, password = $3 WHERE id = $4 RETURNING *;"
            )
            .bind(data.username.unwrap_or(u.username))
            .bind(data.email.unwrap_or(u.email))
            .bind(data.password.unwrap_or(u.password))
            .bind(u.id)
            .fetch_one(&self.client)
            .await?;
            Ok(out)
        } else {
            Err(anyhow::anyhow!("User not found"))
        }
    }

    async fn delete_user(&self, by: UserIdent) -> anyhow::Result<()> {
        let user = by.select().fetch_optional(&self.client).await?;
        if let Some(u) = user {
            sqlx::query("DELETE FROM users WHERE id = $1")
                .bind(u.id)
                .execute(&self.client)
                .await?;
            Ok(())
        } else {
            Err(anyhow::anyhow!("User not found"))
        }
    }

    async fn login_user(&self, by: UserIdent, password: String) -> anyhow::Result<Option<User>> {
        tracing::info!("Checking ident.");
        let user = by.select().fetch_optional(&self.client).await?;
        if let Some(u) = user {
            tracing::info!("Checking password.");
            if u.password == password {
                return Ok(Some(u));
            }
        }
        Err(anyhow::anyhow!("Invalid credentials"))
    }
}
