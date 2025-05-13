[
  import_deps: [:phoenix],
  inputs: ["*.{ex,exs}", "{config,lib,test}/**/*.{ex,exs}", "{lib,test}/**/*.sface"],
  plugins: [Phoenix.LiveView.HTMLFormatter]
]
