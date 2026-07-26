import React, { useState, useEffect } from 'react';
import { apiFetch } from '../services/api';
import { Settings, Save, Download, Building, CreditCard, FileText } from 'lucide-react';

export const SettingsPage: React.FC = () => {
  const [settings, setSettings] = useState<any>({
    name: '',
    phone: '',
    gstin: '',
    address: '',
    bankName: '',
    bankAccountNo: '',
    bankIfsc: '',
    invoiceNotes: '',
  });

  const [saving, setSaving] = useState(false);
  const [msg, setMsg] = useState('');

  useEffect(() => {
    loadSettings();
  }, []);

  const loadSettings = async () => {
    try {
      const data = await apiFetch<any>('/settings');
      setSettings(data);
    } catch (err) {
      console.error('Failed to load settings:', err);
    }
  };

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    setSaving(true);
    setMsg('');
    try {
      await apiFetch('/settings', {
        method: 'PUT',
        body: JSON.stringify(settings),
      });
      setMsg('Settings saved successfully!');
    } catch (err: any) {
      alert('Save failed: ' + err.message);
    } finally {
      setSaving(false);
    }
  };

  const handleExportData = async () => {
    try {
      const exportData = await apiFetch<any>('/settings/export');
      const blob = new Blob([JSON.stringify(exportData, null, 2)], { type: 'application/json' });
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = `IBS_Backup_${Date.now()}.json`;
      a.click();
    } catch (err: any) {
      alert('Export failed: ' + err.message);
    }
  };

  return (
    <div className="max-w-4xl mx-auto space-y-6 font-sans">
      <div className="bg-white border border-slate-200 rounded-2xl p-6 shadow-soft">
        <h1 className="text-xl font-bold text-slate-900">Company Settings</h1>
        <p className="text-xs text-slate-500 mt-0.5">
          Manage business profile, GST details, bank information for invoices, and data backups.
        </p>
      </div>

      {msg && (
        <div className="p-3 bg-emerald-50 border border-emerald-200 rounded-xl text-xs text-emerald-600 font-semibold">
          {msg}
        </div>
      )}

      {/* Settings Form */}
      <form onSubmit={handleSave} className="space-y-6">
        {/* Profile Card */}
        <div className="bg-white border border-slate-200 rounded-2xl p-6 shadow-soft space-y-4">
          <div className="flex items-center space-x-2 text-primary font-bold text-sm border-b border-slate-100 pb-3">
            <Building className="w-4 h-4" />
            <span>Business Profile & GST</span>
          </div>

          <div className="grid md:grid-cols-2 gap-4 text-xs">
            <div>
              <label className="block font-bold text-slate-700 mb-1">Company Name</label>
              <input
                type="text"
                value={settings.name || ''}
                onChange={(e) => setSettings({ ...settings, name: e.target.value })}
                className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 outline-none"
              />
            </div>
            <div>
              <label className="block font-bold text-slate-700 mb-1">Phone Number</label>
              <input
                type="text"
                value={settings.phone || ''}
                onChange={(e) => setSettings({ ...settings, phone: e.target.value })}
                className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 outline-none"
              />
            </div>
            <div>
              <label className="block font-bold text-slate-700 mb-1">GSTIN Number</label>
              <input
                type="text"
                value={settings.gstin || ''}
                onChange={(e) => setSettings({ ...settings, gstin: e.target.value })}
                className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 outline-none font-mono"
              />
            </div>
            <div>
              <label className="block font-bold text-slate-700 mb-1">Business Address</label>
              <input
                type="text"
                value={settings.address || ''}
                onChange={(e) => setSettings({ ...settings, address: e.target.value })}
                className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 outline-none"
              />
            </div>
          </div>
        </div>

        {/* Bank & Invoice Customization */}
        <div className="bg-white border border-slate-200 rounded-2xl p-6 shadow-soft space-y-4">
          <div className="flex items-center space-x-2 text-primary font-bold text-sm border-b border-slate-100 pb-3">
            <CreditCard className="w-4 h-4" />
            <span>Bank Details for Printed Invoices</span>
          </div>

          <div className="grid md:grid-cols-3 gap-4 text-xs">
            <div>
              <label className="block font-bold text-slate-700 mb-1">Bank Name</label>
              <input
                type="text"
                placeholder="e.g. HDFC Bank"
                value={settings.bankName || ''}
                onChange={(e) => setSettings({ ...settings, bankName: e.target.value })}
                className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 outline-none"
              />
            </div>
            <div>
              <label className="block font-bold text-slate-700 mb-1">Account Number</label>
              <input
                type="text"
                value={settings.bankAccountNo || ''}
                onChange={(e) => setSettings({ ...settings, bankAccountNo: e.target.value })}
                className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 outline-none font-mono"
              />
            </div>
            <div>
              <label className="block font-bold text-slate-700 mb-1">IFSC Code</label>
              <input
                type="text"
                value={settings.bankIfsc || ''}
                onChange={(e) => setSettings({ ...settings, bankIfsc: e.target.value })}
                className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 outline-none font-mono"
              />
            </div>
          </div>
        </div>

        {/* Actions & Export Data */}
        <div className="flex items-center justify-between">
          <button
            type="submit"
            disabled={saving}
            className="bg-primary hover:bg-primary-dark text-white font-bold text-xs px-6 py-3 rounded-xl shadow-hover flex items-center space-x-2 transition-all"
          >
            <Save className="w-4 h-4" />
            <span>{saving ? 'Saving...' : 'Save Settings'}</span>
          </button>

          <button
            type="button"
            onClick={handleExportData}
            className="bg-slate-900 hover:bg-slate-800 text-white font-bold text-xs px-6 py-3 rounded-xl shadow-xs flex items-center space-x-2 transition-all"
          >
            <Download className="w-4 h-4" />
            <span>Export Data Backup (JSON)</span>
          </button>
        </div>
      </form>
    </div>
  );
};
