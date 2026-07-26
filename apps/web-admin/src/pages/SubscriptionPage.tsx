import React from 'react';
import { CreditCard, Zap } from 'lucide-react';

interface SubPageProps {
  company: any;
  onOpenPlansModal: () => void;
}

export const SubscriptionPage: React.FC<SubPageProps> = ({ company, onOpenPlansModal }) => {
  return (
    <div className="max-w-4xl mx-auto space-y-6 font-sans">
      <div className="bg-white border border-slate-200 rounded-2xl p-6 shadow-soft">
        <div className="flex items-center space-x-2 text-primary mb-2">
          <CreditCard className="w-5 h-5" />
          <span className="text-xs font-bold uppercase tracking-wider">Subscription</span>
        </div>
        <h1 className="text-xl font-extrabold text-slate-900 tracking-tight">
          Subscription Management
        </h1>
        <p className="text-xs text-slate-500 mt-1">
          Manage plan tiers, active user limits, and renewals.
        </p>

        <div className="mt-6 p-6 rounded-2xl bg-gradient-to-r from-slate-900 to-navy text-white shadow-hover flex flex-col md:flex-row items-start md:items-center justify-between gap-6">
          <div>
            <span className="text-[10px] uppercase font-bold tracking-wider px-2.5 py-0.5 rounded-full bg-primary text-white">
              Current Plan
            </span>
            <h2 className="text-xl font-extrabold mt-2">
              {company?.subscriptionStatus === 'ACTIVE' ? 'Professional Business' : 'Free Trial'}
            </h2>
            <p className="text-xs text-slate-400 mt-1">
              Company: <strong className="text-white">{company?.name}</strong>
            </p>
          </div>

          <button
            onClick={onOpenPlansModal}
            className="bg-primary hover:bg-primary-dark text-white font-bold text-xs px-6 py-3 rounded-xl shadow-hover flex items-center space-x-2 transition-all shrink-0"
          >
            <Zap className="w-4 h-4" />
            <span>Manage Subscription</span>
          </button>
        </div>
      </div>
    </div>
  );
};
