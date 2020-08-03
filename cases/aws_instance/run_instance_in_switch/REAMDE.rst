run_instance_in_switch
======================

Summary
-------
This example introduces ```aws_instance`` resource creation with network interfaces in virtual switch.

Special notes
-------------

``false`` is only valid option for ``source_dest_check`` attribute in ``aws_network_interface`` resource if ``subnet_id`` attribute value pointing to switch id (for example ``sw-83E94661``).

Example
-------
.. literalinclude:: main.tf
