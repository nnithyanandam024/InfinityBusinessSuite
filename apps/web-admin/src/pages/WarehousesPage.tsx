import React, { useState, useEffect } from 'react';
import { apiFetch } from '../services/api';
import { Building2, Plus, MapPin, User } from 'lucide-react';

export const WarehousesPage: React.FC = () => {
  const [warehouses, setWarehouses] = useState<any[]>([]);
  const [isModalOpen, setIsModalOpen] = useState(false);

  const [name, setName] = useState('');
  const [location, setLocation] = useState('');
  const [manager, setManager] = useState('');

  useEffect(() => {
    loadWarehouses();
  }, []);

  const loadWarehouses = async () => {
    try {
      const data = await apiFetch<any[]>('/warehouses');
      setWarehouses(data);
    } catch (err) {
      console.error('Failed to load warehouses:', err);
    }
  };

  const handleCreateWarehouse = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      await apiFetch('/warehouses', {
        method: 'POST',
        body: JSON.stringify({ name, location, manager }),
      });
      setIsModalOpen(false);
      setName('');
      setLocation('');
      loadWarehouses();
    } catch (err: any) {
      alert('Error adding warehouse: ' + err.message);
    }
  };

  return (
    <div className="space-y-6 font-sans">
      <div className="bg-white border border-slate-200 rounded-2xl p-6 shadow-soft flex items-center justify-between">
        <div>
          <h1 className="text-xl font-bold text-slate-900">Warehouses & Branch Locations</h1>
          <p className="text-xs text-slate-500 mt-0.5">
            Manage central stores, retail branches, and inventory locations.
          </p>
        </div>

        <button
          onClick={() => setIsModalOpen(true)}
          className="bg-primary hover:bg-primary-dark text-white font-bold text-xs px-4 py-2.5 rounded-xl shadow-hover flex items-center space-x-2 transition-all"
        >
          <Plus className="w-4 h-4" />
          <span>Add Location</span>
        </button>
      </div>

      <div className="grid md:grid-cols-2 gap-6">
        {warehouses.map((wh) => (
          <div key={wh.id} className="bg-white border border-slate-200 rounded-2xl p-5 shadow-soft space-y-3">
            <div className="flex items-center justify-between border-b border-slate-100 pb-3">
              <div className="flex items-center space-x-2">
                <Building2 className="w-5 h-5 text-primary" />
                <h3 className="text-base font-bold text-slate-900">{wh.name}</h3>
              </div>
              <span className="text-[10px] font-bold bg-emerald-50 text-emerald-600 border border-emerald-100 px-2 py-0.5 rounded-full">
                Active Location
              </span>
            </div>

            <div className="space-y-2 text-xs text-slate-600">
              <div className="flex items-center space-x-2">
                <MapPin className="w-4 h-4 text-slate-400" />
                <span>{wh.location}</span>
              </div>
              <div className="flex items-center space-x-2">
                <User className="w-4 h-4 text-slate-400" />
                <span>Manager: {wh.manager || 'Unassigned'}</span>
              </div>
            </div>
          </div>
        ))}
      </div>

      {isModalOpen && (
        <div className="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm flex items-center justify-center p-4">
          <div className="bg-white rounded-2xl max-w-md w-full p-6 shadow-2xl border border-slate-200 space-y-4">
            <h2 className="text-lg font-bold text-slate-900">Add Warehouse Location</h2>
            <form onSubmit={handleCreateWarehouse} className="space-y-3 text-xs">
              <div>
                <label className="block font-bold text-slate-700 mb-1">Location Name</label>
                <input
                  type="text"
                  required
                  placeholder="e.g. South Branch Depot"
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                  className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 outline-none"
                />
              </div>
              <div>
                <label className="block font-bold text-slate-700 mb-1">Address / City</label>
                <input
                  type="text"
                  required
                  placeholder="e.g. Guindy Industrial Estate, Chennai"
                  value={location}
                  onChange={(e) => setLocation(e.target.value)}
                  className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 outline-none"
                />
              </div>
              <div>
                <label className="block font-bold text-slate-700 mb-1">Manager Name</label>
                <input
                  type="text"
                  placeholder="Optional manager"
                  value={manager}
                  onChange={(e) => setManager(e.target.value)}
                  className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 outline-none"
                />
              </div>

              <div className="flex items-center space-x-3 pt-3 border-t border-slate-100">
                <button
                  type="submit"
                  className="flex-1 bg-primary text-white font-bold py-2.5 rounded-xl hover:bg-primary-dark shadow-hover"
                >
                  Save Location
                </button>
                <button
                  type="button"
                  onClick={() => setIsModalOpen(false)}
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
