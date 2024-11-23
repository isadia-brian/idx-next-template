{ pkgs, version ? "latest", importAlias ? "@/*", language ? "ts"
, packageManager ? "npm", srcDir ? false, eslint ? false, app ? false
, tailwind ? false, ... }: {

  packages = [ pkgs.nodejs_20 pkgs.nodePackages.pnpm ];

  bootstrap = ''
    mkdir -p "$WS_NAME"
	npx create-next-app@${version} "$WS_NAME" \
		--skip-install \
		--import-alias=${importAlias} \
		--${language} \
		${if eslint then "--eslint" else "--no-eslint"} \
		${if srcDir then "--src-dir" else "--no-src-dir"} \
		${if app then "--app" else "--no-app"} \
		${if tailwind then "--tailwind" else "--no-tailwind"}
	mkdir -p "$WS_NAME/.idx/"
	cp -rf ${./dev.nix} "$WS_NAME/.idx/dev.nix"
	chmod -R +w "$WS_NAME"
	mv "$WS_NAME" "$out"
	cd "$out"; npm install --package-lock-only --ignore-scripts
  '';
}
