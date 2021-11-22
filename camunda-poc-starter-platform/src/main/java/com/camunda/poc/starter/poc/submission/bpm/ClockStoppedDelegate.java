package com.camunda.poc.starter.poc.submission.bpm;

import org.apache.http.client.fluent.Request;
import org.apache.http.entity.ContentType;
import org.camunda.bpm.engine.delegate.BpmnError;
import org.camunda.bpm.engine.delegate.DelegateExecution;
import org.camunda.bpm.engine.delegate.JavaDelegate;
import org.camunda.spin.impl.json.jackson.JacksonJsonNode;
import org.camunda.spin.plugin.variable.value.JsonValue;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.logging.Logger;


/**
 * This is an easy adapter implementation 
 * illustrating how a Java Delegate can be used 
 * from within a BPMN 2.0 Service Task.
 */
@Component("clockStoppedDelegate")
public class ClockStoppedDelegate implements JavaDelegate {

  @Value("${data.api.uri}")
  String dataApiUri;

  private final Logger LOGGER = Logger.getLogger(Class.class.getName());
  
  public void execute(DelegateExecution execution) throws Exception {
    
    LOGGER.info("\n\n  ... "+Class.class.getName()+" invoked by "
            + "processDefinitionId=" + execution.getProcessDefinitionId() +" \n "
            + ", activtyId=" + execution.getCurrentActivityId() +" \n "
            + ", activtyName='" + execution.getCurrentActivityName() + "'"+" \n "
            + ", processInstanceId=" + execution.getProcessInstanceId()+" \n "
            + ", businessKey=" + execution.getProcessBusinessKey()+" \n "
            + ", executionId=" + execution.getId()+" \n "
            + ", Data URI= " + dataApiUri
            + " \n\n");


    try {
      Boolean clockStopped = (Boolean) execution.getVariable("clockStopped");
      JacksonJsonNode submission = (JacksonJsonNode) execution.getVariable("submission");

      Integer id = (Integer) submission.prop("id").numberValue();

      JSONObject body = new JSONObject().put("submissionStatus", "clock stopped");

      if(clockStopped){
        //Use fluent HTTP api to get Damage Report
        String request = Request.Patch(dataApiUri + "/submissions/"+id)
                .bodyString(body.toString(), ContentType.APPLICATION_JSON)
                .execute().returnResponse().toString();

        LOGGER.info(" ====>> Response \n" + request);
      }

    }catch(Exception e){
          LOGGER.info("\n\n  ... "+Class.class.getSimpleName()+" just swallow exceptions");
          e.printStackTrace();
    }

    Boolean error = (Boolean) execution.getVariable("error");
    if (error != null && error) {
      throw new BpmnError("Invalid Data Found!");
    }
  }


}