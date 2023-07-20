# Remove old packages folder
if (Test-Path Packages) {
	Remove-Item -Recurse -Force Packages
}

# Install packages
wally install

# Sourcemap generation
rojo.exe sourcemap --output sourcemap.json .\place.project.json

# Fix the types (why is this not native???)
wally-package-types.exe --sourcemap sourcemap.json Packages/
