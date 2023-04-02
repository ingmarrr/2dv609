pub type RResult<T> = Result<T, RError>;

#[derive(thiserror::Error, Debug)]
pub enum RError {
    #[error("Did not find {0} with {1} = {2}")]
    NotFound(String, String, String),
    #[error("{0}: {1} already exists.")]
    AlreadyExists(String, String),
    #[error(transparent)]
    Anyhow(#[from] anyhow::Error),
    #[error(transparent)]
    AxumJsonRejection(#[from] axum::extract::rejection::JsonRejection),
}

impl axum::response::IntoResponse for RError {
    fn into_response(self) -> axum::response::Response {
        let (status, msg) = match self {
            RError::NotFound(what, param, value) => (
                axum::http::StatusCode::NOT_FOUND,
                format!("Did not find {} with {} = {}", what, param, value),
            ),
            RError::Anyhow(err) => (
                axum::http::StatusCode::INTERNAL_SERVER_ERROR,
                err.to_string(),
            ),
            RError::AxumJsonRejection(err) => {
                (axum::http::StatusCode::BAD_REQUEST, err.to_string())
            }
            RError::AlreadyExists(what, value) => (
                axum::http::StatusCode::CONFLICT,
                format!("{}: {} already exists.", what, value),
            ),
        };

        axum::response::Response::builder()
            .status(status)
            .body(msg)
            .unwrap()
            .into_response()
    }
}
