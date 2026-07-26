import React, { useState, useEffect } from 'react';
import { apiFetch } from '../services/api';
import { Search, Plus, Package, Barcode, AlertCircle, Trash2, Edit3 } from 'lucide-react';

export const Inventory: React.FC = () => {
  const [products, setProducts] = useState<any[]>([]);
  const [categories, setCategories] = useState<any[]>([]);
  const [search, setSearch] = useState('');
  const [isAddModalOpen, setIsAddModalOpen] = useState(false);

  // Form states
  const [name, setName] = useState('');
  const [sku, setSku] = useState('');
  const [barcode, setBarcode] = useState('');
  const [hsnCode, setHsnCode] = useState('8471');
  const [categoryId, setCategoryId] = useState('');
  const [buyPrice, setBuyPrice] = useState('850');
  const [sellPrice, setSellPrice] = useState('1499');
  const [gstRate, setGstRate] = useState('18');
  const [currentStock, setCurrentStock] = useState('50');
  const [unit, setUnit] = useState('Pcs');

  useEffect(() => {
    loadInventory();
    loadCategories();
  }, [search]);

  const loadInventory = async () => {
    try {
      const data = await apiFetch<any[]>(`/products?search=${encodeURIComponent(search)}`);
      setProducts(data);
    } catch (err) {
      console.error('Failed to load inventory:', err);
    }
  };

  const loadCategories = async () => {
    try {
      const data = await apiFetch<any[]>('/products/categories');
      setCategories(data);
      if (data.length > 0) setCategoryId(data[0].id);
    } catch (err) {
      console.error('Failed to load categories:', err);
    }
  };

  const handleCreateProduct = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      await apiFetch('/products', {
        method: 'POST',
        body: JSON.stringify({
          name,
          sku: sku || `SKU-${Date.now().toString().slice(-6)}`,
          barcode,
          hsnCode,
          categoryId: categoryId || undefined,
          buyPrice: Number(buyPrice),
          sellPrice: Number(sellPrice),
          gstRate: Number(gstRate),
          currentStock: Number(currentStock),
          unit,
        }),
      });
      setIsAddModalOpen(false);
      setName('');
      loadInventory();
    } catch (err: any) {
      alert('Error creating product: ' + err.message);
    }
  };

  const handleAdjustStock = async (id: string, delta: number) => {
    try {
      await apiFetch(`/products/${id}/stock`, {
        method: 'PUT',
        body: JSON.stringify({ delta }),
      });
      loadInventory();
    } catch (err: any) {
      alert('Stock update failed: ' + err.message);
    }
  };

  const handleDelete = async (id: string) => {
    if (!confirm('Are you sure you want to delete this product?')) return;
    try {
      await apiFetch(`/products/${id}`, { method: 'DELETE' });
      loadInventory();
    } catch (err: any) {
      alert('Delete failed: ' + err.message);
    }
  };

  return (
    <div className="space-y-6 font-sans">
      {/* Page Header */}
      <div className="bg-white border border-slate-200 rounded-2xl p-6 shadow-soft flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
        <div>
          <div className="flex items-center space-x-2">
            <Package className="w-5 h-5 text-primary" />
            <h1 className="text-2xl font-extrabold text-slate-900 tracking-tight">
              Inventory & Stock Management
            </h1>
          </div>
          <p className="text-xs text-slate-500 mt-1">
            Manage SKU, Barcodes, HSN Codes, GST rates, and live stock adjustments.
          </p>
        </div>

        <button
          onClick={() => setIsAddModalOpen(true)}
          className="bg-primary hover:bg-primary-dark text-white font-bold text-xs px-4 py-2.5 rounded-xl shadow-hover flex items-center space-x-2 transition-all"
        >
          <Plus className="w-4 h-4" />
          <span>Add New Product</span>
        </button>
      </div>

      {/* Search & Stats Bar */}
      <div className="bg-white border border-slate-200 rounded-2xl p-4 shadow-soft flex items-center justify-between gap-4">
        <div className="flex items-center space-x-2 bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 w-80 focus-within:ring-2 focus-within:ring-primary/20">
          <Search className="w-4 h-4 text-slate-400" />
          <input
            type="text"
            placeholder="Search by Product Name, SKU, Barcode..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            className="bg-transparent text-xs text-slate-800 outline-none w-full"
          />
        </div>

        <div className="flex items-center space-x-3 text-xs text-slate-600 font-semibold">
          <span>Total Products: <strong className="text-slate-900 font-bold">{products.length}</strong></span>
        </div>
      </div>

      {/* Products Table */}
      <div className="bg-white border border-slate-200 rounded-2xl shadow-soft overflow-hidden">
        <table className="w-full text-left border-collapse">
          <thead>
            <tr className="bg-slate-50 border-b border-slate-200 text-[11px] font-bold text-slate-400 uppercase tracking-wider">
              <th className="p-4">Product Name & Category</th>
              <th className="p-4">SKU / HSN</th>
              <th className="p-4">Buy Price</th>
              <th className="p-4">Sell Price</th>
              <th className="p-4">GST Rate</th>
              <th className="p-4">Stock Level</th>
              <th className="p-4 text-right">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-slate-100 text-xs">
            {products.length === 0 ? (
              <tr>
                <td colSpan={7} className="p-8 text-center text-slate-400">
                  No products found. Click "Add New Product" to populate your inventory catalog.
                </td>
              </tr>
            ) : (
              products.map((prod) => (
                <tr key={prod.id} className="hover:bg-slate-50/80 transition-colors">
                  <td className="p-4">
                    <div className="font-bold text-slate-900">{prod.name}</div>
                    <div className="text-[10px] text-slate-400">{prod.category?.name || 'General'}</div>
                  </td>
                  <td className="p-4 font-mono text-[11px]">
                    <div>{prod.sku}</div>
                    <div className="text-slate-400">HSN: {prod.hsnCode || 'N/A'}</div>
                  </td>
                  <td className="p-4 font-semibold text-slate-600">₹{prod.buyPrice}</td>
                  <td className="p-4 font-bold text-slate-900">₹{prod.sellPrice}</td>
                  <td className="p-4">
                    <span className="bg-blue-50 text-primary border border-blue-100 font-bold text-[10px] px-2 py-0.5 rounded-full">
                      {prod.gstRate}% GST
                    </span>
                  </td>
                  <td className="p-4">
                    <div className="flex items-center space-x-2">
                      <button
                        onClick={() => handleAdjustStock(prod.id, -1)}
                        className="w-6 h-6 rounded-lg bg-slate-100 font-bold text-slate-600 hover:bg-slate-200"
                      >
                        -
                      </button>
                      <span
                        className={`font-bold text-xs px-2 py-0.5 rounded-lg ${
                          prod.currentStock > 10
                            ? 'bg-emerald-50 text-emerald-700'
                            : 'bg-rose-50 text-rose-700 border border-rose-200'
                        }`}
                      >
                        {prod.currentStock} {prod.unit}
                      </span>
                      <button
                        onClick={() => handleAdjustStock(prod.id, 1)}
                        className="w-6 h-6 rounded-lg bg-slate-100 font-bold text-slate-600 hover:bg-slate-200"
                      >
                        +
                      </button>
                    </div>
                  </td>
                  <td className="p-4 text-right">
                    <button
                      onClick={() => handleDelete(prod.id)}
                      className="p-1.5 text-rose-500 hover:bg-rose-50 rounded-lg transition-colors"
                      title="Delete Product"
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

      {/* Add Product Modal Overlay */}
      {isAddModalOpen && (
        <div className="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm flex items-center justify-center p-4">
          <div className="bg-white rounded-2xl max-w-lg w-full p-6 shadow-2xl border border-slate-200 space-y-4">
            <h2 className="text-lg font-extrabold text-slate-900">Add New Inventory Item</h2>
            <form onSubmit={handleCreateProduct} className="space-y-3 text-xs">
              <div>
                <label className="block font-bold text-slate-700 mb-1">Product Name</label>
                <input
                  type="text"
                  required
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                  placeholder="e.g. Wireless Mouse"
                  className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 outline-none"
                />
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Category</label>
                  <select
                    value={categoryId}
                    onChange={(e) => setCategoryId(e.target.value)}
                    className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 outline-none font-semibold text-slate-700"
                  >
                    {categories.map((cat) => (
                      <option key={cat.id} value={cat.id}>
                        {cat.name}
                      </option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">HSN / SAC Code</label>
                  <input
                    type="text"
                    value={hsnCode}
                    onChange={(e) => setHsnCode(e.target.value)}
                    className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 outline-none"
                  />
                </div>
              </div>

              <div className="grid grid-cols-3 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Buy Price (₹)</label>
                  <input
                    type="number"
                    value={buyPrice}
                    onChange={(e) => setBuyPrice(e.target.value)}
                    className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 outline-none"
                  />
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Sell Price (₹)</label>
                  <input
                    type="number"
                    value={sellPrice}
                    onChange={(e) => setSellPrice(e.target.value)}
                    className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 outline-none font-bold"
                  />
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">GST Rate (%)</label>
                  <select
                    value={gstRate}
                    onChange={(e) => setGstRate(e.target.value)}
                    className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 outline-none font-bold text-slate-700"
                  >
                    <option value="0">0% Exempt</option>
                    <option value="5">5% GST</option>
                    <option value="12">12% GST</option>
                    <option value="18">18% GST</option>
                    <option value="28">28% GST</option>
                  </select>
                </div>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Initial Stock</label>
                  <input
                    type="number"
                    value={currentStock}
                    onChange={(e) => setCurrentStock(e.target.value)}
                    className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 outline-none"
                  />
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Unit</label>
                  <input
                    type="text"
                    value={unit}
                    onChange={(e) => setUnit(e.target.value)}
                    className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 outline-none"
                  />
                </div>
              </div>

              <div className="flex items-center space-x-3 pt-3 border-t border-slate-100">
                <button
                  type="submit"
                  className="flex-1 bg-primary text-white font-bold py-2.5 rounded-xl hover:bg-primary-dark shadow-hover"
                >
                  Save Product
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
