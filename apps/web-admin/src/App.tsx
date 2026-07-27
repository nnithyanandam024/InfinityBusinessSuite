import React, { useState, useEffect } from 'react';
import { apiFetch, getAuthToken } from './services/api';
import { Navbar } from './components/Navbar';
import { Sidebar } from './components/Sidebar';
import { Login } from './pages/Login';
import { Dashboard } from './pages/Dashboard';
import { BillingPOS } from './pages/BillingPOS';
import { Inventory } from './pages/Inventory';
import { BarcodePrinter } from './pages/BarcodePrinter';
import { WarehousesPage } from './pages/WarehousesPage';
import { CustomerSupplier } from './pages/CustomerSupplier';
import { Expenses } from './pages/Expenses';
import { Reports } from './pages/Reports';
import { UsersPage } from './pages/UsersPage';
import { AuditLogsPage } from './pages/AuditLogsPage';
import { SubscriptionPage } from './pages/SubscriptionPage';
import { SettingsPage } from './pages/SettingsPage';
import { SuperAdminPortal } from './pages/SuperAdminPortal';
import { SubscriptionPlansModal } from './components/SubscriptionPlansModal';

export const App: React.FC = () => {
  const [user, setUser] = useState<any>(null);
  const [company, setCompany] = useState<any>(null);
  const [loading, setLoading] = useState(true);

  const [activeTab, setActiveTab] = useState('dashboard');
  const [isSubscriptionModalOpen, setIsSubscriptionModalOpen] = useState(false);

  useEffect(() => {
    const token = getAuthToken();
    if (token) {
      fetchUser();
    } else {
      setLoading(false);
    }
  }, []);

  const fetchUser = async () => {
    try {
      const res = await apiFetch<any>('/auth/me');
      setUser(res);
      setCompany(res.company);
    } catch (err) {
      console.error('Session expired:', err);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-slate-50 flex items-center justify-center font-sans">
        <div className="text-center space-y-3">
          <div className="w-10 h-10 border-4 border-primary border-t-transparent rounded-full animate-spin mx-auto" />
          <div className="text-xs font-bold text-slate-500">Loading Infinity Business Suite...</div>
        </div>
      </div>
    );
  }

  if (!user) {
    return (
      <Login
        onLoginSuccess={(u, c) => {
          setUser(u);
          setCompany(c);
        }}
      />
    );
  }

  return (
    <div className="min-h-screen bg-slate-50 flex flex-col font-sans">
      <Navbar
        user={user}
        company={company}
        onOpenSubscriptionModal={() => setIsSubscriptionModalOpen(true)}
      />

      <div className="flex-1 flex">
        <Sidebar activeTab={activeTab} setActiveTab={setActiveTab} />

        <main className="flex-1 p-6 overflow-y-auto max-w-7xl mx-auto w-full">
          {activeTab === 'dashboard' && (
            <Dashboard
              onNavigateToPOS={() => setActiveTab('billing')}
              onNavigateToInventory={() => setActiveTab('inventory')}
            />
          )}

          {activeTab === 'billing' && <BillingPOS />}

          {activeTab === 'inventory' && <Inventory />}

          {activeTab === 'barcode' && <BarcodePrinter />}

          {activeTab === 'warehouses' && <WarehousesPage />}

          {activeTab === 'customers' && <CustomerSupplier />}

          {activeTab === 'expenses' && <Expenses />}

          {activeTab === 'reports' && <Reports />}

          {activeTab === 'users' && <UsersPage />}

          {activeTab === 'audit' && <AuditLogsPage />}

          {activeTab === 'subscription' && (
            <SubscriptionPage
              company={company}
              onOpenPlansModal={() => setIsSubscriptionModalOpen(true)}
            />
          )}

          {activeTab === 'superadmin' && <SuperAdminPortal />}

          {activeTab === 'settings' && <SettingsPage />}
        </main>
      </div>

      <SubscriptionPlansModal
        isOpen={isSubscriptionModalOpen}
        onClose={() => setIsSubscriptionModalOpen(false)}
        company={company}
        onSubscriptionUpdated={fetchUser}
      />
    </div>
  );
};

export default App;
