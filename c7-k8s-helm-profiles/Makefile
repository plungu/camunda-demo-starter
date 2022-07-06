namespace ?= camunda7
release ?= camunda7
chart ?= camunda7/camunda-bpm-platform
dbSecretName ?= c7-db-secret
values ?= camunda7-run-values.yaml
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
