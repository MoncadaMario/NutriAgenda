import { next } from '@vercel/functions';

export const config = {
  matcher: [
    '/patient-dashboard',
    '/nutritionist-dashboard',
    '/admin-dashboard',
    '/user-management',
  ],
};

export default function middleware(request) {
  const cookieHeader = request.headers.get('cookie') || '';
  const tieneSesion = cookieHeader
    .split(';')
    .some((parte) => parte.trim().startsWith('na_session=1'));

  if (!tieneSesion) {
    const url = new URL(request.url);
    url.pathname = '/login';
    return Response.redirect(url, 302);
  }

  return next();
}