module.exports = {
  content: [
    './js/**/*.js',
    '../lib/*_web.{ex,sface}',
    '../lib/*_web/**/*.{*ex,sface}',
    '../lib/website/blog/markdown.ex',
    '../priv/blogs/**/*.md'
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
