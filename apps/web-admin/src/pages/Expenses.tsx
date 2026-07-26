import React, { useState, useEffect } from 'react';
import { apiFetch } from '../services/api';
import { DollarSign, Plus, Trash2, Tag, Calendar } from 'lucide-react';

export const Expenses: React.FC = () => {
  const [expenses, setExpenses] = useState<any[]>([]);
  const [isAddModalOpen, setIsAddModalOpen] = useState(false);

  const [title, setTitle] = useState('');
  const [category, setCategory] = useState('Utilities');
  const [amount, setAmount] = useState('');
  const [notes, setNotes] = useState('');

  useEffect(() => {
    loadExpenses();
  }, []);

  const loadExpenses = async () => {
    try {
      const data = await apiFetch<any[]>('/expenses');
      setExpenses(data);
    } catch (err) {
      console.error('Failed to load expenses:', err);
    }
  };

  const handleCreateExpense = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      await apiFetch('/expenses', {
        method: 'POST',
        body: JSON.stringify({
          title,
          category,
          amount: Number(amount),
          notes,
        }),
      });
      setIsAddModalOpen(false);
      setTitle('');
      setAmount('');
      loadExpenses();
    } catch (err: any) {
      alert('Error recording expense: ' + err.message);
    }
  };

  const handleDeleteExpense = async (id: string) => {
    if (!confirm('Delete this expense entry?')) return;
    try {
      await apiFetch(`/expenses/${id}`, { method: 'DELETE' });
      loadExpenses();
    } catch (err: any) {
      alert('Delete failed: ' + err.message);
    }
  };

  const totalExpenseAmount = expenses.reduce((acc, curr) => acc + (curr.amount || 0), 0);

  return (
    <div className="space-y-6 font-sans">
      {/* Header */}
      <div className="bg-white border border-slate-200 rounded-2xl p-6 shadow-soft flex items-center justify-between">
        <div>
          <h1 className="text-xl font-bold text-slate-900">Expenses & Operating Costs</h1>
          <p className="text-xs text-slate-500 mt-0.5">
            Track business expenses, utilities, payroll, and maintenance costs.
          </p>
        </div>

        <button
          onClick={() => setIsAddModalOpen(true)}
          className="bg-primary hover:bg-primary-dark text-white font-bold text-xs px-4 py-2.5 rounded-xl shadow-hover flex items-center space-x-2 transition-all"
        >
          <Plus className="w-4 h-4" />
          <span>Record Expense</span>
        </button>
      </div>

      {/* Summary KPI */}
      <div className="bg-white border border-slate-200 rounded-card p-5 shadow-soft max-w-sm">
        <div className="flex items-center justify-between text-xs font-semibold text-slate-400">
          <span>Total Expenses Recorded</span>
          <DollarSign className="w-4 h-4 text-rose-500" />
        </div>
        <div className="text-2xl font-extrabold text-slate-900 mt-2">
          ₹{totalExpenseAmount.toLocaleString()}
        </div>
      </div>

      {/* Expense List */}
      <div className="bg-white border border-slate-200 rounded-2xl shadow-soft overflow-hidden">
        <table className="w-full text-left border-collapse">
          <thead>
            <tr className="bg-slate-50 border-b border-slate-200 text-[11px] font-bold text-slate-400 uppercase tracking-wider">
              <th className="p-4">Title & Notes</th>
              <th className="p-4">Category</th>
              <th className="p-4">Date</th>
              <th className="p-4">Amount</th>
              <th className="p-4 text-right">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-slate-100 text-xs">
            {expenses.length === 0 ? (
              <tr>
                <td colSpan={5} className="p-8 text-center text-slate-400">
                  No expenses recorded yet. Click "Record Expense" to track costs.
                </td>
              </tr>
            ) : (
              expenses.map((exp) => (
                <tr key={exp.id} className="hover:bg-slate-50 transition-colors">
                  <td className="p-4">
                    <div className="font-bold text-slate-900">{exp.title}</div>
                    <div className="text-[10px] text-slate-400">{exp.notes || 'No notes'}</div>
                  </td>
                  <td className="p-4">
                    <span className="bg-slate-100 text-slate-700 font-semibold px-2 py-0.5 rounded-full text-[10px]">
                      {exp.category}
                    </span>
                  </td>
                  <td className="p-4 text-slate-500">
                    {new Date(exp.expenseDate).toLocaleDateString()}
                  </td>
                  <td className="p-4 font-bold text-rose-600">₹{exp.amount.toLocaleString()}</td>
                  <td className="p-4 text-right">
                    <button
                      onClick={() => handleDeleteExpense(exp.id)}
                      className="p-1.5 text-rose-500 hover:bg-rose-50 rounded-lg transition-colors"
                    >
                      <Trash2 className="w-4 h-4" />
                    </button>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      {/* Record Modal */}
      {isAddModalOpen && (
        <div className="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm flex items-center justify-center p-4">
          <div className="bg-white rounded-2xl max-w-md w-full p-6 shadow-2xl border border-slate-200 space-y-4">
            <h2 className="text-lg font-bold text-slate-900">Record Business Expense</h2>
            <form onSubmit={handleCreateExpense} className="space-y-3 text-xs">
              <div>
                <label className="block font-bold text-slate-700 mb-1">Expense Title</label>
                <input
                  type="text"
                  required
                  placeholder="e.g. Monthly Electricity Bill"
                  value={title}
                  onChange={(e) => setTitle(e.target.value)}
                  className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 outline-none"
                />
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Category</label>
                  <select
                    value={category}
                    onChange={(e) => setCategory(e.target.value)}
                    className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 outline-none font-semibold text-slate-700"
                  >
                    <option value="Utilities">Utilities</option>
                    <option value="Rent">Shop Rent</option>
                    <option value="Payroll">Staff Salaries</option>
                    <option value="Maintenance">Maintenance</option>
                    <option value="Marketing">Marketing</option>
                  </select>
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Amount (₹)</label>
                  <input
                    type="number"
                    required
                    placeholder="2500"
                    value={amount}
                    onChange={(e) => setAmount(e.target.value)}
                    className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 outline-none font-bold"
                  />
                </div>
              </div>

              <div>
                <label className="block font-bold text-slate-700 mb-1">Notes</label>
                <input
                  type="text"
                  placeholder="Optional details"
                  value={notes}
                  onChange={(e) => setNotes(e.target.value)}
                  className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 outline-none"
                />
              </div>

              <div className="flex items-center space-x-3 pt-3 border-t border-slate-100">
                <button
                  type="submit"
                  className="flex-1 bg-primary text-white font-bold py-2.5 rounded-xl hover:bg-primary-dark shadow-hover"
                >
                  Save Expense
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
