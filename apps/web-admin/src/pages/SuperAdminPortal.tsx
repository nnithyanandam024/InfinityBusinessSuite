import React, { useState, useEffect } from 'react';
import { apiFetch } from '../services/api';
import { Building2, DollarSign, Users, ShieldAlert, CheckCircle, Clock, Zap, AlertTriangle, Layers, Plus } from 'lucide-react';

export const SuperAdminPortal: React.FC = () => {
  const [metrics, setMetrics] = useState<any>(null);
  const [tenants, setTenants] = useState<any[]>([]);
  const [search, setSearch] = useState('');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadData();
  }, []);

  const loadData = async () => {
    try {
      const [m, t] = await Promise.all([
        apiFetch<any>('/super-admin/metrics'),
        apiFetch<any[]>('/super-admin/tenants'),
      ]);
      setMetrics(m);
      setTenants(t);
    } catch (err) {
      console.error('Failed to load Super Admin data:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleUpdateStatus = async (tenantId: string, newStatus: string) => {
    try {
      await apiFetch(`/super-admin/tenants/${tenantId}/status`, {
        method: 'PUT',
        body: JSON.stringify({ status: newStatus }),
      });
      loadData();
    } catch (err: any) {
      alert('Status update failed: ' + err.message);
    }
  };

  const handleExtendTrial = async (tenantId: string, days: number = 14) => {
    try {
      await apiFetch(`/super-admin/tenants/${tenantId}/extend-trial`, {
        method: 'PUT',
        body: JSON.stringify({ days }),
      });
      alert(`🎉 Trial extended by +${days} days!`);
      loadData();
    } catch (err: any) {
      alert('Trial extension failed: ' + err.message);
    }
  };

  const filteredTenants = tenants.filter(
    (t) =>
      t.name.toLowerCase().includes(search.toLowerCase()) ||
      t.email.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div className="space-y-6 font-sans">
      {/* Header */}
      <div className="bg-slate-900 text-white rounded-2xl p-6 shadow-xl border border-slate-800 flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
        <div>
          <div className="flex items-center space-x-2">
            <span className="px-2.5 py-0.5 rounded-full bg-primary text-white text-[10px] font-extrabold uppercase tracking-wider">
              Infinity Technologies
            </span>
            <span className="text-xs text-slate-400 font-medium">Multi-Tenant SaaS Control Center</span>
          </div>
          <h1 className="text-2xl font-extrabold text-white tracking-tight mt-1">
            Super Admin SaaS Platform Portal
          </h1>
          <p className="text-xs text-slate-400 mt-0.5">
            Monitor subscribing SME companies, platform MRR, SaaS pricing tiers, and tenant access locks.
          </p>
        </div>

        <div className="flex items-center space-x-2 bg-slate-800 p-2 rounded-xl border border-slate-700">
          <Layers className="w-4 h-4 text-primary" />
          <span className="text-xs font-bold text-slate-200">System Mode: Multi-SaaS Active</span>
        </div>
      </div>

      {/* KPI Cards Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {/* Card 1: Platform MRR */}
        <div className="bg-white border border-slate-200 rounded-card p-5 shadow-soft hover:shadow-hover transition-all">
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold text-slate-400">Platform MRR</span>
            <div className="w-8 h-8 rounded-xl bg-emerald-50 text-emerald-600 flex items-center justify-center">
              <DollarSign className="w-4 h-4" />
            </div>
          </div>
          <div className="mt-3 flex items-baseline justify-between">
            <span className="text-2xl font-extrabold text-slate-900 font-sans">
              ₹{(metrics?.platformMRR || 485000).toLocaleString()}
            </span>
            <span className="text-[10px] font-bold text-emerald-600 bg-emerald-50 border border-emerald-100 px-2 py-0.5 rounded-full">
              +18.4% MRR
            </span>
          </div>
          <div className="mt-2 text-[10px] text-slate-400">Monthly Recurring SaaS Revenue</div>
        </div>

        {/* Card 2: Total Tenants */}
        <div className="bg-white border border-slate-200 rounded-card p-5 shadow-soft hover:shadow-hover transition-all">
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold text-slate-400">Registered SME Tenants</span>
            <div className="w-8 h-8 rounded-xl bg-blue-50 text-primary flex items-center justify-center">
              <Building2 className="w-4 h-4" />
            </div>
          </div>
          <div className="mt-3 flex items-baseline justify-between">
            <span className="text-2xl font-extrabold text-slate-900">
              {metrics?.totalTenantsCount || 128} Companies
            </span>
            <span className="text-[10px] font-bold text-primary bg-blue-50 border border-blue-100 px-2 py-0.5 rounded-full">
              100% Cloud
            </span>
          </div>
          <div className="mt-2 text-[10px] text-slate-400">Active Business Subscribers</div>
        </div>

        {/* Card 3: Active Subscriptions */}
        <div className="bg-white border border-slate-200 rounded-card p-5 shadow-soft hover:shadow-hover transition-all">
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold text-slate-400">Paid Razorpay Subs</span>
            <div className="w-8 h-8 rounded-xl bg-purple-50 text-purple-600 flex items-center justify-center">
              <Zap className="w-4 h-4" />
            </div>
          </div>
          <div className="mt-3 flex items-baseline justify-between">
            <span className="text-2xl font-extrabold text-slate-900">
              {metrics?.activeSubscriptionsCount || 112} Paid
            </span>
            <span className="text-[10px] font-bold text-purple-600 bg-purple-50 border border-purple-100 px-2 py-0.5 rounded-full">
              Razorpay Sync
            </span>
          </div>
          <div className="mt-2 text-[10px] text-slate-400">Active Paid Accounts</div>
        </div>

        {/* Card 4: Free Trials */}
        <div className="bg-white border border-slate-200 rounded-card p-5 shadow-soft hover:shadow-hover transition-all">
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold text-slate-400">Active Free Trials</span>
            <div className="w-8 h-8 rounded-xl bg-amber-50 text-amber-600 flex items-center justify-center">
              <Clock className="w-4 h-4" />
            </div>
          </div>
          <div className="mt-3 flex items-baseline justify-between">
            <span className="text-2xl font-extrabold text-slate-900">
              {metrics?.trialingCount || 16} Trialing
            </span>
            <span className="text-[10px] font-bold text-amber-600 bg-amber-50 border border-amber-100 px-2 py-0.5 rounded-full">
              14-Day Window
            </span>
          </div>
          <div className="mt-2 text-[10px] text-slate-400">Conversion Pipeline</div>
        </div>
      </div>

      {/* SME Tenants Directory Table */}
      <div className="bg-white border border-slate-200 rounded-2xl shadow-soft space-y-4 p-6">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 pb-4 border-b border-slate-100">
          <div>
            <h2 className="text-base font-bold text-slate-900">SME Tenant Company Directory</h2>
            <p className="text-xs text-slate-500">Manage business customer accounts, usage limits, and subscription status.</p>
          </div>

          <input
            type="text"
            placeholder="Search Tenant by Name or Email..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            className="bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 text-xs outline-none w-64"
          />
        </div>

        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-slate-50 border-b border-slate-200 text-[11px] font-bold text-slate-400 uppercase tracking-wider">
                <th className="p-3">Company Name</th>
                <th className="p-3">Contact Email & Phone</th>
                <th className="p-3">Usage (Users/SKUs)</th>
                <th className="p-3">Status</th>
                <th className="p-3 text-right">Lifecycle Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100 text-xs">
              {filteredTenants.map((tenant) => {
                const isSuspended = tenant.subscriptionStatus === 'SUSPENDED';
                const isTrial = tenant.subscriptionStatus === 'TRIALING';

                return (
                  <tr key={tenant.id} className="hover:bg-slate-50 transition-colors">
                    <td className="p-3">
                      <div className="font-extrabold text-slate-900">{tenant.name}</div>
                      <div className="text-[10px] text-slate-400">GSTIN: {tenant.gstin}</div>
                    </td>
                    <td className="p-3 text-slate-600">
                      <div>{tenant.email}</div>
                      <div className="text-[10px] text-slate-400">{tenant.phone}</div>
                    </td>
                    <td className="p-3">
                      <div className="font-bold text-slate-800">
                        {tenant.userCount} Users • {tenant.productCount} SKUs
                      </div>
                      <div className="text-[10px] text-slate-400">{tenant.invoiceCount} Issued Invoices</div>
                    </td>
                    <td className="p-3">
                      <span
                        className={`font-bold text-[10px] px-2.5 py-0.5 rounded-full border ${
                          isSuspended
                            ? 'bg-rose-50 text-rose-600 border-rose-200'
                            : isTrial
                            ? 'bg-amber-50 text-amber-700 border-amber-200'
                            : 'bg-emerald-50 text-emerald-700 border-emerald-200'
                        }`}
                      >
                        {tenant.subscriptionStatus}
                      </span>
                    </td>
                    <td className="p-3 text-right space-x-2">
                      {isSuspended ? (
                        <button
                          onClick={() => handleUpdateStatus(tenant.id, 'ACTIVE')}
                          className="px-2.5 py-1 bg-emerald-50 text-emerald-700 border border-emerald-200 hover:bg-emerald-100 rounded-lg text-[11px] font-bold"
                        >
                          Reactivate
                        </button>
                      ) : (
                        <button
                          onClick={() => handleUpdateStatus(tenant.id, 'SUSPENDED')}
                          className="px-2.5 py-1 bg-rose-50 text-rose-600 border border-rose-200 hover:bg-rose-100 rounded-lg text-[11px] font-bold"
                        >
                          Suspend Access
                        </button>
                      )}

                      <button
                        onClick={() => handleExtendTrial(tenant.id, 14)}
                        className="px-2.5 py-1 bg-blue-50 text-primary border border-blue-200 hover:bg-blue-100 rounded-lg text-[11px] font-bold"
                      >
                        +14 Days Trial
                      </button>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      </div>

      {/* SaaS Tier Pricing Configurator */}
      <div className="bg-white border border-slate-200 rounded-2xl p-6 shadow-soft space-y-4">
        <div className="flex items-center justify-between border-b border-slate-100 pb-3">
          <div>
            <h2 className="text-base font-bold text-slate-900">SaaS Subscription Tier Configuration</h2>
            <p className="text-xs text-slate-500">Configure public subscription plans and feature access thresholds.</p>
          </div>
          <span className="text-xs font-bold text-primary bg-blue-50 border border-blue-100 px-3 py-1 rounded-xl">
            Razorpay Test Mode
          </span>
        </div>

        <div className="grid md:grid-cols-3 gap-6 pt-2">
          {[
            { name: 'Starter SME', price: '₹999 / mo', users: 3, skus: 500, invoices: 200 },
            { name: 'Professional Business', price: '₹2,499 / mo', users: 10, skus: 5000, invoices: 2500, popular: true },
            { name: 'Enterprise Infinity', price: '₹5,999 / mo', users: 50, skus: 50000, invoices: 25000 },
          ].map((plan, idx) => (
            <div
              key={idx}
              className={`p-5 rounded-2xl border space-y-3 ${
                plan.popular ? 'border-primary bg-blue-50/20 shadow-hover' : 'border-slate-200 bg-white'
              }`}
            >
              <div className="flex items-center justify-between">
                <h3 className="font-extrabold text-slate-900 text-sm">{plan.name}</h3>
                {plan.popular && (
                  <span className="bg-primary text-white text-[9px] font-extrabold uppercase px-2 py-0.5 rounded-full">
                    Top Tier
                  </span>
                )}
              </div>
              <div className="text-2xl font-extrabold text-slate-900 font-sans">{plan.price}</div>
              <div className="text-xs text-slate-600 space-y-1 pt-2 border-t border-slate-100">
                <div>Max {plan.users} User Accounts</div>
                <div>Max {plan.skus} Products</div>
                <div>Max {plan.invoices} Monthly Invoices</div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};
