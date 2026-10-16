# 시스템 아키텍처

## 데이터 흐름

```
[A. 센서 노드]                [B. 독성 모델]              [C. 정화 설계]           [D. 에너지 설계]
 토양/지하수 오염도   ──►   기후 시나리오별    ──►   필요 정화용량       ──►   설비 전력수요
 실시간 측정                위해도 환산                (이온교환수지)            PV/ESS sizing
     │                          │                         │                       │
     ▼                          ▼                         ▼                       ▼
 sensor_readings          toxicity_results         resin_experiments      energy_demand /
                                                    adsorption_isotherms   energy_supply_scenarios
     └──────────────────────────┴─────────────────────────┴───────────────────────┘
                                             ▼
                                   [통합 DSS 대시보드]
                                   mcda_scores (다기준의사결정)
```

## 서브시스템 간 인터페이스

| From → To | 전달 데이터 | 포맷 |
|---|---|---|
| A → B | 오염물질 농도(ppm), 측정시각, 위치 | JSON / Supabase `sensor_readings` |
| B → C | 기후 시나리오별 위해도 점수, 목표 정화농도 | Supabase `toxicity_results` |
| C → D | 정화설비 종류·용량·가동시간 | Supabase `resin_experiments` (capacity 필드) |
| D → 통합 | 설비별 소요전력, 자립 가능 여부 | Supabase `energy_demand` |
| A,B,C,D → 통합 | 전체 결과 | `mcda_scores`에서 가중합산 |

## 기술 스택

- **버전관리**: GitHub (`duawlghks9710/CCS_Project`), 브랜치 전략은 README 참고
- **데이터베이스**: Supabase (PostgreSQL + REST/Realtime API)
- **서브시스템 A**: C/C++ (Arduino/ESP32) 또는 MicroPython — 센서 펌웨어
- **서브시스템 B**: Python (RDKit, scikit-learn, OECD QSAR 참고)
- **서브시스템 C**: Python (lmfit, numpy) — 흡착등온선 피팅
- **서브시스템 D**: Python 또는 Excel/PVsyst — 에너지 시뮬레이션
- **통합 대시보드**: Python(Streamlit/Dash) 또는 웹(React) — Supabase에서 직접 조회

## 네이밍 규칙

- 브랜치: `feature/<subsystem>-<설명>` (예: `feature/B-toxicology-qsar-model`)
- 커밋 메시지: `[subsystem] 작업내용` (예: `[C] Langmuir isotherm fitting 추가`)
- 데이터 테이블: 영문 snake_case, 상세는 `integration/dss_dashboard/schema.sql`
