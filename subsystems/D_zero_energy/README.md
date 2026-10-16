# D. 에너지 자립 — 제로에너지 설계 (에너지그리드학)

## 목표
A(센서망)와 C(정화설비)의 전력수요를 합산하고, PV/ESS 용량을 sizing하여
해당 설비군이 외부 전력 없이 자립 운영 가능한 제로에너지 설계를 제시한다.

## 할 일 (2주차)
- [ ] A, C로부터 전력예산/소요전력 데이터 수집
- [ ] 일사량·부지 조건 기반 PV 발전량 시뮬레이션
- [ ] ESS 용량 sizing (피크 대응, 야간 운영 포함)
- [ ] 제로에너지 달성률(ZEB 지수) 계산

## 산출물
- `energy_sim/` : 에너지 시뮬레이션 코드/모델 (EnergyPlus, PVsyst 또는 자체 Python 모델)
- Supabase `energy_demand`, `energy_supply_scenarios` 테이블 적재

## 인터페이스
- 입력 (A, C ← ): 전력예산, `resin_experiments.required_power_kw`
- 출력 (→ 통합): `energy_demand(site_id, total_demand_kw, pv_capacity_kw, ess_capacity_kwh, self_sufficiency_pct)`
