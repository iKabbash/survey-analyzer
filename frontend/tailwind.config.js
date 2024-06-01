/** @type {import('tailwindcss').Config} */
export default {
    content: [
      "./index.html",
      "./src/**/*.{js,ts,jsx,tsx}",
    ],
    theme: {
      extend: {
        colors: {
          background: '#020617',
          text1: '#004aad',
          text2: '#0071c9 ',
        }
      },
    },
    plugins: [],
  }