module.exports = {
  content: [
    './js/**/*.js',
    '../lib/*_web.{ex,sface}',
    '../lib/*_web/**/*.{*ex,sface}'
  ],
  theme: {
    extend: {
      fontFamily: {
        serif: ['"Noto Serif"'],
        sans: ['"Noto Sans"']
      }
    },
  },
  plugins: [],
};
