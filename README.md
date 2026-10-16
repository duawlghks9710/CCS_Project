# CCS_Project — 기후변화 대응형 제로에너지 자율 모니터링·정화 통합 DSS

CCS자연기반해법(NbS) 과제 — **착수 트랙 ①: 브라운필드 의사결정지원시스템(DSS)**

오염 부지(브라운필드)의 "센싱 → 독성 리스크 평가 → 정화 → 에너지 자립"을 하나의
파이프라인으로 연결하는 통합 DSS를 4개 전공이 협업하여 1개월 내 개발합니다.

## 팀 구성 및 서브시스템

| Layer | 폴더 | 담당 전공 | 역할 |
|---|---|---|---|
| A. 센싱 | [`subsystems/A_sensing_embedded`](subsystems/A_sensing_embedded) | 전자정보시스템공학(임베디드) | 저전력 IoT 센서로 토양·지하수 오염 실시간 모니터링 |
| B. 리스크 | [`subsystems/B_toxicology_model`](subsystems/B_toxicology_model) | 생명과학(분자독성학) | 기후변화(온도) 시나리오별 오염물질 독성 변화 예측 |
| C. 정화 | [`subsystems/C_resin_purification`](subsystems/C_resin_purification) | 그린화학공학(이온교환수지) | 중금속/유류 오염 지하수 정화용 이온교환수지 합성·흡착성능 최적화 |
| D. 에너지 | [`subsystems/D_zero_energy`](subsystems/D_zero_energy) | 에너지그리드학(제로에너지) | 센서·정화 설비 전력수요 시뮬레이션, PV/ESS sizing |

최종 산출물은 [`integration/dss_dashboard`](integration/dss_dashboard)에서 4개 서브시스템의
출력을 MCDA(다기준의사결정) 매트릭스로 통합합니다.

## 폴더 구조

```
CCS_Project/
├── docs/                      # 과제 기획·회의록·주차별 보고서
│   ├── 00_project_charter.md  # 과제 개요, 대상지, 문제정의, 유의사항
│   ├── 01_architecture.md     # 전체 시스템 아키텍처 및 데이터 흐름
│   └── weekly/                # 주차별 진행 보고 (week1~4)
├── subsystems/
│   ├── A_sensing_embedded/    # 임베디드 센서 펌웨어·사양
│   ├── B_toxicology_model/    # 독성 QSAR 모델링 코드
│   ├── C_resin_purification/  # 이온교환수지 합성·흡착 실험·피팅
│   └── D_zero_energy/         # 에너지 수요-공급 시뮬레이션
├── integration/
│   └── dss_dashboard/         # 4개 서브시스템 통합 대시보드/MCDA
├── data/
│   ├── raw/                   # 원본 데이터 (공공데이터, 센서로그 등)
│   └── processed/             # 전처리된 데이터
└── .github/
    └── ISSUE_TEMPLATE/        # 이슈 템플릿 (작업요청/버그/실험결과)
```

## 데이터 백엔드 (Supabase)

실시간 센서 데이터, 독성 모델 결과, 수지 실험 데이터, 에너지 시뮬레이션 결과는
Supabase(PostgreSQL)에 저장합니다. 스키마는 `docs/01_architecture.md`와
`integration/dss_dashboard/schema.sql` 참고.

## 일정 (4주, 2026-10-19 ~ 2026-11-15)

| 주차 | 내용 |
|---|---|
| 1주차 | 문제정의·대상지 확정, 데이터 수집, 아키텍처 확정 |
| 2주차 | 서브시스템 A/B/C/D 개별 개발 |
| 3주차 | 4개 서브시스템 데이터 파이프라인·대시보드 통합 |
| 4주차 | 검증·민감도 분석, 최종 보고서·발표자료 작성 |

## 브랜치 전략

- `main`: 항상 동작하는 통합 버전만 유지
- `feature/A-sensing`, `feature/B-toxicology`, `feature/C-resin`, `feature/D-energy`: 서브시스템별 개발 브랜치
- `feature/integration`: 통합 대시보드 개발 브랜치
- 각자 자신의 `feature/*` 브랜치에서 작업 후 PR로 `main`에 병합 (리뷰 1인 이상 권장)

## 담당자 유의사항 (원 발표자료 기준)

- **LLM 활용은 추출·코딩·설명 한정, 창장 원자료 정보보완청구 착수 주 실시**
- 애로사항·산출물 형식 공유 체계는 `docs/weekly/`에 주차별로 기록
