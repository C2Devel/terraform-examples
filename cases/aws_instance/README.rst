aws_instance
============

Summary
-------
This example introduces ``aws_instance`` resource.

.. toctree::
   :caption: additional examples

   run_instance_with_cdrom/README
   run_instance_with_ebs_override/README
   run_instance_with_data_source_ami/README
   run_instances_remove_cdrom/README

Differences
-----------

Unsupported attributes
~~~~~~~~~~~~~~~~~~~~~~

* ``tenancy``
* ``host_id``
* ``cpu_core_count``
* ``cpu_threat_per_code``
* ``ebs_optimized``
* ``get_password_data``
* ``monitoring``
* ``iam_instance_profile``
* ``ipv6_address_count``
* ``ipv6_addresses``
* ``volume_tags``
* ``network_interface``
* ``credit_specification``
* ``private_ip``

Special notes
-------------

This resource supports ``tags`` attribute:

Example tag
~~~~~~~~~~~
.. code-block::

   resource "aws_instance" "test" {
       ...

       tags = {
         Name = "value"
       }
       ...
    }

Example
-------
.. literalinclude:: main.tf
