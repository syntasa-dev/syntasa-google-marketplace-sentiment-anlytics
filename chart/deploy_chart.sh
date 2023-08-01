helm package syntasa
mv syntasa-7.1.2.tgz syntasa
helm repo index syntasa/ --url https://syntasa-dev.github.io/syntasa/