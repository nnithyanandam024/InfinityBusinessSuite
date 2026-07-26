import React, { useState, useEffect } from 'react';
import { apiFetch } from '../services/api';
import { Users, Plus, Phone, Mail, Building, FileText } from 'lucide-react';

export const CustomerSupplier: React.FC = () => {
  const [activeTab, setActiveTab] = useState<'customers' | 'suppliers'>('customers');
  const [contacts, setContacts] = useState<any[]>([]);
  const [isAddModalOpen, setIsAddModalOpen] = useState(false);

  const [name, setName] = useState('');
  const [phone, setPhone] = useState('');
  const [email, setEmail] = useState('');
  const [gstin, setGstin] = useState('');
  const [address, setAddress] = useState('');
  const [openingBalance, setOpeningBalance] = useState('0');

  useEffect(() => {
    loadContacts();
  }, [activeTab]);

  const loadContacts = async () => {
    try {
      const endpoint = activeTab === 'customers' ? '/contacts/customers' : '/contacts/suppliers';
      const data = await apiFetch<any[]>(endpoint);
      setContacts(data);
    } catch (err) {
      console.error('Failed to load contacts:', err);
    }
  };

  const handleSaveContact = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const endpoint = activeTab === 'customers' ? '/contacts/customers' : '/contacts/suppliers';
      await apiFetch(endpoint, {
        method: 'POST',
        body: JSON.stringify({
          name,
          phone,
          email,
          gstin,
          address,
          openingBalance: Number(openingBalance),
        }),
      });
      setIsAddModalOpen(false);
      setName('');
      setPhone('');
      loadContacts();
    } catch (err: any) {
      alert('Error saving contact: ' + err.message);
    }
  };

  return (
    <div className="space-y-6 font-sans">
      {/* Top Header */}
      <div className="bg-white border border-slate-200 rounded-2xl p-6 shadow-soft flex items-center justify-between">
        <div>
          <h1 className="text-xl font-bold text-slate-900">
            {activeTab === 'customers' ? 'Customers' : 'Suppliers'} Directory
          </h1>
          <p className="text-xs text-slate-500 mt-0.5">
            Manage contact profiles, GSTINs, and balance ledgers.
          </p>
        </div>

        <button
          onClick={() => setIsAddModalOpen(true)}
          className="bg-primary hover:bg-primary-dark text-white font-bold text-xs px-4 py-2.5 rounded-xl shadow-hover flex items-center space-x-2 transition-all"
        >
          <Plus className="w-4 h-4" />
          <span>Add {activeTab === 'customers' ? 'Customer' : 'Supplier'}</span>
        </button>
      </div>

      {/* Tabs Switcher */}
      <div className="flex space-x-2 border-b border-slate-200 pb-2">
        <button
          onClick={() => setActiveTab('customers')}
          className={`px-4 py-2 rounded-xl font-bold text-xs transition-colors ${
            activeTab === 'customers' ? 'bg-primary text-white' : 'text-slate-600 hover:bg-slate-100'
          }`}
        >
          Customers
        </button>
        <button
          onClick={() => setActiveTab('suppliers')}
          className={`px-4 py-2 rounded-xl font-bold text-xs transition-colors ${
            activeTab === 'suppliers' ? 'bg-primary text-white' : 'text-slate-600 hover:bg-slate-100'
          }`}
        >
          Suppliers
        </button>
      </div>

      {/* Contacts Table */}
      <div className="bg-white border border-slate-200 rounded-2xl shadow-soft overflow-hidden">
        <table className="w-full text-left border-collapse">
          <thead>
            <tr className="bg-slate-50 border-b border-slate-200 text-[11px] font-bold text-slate-400 uppercase tracking-wider">
              <th className="p-4">Name</th>
              <th className="p-4">Phone / Email</th>
              <th className="p-4">GSTIN</th>
              <th className="p-4">Balance</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-slate-100 text-xs">
            {contacts.length === 0 ? (
              <tr>
                <td colSpan={4} className="p-8 text-center text-slate-400">
                  No {activeTab} added yet.
                </td>
              </tr>
            ) : (
              contacts.map((contact) => (
                <tr key={contact.id} className="hover:bg-slate-50 transition-colors">
                  <td className="p-4 font-bold text-slate-900">{contact.name}</td>
                  <td className="p-4 text-slate-600">
                    <div>{contact.phone}</div>
                    <div className="text-[10px] text-slate-400">{contact.email || '-'}</div>
                  </td>
                  <td className="p-4 font-mono text-slate-700">{contact.gstin || 'Unregistered'}</td>
                  <td className="p-4 font-extrabold text-slate-900">
                    ₹{(contact.balance || 0).toLocaleString()}
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      {/* Add Modal Overlay */}
      {isAddModalOpen && (
        <div className="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm flex items-center justify-center p-4">
          <div className="bg-white rounded-2xl max-w-md w-full p-6 shadow-2xl border border-slate-200 space-y-4">
            <h2 className="text-lg font-bold text-slate-900">
              Add {activeTab === 'customers' ? 'Customer' : 'Supplier'}
            </h2>
            <form onSubmit={handleSaveContact} className="space-y-3 text-xs">
              <div>
                <label className="block font-bold text-slate-700 mb-1">Name</label>
                <input
                  type="text"
                  required
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                  className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 outline-none"
                />
              </div>
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Phone</label>
                  <input
                    type="text"
                    required
                    value={phone}
                    onChange={(e) => setPhone(e.target.value)}
                    className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 outline-none"
                  />
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Email</label>
                  <input
                    type="email"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 outline-none"
                  />
                </div>
              </div>
              <div>
                <label className="block font-bold text-slate-700 mb-1">GSTIN Number</label>
                <input
                  type="text"
                  placeholder="33AAAAA0000A1Z5"
                  value={gstin}
                  onChange={(e) => setGstin(e.target.value)}
                  className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 outline-none"
                />
              </div>

              <div className="flex items-center space-x-3 pt-3 border-t border-slate-100">
                <button
                  type="submit"
                  className="flex-1 bg-primary text-white font-bold py-2.5 rounded-xl hover:bg-primary-dark shadow-hover"
                >
                  Save
                </button>
                <button
                  type="button"
                  onClick={() => setIsAddModalOpen(false)}
                  className="px-4 py-2.5 border border-slate-200 font-bold text-slate-700 rounded-xl hover:bg-slate-50"
                >
                  Cancel
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};
