use crate::{
    db::store::Store,
    errors::RResult,
    models::user::{CreateUser, GetUsers, UpdateUser, User, UserIdent, UsersResponse},
};

pub struct UsersRouter;

impl UsersRouter {
    pub fn new(store: Store) -> axum::Router {
        let store = axum::extract::Extension(store);
        axum::Router::new()
            .route("/users", axum::routing::get(get_users))
            .route("/users", axum::routing::post(create_user))
            .route("/users/:id", axum::routing::get(get_user))
            .route("/users/:id", axum::routing::put(update_user))
            .route("/users/:id", axum::routing::delete(delete_user))
            .layer(store)
    }
}

pub async fn get_users(
    params: axum::extract::Query<GetUsers>,
    axum::Extension(store): axum::extract::Extension<Store>,
) -> RResult<axum::Json<UsersResponse>> {
    tracing::info!("Getting users: {:?}", params);
    let users = store.users.get_users().await?;
    Ok(axum::response::Json(users.into()))
}

pub async fn get_user(
    axum::extract::Path(id): axum::extract::Path<i32>,
    axum::Extension(store): axum::extract::Extension<Store>,
) -> RResult<axum::Json<User>> {
    tracing::info!("Getting User: {}", id);
    let user = store.users.get_user(UserIdent::Id(id)).await?;
    if let None = user {
        tracing::error!("User not found: {}", id);
        return Err(crate::errors::RError::NotFound(
            "User".into(),
            "id".into(),
            id.to_string(),
        ));
    }
    Ok(axum::response::Json(user.unwrap()))
}

pub async fn create_user(
    axum::Extension(store): axum::extract::Extension<Store>,
    axum::extract::Json(user): axum::extract::Json<CreateUser>,
) -> RResult<axum::Json<crate::models::user::User>> {
    tracing::info!("Creating User: {:?}", user);
    let user_res = store.users.create_user(user).await?;
    Ok(axum::response::Json(user_res))
}

pub async fn update_user(
    axum::extract::Path(id): axum::extract::Path<i32>,
    axum::Extension(store): axum::extract::Extension<Store>,
    axum::extract::Json(user): axum::extract::Json<UpdateUser>,
) -> RResult<axum::Json<crate::models::user::User>> {
    tracing::info!("Updating User: {} - with: {:?}", id, user);
    let user_res = store.users.update_user(UserIdent::Id(id), user).await?;
    Ok(axum::response::Json(user_res))
}

pub async fn delete_user(
    axum::extract::Path(id): axum::extract::Path<i32>,
    axum::Extension(store): axum::extract::Extension<Store>,
) -> RResult<axum::Json<()>> {
    tracing::info!("Deleting User: {}", id);
    store.users.delete_user(UserIdent::Id(id)).await?;
    Ok(axum::response::Json(()))
}
