// Vercel API 엔드포인트: 환경변수에서 Supabase 설정 로드
// api/config.js

export default function handler(req, res) {
  // CORS 헤더 설정
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Content-Type', 'application/json');
  
  // OPTIONS 요청 처리
  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  // 환경변수에서 Supabase 설정 읽기
  const url = process.env.VITE_SUPABASE_URL;
  const anonKey = process.env.VITE_SUPABASE_ANON_KEY;

  console.log('[API] Config 요청 - URL:', url ? '설정됨' : '미설정', 'KEY:', anonKey ? '설정됨' : '미설정');

  // 필수 환경변수 확인
  if (!url || !anonKey) {
    console.error('[API] 환경변수 누락:', { url: !url, anonKey: !anonKey });
    return res.status(400).json({
      error: 'Missing Supabase configuration',
      message: 'VITE_SUPABASE_URL과 VITE_SUPABASE_ANON_KEY를 Vercel 환경변수에 설정하세요.',
      configured: { url: !!url, anonKey: !!anonKey }
    });
  }

  res.status(200).json({
    supabase: {
      url: url,
      anonKey: anonKey
    }
  });
}
