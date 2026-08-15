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

### 4단계: HTML 파일 수정
`index.html` 파일을 열어 다음을 수정:

```javascript
// 현재 코드:
const SUPABASE_URL = 'YOUR_SUPABASE_URL';
const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY';

// 변경:
const SUPABASE_URL = 'https://xxxxxxxxxxxx.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
```

> ⚠️ **주의**: API 키는 공개 저장소에 업로드하지 마세요!
> 프라이빗 저장소를 사용하거나 `.env` 파일로 관리하세요.

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

## 🔧 환경 변수 설정 (선택사항)

보안을 위해 `.env` 파일 사용 권장:

1. 프로젝트 루트에 `.env` 파일 생성:
```
VITE_SUPABASE_URL=https://xxxxxxxxxxxx.supabase.co
VITE_SUPABASE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

2. `index.html`에서 읽기:
```javascript
const SUPABASE_URL = import.meta.env.VITE_SUPABASE_URL;
const SUPABASE_ANON_KEY = import.meta.env.VITE_SUPABASE_KEY;
```

---

## ✅ 테스트하기

1. 웹사이트 열기
2. 브라우저 콘솔 확인 (F12 > Console)
3. "✅ 데이터 저장 완료" 메시지가 보이면 성공!
4. Supabase 대시보드에서 `roulette_spins` 테이블 확인

---

## 🐛 문제 해결

### "Supabase 저장 실패" 에러
- ✓ SUPABASE_URL과 SUPABASE_ANON_KEY가 올바른지 확인
- ✓ 테이블이 생성되었는지 확인
- ✓ RLS 정책이 활성화되었는지 확인

### 데이터가 저장되지 않음
- ✓ 브라우저 개발자 도구(F12)의 Network 탭 확인
- ✓ 콘솔 에러 메시지 확인
- ✓ Supabase 프로젝트의 Logs 탭 확인

---

## 📚 참고 자료
- [Supabase 공식 문서](https://supabase.com/docs)
- [Supabase JavaScript 클라이언트](https://supabase.com/docs/reference/javascript/introduction)
