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
            .route("/scenario/:id", axum::routing::get(get_scenario))
            .route("/scenario/:id", axum::routing::put(update_scenario))
            .route("/scenario/:id", axum::routing::delete(delete_scenario))
            .route("/additional", axum::routing::get(get_possible_downloads))
            .layer(store)
    }
}

pub async fn get_scenarios(
    params: axum::extract::Query<GetScenarios>,
    axum::Extension(store): axum::Extension<Store>,
) -> RResult<axum::Json<ScenariosResponse>> {
    tracing::info!("Getting scenarios: {:?}", params);
    let scenarios = store.scenarios.get_scenarios(ScenariosIdent::All).await?;
    Ok(axum::Json(scenarios.into()))
}

pub async fn create_scenario(
    axum::extract::Extension(store): axum::extract::Extension<Store>,
    axum::extract::Json(scenario): axum::extract::Json<CreateScenario>,
) -> RResult<axum::Json<Scenario>> {
    tracing::info!("Creating Scenario: {:?}", scenario);
    let scenario_res = store.scenarios.create_scenario(scenario).await?;
    Ok(axum::Json(scenario_res))
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
    Ok(axum::Json(scenario.unwrap()))
}

pub async fn update_scenario(
    axum::extract::Path(id): axum::extract::Path<i64>,
    axum::extract::Extension(store): axum::extract::Extension<Store>,
    axum::extract::Json(scenario): axum::extract::Json<UpdateScenario>,
) -> RResult<axum::Json<Scenario>> {
    tracing::info!("Updating Scenario: {}", id);
    let scenario = store.scenarios.update_scenario(id, scenario).await?;
    Ok(axum::Json(scenario))
}

pub async fn delete_scenario(
    axum::extract::Path(id): axum::extract::Path<i64>,
    axum::extract::Extension(store): axum::extract::Extension<Store>,
) -> RResult<axum::Json<()>> {
    tracing::info!("Deleting Scenario: {}", id);
    store.scenarios.delete_scenario(id).await?;
    Ok(axum::Json(()))
}

pub async fn get_possible_downloads(
    axum::extract::Extension(store): axum::extract::Extension<Store>,
) -> RResult<axum::Json<ScenariosResponse>> {
    tracing::info!("Getting possible downloads");
    let scenarios = store
        .scenarios
        .get_scenarios(ScenariosIdent::Downloadable)
        .await?;
    Ok(axum::Json(scenarios.into()))
}
