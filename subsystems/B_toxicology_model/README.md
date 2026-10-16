# B. 리스크 평가 — 분자독성학 (생명과학)

## 목표
기후변화(온도 상승) 시나리오별로 센서가 측정한 오염물질의 독성 변화를 QSAR 기반으로
예측하고, 위해도 점수를 산출하여 서브시스템 C(정화설계)의 입력으로 전달한다.

## 할 일 (2주차)
- [ ] 대상 오염물질 목록 확정 (A팀과 협의)
- [ ] 기후 시나리오(RCP/SSP) 및 온도 구간 설정
- [ ] 온도의존 독성계수 모델 구축 (QSAR Toolbox / T.E.S.T 등 참고)
- [ ] `sensor_readings` → 위해도 점수 환산 파이프라인 작성

## 산출물
- `qsar_model/` : 독성 예측 모델 코드 및 참고 문헌 정리
- Supabase `toxicity_scenarios`, `toxicity_results` 테이블 적재

## 인터페이스
- 입력 (A ← ): `sensor_readings`
- 출력 (→ C): `toxicity_results(site_id, pollutant, scenario_id, risk_score, target_concentration_ppm)`
