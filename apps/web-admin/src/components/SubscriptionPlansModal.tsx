import React, { useState, useEffect } from 'react';
import { Check, X, ShieldCheck } from 'lucide-react';
import { apiFetch } from '../services/api';

interface ModalProps {
  isOpen: boolean;
  onClose: () => void;
  company: any;
  onSubscriptionUpdated: () => void;
}

export const SubscriptionPlansModal: React.FC<ModalProps> = ({
  isOpen,
  onClose,
  company,
  onSubscriptionUpdated,
}) => {
  const [plans, setPlans] = useState<any[]>([]);
  const [billingCycle, setBillingCycle] = useState<'MONTHLY' | 'YEARLY'>('MONTHLY');
  const [loadingPlanId, setLoadingPlanId] = useState<string | null>(null);

  useEffect(() => {
    if (isOpen) {
      apiFetch<any[]>('/subscription/plans')
        .then(setPlans)
        .catch(err => console.error('Failed to load subscription plans:', err));
    }
  }, [isOpen]);

  if (!isOpen) return null;

  const handleSubscribe = async (plan: any) => {
    try {
      setLoadingPlanId(plan.id);

      const orderData = await apiFetch<any>('/subscription/create-razorpay-order', {
        method: 'POST',
        body: JSON.stringify({ planId: plan.id, billingCycle }),
      });

      const options = {
        key: orderData.keyId,
        amount: orderData.amount,
        currency: orderData.currency,
        name: 'Infinity Technologies',
        description: `${plan.name} (${billingCycle} Subscription)`,
        order_id: orderData.orderId,
        handler: async function (response: any) {
          try {
            await apiFetch('/subscription/verify-razorpay-payment', {
              method: 'POST',
              body: JSON.stringify({
                razorpayOrderId: response.razorpay_order_id || orderData.orderId,
                razorpayPaymentId: response.razorpay_payment_id || `pay_${Date.now()}`,
                razorpaySignature: response.razorpay_signature || 'test_sig',
              }),
            });
            alert('🎉 Subscription Activated!');
            onSubscriptionUpdated();
            onClose();
          } catch (err: any) {
            alert('Payment verification error: ' + err.message);
          } finally {
            setLoadingPlanId(null);
          }
        },
        prefill: {
          name: company?.name || 'Customer',
          email: company?.email || '',
          contact: company?.phone || '',
        },
        theme: {
          color: '#2563EB',
        },
      };

      if ((window as any).Razorpay) {
        const rzp = new (window as any).Razorpay(options);
        rzp.open();
      } else {
        const proceed = confirm(
          `Checkout Test Mode:\nPlan: ${plan.name}\nAmount: ₹${orderData.amount / 100}\nConfirm subscription payment?`
        );
        if (proceed) {
          await apiFetch('/subscription/verify-razorpay-payment', {
            method: 'POST',
            body: JSON.stringify({
              razorpayOrderId: orderData.orderId,
              razorpayPaymentId: `pay_${Date.now()}`,
              razorpaySignature: 'simulated_signature',
            }),
          });
          alert('🎉 Subscription activated!');
          onSubscriptionUpdated();
          onClose();
        }
        setLoadingPlanId(null);
      }
    } catch (err: any) {
      alert('Failed to initiate checkout: ' + err.message);
      setLoadingPlanId(null);
    }
  };

  return (
    <div className="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm flex items-center justify-center p-4">
      <div className="bg-white rounded-2xl max-w-4xl w-full p-6 shadow-2xl border border-slate-200 relative max-h-[90vh] overflow-y-auto">
        <button
          onClick={onClose}
          className="absolute top-4 right-4 p-2 text-slate-400 hover:text-slate-600 rounded-full hover:bg-slate-100"
        >
          <X className="w-5 h-5" />
        </button>

        {/* Modal Header */}
        <div className="text-center max-w-lg mx-auto mb-6">
          <h2 className="text-2xl font-extrabold text-slate-900 tracking-tight font-sans">
            Subscription Plans
          </h2>
          <p className="text-xs text-slate-500 mt-1">
            Choose a plan that fits your business size.
          </p>
        </div>

        {/* Billing Cycle Toggle */}
        <div className="flex items-center justify-center space-x-3 mb-8">
          <span className={`text-xs font-bold ${billingCycle === 'MONTHLY' ? 'text-primary' : 'text-slate-400'}`}>
            Monthly
          </span>
          <button
            onClick={() => setBillingCycle(prev => (prev === 'MONTHLY' ? 'YEARLY' : 'MONTHLY'))}
            className="w-12 h-6 bg-slate-200 rounded-full p-1 transition-colors relative"
          >
            <div
              className={`w-4 h-4 rounded-full bg-primary transition-transform ${
                billingCycle === 'YEARLY' ? 'translate-x-6' : 'translate-x-0'
              }`}
            />
          </button>
          <span className={`text-xs font-bold ${billingCycle === 'YEARLY' ? 'text-primary' : 'text-slate-400'}`}>
            Yearly <span className="text-emerald-600 bg-emerald-50 px-1.5 py-0.5 rounded-full text-[10px]">Save 20%</span>
          </span>
        </div>

        {/* Plan Cards Grid */}
        <div className="grid md:grid-cols-3 gap-6">
          {plans.map((plan) => {
            const price = billingCycle === 'YEARLY' ? plan.priceYearly : plan.priceMonthly;
            const isSelected = company?.planId === plan.id;
            const isPopular = plan.tier === 'PROFESSIONAL';

            return (
              <div
                key={plan.id}
                className={`rounded-2xl p-5 border flex flex-col justify-between transition-all relative ${
                  isPopular
                    ? 'border-primary shadow-hover bg-gradient-to-b from-blue-50/40 to-white ring-2 ring-primary/20'
                    : 'border-slate-200 bg-white hover:shadow-soft'
                }`}
              >
                {isPopular && (
                  <span className="absolute -top-3 left-1/2 -translate-x-1/2 bg-primary text-white text-[10px] uppercase tracking-wider font-extrabold px-3 py-0.5 rounded-full shadow-xs">
                    Popular
                  </span>
                )}

                <div>
                  <h3 className="text-base font-bold text-slate-900">{plan.name}</h3>
                  <div className="mt-3 flex items-baseline">
                    <span className="text-3xl font-extrabold text-slate-900 tracking-tight font-sans">
                      ₹{price.toLocaleString()}
                    </span>
                    <span className="text-xs text-slate-400 font-semibold ml-1">
                      /{billingCycle === 'YEARLY' ? 'yr' : 'mo'}
                    </span>
                  </div>

                  <ul className="mt-4 space-y-2 text-xs text-slate-600">
                    <li className="flex items-center space-x-2">
                      <Check className="w-4 h-4 text-emerald-500 shrink-0" />
                      <span>Max {plan.maxUsers} Users</span>
                    </li>
                    <li className="flex items-center space-x-2">
                      <Check className="w-4 h-4 text-emerald-500 shrink-0" />
                      <span>{plan.maxProducts} Inventory Items</span>
                    </li>
                    <li className="flex items-center space-x-2">
                      <Check className="w-4 h-4 text-emerald-500 shrink-0" />
                      <span>{plan.maxInvoicesPerMonth} Monthly Invoices</span>
                    </li>
                    {plan.features?.map((feat: string, idx: number) => (
                      <li key={idx} className="flex items-center space-x-2">
                        <Check className="w-4 h-4 text-emerald-500 shrink-0" />
                        <span>{feat}</span>
                      </li>
                    ))}
                  </ul>
                </div>

                <div className="mt-6 pt-4 border-t border-slate-100">
                  <button
                    onClick={() => handleSubscribe(plan)}
                    disabled={loadingPlanId === plan.id}
                    className={`w-full py-2.5 rounded-xl font-bold text-xs flex items-center justify-center space-x-2 transition-all ${
                      isPopular
                        ? 'bg-primary text-white hover:bg-primary-dark shadow-hover'
                        : 'bg-navy text-white hover:bg-slate-800 shadow-xs'
                    }`}
                  >
                    <ShieldCheck className="w-4 h-4" />
                    <span>
                      {loadingPlanId === plan.id
                        ? 'Processing...'
                        : isSelected
                        ? 'Renew Plan'
                        : 'Subscribe'}
                    </span>
                  </button>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
};
