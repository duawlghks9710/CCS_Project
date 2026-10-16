# A. 센싱 — 임베디드 오염 모니터링 (전자정보시스템공학)

## 목표
저전력 IoT 센서 노드로 대상지의 토양/지하수 오염물질 농도를 실시간 측정하고,
edge에서 1차 이상탐지를 수행하여 Supabase `sensor_readings` 테이블로 전송한다.

## 할 일 (2주차)
- [ ] 측정 대상 오염물질 확정 (중금속 이온 전극 / pH / 전기전도도 등)
- [ ] MCU·통신모듈 선정 (ESP32 + LoRa/NB-IoT), 전력예산 계산
- [ ] edge 이상탐지 로직 설계 (임계값 기반 or 경량 ML)
- [ ] Supabase REST API로 센서값 upsert하는 펌웨어/게이트웨이 코드 작성

## 산출물
- `firmware/` : 센서 노드 펌웨어 코드
- `power_budget.md` : 전력예산 계산서 (서브시스템 D 입력값)
- Supabase `sensor_readings` 테이블에 실측/시뮬레이션 데이터 적재

## 인터페이스 (출력 → B)
`sensor_readings(site_id, node_id, pollutant, concentration_ppm, measured_at, lat, lon)`
