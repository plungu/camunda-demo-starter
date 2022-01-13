package com.camunda.poc.starter.poc.submission.repo;

import com.camunda.poc.starter.entity.workflow.Status;
import com.camunda.poc.starter.poc.submission.entity.Submission;
import com.camunda.poc.starter.entity.workflow.User;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.data.rest.core.config.RepositoryRestConfiguration;
import org.springframework.data.rest.webmvc.config.RepositoryRestConfigurer;

@Profile("poc-submission")
@Configuration
public class RepositoryConfig implements RepositoryRestConfigurer {

  @Override
	public void configureRepositoryRestConfiguration(RepositoryRestConfiguration config) {
    config.exposeIdsFor(Submission.class, User.class, Status.class);
  }

}
