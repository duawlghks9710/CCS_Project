# Supabase 설정

## 프로젝트 정보
- 프로젝트명: `ccs-project`
- 리전: `ap-northeast-2` (서울)
- URL: `https://mbeketfidinzfzhcgaqv.supabase.co`
- API Key(anon/publishable): **팀원에게 개별 전달, 절대 git에 커밋하지 않음**
  (받는 방법: 팀장이 Supabase 대시보드 → Project Settings → API Keys에서 공유)

## 스키마
`integration/dss_dashboard/schema.sql`에 정의된 9개 테이블이 이미 프로젝트에 적용되어
있습니다: `sites`, `sensor_nodes`, `sensor_readings`, `toxicity_scenarios`,
`toxicity_results`, `resin_experiments`, `adsorption_isotherms`, `energy_demand`,
`mcda_scores`.

## ⚠️ 보안 — Row Level Security (RLS) 미설정 상태

**현재 9개 테이블 모두 RLS(행 단위 보안)가 꺼져 있습니다.** 이 상태에서는
anon/publishable API 키만 있으면 **누구나 전체 테이블을 읽고 쓸 수 있습니다.**
팀 내부 개발 단계에서는 편의상 꺼둔 상태이지만, 아래 중 하나는 반드시 적용하세요.

### 옵션 1 — 개발 중에는 꺼둔 채로, 키를 외부에 노출하지 않기
- `.env` 파일을 `.gitignore`에 반드시 유지 (이미 설정됨)
- API 키를 깃허브 이슈/커밋/공개 문서에 절대 붙여넣지 않기

### 옵션 2 (권장, 발표 전 적용) — RLS 활성화 + 팀 전용 정책
```sql
alter table sites enable row level security;
alter table sensor_nodes enable row level security;
alter table sensor_readings enable row level security;
alter table toxicity_scenarios enable row level security;
alter table toxicity_results enable row level security;
alter table resin_experiments enable row level security;
alter table adsorption_isotherms enable row level security;
alter table energy_demand enable row level security;
alter table mcda_scores enable row level security;

-- 가장 단순한 팀 전용 정책 예시(인증된 사용자만 전체 접근 허용)
create policy "authenticated_full_access" on sites
    for all using (auth.role() = 'authenticated');
-- 나머지 8개 테이블도 동일하게 반복 (테이블명만 교체)
```
실제 서비스로 외부 공개할 계획이 없는 1개월짜리 팀 프로젝트이므로, 최소한
"인증된 사용자만 접근 가능" 수준의 정책으로도 충분합니다. 발표/제출 전에는
반드시 적용을 권장합니다.

## 클라이언트 연결 예시 (Python)
```python
from supabase import create_client
import os

url = os.environ["SUPABASE_URL"]
key = os.environ["SUPABASE_PUBLISHABLE_KEY"]
supabase = create_client(url, key)

# 예: 센서 데이터 삽입 (A팀)
supabase.table("sensor_readings").insert({
    "site_id": "<site_uuid>",
    "pollutant": "Pb",
    "concentration_ppm": 12.4,
}).execute()
```
