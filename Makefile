CASES := $(notdir $(wildcard cases/*))

TERRAFORM      := $(shell which terraform)
TERRAFORM_VARS  = terraform.tfvars


define TERRAFORM_CASE_CMD
.PHONY: $(1)-$(2)

$(1)-$(2):
	cd cases/$(2) && \
	    ln -sf ../../$(TERRAFORM_VARS) && \
	    $(TERRAFORM) $(1)
endef

$(foreach case,$(CASES),$(eval $(call TERRAFORM_CASE_CMD,plan,$(case))))
$(foreach case,$(CASES),$(eval $(call TERRAFORM_CASE_CMD,apply,$(case))))
$(foreach case,$(CASES),$(eval $(call TERRAFORM_CASE_CMD,destroy,$(case))))
