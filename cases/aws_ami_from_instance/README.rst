aws_ami_from_instance
=====================

Summary
-------
This example introduces ``aws_ami_from_instance`` resource.

Differences
-----------

Unsupported attributes
~~~~~~~~~~~~~~~~~~~~~~

* ``snapshot_without_reboot``

Notes
~~~~~

Current resource cant be created properly. Add custom code to switch instance to ``stopped`` state.

Example
-------
.. literalinclude:: main.tf
