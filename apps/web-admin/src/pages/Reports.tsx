import React, { useState, useEffect } from 'react';
import { apiFetch } from '../services/api';
import { BarChart3, FileSpreadsheet, TrendingUp, DollarSign } from 'lucide-react';

export const Reports: React.FC = () => {
  const [gstReport, setGstReport] = useState<any>(null);
  const [pnlReport, setPnlReport] = useState<any>(null);

  useEffect(() => {
    apiFetch<any>('/reports/gst').then(setGstReport).catch(console.error);
    apiFetch<any>('/reports/profit-loss').then(setPnlReport).catch(console.error);
  }, []);

  return (
    <div className="space-y-6 font-sans">
      <div className="bg-white border border-slate-200 rounded-2xl p-6 shadow-soft">
        <h1 className="text-xl font-bold text-slate-900">Reports & GST Analytics</h1>
        <p className="text-xs text-slate-500 mt-0.5">
          GSTR-1 return summaries, tax breakdowns, and profit & loss metrics.
        </p>
      </div>

      <div className="grid md:grid-cols-2 gap-6">
        {/* GST Report Card */}
        <div className="bg-white border border-slate-200 rounded-2xl p-6 shadow-soft space-y-4">
          <div className="flex items-center justify-between border-b border-slate-100 pb-3">
            <div className="flex items-center space-x-2">
              <FileSpreadsheet className="w-5 h-5 text-primary" />
              <h2 className="text-base font-bold text-slate-900">GST Return Summary (GSTR-1)</h2>
            </div>
            <span className="text-xs font-bold text-emerald-600 bg-emerald-50 px-2 py-0.5 rounded-full border border-emerald-100">
              Tax Compliant
            </span>
          </div>

          <div className="space-y-3 text-xs">
            <div className="flex justify-between py-1 border-b border-slate-50">
              <span className="text-slate-500">Total Taxable Sales:</span>
              <span className="font-extrabold text-slate-900">
                ₹{(gstReport?.totalTaxableValue || 0).toLocaleString()}
              </span>
            </div>
            <div className="flex justify-between py-1 border-b border-slate-50">
              <span className="text-slate-500">CGST Collected (Intra-state):</span>
              <span className="font-bold text-slate-800">
                ₹{(gstReport?.totalCgst || 0).toFixed(2)}
              </span>
            </div>
            <div className="flex justify-between py-1 border-b border-slate-50">
              <span className="text-slate-500">SGST Collected (Intra-state):</span>
              <span className="font-bold text-slate-800">
                ₹{(gstReport?.totalSgst || 0).toFixed(2)}
              </span>
            </div>
            <div className="flex justify-between py-1 border-b border-slate-50">
              <span className="text-slate-500">IGST Collected (Inter-state):</span>
              <span className="font-bold text-slate-800">
                ₹{(gstReport?.totalIgst || 0).toFixed(2)}
              </span>
            </div>
            <div className="flex justify-between py-2 font-extrabold text-slate-900 border-t border-slate-200">
              <span>Total Tax Collected:</span>
              <span className="text-primary font-sans">
                ₹{(gstReport?.totalTaxAmount || 0).toLocaleString()}
              </span>
            </div>
          </div>
        </div>

        {/* Profit & Loss Card */}
        <div className="bg-white border border-slate-200 rounded-2xl p-6 shadow-soft space-y-4">
          <div className="flex items-center justify-between border-b border-slate-100 pb-3">
            <div className="flex items-center space-x-2">
              <TrendingUp className="w-5 h-5 text-emerald-600" />
              <h2 className="text-base font-bold text-slate-900">Profit & Loss Summary</h2>
            </div>
            <span className="text-xs font-bold text-primary bg-blue-50 px-2 py-0.5 rounded-full border border-blue-100">
              Margin: {pnlReport?.marginPercentage || 0}%
            </span>
          </div>

          <div className="space-y-3 text-xs">
            <div className="flex justify-between py-1 border-b border-slate-50">
              <span className="text-slate-500">Gross Sales Revenue:</span>
              <span className="font-extrabold text-slate-900">
                ₹{(pnlReport?.totalRevenue || 0).toLocaleString()}
              </span>
            </div>
            <div className="flex justify-between py-1 border-b border-slate-50">
              <span className="text-slate-500">Cost of Goods Sold (COGS):</span>
              <span className="font-bold text-rose-600">
                - ₹{(pnlReport?.estimatedCostOfGoodsSold || 0).toLocaleString()}
              </span>
            </div>
            <div className="flex justify-between py-1 border-b border-slate-50">
              <span className="text-slate-500">Gross Profit Margin:</span>
              <span className="font-bold text-emerald-600">
                ₹{(pnlReport?.grossProfit || 0).toLocaleString()}
              </span>
            </div>
            <div className="flex justify-between py-2 font-extrabold text-slate-900 border-t border-slate-200">
              <span>Net Profit:</span>
              <span className="text-emerald-600 font-sans">
                ₹{(pnlReport?.netProfit || 0).toLocaleString()}
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
