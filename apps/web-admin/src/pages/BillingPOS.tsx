import React, { useState, useEffect } from 'react';
import { apiFetch } from '../services/api';
import { Search, ShoppingCart, Plus, Minus, Trash2, Printer, CheckCircle, Barcode, ShieldAlert } from 'lucide-react';

export const BillingPOS: React.FC = () => {
  const [products, setProducts] = useState<any[]>([]);
  const [search, setSearch] = useState('');
  const [cart, setCart] = useState<any[]>([]);
  
  const [customerName, setCustomerName] = useState('Walk-in Customer');
  const [customerPhone, setCustomerPhone] = useState('');
  const [gstType, setGstType] = useState<'INTRA_STATE' | 'INTER_STATE'>('INTRA_STATE');
  const [paymentMethod, setPaymentMethod] = useState('CASH');

  const [loading, setLoading] = useState(false);
  const [generatedInvoice, setGeneratedInvoice] = useState<any | null>(null);

  useEffect(() => {
    loadProducts();
  }, [search]);

  const loadProducts = async () => {
    try {
      const data = await apiFetch<any[]>(`/products?search=${encodeURIComponent(search)}`);
      setProducts(data);
    } catch (err) {
      console.error('Failed to fetch products:', err);
    }
  };

  const addToCart = (product: any) => {
    if (product.currentStock <= 0) {
      alert(`Out of stock! ${product.name} has 0 items remaining.`);
      return;
    }

    setCart((prev) => {
      const existing = prev.find((item) => item.id === product.id);
      if (existing) {
        if (existing.quantity >= product.currentStock) {
          alert(`Cannot exceed stock limit of ${product.currentStock}`);
          return prev;
        }
        return prev.map((item) =>
          item.id === product.id ? { ...item, quantity: item.quantity + 1 } : item
        );
      }
      return [...prev, { ...product, quantity: 1, discount: 0 }];
    });
  };

  const updateQuantity = (id: string, delta: number) => {
    setCart((prev) =>
      prev
        .map((item) => {
          if (item.id === id) {
            const newQty = item.quantity + delta;
            return newQty > 0 ? { ...item, quantity: newQty } : null;
          }
          return item;
        })
        .filter(Boolean)
    );
  };

  const removeFromCart = (id: string) => {
    setCart((prev) => prev.filter((item) => item.id !== id));
  };

  // Tax calculations
  const calculateTotals = () => {
    let subtotal = 0;
    let totalTax = 0;
    let cgst = 0;
    let sgst = 0;
    let igst = 0;

    cart.forEach((item) => {
      const lineSubtotal = item.sellPrice * item.quantity - (item.discount || 0);
      subtotal += lineSubtotal;

      const rate = item.gstRate || 18.0;
      if (gstType === 'INTRA_STATE') {
        const halfRate = rate / 2;
        const lineCgst = (lineSubtotal * halfRate) / 100;
        const lineSgst = (lineSubtotal * halfRate) / 100;
        cgst += lineCgst;
        sgst += lineSgst;
        totalTax += lineCgst + lineSgst;
      } else {
        const lineIgst = (lineSubtotal * rate) / 100;
        igst += lineIgst;
        totalTax += lineIgst;
      }
    });

    const grandTotal = Math.round(subtotal + totalTax);

    return { subtotal, totalTax, cgst, sgst, igst, grandTotal };
  };

  const totals = calculateTotals();

  const handleCheckout = async () => {
    if (cart.length === 0) return alert('Cart is empty!');
    setLoading(true);

    try {
      const invoiceData = await apiFetch<any>('/billing/invoices', {
        method: 'POST',
        body: JSON.stringify({
          customerName,
          customerPhone,
          gstType,
          paymentMethod,
          items: cart.map((item) => ({
            productId: item.id,
            quantity: item.quantity,
            discount: item.discount || 0,
          })),
        }),
      });

      setGeneratedInvoice(invoiceData);
      setCart([]);
      loadProducts();
    } catch (err: any) {
      alert('Checkout error: ' + err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="grid lg:grid-cols-12 gap-6 font-sans">
      {/* Left Column: Product Catalog & Search */}
      <div className="lg:col-span-7 space-y-4">
        <div className="bg-white border border-slate-200 rounded-2xl p-4 shadow-soft flex items-center justify-between gap-4">
          <div className="flex items-center space-x-2 bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 w-full focus-within:ring-2 focus-within:ring-primary/20">
            <Search className="w-4 h-4 text-slate-400" />
            <input
              type="text"
              placeholder="Search products by Name, Barcode, or HSN Code..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="bg-transparent text-xs text-slate-800 outline-none w-full"
            />
          </div>
          <div className="flex items-center space-x-1 px-3 py-2 bg-blue-50 text-primary rounded-xl text-xs font-bold shrink-0 border border-blue-100">
            <Barcode className="w-4 h-4" />
            <span>Barcode Ready</span>
          </div>
        </div>

        {/* Product Cards Grid */}
        <div className="grid sm:grid-cols-2 md:grid-cols-3 gap-4 max-h-[calc(100vh-14rem)] overflow-y-auto pr-1">
          {products.map((prod) => (
            <div
              key={prod.id}
              onClick={() => addToCart(prod)}
              className="bg-white border border-slate-200 rounded-2xl p-4 shadow-soft hover:shadow-hover transition-all cursor-pointer flex flex-col justify-between group"
            >
              <div>
                <div className="flex items-start justify-between">
                  <span className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">
                    {prod.category?.name || 'General'}
                  </span>
                  <span className="text-[10px] font-bold text-slate-600 bg-slate-100 px-1.5 py-0.5 rounded-full">
                    GST {prod.gstRate}%
                  </span>
                </div>
                <h3 className="text-xs font-bold text-slate-900 group-hover:text-primary transition-colors mt-1">
                  {prod.name}
                </h3>
                <div className="text-[10px] text-slate-400 mt-0.5">HSN: {prod.hsnCode || 'N/A'}</div>
              </div>

              <div className="mt-3 pt-2 border-t border-slate-100 flex items-center justify-between">
                <div>
                  <span className="text-sm font-extrabold text-slate-900">₹{prod.sellPrice}</span>
                  <span className="text-[10px] text-slate-400 block">/{prod.unit}</span>
                </div>
                <span
                  className={`text-[10px] font-bold px-2 py-0.5 rounded-full ${
                    prod.currentStock > 10
                      ? 'bg-emerald-50 text-emerald-600'
                      : 'bg-rose-50 text-rose-600 border border-rose-100'
                  }`}
                >
                  Stock: {prod.currentStock}
                </span>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Right Column: POS Cart & Checkout */}
      <div className="lg:col-span-5 bg-white border border-slate-200 rounded-2xl p-5 shadow-soft flex flex-col justify-between h-[calc(100vh-8rem)]">
        <div>
          <div className="flex items-center justify-between pb-3 border-b border-slate-200 mb-4">
            <div className="flex items-center space-x-2">
              <ShoppingCart className="w-5 h-5 text-primary" />
              <h2 className="text-base font-extrabold text-slate-900">Billing Counter & Cart</h2>
            </div>
            <span className="text-xs font-bold text-slate-500">{cart.length} Items</span>
          </div>

          {/* Customer & GST Configuration */}
          <div className="grid grid-cols-2 gap-3 mb-4">
            <div>
              <label className="block text-[10px] font-bold text-slate-600 mb-1">Customer Name</label>
              <input
                type="text"
                value={customerName}
                onChange={(e) => setCustomerName(e.target.value)}
                className="w-full bg-slate-50 border border-slate-200 rounded-xl px-2.5 py-1.5 text-xs outline-none"
              />
            </div>
            <div>
              <label className="block text-[10px] font-bold text-slate-600 mb-1">GST Tax Type</label>
              <select
                value={gstType}
                onChange={(e: any) => setGstType(e.target.value)}
                className="w-full bg-slate-50 border border-slate-200 rounded-xl px-2.5 py-1.5 text-xs outline-none font-semibold text-slate-700"
              >
                <option value="INTRA_STATE">Intra-State (CGST + SGST)</option>
                <option value="INTER_STATE">Inter-State (IGST 18%)</option>
              </select>
            </div>
          </div>

          {/* Cart Item List */}
          <div className="max-h-56 overflow-y-auto space-y-2 pr-1 mb-4">
            {cart.length === 0 ? (
              <div className="text-center py-10 text-slate-400 text-xs">
                Cart is empty. Click items from catalog to add.
              </div>
            ) : (
              cart.map((item) => (
                <div key={item.id} className="flex items-center justify-between p-2.5 bg-slate-50 rounded-xl border border-slate-200 text-xs">
                  <div className="flex-1 pr-2">
                    <div className="font-bold text-slate-800">{item.name}</div>
                    <div className="text-[10px] text-slate-400">₹{item.sellPrice} × {item.quantity} (GST {item.gstRate}%)</div>
                  </div>
                  <div className="flex items-center space-x-2">
                    <button
                      onClick={() => updateQuantity(item.id, -1)}
                      className="p-1 bg-white border border-slate-200 rounded-lg text-slate-600 hover:bg-slate-100"
                    >
                      <Minus className="w-3 h-3" />
                    </button>
                    <span className="font-bold text-slate-800 w-4 text-center">{item.quantity}</span>
                    <button
                      onClick={() => updateQuantity(item.id, 1)}
                      className="p-1 bg-white border border-slate-200 rounded-lg text-slate-600 hover:bg-slate-100"
                    >
                      <Plus className="w-3 h-3" />
                    </button>
                    <button
                      onClick={() => removeFromCart(item.id)}
                      className="p-1 text-rose-500 hover:bg-rose-50 rounded-lg"
                    >
                      <Trash2 className="w-3.5 h-3.5" />
                    </button>
                  </div>
                </div>
              ))
            )}
          </div>
        </div>

        {/* Invoice Summary & Checkout Action */}
        <div className="pt-4 border-t border-slate-200 space-y-2 bg-slate-50/50 p-4 rounded-xl">
          <div className="flex items-center justify-between text-xs text-slate-600">
            <span>Subtotal:</span>
            <span>₹{totals.subtotal.toLocaleString()}</span>
          </div>

          {gstType === 'INTRA_STATE' ? (
            <>
              <div className="flex items-center justify-between text-xs text-slate-500">
                <span>CGST:</span>
                <span>₹{totals.cgst.toFixed(2)}</span>
              </div>
              <div className="flex items-center justify-between text-xs text-slate-500">
                <span>SGST:</span>
                <span>₹{totals.sgst.toFixed(2)}</span>
              </div>
            </>
          ) : (
            <div className="flex items-center justify-between text-xs text-slate-500">
              <span>IGST:</span>
              <span>₹{totals.igst.toFixed(2)}</span>
            </div>
          )}

          <div className="flex items-center justify-between text-base font-extrabold text-slate-900 pt-2 border-t border-slate-200">
            <span>Grand Total:</span>
            <span className="text-primary font-sans">₹{totals.grandTotal.toLocaleString()}</span>
          </div>

          <div className="flex items-center space-x-2 pt-2">
            <select
              value={paymentMethod}
              onChange={(e) => setPaymentMethod(e.target.value)}
              className="bg-white border border-slate-200 rounded-xl px-3 py-2 text-xs font-bold text-slate-700 outline-none"
            >
              <option value="CASH">Cash</option>
              <option value="UPI">UPI / QR Code</option>
              <option value="CARD">Debit / Credit Card</option>
              <option value="NETBANKING">NetBanking</option>
            </select>

            <button
              onClick={handleCheckout}
              disabled={loading || cart.length === 0}
              className="flex-1 bg-primary hover:bg-primary-dark text-white font-bold text-xs py-2.5 rounded-xl shadow-hover transition-all flex items-center justify-center space-x-2"
            >
              <Printer className="w-4 h-4" />
              <span>{loading ? 'Processing Invoice...' : 'Generate GST Invoice'}</span>
            </button>
          </div>
        </div>

        {/* Invoice Thermal Print Modal Overlay */}
        {generatedInvoice && (
          <div className="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm flex items-center justify-center p-4">
            <div className="bg-white rounded-2xl max-w-md w-full p-6 shadow-2xl border border-slate-200 relative space-y-4">
              <div className="text-center border-b border-slate-200 pb-4">
                <CheckCircle className="w-10 h-10 text-emerald-500 mx-auto mb-2" />
                <h3 className="text-lg font-bold text-slate-900">GST Invoice Generated</h3>
                <p className="text-xs text-slate-500 font-mono">{generatedInvoice.invoiceNumber}</p>
              </div>

              {/* Thermal Invoice Printable Preview */}
              <div className="bg-slate-50 border border-slate-200 p-4 rounded-xl font-mono text-[11px] space-y-2 text-slate-800">
                <div className="text-center font-bold text-xs uppercase">Infinity Digital Retailers</div>
                <div className="text-center text-[10px] text-slate-500">GSTIN: 33AAAAA0000A1Z5</div>
                <div className="border-b border-dashed border-slate-300 py-1" />
                <div className="flex justify-between">
                  <span>Customer:</span>
                  <span>{generatedInvoice.customerName}</span>
                </div>
                <div className="flex justify-between">
                  <span>Payment Method:</span>
                  <span>{generatedInvoice.paymentMethod}</span>
                </div>
                <div className="border-b border-dashed border-slate-300 py-1" />
                {generatedInvoice.items?.map((item: any, idx: number) => (
                  <div key={idx} className="flex justify-between text-[10px]">
                    <span>{item.productName} × {item.quantity}</span>
                    <span>₹{item.totalAmount}</span>
                  </div>
                ))}
                <div className="border-b border-dashed border-slate-300 py-1" />
                <div className="flex justify-between font-bold text-xs">
                  <span>TOTAL PAID:</span>
                  <span>₹{generatedInvoice.grandTotal}</span>
                </div>
              </div>

              <div className="flex items-center space-x-3 pt-2">
                <button
                  onClick={() => window.print()}
                  className="flex-1 bg-slate-900 text-white font-bold text-xs py-2.5 rounded-xl hover:bg-slate-800 flex items-center justify-center space-x-1.5"
                >
                  <Printer className="w-4 h-4" />
                  <span>Print Receipt</span>
                </button>
                <button
                  onClick={() => setGeneratedInvoice(null)}
                  className="px-4 py-2.5 rounded-xl border border-slate-200 text-xs font-bold text-slate-700 hover:bg-slate-50"
                >
                  Close
                </button>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};
