WORKDIR := $(abspath .)
CASES_PATHS := $(sort $(dir $(wildcard $(WORKDIR)/cases/*/ $(WORKDIR)/cases/*/*/)))
CASES_NAMES := $(foreach PATH, $(CASES_PATHS), $(lastword $(subst /, ,$(PATH))))

TERRAFORM := $(shell which terraform)
TRASH_FILES := terraform.tfstate terraform.tfstate.backup crash.log
AUTOTEST_ARTIFACTS := atlocal atconfig Makefile package.m4 testsuite testsuite.log testsuite.dir
AUTOCONF_ARTIFACTS := config.log configure config.status install-sh missing autom4te.cache

.PHONY: clean init show-cases clean-all
.SILENT: clean init show-cases clean-all

define TITLE
   ____ ____    _____                    __                                                       _            
  / ___|___ \  |_   _|__ _ __ _ __ __ _ / _| ___  _ __ _ __ ___     _____  ____ _ _ __ ___  _ __ | | ___  ___  
 | |     __) |   | |/ _ \ '__| '__/ _` | |_ / _ \| '__| '_ ` _ \   / _ \ \/ / _` | '_ ` _ \| '_ \| |/ _ \/ __| 
 | |___ / __/    | |  __/ |  | | | (_| |  _| (_) | |  | | | | | | |  __/>  < (_| | | | | | | |_) | |  __/\__ \ 
  \____|_____|   |_|\___|_|  |_|  \__,_|_|  \___/|_|  |_| |_| |_|  \___/_/\_\__,_|_| |_| |_| .__/|_|\___||___/ 
                                                                                                               
endef

export TITLE

init: show-perfect-title ; @$(TERRAFORM) init

show-perfect-title: ; @echo "$$TITLE"

show-cases:
	find ./cases/ -mindepth 2 -name README.rst | \
		awk -F'/' '{print $$(NF-1)}'

clean-tests:
	$(foreach to_del,\
		$(AUTOTEST_ARTIFACTS),\
			rm -rf $(WORKDIR)/tests/$(to_del) ;)



clean-cases: COMMON_RESOURCES_NAMES := $(shell ls $(WORKDIR)/common)
clean-cases: LINKS := $(shell find -L $(WORKDIR)/cases -xtype l -print0 | xargs -0 -i% basename %)
clean-cases:
	$(foreach to_del,\
		$(TRASH_FILES) $(LINKS),\
			$(if $(filter $(to_del), $(COMMON_RESOURCES_NAMES)),,\
				find $(WORKDIR)/cases -name $(to_del) -delete ; \
				)\
	)

clean: clean-cases clean-tests
	$(foreach to_del,\
		$(AUTOCONF_ARTIFACTS),\
			rm -rf $(WORKDIR)/$(to_del) ;)

clean-all: clean
	rm -rf $(WORKDIR)/.terraform/ $(WORKDIR)/.terraform.lock.hcl

define TERRAFORM_IMPORT_CASE_CMD

.PHONY: import-$(lastword $(subst /, ,$(1))) 
import-$(lastword $(subst /, ,$(1))): 
	mv $(1)terraform.tfstate $(1)terraform.tfstate.main ;\
	$(TERRAFORM) import \
	-no-color \
	-state $(1)terraform.tfstate \
	-config $(1) \
	$(shell jq -r '.resources[] | "\(.type).\(.name) \(.instances[].attributes.id)"' $(1)terraform.tfstate 2>/dev/null) || exit 1 ;\
	rm $(1)terraform.tfstate ;\
	mv $(1)terraform.tfstate.main $(1)terraform.tfstate ;
endef

define TERRAFORM_CASE_CMD

.PHONY: $(1)-$(lastword $(subst /, ,$(2)))
$(1)-$(lastword $(subst /, ,$(2))): 
	ln -sf $(WORKDIR)/.terraform $(2) ;\
	ln -sf $(WORKDIR)/main.tf $(2)provider.tf ;\
	ln -sf $(WORKDIR)/terraform.tfvars $(2) ;\
	ln -sf $(WORKDIR)/.terraform.lock.hcl $(2) ;\
	TF_LOG=$(TF_LOG) $(TERRAFORM) -chdir=$(2) $(1) $(3) -no-color -state $(2)terraform.tfstate;
endef

$(foreach path,$(CASES_PATHS),$(eval $(call TERRAFORM_CASE_CMD,plan,$(path))))
$(foreach path,$(CASES_PATHS),$(eval $(call TERRAFORM_CASE_CMD,apply,$(path),-auto-approve)))
$(foreach path,$(CASES_PATHS),$(eval $(call TERRAFORM_CASE_CMD,destroy,$(path),-auto-approve)))


$(foreach path,$(CASES_PATHS),$(eval $(call TERRAFORM_IMPORT_CASE_CMD,$(path))))

check: ; $(MAKE) -C tests $@-local
