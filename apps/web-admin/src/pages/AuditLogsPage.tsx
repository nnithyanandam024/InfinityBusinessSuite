import React, { useState, useEffect } from 'react';
import { apiFetch } from '../services/api';
import { ShieldCheck, Clock, FileText } from 'lucide-react';

export const AuditLogsPage: React.FC = () => {
  const [logs, setLogs] = useState<any[]>([]);

  useEffect(() => {
    loadLogs();
  }, []);

  const loadLogs = async () => {
    try {
      const data = await apiFetch<any[]>('/audit');
      setLogs(data);
    } catch (err) {
      console.error('Failed to load audit logs:', err);
    }
  };

  return (
    <div className="space-y-6 font-sans">
      <div className="bg-white border border-slate-200 rounded-2xl p-6 shadow-soft">
        <h1 className="text-xl font-bold text-slate-900">System Audit Logs</h1>
        <p className="text-xs text-slate-500 mt-0.5">
          Security audit trail and activity history.
        </p>
      </div>

      <div className="bg-white border border-slate-200 rounded-2xl p-6 shadow-soft space-y-4">
        <div className="space-y-3 text-xs">
          {logs.map((log) => (
            <div
              key={log.id}
              className="flex items-start justify-between p-3.5 rounded-xl bg-slate-50 border border-slate-200"
            >
              <div className="flex items-start space-x-3">
                <div className="p-2 bg-white rounded-lg border border-slate-200 text-primary">
                  <ShieldCheck className="w-4 h-4" />
                </div>
                <div>
                  <span className="font-bold text-slate-900 block">{log.action}</span>
                  <span className="text-slate-600 mt-0.5 block">{log.details}</span>
                </div>
              </div>

              <div className="flex items-center space-x-1 text-[10px] text-slate-400 font-semibold shrink-0">
                <Clock className="w-3 h-3" />
                <span>{new Date(log.createdAt).toLocaleString()}</span>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};
