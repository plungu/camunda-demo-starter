namespace ?= camunda7
release ?= camunda7
chart ?= camunda7/camunda-bpm-platform
values ?= camunda7-values.yaml
dbSecretName ?= c7-db-secret

.PHONY: all
all: camunda7 await-postgres deploy-bpm-configs postgres
# all: camunda await-zeebe deploy-models benchmark

.PHONY: clean
clean: clean-camunda7 clean-bpm-configs clean-postgres

include include/camunda7.mk
include include/postgres.mk

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
.PHONY: await-postgres
await-benchmark:
	kubectl wait --for=condition=Ready pod -n $(namespace) -l app=c7-database --timeout=900s
