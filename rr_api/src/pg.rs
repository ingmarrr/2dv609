use sqlx::Row;
use std::error::Error;

pub async fn test_db() -> Result<(), Box<dyn Error>> {
    println!("test_db() called");
    let url = "postgres://root:root@localhost:5432/sandbox";
    let pool = sqlx::postgres::PgPool::connect(url).await?;
    let res = sqlx::query("SELECT 1 + 1 as num").fetch_one(&pool).await?;

    let sum: i32 = res.try_get("num")?;
    println!("sum: {}", sum);
    Ok(())
}
