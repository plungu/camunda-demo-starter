.PHONY: postgres
postgres: bitnami-postgres postgres-secret

.PHONY: bitnami-postgres
bitnami-postgres:
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm repo update bitnami
	helm upgrade --install --set image.tag=11.14.0 --set existingSecret=$(dbSecretName),global.postgresql.existingSecret=$(dbSecretName),postgresqlPostgresPassword=camunda,postgresqlPassword=camunda,postgresqlUsername=camunda,postgresqlDatabase=camunda c7-database bitnami/postgresql --namespace $(namespace) --values include/pg-values.yaml

.PHONY: postgres-secret
postgres-secret:
	kubectl create secret generic \
    $(dbSecretName) \
    --from-literal=DB_USERNAME=camunda \
    --from-literal=DB_PASSWORD=camunda --namespace $(namespace)

.PHONY: clean-postgres
clean-postgres:
	-helm --namespace $(namespace) uninstall
	-kubectl delete -n postrgres pvc -l app.kubernetes.io/instance=postgres
	-kubectl delete namespace $(namespace)
	-kubectl delete secrets $(dbSecretName) --namespace $(namespace)

# .PHONY: await-secret
# await-secret:
# 	kubectl wait --for=condition=Ready secret -n $(namespace) -l app=postgres-secret --timeout=900s
