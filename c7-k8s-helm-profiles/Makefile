namespace ?= camunda7
release ?= camunda7
chart ?= camunda7/camunda-bpm-platform
dbSecretName ?= c7-db-secret
#values ?= camunda7-run-values.yaml
#values ?= camunda7-tomcat-values.yaml

# .PHONY: all
# all: namespace camunda7 postgres await-postgres

.PHONY: run
run: namespace camunda7 postgres

.PHONY: tomcat
tomcat: namespace camunda7 deploy-bpm-configs postgres

.PHONY: clean-run
clean-run: clean-camunda7 clean-postgres

.PHONY: clean-tomcat
clean-tomcat: clean-camunda7 clean-bpm-configs clean-postgres

include include/camunda7.mk
include include/postgres.mk
# include include/cockroach.mk

.PHONY: deploy-bpm-configs
deploy-bpm-configs:
	kubectl create configmap bpm-platform-xml --from-file=bpm-platform.xml=../camunda-tomcat-docker/bpm-platform-multi-schema-tenant.xml   -n $(namespace)
	kubectl create configmap server-xml --from-file=server.xml=../camunda-tomcat-docker/multi-schema-server.xml   -n $(namespace)

# TODO: create the schemas in the database for the tenants
# could also use a Kube Job to do this.
	# POSTGRES_ADMIN_PASSWORD=$(kubectl get secret --namespace camunda7 c7-database-postgresql -o jsonpath="{.data.postgres-password}" | base64 -d); echo $POSTGRES_ADMIN_PASSWORD;
	# POSTGRES_PASSWORD := $(kubectl get secret --namespace camunda7 c7-database-postgresql -o jsonpath="{.data.password}" | base64 -d)
	# @echo $(POSTGRES_PASSWORD)
	# export $(POSTGRES_PASSWORD)
	# kubectl run c7-database-postgresql-client --rm --tty -i --restart='Never' --namespace camunda7 --image docker.io/bitnami/postgresql:11.14.0 --env="PGPASSWORD=$(POSTGRES_PASSWORD)" --command -- psql --host c7-database-postgresql -U camunda -d camunda -p 5432
	# /opt/bitnami/scripts/postgresql/entrypoint.sh /bin/bash CREATE SCHEMA IF NOT EXISTS tnt_1; exit;

	# kubectl apply -f pg-client-job.yaml                                    -n $(namespace)
	# kubectl wait --for=condition=complete job/pg-client-job --timeout=300s -n $(namespace)
	# kubectl delete -f pg-client-job.yaml                                   -n $(namespace)


.PHONY: clean-bpm-configs
clean-bpm-configs:
	kubectl delete configmap bpm-platform-xml -n $(namespace)
	kubectl delete configmap server-xml -n $(namespace)

# .PHONY: benchmark
# benchmark:
# 	kubectl apply -n $(namespace) -f benchmark.yaml
#
# .PHONY: clean-benchmark
# clean-benchmark:
# 	-kubectl delete -n $(namespace) -f benchmark.yaml
#
# .PHONY: await-postgres
# await-postgres:
# 	kubectl wait --for=condition=Ready pod -n $(namespace) -l app=c7-database --timeout=900s
