-- CCS_Project 통합 DSS 데이터베이스 스키마
-- Supabase(PostgreSQL)에 적용. 각 테이블은 담당 서브시스템이 적재/조회한다.

create table if not exists sites (
    site_id      uuid primary key default gen_random_uuid(),
    name         text not null,
    description  text,
    lat          double precision,
    lon          double precision,
    created_at   timestamptz not null default now()
);

-- A. 센싱 -------------------------------------------------------------
create table if not exists sensor_nodes (
    node_id      uuid primary key default gen_random_uuid(),
    site_id      uuid not null references sites(site_id) on delete cascade,
    node_name    text not null,
    mcu_type     text,
    power_budget_mw double precision,
    lat          double precision,
    lon          double precision,
    created_at   timestamptz not null default now()
);

create table if not exists sensor_readings (
    reading_id        bigint generated always as identity primary key,
    site_id           uuid not null references sites(site_id) on delete cascade,
    node_id           uuid references sensor_nodes(node_id) on delete set null,
    pollutant         text not null,
    concentration_ppm double precision not null,
    measured_at       timestamptz not null default now(),
    is_anomaly        boolean default false
);

-- B. 독성/리스크 -------------------------------------------------------
create table if not exists toxicity_scenarios (
    scenario_id   uuid primary key default gen_random_uuid(),
    scenario_name text not null,          -- 예: SSP2-4.5, SSP5-8.5
    temperature_c double precision not null,
    description   text
);

create table if not exists toxicity_results (
    result_id                 bigint generated always as identity primary key,
    site_id                   uuid not null references sites(site_id) on delete cascade,
    scenario_id               uuid not null references toxicity_scenarios(scenario_id) on delete cascade,
    pollutant                 text not null,
    risk_score                double precision not null,   -- 0~1 정규화
    target_concentration_ppm  double precision,             -- 정화 목표 농도
    computed_at               timestamptz not null default now()
);

-- C. 정화(이온교환수지) --------------------------------------------------
create table if not exists resin_experiments (
    experiment_id      uuid primary key default gen_random_uuid(),
    site_id             uuid not null references sites(site_id) on delete cascade,
    resin_type          text not null,
    synthesis_condition jsonb,              -- 합성 조건(온도, 시간, 비율 등)
    capacity_kg         double precision,    -- 설계 정화용량
    required_power_kw   double precision,    -- 운영 소요전력 (→ D 입력)
    operating_hours     double precision,
    created_at          timestamptz not null default now()
);

create table if not exists adsorption_isotherms (
    point_id        bigint generated always as identity primary key,
    experiment_id   uuid not null references resin_experiments(experiment_id) on delete cascade,
    equilibrium_conc_ppm double precision not null,  -- Ce
    adsorbed_amount_mg_g double precision not null,  -- qe
    model_type      text,  -- 'langmuir' | 'freundlich'
    fitted_params   jsonb
);

-- D. 에너지 자립 ---------------------------------------------------------
create table if not exists energy_demand (
    demand_id             uuid primary key default gen_random_uuid(),
    site_id               uuid not null references sites(site_id) on delete cascade,
    total_demand_kw       double precision not null,
    pv_capacity_kw        double precision,
    ess_capacity_kwh      double precision,
    self_sufficiency_pct  double precision,   -- 제로에너지 달성률
    computed_at           timestamptz not null default now()
);

-- 통합 — MCDA -------------------------------------------------------------
create table if not exists mcda_scores (
    score_id         bigint generated always as identity primary key,
    site_id          uuid not null references sites(site_id) on delete cascade,
    scenario_label   text not null,         -- 정화공법/시나리오 조합 이름
    risk_reduction_score double precision,  -- B 기반
    cost_score            double precision, -- C 기반
    energy_self_sufficiency_score double precision, -- D 기반
    total_score      double precision,      -- 가중합산 결과
    weights           jsonb,                -- 사용된 가중치 기록
    computed_at       timestamptz not null default now()
);

-- 인덱스
create index if not exists idx_sensor_readings_site_time on sensor_readings(site_id, measured_at);
create index if not exists idx_toxicity_results_site on toxicity_results(site_id, scenario_id);
create index if not exists idx_resin_experiments_site on resin_experiments(site_id);
