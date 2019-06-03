aws_network_interface
=====================

Summary
-------
This example introduces ``aws_network_interface`` resource.

Differences
-----------

Unsupported attributes
~~~~~~~~~~~~~~~~~~~~~~

* ``private_ips``
* ``private_ips_count``
* ``security_groups``
* ``attachment``

Notes
~~~~~

In fact, you can create ``aws_network_interface`` with ``security_groups`` but, due to bug #<bug_number>,
this interface can not be deleted.

Example
-------
.. literalinclude:: main.tf
