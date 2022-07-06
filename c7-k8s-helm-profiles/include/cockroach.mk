.PHONY: cockroachdb
postgres: cockroachdb db-secret

.PHONY: cockroachdb
cockroachdb:
	helm repo add cockroachdb https://charts.cockroachdb.com/
	helm repo update cockroachdb
	helm upgrade --install cockroachdb cockroachdb/cockroachdb

.PHONY: clean-cockroachdb
clean-cockroachdb:
	-helm uninstall cockroachdb
