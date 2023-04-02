use crate::{
    endpoints::Store,
    errors::RResult,
    models::scenario::{
        CreateScenario, GetScenarios, Scenario, ScenariosIdent, ScenariosResponse, UpdateScenario,
    },
};

pub struct ScenariosRouter;

impl ScenariosRouter {
    pub fn new(store: Store) -> axum::Router {
        let store = axum::extract::Extension(store);
        axum::Router::new()
            .route("/scenarios", axum::routing::get(get_scenarios))
            .route("/scenario", axum::routing::post(create_scenario))
            .route("/scenario:id", axum::routing::get(get_scenario))
            .route("/scenario:id", axum::routing::put(update_scenario))
            .route("/scenario:id", axum::routing::delete(delete_scenario))
            .layer(store)
    }
}

pub async fn get_scenarios(
    params: axum::extract::Query<GetScenarios>,
    axum::Extension(store): axum::Extension<Store>,
) -> RResult<axum::Json<ScenariosResponse>> {
    tracing::info!("Getting scenarios: {:?}", params);
    let scenarios = store.scenarios.get_scenarios(ScenariosIdent::All).await?;
    Ok(axum::response::Json(scenarios.into()))
}

pub async fn create_scenario(
    axum::extract::Extension(store): axum::extract::Extension<Store>,
    axum::extract::Json(scenario): axum::extract::Json<CreateScenario>,
) -> RResult<axum::Json<Scenario>> {
    tracing::info!("Creating Scenario: {:?}", scenario);
    let scenario_res = store.scenarios.create_scenario(scenario).await?;
    Ok(axum::response::Json(scenario_res))
}

pub async fn get_scenario(
    axum::extract::Path(id): axum::extract::Path<i64>,
    axum::Extension(store): axum::extract::Extension<Store>,
) -> RResult<axum::Json<Scenario>> {
    tracing::info!("Getting Scenario: {}", id);
    let scenario = store.scenarios.get_scenario(id).await?;
    if let None = scenario {
        tracing::error!("Scenario not found: {}", 1);
        return Err(crate::errors::RError::NotFound(
            "Scenario".into(),
            "id".into(),
            1.to_string(),
        ));
    }
    Ok(axum::response::Json(scenario.unwrap()))
}

#[axum_macros::debug_handler]
pub async fn update_scenario(
    axum::extract::Path(id): axum::extract::Path<i64>,
    axum::extract::Extension(store): axum::extract::Extension<Store>,
    axum::extract::Json(scenario): axum::extract::Json<UpdateScenario>,
) -> RResult<axum::Json<Scenario>> {
    tracing::info!("Updating Scenario: {}", id);
    let scenario = store.scenarios.update_scenario(id, scenario).await?;
    Ok(axum::response::Json(scenario))
}

pub async fn delete_scenario(
    axum::extract::Path(id): axum::extract::Path<i64>,
    axum::extract::Extension(store): axum::extract::Extension<Store>,
) -> RResult<axum::Json<()>> {
    tracing::info!("Deleting Scenario: {}", id);
    store.scenarios.delete_scenario(id).await?;
    Ok(axum::response::Json(()))
}
