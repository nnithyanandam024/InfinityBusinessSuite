import React, { useState, useEffect } from 'react';
import { apiFetch } from '../services/api';
import { Barcode, Printer, Search } from 'lucide-react';

export const BarcodePrinter: React.FC = () => {
  const [products, setProducts] = useState<any[]>([]);
  const [search, setSearch] = useState('');
  const [selectedProduct, setSelectedProduct] = useState<any>(null);
  const [copies, setCopies] = useState(6);

  useEffect(() => {
    loadProducts();
  }, [search]);

  const loadProducts = async () => {
    try {
      const data = await apiFetch<any[]>(`/products?search=${encodeURIComponent(search)}`);
      setProducts(data);
      if (data.length > 0 && !selectedProduct) {
        setSelectedProduct(data[0]);
      }
    } catch (err) {
      console.error('Failed to load products:', err);
    }
  };

  const handlePrint = () => {
    window.print();
  };

  return (
    <div className="space-y-6 font-sans">
      {/* Header bar (hidden on print) */}
      <div className="no-print bg-white border border-slate-200 rounded-2xl p-6 shadow-soft flex items-center justify-between">
        <div>
          <h1 className="text-xl font-bold text-slate-900">Barcode Label Print Station</h1>
          <p className="text-xs text-slate-500 mt-0.5">
            Generate 50mm x 25mm thermal barcode labels for product SKUs.
          </p>
        </div>

        <button
          onClick={handlePrint}
          disabled={!selectedProduct}
          className="bg-primary hover:bg-primary-dark text-white font-bold text-xs px-4 py-2.5 rounded-xl shadow-hover flex items-center space-x-2 transition-all"
        >
          <Printer className="w-4 h-4" />
          <span>Print Label Sheet</span>
        </button>
      </div>

      <div className="grid md:grid-cols-12 gap-6">
        {/* Left Product Selector (hidden on print) */}
        <div className="no-print md:col-span-5 bg-white border border-slate-200 rounded-2xl p-5 shadow-soft space-y-4">
          <h2 className="text-sm font-bold text-slate-900">Select Product to Print</h2>
          <div className="flex items-center space-x-2 bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 text-xs">
            <Search className="w-4 h-4 text-slate-400" />
            <input
              type="text"
              placeholder="Search product..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="bg-transparent outline-none w-full"
            />
          </div>

          <div className="max-h-72 overflow-y-auto space-y-2 pr-1">
            {products.map((p) => (
              <div
                key={p.id}
                onClick={() => setSelectedProduct(p)}
                className={`p-3 rounded-xl border text-xs cursor-pointer transition-all ${
                  selectedProduct?.id === p.id
                    ? 'border-primary bg-blue-50/50 shadow-xs'
                    : 'border-slate-200 hover:bg-slate-50'
                }`}
              >
                <div className="font-bold text-slate-900">{p.name}</div>
                <div className="flex items-center justify-between text-[10px] text-slate-400 mt-1">
                  <span>SKU: {p.sku}</span>
                  <span className="font-bold text-slate-800">₹{p.sellPrice}</span>
                </div>
              </div>
            ))}
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">Number of Label Copies</label>
            <input
              type="number"
              value={copies}
              onChange={(e) => setCopies(Number(e.target.value))}
              min={1}
              max={50}
              className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 text-xs font-bold outline-none"
            />
          </div>
        </div>

        {/* Right Label Sheet Preview (Printable Area) */}
        <div className="printable-area md:col-span-7 bg-white border border-slate-200 rounded-2xl p-6 shadow-soft space-y-4">
          <h2 className="no-print text-sm font-bold text-slate-900">Thermal Label Preview (50mm × 25mm)</h2>
          {selectedProduct ? (
            <div className="printable-grid grid grid-cols-2 gap-4 p-4 bg-slate-50 border border-slate-200 rounded-2xl">
              {Array.from({ length: copies }).map((_, idx) => (
                <div
                  key={idx}
                  className="bg-white border border-slate-800 p-3 rounded-lg text-center space-y-1 shadow-xs font-mono text-[10px] break-inside-avoid"
                >
                  <div className="font-bold text-xs truncate text-slate-900">{selectedProduct.name}</div>
                  <div className="text-slate-500">SKU: {selectedProduct.sku}</div>
                  <div className="bg-slate-900 text-white font-bold py-1 px-2 rounded tracking-widest text-center text-xs my-1">
                    |||| || ||||| ||||
                  </div>
                  <div className="text-slate-500 text-[9px]">{selectedProduct.barcode || '8901234567890'}</div>
                  <div className="font-extrabold text-sm text-slate-900">MRP: ₹{selectedProduct.sellPrice}</div>
                </div>
              ))}
            </div>
          ) : (
            <div className="no-print text-center py-12 text-slate-400 text-xs">
              Select a product from the list to preview barcode labels.
            </div>
          )}
        </div>
      </div>
    </div>
  );
};
