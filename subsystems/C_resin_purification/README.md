# C. 정화 — 이온교환수지 합성 (그린화학공학)

## 목표
B팀이 산출한 목표 정화농도를 달성하기 위해 필요한 이온교환수지를 합성·특성분석하고,
흡착등온선/동역학 모델을 피팅하여 소요 정화용량을 산정한다.

## 할 일 (2주차)
- [ ] 대상 오염물질(중금속 등)에 맞는 수지 조성 설계
- [ ] 합성 실험 (FT-IR, BET 특성분석)
- [ ] 흡착등온선(Langmuir/Freundlich) 및 동역학 데이터 수집·피팅 (Python lmfit)
- [ ] 목표 정화농도 대비 필요 수지량·설비 규모 산정

## 산출물
- `experiments/` : 실험 데이터 및 피팅 스크립트
- Supabase `resin_experiments`, `adsorption_isotherms` 테이블 적재

## 인터페이스
- 입력 (B ← ): `toxicity_results.target_concentration_ppm`
- 출력 (→ D): `resin_experiments(site_id, resin_type, capacity_kg, required_power_kw, operating_hours)`
