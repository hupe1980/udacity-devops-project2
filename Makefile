NETWORK_STACK_NAME?=udacity-lesson2-network
BASTION_STACK_NAME?=udacity-lesson2-bastion
APPLICATION_STACK_NAME?=udacity-lesson2-application

lint-network:
	cfn-lint -t network.yml

lint-bastion:
	cfn-lint -t bastion.yml

lint-application:
	cfn-lint -t application.yml

lint: lint-network lint-bastion lint-application

validate-network:
	aws cloudformation validate-template \
		--template-body file://network.yml

validate-bastion:
	aws cloudformation validate-template \
		--template-body file://bastion.yml

validate-application:
	aws cloudformation validate-template \
		--template-body file://application.yml

validate: validate-network validate-bastion validate-application

deploy-network:
	aws cloudformation deploy \
		--stack-name ${NETWORK_STACK_NAME} \
		--template-file network.yml \
		--parameter-overrides $$(jq -r '.[] | [.ParameterKey, .ParameterValue] | join("=")' network.json) 

deploy-bastion:
	aws cloudformation deploy \
		--stack-name ${BASTION_STACK_NAME} \
		--template-file bastion.yml \
		--parameter-overrides $$(jq -r '.[] | [.ParameterKey, .ParameterValue] | join("=")' bastion.json) \
		--capabilities CAPABILITY_NAMED_IAM
		
deploy-application:
	aws cloudformation deploy \
		--stack-name ${APPLICATION_STACK_NAME} \
		--template-file application.yml \
		--parameter-overrides $$(jq -r '.[] | [.ParameterKey, .ParameterValue] | join("=")' application.json) \
		--capabilities CAPABILITY_NAMED_IAM

deploy: deploy-network deploy-bastion deploy-application

delete-network:
	aws cloudformation delete-stack \
		--stack-name ${NETWORK_STACK_NAME}

delete-bastion:
	aws cloudformation delete-stack \
		--stack-name ${BASTION_STACK_NAME}

delete-application:
	aws cloudformation delete-stack \
		--stack-name ${APPLICATION_STACK_NAME}
