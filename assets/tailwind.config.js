module.exports = {
  mode: "jit",
  purge: ["./js/**/*.js", "../lib/*_web/**/*.*ex", "../lib/*_web/**/*.*sface"],
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
