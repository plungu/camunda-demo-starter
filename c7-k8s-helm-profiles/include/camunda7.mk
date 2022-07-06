.PHONY: camunda7
camunda7:
	helm repo add camunda7 https://helm.camunda.cloud
	helm repo update camunda7
	helm search repo $(chart)
	helm upgrade --install --namespace $(namespace) $(release) $(chart) --values $(values) --skip-crds

#	helm upgrade --install camunda7 camunda7/camunda-bpm-platform --values camunda7-values.yaml

.PHONY: namespace
namespace:
	-kubectl create namespace $(namespace)
	-kubens $(namespace)

# Generates templates from the camunda7 helm charts, useful to make some more specific changes which are not doable by the values file.
.PHONY: template
template:
	helm template $(release) $(chart) -f $(values) --skip-crds --output-dir .
	@echo "To apply the templates use: kubectl apply -f camunda7-platform/templates/ -n $(namespace)"

# .PHONY: update
# update:
# 	OPERATE_SECRET=$$(kubectl get secret --namespace $(namespace) "camunda7-operate-identity-secret" -o jsonpath="{.data.operate-secret}" | base64 --decode); \
# 	# TASKLIST_SECRET=$$(kubectl get secret --namespace $(namespace) "camunda7-tasklist-identity-secret" -o jsonpath="{.data.tasklist-secret}" | base64 --decode); \
# 	# OPTIMIZE_SECRET=$$(kubectl get secret --namespace $(namespace) "camunda7-optimize-identity-secret" -o jsonpath="{.data.optimize-secret}" | base64 --decode); \
# 	helm upgrade --namespace $(namespace) $(release) $(chart) -f camunda7-values.yaml \
# 	  --set global.identity.auth.operate.existingSecret=$$OPERATE_SECRET
	  # --set global.identity.auth.tasklist.existingSecret=$$TASKLIST_SECRET \
	  # --set global.identity.auth.optimize.existingSecret=$$OPTIMIZE_SECRET

.PHONY: clean-camunda7
clean-camunda7:
	-helm --namespace $(namespace) uninstall $(release)
	-kubectl delete -n $(namespace) pvc -l app.kubernetes.io/instance=$(release)
	-kubectl delete -n $(namespace) pvc -l app=camunda7
	-kubectl delete namespace $(namespace)

.PHONY: logs
logs:
	kubectl logs -f -n $(namespace) -l app.kubernetes.io/name=camunda7

.PHONY: watch
watch:
	kubectl get pods -w -n $(namespace)

.PHONY: watch-camunda7
watch-camunda7:
	kubectl get pods -w -n $(namespace) -l app.kubernetes.io/name=camunda7

.PHONY: port-camunda7
port-camunda7:
	# kubectl port-forward svc/$(release)-camunda7 26500:26500 -n $(namespace)
	kubectl --namespace camunda7 port-forward svc/$(release)-camunda-bpm-platform 8080

.PHONY: await-camunda7
await-camunda7:
	kubectl wait --for=condition=Ready pod -n $(namespace) -l app.kubernetes.io/name=camunda7 --timeout=900s

.PHONY: url-grafana
url-grafana:
	@echo "http://`kubectl get svc metrics-grafana-loadbalancer -n default -o 'custom-columns=ip:status.loadBalancer.ingress[0].ip' | tail -n 1`/d/I4lo7_EZk/camunda7?var-namespace=$(namespace)"

.PHONY: open-grafana
open-grafana:
	xdg-open http://$(shell kubectl get services metrics-grafana-loadbalancer -n default -o jsonpath={..ip})/d/I4lo7_EZk/camunda7?var-namespace=$(namespace) &
