const API_BASE = '/api';

export function getAuthToken(): string | null {
  return localStorage.getItem('ibs_token');
}

export function setAuthToken(token: string) {
  localStorage.setItem('ibs_token', token);
}

export function clearAuthToken() {
  localStorage.removeItem('ibs_token');
  localStorage.removeItem('ibs_user');
}

export async function apiFetch<T>(endpoint: string, options: RequestInit = {}): Promise<T> {
  const token = getAuthToken();
  const headers: Record<string, string> = {
    'Content-Type': 'application/json',
    ...(options.headers as Record<string, string>),
  };

  if (token) {
    headers['Authorization'] = `Bearer ${token}`;
  }

  const response = await fetch(`${API_BASE}${endpoint}`, {
    ...options,
    headers,
  });

  if (response.status === 401) {
    clearAuthToken();
    window.location.href = '/login';
    throw new Error('Unauthorized');
  }

  const data = await response.json();

  if (!response.ok) {
    throw new Error(data.message || 'API request failed');
  }

  return data as T;
}
