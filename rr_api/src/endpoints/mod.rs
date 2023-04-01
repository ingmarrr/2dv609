// use axum::extract::FromRequest;
// use serde::de::DeserializeOwned;

// use crate::errors::RError;

pub mod scenario_eps;
pub mod user_eps;

// #[derive(Debug, Clone, Copy, Default)]
// pub struct JsonExtractor<T>(pub T);

// #[async_trait::async_trait]
// impl<T, B> FromRequest<B> for JsonExtractor<T>
// where
//     T: DeserializeOwned + Send,
//     B: Send + Sync + 'static,
//     B::Data: Send,
//     B::Error: Into<BoxError>,
// {
//     type Rejection = RError;

//     async fn from_request(
//         req: *mut axum::extract::RequestParts<B>,
//     ) -> Result<Self, Self::Rejection> {
//         let axum::Json(body) = axum::extract::Json::<T>::from_request(req).await?;
//         Ok(JsonExtractor(body))
//     }
// }
