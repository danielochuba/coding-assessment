/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.erb',
    './app/views/**/*.html.erb',
    './app/views/devise/**/*.erb',
  ],
  theme: {
    extend: {
      backgroundImage: {
        'custom-bg': "url('/assets/images/background.png')",
      },
    },
  },
  plugins: [],
  safelist: [
    'bg-gray-100',
    'bg-blue-500',
    'hover:bg-blue-700',
    'text-blue-600',
    'hover:bg-gray-100',
    'bg-red-200',
    'border-red-500',
    'text-red-500',
    'text-red-700',
    'text-red-800',
    'w-full',
    'max-w-md',
    'max-w-4xl',
    'min-h-screen',
    'overflow-auto',
    'grid-cols-1',
    'md:grid-cols-2',
    'gap-4',
    'pl-10',
    'px-2',
    'pl-3',
    'h-full',
    'pointer-events-none'
  ]
}
