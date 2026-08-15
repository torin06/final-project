// Vercel API 엔드포인트: 환경변수에서 Supabase 설정 로드
// api/config.js

export default function handler(req, res) {
  // CORS 헤더 설정
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  
  // OPTIONS 요청 처리
  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  // 환경변수에서 Supabase 설정 읽기
  const config = {
    supabase: {
      url: process.env.VITE_SUPABASE_URL || '',
      anonKey: process.env.VITE_SUPABASE_ANON_KEY || ''
    }
  };

  // 필수 환경변수 확인
  if (!config.supabase.url || !config.supabase.anonKey) {
    return res.status(400).json({
      error: 'Missing Supabase configuration',
      message: 'VITE_SUPABASE_URL and VITE_SUPABASE_ANON_KEY must be set'
    });
  }

  res.status(200).json(config);
}
