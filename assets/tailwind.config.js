module.exports = {
  mode: "jit",
  purge: ["./js/**/*.js", "../lib/*_web/**/*.*ex"],
  theme: {
    extend: {
      fontFamily: {
        serif: ['"Noto Serif"']
      }
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
};
