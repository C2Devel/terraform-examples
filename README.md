<h3 align="center">terraform in croc cloud</h3>
<p align="center">reference test suite with supported resources</p>
<p align="center">&#183; <a href="http://docs.website.cloud.croc.ru/ru/api/tools/terraform.html">Documentation</a> &#183;</p>

---

## Supported resources

### ec2 resources

* [aws_ami](cases/aws_ami/README.rst)
* [aws_ami_from_instance](cases/aws_ami_from_instance/README.rst)
* [aws_ami_lauch_permission](cases/aws_ami_launch_permission/README.rst)
* [aws_ebs_snapshot](cases/aws_ebs_snapshot/README.rst)
* [aws_snapshot_create_volume_permission](cases/aws_snapshot_create_volume_permission)
* [aws_ebs_volume](cases/aws_ebs_volume/README.rst)
* [aws_eip](cases/aws_eip/README.rst)
* [aws_eip_association](cases/aws_eip_association/README.rst)
* [aws_instance](cases/aws_instance/README.rst), more examples:
  - [run instance with cdrom](cases/aws_instance/run_instance_with_cdrom/README.rst)
  - [run instance with ebs override](cases/aws_instance/run_instance_with_ebs_override/README.rst)
  - [run instance remove cdrom](cases/aws_instance/run_instances_remove_cdrom/README.rst)
* [aws_key_pair](cases/aws_key_pair/README.rst)
* [aws_placement_group](cases/aws_placement_group/README.rst)
* [aws_volume_attachment](cases/aws_volume_attachment/README.rst)

### vpc resources

* [aws_vpc](cases/aws_vpc/README.rst)
* [aws_default_vpc](cases/aws_default_vpc/README.rst)
* [aws_default_vpc_dhcp_options](cases/aws_default_vpc/README.rst)
* [aws_vpc_dhcp_options](cases/aws_vpc_dhcp_options/README.rst)
* [aws_vpc_dhcp_options_association](cases/aws_vpc_dhcp_options_association/README.rst)
* [aws_customer_gateway](cases/aws_customer_gateway/README.rst)
* [aws_network_acl](cases/aws_network_acl/README.rst)
* [aws_default_network_acl](cases/aws_default_network_acl/README.rst)
* [aws_network_acl_rule](cases/aws_network_acl_rule/README.rst)
* [aws_route](cases/aws_route/README.rst)
* [aws_route_table](cases/aws_route_table/README.rst)
* [aws_default_route_table](cases/aws_default_route_table/README.rst)
* [aws_route_table_association](cases/aws_route_table_association/README.rst)
* [aws_subnet](cases/aws_subnet/README.rst)
* [aws_default_security_group](cases/aws_default_security_group/README.rst)
* [aws_security_group](cases/aws_security_group/README.rst)
* [aws_default_security_group](cases/aws_default_security_group/README.rst)
* [aws_security_group_rule](cases/aws_security_group_rule/README.rst)


## How to run test cases

* Install [terraform](https://www.terraform.io/downloads.html) (`0.10.*` and `0.11.*` versions are supported)

* Create ``terraform.tfvars`` file:

```sh
  $ cp terraform.tfvars.example terraform.tfvars
```

* Update ``terraform.tfvars`` file with desirable values

* Run ``make init`` to init ``aws provider``

* Run ``make show-cases`` to list all available cases

* Run terraform ``plan``, ``apply`` and ``destroy`` command for specified case:

```sh
  $ make plan-<case_name>
  $ make apply-<case_name>
  $ make destroy-<case_name>
```

* Or run all cases with ``make all``

* Use ``make clean`` to remove ``terraform.tfstate*`` and ``crash.log`` files

* Use ``make clean-all`` to remove ``aws provider``
