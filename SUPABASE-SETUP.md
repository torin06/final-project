# Supabase 설정 가이드

## 📋 개요
이 웹사이트는 Supabase를 사용하여 다음 데이터를 자동으로 저장합니다:
- **룰렛 돌린 횟수**: 사용자가 점심 메뉴를 몇 번 뽑았는지
- **룰렛 결과**: 매번 뽑힌 메뉴
- **방문 시간**: 사용자가 사이트에 머문 시간

---

## 🚀 Supabase 설정 단계

### 1단계: Supabase 프로젝트 생성
1. [Supabase](https://supabase.com)에 방문하여 회원가입/로그인
2. **New Project** 클릭
3. 프로젝트 정보 입력:
   - **Name**: `lunch-roulette` (또는 원하는 이름)
   - **Database Password**: 안전한 비밀번호 설정
   - **Region**: `Asia Pacific (Singapore)` 선택
4. **Create new project** 클릭 (프로젝트 생성에 약 2-5분 소요)

### 2단계: API 키 복사
1. 프로젝트 대시보드에서 **Settings** (⚙️) > **API** 클릭
2. 다음 정보를 복사:
   - **Project URL** (SUPABASE_URL)
   - **anon public** 키 (SUPABASE_ANON_KEY)

### 3단계: 데이터베이스 테이블 생성
1. Supabase 대시보드에서 **SQL Editor** 클릭
2. **New Query** 클릭
3. `supabase-setup.sql` 파일의 코드를 붙여넣기
4. **Run** 클릭 (또는 Ctrl+Enter)
5. 성공 메시지가 표시되면 완료!

### 4단계: Vercel 환경변수 설정

웹사이트는 런타임에 `/api/config` 엔드포인트에서 환경변수를 로드합니다.

#### 로컬 개발 환경:
1. 프로젝트 루트에 `.env` 파일 생성
2. 다음 내용 입력:
```
VITE_SUPABASE_URL=https://xxxxxxxxxxxx.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

#### Vercel 배포:
1. [Vercel 대시보드](https://vercel.com) > 프로젝트 선택
2. **Settings** > **Environment Variables** 클릭
3. 다음 두 변수 추가:
   - **Name**: `VITE_SUPABASE_URL`
   - **Value**: Supabase 프로젝트 URL
   - **Name**: `VITE_SUPABASE_ANON_KEY`
   - **Value**: Supabase 익명 공개 키
4. **Save** 클릭
5. 프로젝트 재배포 (`git push` 또는 Vercel 대시보드에서 Redeploy)

> ✅ **보안**: API 엔드포인트(`/api/config`)에서 환경변수를 관리하므로, 민감한 정보를 소스 코드에 하드코딩하지 않습니다.

---

## 📊 데이터 확인

### Supabase에서 데이터 확인하기:
1. Supabase 대시보드 > **Table Editor** 클릭
2. `sessions` 또는 `roulette_spins` 테이블 선택
3. 저장된 데이터 확인

### 테이블 구조:

**sessions 테이블** (사용자 세션):
| 열 | 설명 |
|---|---|
| id | 고유 ID |
| session_id | 세션 ID |
| start_time | 방문 시작 시간 |
| end_time | 방문 종료 시간 |
| duration_minutes | 머문 시간 (분) |

**roulette_spins 테이블** (룰렛 실행 기록):
| 열 | 설명 |
|---|---|
| id | 고유 ID |
| session_id | 세션 ID |
| menu | 뽑힌 메뉴 |
| spin_count | 룰렛 돌린 순서 |
| spun_at | 실행 시간 |

---

## 🔧 아키텍처

이 프로젝트는 보안 및 환경 분리를 위해 다음 구조를 사용합니다:

```
index.html (클라이언트)
    ↓
/api/config.js (Vercel API 엔드포인트)
    ↓
process.env.VITE_SUPABASE_URL
process.env.VITE_SUPABASE_ANON_KEY
```

**장점:**
- ✅ 환경변수가 소스 코드에 하드코딩되지 않음
- ✅ 프라이빗/퍼블릭 저장소 모두 안전
- ✅ Vercel 자동 배포 지원
- ✅ 로컬 개발과 프로덕션 환경 분리

---

## 🔧 환경 변수 설정 (선택사항)

보안을 위해 `.env` 파일 사용 권장:

1. 프로젝트 루트에 `.env` 파일 생성:
```
VITE_SUPABASE_URL=https://xxxxxxxxxxxx.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

2. `.gitignore`에 추가 (이미 포함되어 있을 수 있음):
```
.env
.env.local
```

---

## ✅ 테스트하기

### 로컬 환경:
1. `.env` 파일에 Supabase 설정 입력
2. 로컬 서버 실행:
```bash
npx http-server .
```
3. http://localhost:8080 접속
4. 브라우저 콘솔 확인 (F12 > Console)
5. "✅ Supabase 초기화 완료" 메시지 확인

### Vercel 배포:
1. Vercel 환경변수 설정 완료
2. `git push`로 배포
3. 브라우저 개발자 도구 Network 탭에서:
   - `GET /api/config` 요청 확인
   - 상태 코드 200 확인
4. Console 탭에서 성공 메시지 확인

---

## 🐛 문제 해결

### "Failed to load config: 400" 에러
- ✓ Vercel 환경변수가 설정되었는지 확인
- ✓ `VITE_SUPABASE_URL`과 `VITE_SUPABASE_ANON_KEY` 모두 설정되었는지 확인
- ✓ 배포 후 재시작 필요

### "Supabase 초기화 실패" 에러
- ✓ 환경변수 값이 올바른지 확인
- ✓ Supabase 프로젝트가 활성화되었는지 확인
- ✓ RLS 정책이 올바르게 설정되었는지 확인

### 데이터가 저장되지 않음
- ✓ Vercel 환경변수 설정 확인
- ✓ `/api/config` 엔드포인트 동작 확인 (Network 탭)
- ✓ Supabase 대시보드의 Logs 탭 확인

---

## 📚 참고 자료
- [Supabase 공식 문서](https://supabase.com/docs)
- [Supabase JavaScript 클라이언트](https://supabase.com/docs/reference/javascript/introduction)
