pub mod endpoints;
pub mod pg;

#[tokio::main]
async fn main() -> tide::Result<()> {
    // let mut app = tide::new();
    // app.at("/").get(endpoints::select);
    // app.listen("localhost:8080").await?;
    let res = pg::test_db().await;
    println!("{:?}", res);
    Ok(())
}
