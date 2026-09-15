export default async function handler(req, res) {
  const supabaseUrl = process.env.SUPABASE_URL;
  const supabaseKey = process.env.SUPABASE_ANON_KEY;

  let database = 'not_configured';

  if (supabaseUrl && supabaseKey) {
    try {
      const response = await fetch(`${supabaseUrl}/auth/v1/health`, {
        headers: { apikey: supabaseKey },
      });
      database = response.ok ? 'ok' : 'error';
    } catch (error) {
      database = 'error';
    }
  }

  const healthy = database === 'ok';

  res.status(healthy ? 200 : 503).json({
    status: healthy ? 'ok' : 'degraded',
    service: 'NutriAgenda API',
    timestamp: new Date().toISOString(),
    checks: { database },
  });
}