/** @type {import('tailwindcss').Config} */
export default {
  content: [
    './index.html',
    './src/**/*.{js,ts,jsx,tsx}',
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#2563EB',
          dark: '#1D4ED8',
          light: '#3B82F6',
          50: '#EFF6FF',
          100: '#DBEAFE',
        },
        navy: {
          DEFAULT: '#0F172A',
          card: '#0A0F1D',
          light: '#1E293B',
        },
        success: '#10B981',
      },
      fontFamily: {
        sans: ['Inter', 'Outfit', 'sans-serif'],
      },
      boxShadow: {
        soft: '0 4px 20px -2px rgba(15, 23, 42, 0.05)',
        hover: '0 12px 30px -4px rgba(37, 99, 235, 0.12)',
      },
      borderRadius: {
        card: '16px',
      },
    },
  },
  plugins: [],
};
