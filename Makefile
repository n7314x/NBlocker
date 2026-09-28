.PHONY: bootstrap generate lint build ipa clean

bootstrap:
	./scripts/bootstrap.sh

generate:
	./scripts/generate-project.sh

lint:
	./scripts/lint.sh

build:
	./scripts/build.sh

ipa:
	./scripts/build-ipa.sh

clean:
	./scripts/clean.sh
