.PHONY: watch
watch:
	cd assets && \
	esbuild default \
		--sourcemap=inline \
		--watch && \
	tailwindcss \
      --input=css/app.css \
      --output=../priv/static/assets/app.css \
      --postcss \
      --watch

.PHONY: install
install:
	npm --prefix assets install
