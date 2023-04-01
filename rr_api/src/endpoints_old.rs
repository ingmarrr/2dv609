pub async fn select(req: tide::Request<()>) -> tide::Result<tide::Response> {
    let res = tide::Response::builder(200)
        .body("<h1>Hey, Im getting the stuff!</h1>")
        .content_type(tide::http::mime::HTML)
        .build();
    Ok(res)
}
