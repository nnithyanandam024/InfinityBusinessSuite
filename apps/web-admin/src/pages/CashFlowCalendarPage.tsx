import React from 'react';
import { Calendar as CalendarIcon, ArrowDownRight, ArrowUpRight, DollarSign } from 'lucide-react';

export const CashFlowCalendarPage: React.FC = () => {
  const days = Array.from({ length: 31 }, (_, i) => i + 1);

  return (
    <div className="p-6 max-w-7xl mx-auto space-y-6">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-slate-900 flex items-center gap-2">
            <CalendarIcon className="w-7 h-7 text-blue-600" />
            Cash-Flow Calendar Projection
          </h1>
          <p className="text-slate-500 text-sm">
            Forecast daily expected collections vs. supplier/expense payments
          </p>
        </div>

        <div className="flex items-center gap-3">
          <div className="bg-emerald-50 border border-emerald-200 text-emerald-700 px-4 py-2 rounded-xl text-sm font-semibold flex items-center gap-1.5">
            <ArrowUpRight className="w-4 h-4" />
            Expected Collections: ₹1,24,500
          </div>
          <div className="bg-amber-50 border border-amber-200 text-amber-800 px-4 py-2 rounded-xl text-sm font-semibold flex items-center gap-1.5">
            <ArrowDownRight className="w-4 h-4" />
            Expected Payments: ₹87,000
          </div>
          <div className="bg-blue-600 text-white px-4 py-2 rounded-xl text-sm font-bold flex items-center gap-1.5 shadow-md shadow-blue-500/20">
            <DollarSign className="w-4 h-4" />
            Projected Net: +₹37,500
          </div>
        </div>
      </div>

      {/* Calendar Grid */}
      <div className="bg-white rounded-2xl border border-slate-200 shadow-sm p-6">
        <h2 className="text-lg font-bold text-slate-900 mb-4">August 2026 Cash Projections</h2>
        <div className="grid grid-cols-7 gap-3 text-center">
          {['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].map((day) => (
            <div key={day} className="text-xs font-bold text-slate-400 uppercase py-2">
              {day}
            </div>
          ))}
          {days.map((day) => {
            const hasCollections = day % 3 === 0 || day === 5;
            const hasPayments = day % 4 === 0 || day === 5;
            return (
              <div
                key={day}
                className={`min-h-[90px] p-2.5 rounded-xl border text-left flex flex-col justify-between transition-all hover:border-blue-400 ${
                  day === 5 ? 'bg-blue-50/50 border-blue-300 ring-2 ring-blue-500/20' : 'bg-slate-50/50 border-slate-200'
                }`}
              >
                <span className="text-xs font-bold text-slate-700">{day}</span>
                <div className="space-y-1">
                  {hasCollections && (
                    <div className="text-[10px] bg-emerald-100 text-emerald-800 font-bold px-1.5 py-0.5 rounded flex justify-between">
                      <span>+Rec</span>
                      <span>₹{(day * 1400).toLocaleString('en-IN')}</span>
                    </div>
                  )}
                  {hasPayments && (
                    <div className="text-[10px] bg-amber-100 text-amber-900 font-bold px-1.5 py-0.5 rounded flex justify-between">
                      <span>-Pay</span>
                      <span>₹{(day * 900).toLocaleString('en-IN')}</span>
                    </div>
                  )}
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
};
