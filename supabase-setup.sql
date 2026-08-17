-- Supabase SQL: 룰렛 데이터 저장 테이블 생성

-- 1. 사용자 세션 테이블
CREATE TABLE IF NOT EXISTS sessions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  session_id TEXT UNIQUE NOT NULL,
  start_time TIMESTAMP DEFAULT NOW(),
  end_time TIMESTAMP,
  duration_minutes INT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 2. 룰렛 실행 기록 테이블
CREATE TABLE IF NOT EXISTS roulette_spins (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  session_id TEXT NOT NULL,
  menu TEXT NOT NULL,
  spin_count INT NOT NULL,
  spun_at TIMESTAMP DEFAULT NOW(),
  created_at TIMESTAMP DEFAULT NOW(),
  FOREIGN KEY (session_id) REFERENCES sessions(session_id) ON DELETE CASCADE
);

-- Existing session rows remain intact; these columns are added only when absent.
ALTER TABLE sessions ADD COLUMN IF NOT EXISTS quick_result_clicked BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE sessions ADD COLUMN IF NOT EXISTS quick_result_enabled BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE sessions ADD COLUMN IF NOT EXISTS added_menus JSONB NOT NULL DEFAULT '[]'::jsonb;
ALTER TABLE sessions ADD COLUMN IF NOT EXISTS removed_menus JSONB NOT NULL DEFAULT '[]'::jsonb;
ALTER TABLE sessions ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT NOW();

-- Append-only history for each quick-result click and menu edit.
CREATE TABLE IF NOT EXISTS roulette_interactions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  session_id TEXT NOT NULL,
  event_type TEXT NOT NULL CHECK (event_type IN ('quick_result_clicked', 'menu_added', 'menu_removed')),
  menu_value TEXT,
  event_value BOOLEAN,
  occurred_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  FOREIGN KEY (session_id) REFERENCES sessions(session_id) ON DELETE CASCADE
);

-- 3. 인덱스 생성 (쿼리 성능 향상)
CREATE INDEX IF NOT EXISTS idx_sessions_session_id ON sessions(session_id);
CREATE INDEX IF NOT EXISTS idx_roulette_spins_session_id ON roulette_spins(session_id);
CREATE INDEX IF NOT EXISTS idx_roulette_spins_created_at ON roulette_spins(created_at);
CREATE INDEX IF NOT EXISTS idx_roulette_interactions_session_id ON roulette_interactions(session_id);
CREATE INDEX IF NOT EXISTS idx_roulette_interactions_occurred_at ON roulette_interactions(occurred_at);

-- 테이블 권한 설정 (선택사항)
ALTER TABLE sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE roulette_spins ENABLE ROW LEVEL SECURITY;
ALTER TABLE roulette_interactions ENABLE ROW LEVEL SECURITY;

-- 모든 사용자가 읽고 쓸 수 있도록 정책 설정
DROP POLICY IF EXISTS "Enable all access" ON sessions;
DROP POLICY IF EXISTS "Enable all access" ON roulette_spins;
CREATE POLICY "Enable all access" ON sessions FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all access" ON roulette_spins FOR ALL USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "Enable all access" ON roulette_interactions;
CREATE POLICY "Enable all access" ON roulette_interactions FOR ALL USING (true) WITH CHECK (true);
