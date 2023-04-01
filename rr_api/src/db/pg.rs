pub type PgQuery = sqlx::query::Query<'static, sqlx::Postgres, sqlx::postgres::PgArguments>;
pub type PgQueryAs<'a, T> =
    sqlx::query::QueryAs<'a, sqlx::Postgres, T, sqlx::postgres::PgArguments>;

pub trait Selectable {
    type Output;

    fn select<'a>(&self) -> PgQueryAs<'a, Self::Output>;
}

pub trait Insertable {
    fn insert(&self) -> PgQuery;
}

pub trait Updatable {
    fn update(&self) -> PgQuery;
}

pub trait Deletable {
    fn delete(&self) -> PgQuery;
}

pub trait Crud: Selectable + Insertable + Updatable + Deletable {}

pub trait ToQuery {
    fn to_query(&self) -> PgQuery;
}

pub struct SelectOptions {
    pub limit: Option<SelectOption>,
    pub offset: Option<SelectOption>,
}

impl std::fmt::Display for SelectOptions {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let mut options = vec![];
        if let Some(limit) = &self.limit {
            options.push(limit.to_string());
        }
        if let Some(offset) = &self.offset {
            options.push(offset.to_string());
        }
        write!(f, "{}", options.join(" "))
    }
}

pub enum SelectOption {
    Limit(i64),
    Offset(i64),
}

impl std::fmt::Display for SelectOption {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            SelectOption::Limit(limit) => write!(f, "LIMIT {}", limit),
            SelectOption::Offset(offset) => write!(f, "OFFSET {}", offset),
        }
    }
}
